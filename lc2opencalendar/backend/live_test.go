package main

import (
	"bufio"
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"testing"
	"time"
)

// openStream connects to /api/stream and returns a channel with each change.
func openStream(t *testing.T, url string) <-chan change {
	t.Helper()
	ctx, cancel := context.WithCancel(context.Background())
	t.Cleanup(cancel)
	req, _ := http.NewRequestWithContext(ctx, "GET", url+"/api/stream", nil)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	if ct := res.Header.Get("Content-Type"); ct != "text/event-stream" {
		t.Fatalf("content type %q", ct)
	}
	out := make(chan change, 16)
	connected := make(chan struct{})
	go func() {
		defer res.Body.Close()
		sc := bufio.NewScanner(res.Body)
		for sc.Scan() {
			line := sc.Text()
			if line == ": connected" {
				close(connected)
			}
			if data, ok := strings.CutPrefix(line, "data: "); ok {
				var c change
				if json.Unmarshal([]byte(data), &c) == nil {
					out <- c
				}
			}
		}
	}()
	select {
	case <-connected:
	case <-time.After(2 * time.Second):
		t.Fatal("stream did not connect")
	}
	return out
}

func expectChange(t *testing.T, ch <-chan change, want change) {
	t.Helper()
	select {
	case got := <-ch:
		if got != want {
			t.Fatalf("got %+v, want %+v", got, want)
		}
	case <-time.After(2 * time.Second):
		t.Fatalf("no change, want %+v", want)
	}
}

func TestStreamSendsChanges(t *testing.T) {
	srv := newTestServer(t)
	stream := openStream(t, srv.URL)

	// The client id from the header is passed on.
	req, _ := http.NewRequest("PUT", srv.URL+"/api/settings", strings.NewReader(`{"timeFormat":"24h"}`))
	req.Header.Set(clientHeader, "tab-1")
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	res.Body.Close()
	expectChange(t, stream, change{Topic: "settings", Client: "tab-1"})

	code, body := do(t, srv, "POST", "/api/events",
		`{"title":"A","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	if code != http.StatusCreated {
		t.Fatalf("create: %d %s", code, body)
	}
	expectChange(t, stream, change{Topic: "events"})

	// A failed change sends nothing.
	if code, _ := do(t, srv, "POST", "/api/events", `{"title":"bad"}`); code != http.StatusBadRequest {
		t.Fatalf("bad event: %d", code)
	}
	code, body = do(t, srv, "POST", "/api/calendars", `{"name":"Work"}`)
	if code != http.StatusCreated {
		t.Fatalf("create calendar: %d %s", code, body)
	}
	expectChange(t, stream, change{Topic: "calendars"})

	var cal Calendar
	json.Unmarshal([]byte(body), &cal)
	if code, _ := do(t, srv, "DELETE", "/api/calendars/"+itoa(cal.ID), ""); code != http.StatusNoContent {
		t.Fatalf("delete calendar: %d", code)
	}
	expectChange(t, stream, change{Topic: "calendars"})
	expectChange(t, stream, change{Topic: "events"})
}

func TestHubCloseEndsStreams(t *testing.T) {
	hub := NewHub()
	ch, ok := hub.subscribe()
	if !ok || ch == nil {
		t.Fatal("subscribe failed")
	}
	hub.Close()
	select {
	case <-hub.done:
	default:
		t.Fatal("done not closed")
	}
	if _, ok := hub.subscribe(); ok {
		t.Fatal("subscribe after close should fail")
	}
}
