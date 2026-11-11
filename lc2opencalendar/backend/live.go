package main

// Live updates: every open app (web tab, desktop app) keeps one
// Server-Sent Events stream open (GET /api/stream). After each change the
// server sends a small message naming what changed ("events", "calendars" or
// "settings"). The apps then load that data again with the normal API.

import (
	"encoding/json"
	"net/http"
	"sync"
	"time"
)

// clientHeader is sent by the apps with every request, so the stream can say
// which app made a change (that app does not need to load it again).
const clientHeader = "X-lc2opencalendar-Client"

const (
	heartbeatEvery = 25 * time.Second // keeps proxies from closing a quiet stream
	maxClientIDLen = 64
)

// change is one message on the stream.
type change struct {
	Topic  string `json:"topic"`
	Client string `json:"client,omitempty"`
}

// Hub sends changes to all open streams.
type Hub struct {
	mu     sync.Mutex
	subs   map[chan change]struct{}
	closed bool
	done   chan struct{}
}

func NewHub() *Hub {
	return &Hub{subs: map[chan change]struct{}{}, done: make(chan struct{})}
}

func (h *Hub) subscribe() (chan change, bool) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed {
		return nil, false
	}
	ch := make(chan change, 16)
	h.subs[ch] = struct{}{}
	return ch, true
}

func (h *Hub) unsubscribe(ch chan change) {
	h.mu.Lock()
	defer h.mu.Unlock()
	delete(h.subs, ch)
}

// Publish sends a change to every stream. A stream that is too slow to keep
// up drops the message; it still gets the next one.
func (h *Hub) Publish(c change) {
	h.mu.Lock()
	defer h.mu.Unlock()
	for ch := range h.subs {
		select {
		case ch <- c:
		default:
		}
	}
}

// Close ends all streams (used when the server shuts down).
func (h *Hub) Close() {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed {
		h.closed = true
		close(h.done)
	}
}

// stream is the handler for GET /api/stream.
func (h *Hub) stream(w http.ResponseWriter, r *http.Request) {
	rc := http.NewResponseController(w)
	ch, ok := h.subscribe()
	if !ok {
		writeError(w, http.StatusServiceUnavailable, "server is shutting down")
		return
	}
	defer h.unsubscribe(ch)

	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("X-Accel-Buffering", "no") // nginx: do not buffer the stream
	w.WriteHeader(http.StatusOK)
	// Tell the browser to retry after 3 seconds if the stream breaks.
	if _, err := w.Write([]byte("retry: 3000\n: connected\n\n")); err != nil {
		return
	}
	if err := rc.Flush(); err != nil {
		return
	}

	beat := time.NewTicker(heartbeatEvery)
	defer beat.Stop()
	for {
		var msg []byte
		select {
		case <-r.Context().Done():
			return
		case <-h.done:
			return
		case <-beat.C:
			msg = []byte(": ping\n\n")
		case c := <-ch:
			b, _ := json.Marshal(c)
			msg = append(append([]byte("data: "), b...), '\n', '\n')
		}
		if _, err := w.Write(msg); err != nil {
			return
		}
		if err := rc.Flush(); err != nil {
			return
		}
	}
}

// statusWriter remembers the response status.
type statusWriter struct {
	http.ResponseWriter
	status int
}

func (s *statusWriter) WriteHeader(code int) {
	if s.status == 0 {
		s.status = code
	}
	s.ResponseWriter.WriteHeader(code)
}

func (s *statusWriter) Write(b []byte) (int, error) {
	if s.status == 0 {
		s.status = http.StatusOK
	}
	return s.ResponseWriter.Write(b)
}

// notify wraps a handler that changes data: after a successful response it
// tells all streams which topics changed.
func (h *Hub) notify(next http.HandlerFunc, topics ...string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sw := &statusWriter{ResponseWriter: w}
		next(sw, r)
		if sw.status < 200 || sw.status >= 300 {
			return
		}
		client := r.Header.Get(clientHeader)
		if len(client) > maxClientIDLen {
			client = ""
		}
		for _, t := range topics {
			h.Publish(change{Topic: t, Client: client})
		}
	}
}
