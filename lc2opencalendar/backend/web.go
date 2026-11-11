package main

import (
	"embed"
	"io/fs"
	"net/http"
	"path"
	"strings"
)

// The frontend is built by Vite and copied into web/dist before `go build`
// (the Dockerfile and `npm run build:app` do this).
//
//go:embed all:web/dist
var webFiles embed.FS

func frontendHandler() http.Handler {
	dist, err := fs.Sub(webFiles, "web/dist")
	if err != nil {
		panic(err)
	}
	if _, err := fs.Stat(dist, "index.html"); err != nil {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.Header().Set("Content-Type", "text/plain; charset=utf-8")
			w.WriteHeader(http.StatusServiceUnavailable)
			_, _ = w.Write([]byte("The frontend is not built into this binary.\n" +
				"Build it with `npm run build:app`, or run the Vite dev server (see README.md).\n"))
		})
	}

	files := http.FileServerFS(dist)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimPrefix(path.Clean(r.URL.Path), "/")
		if name == "" {
			name = "index.html"
		}
		if _, err := fs.Stat(dist, name); err != nil {
			// Unknown path: serve the app shell (single-page app).
			serveIndex(w, r, dist)
			return
		}
		if strings.HasPrefix(name, "assets/") {
			// Vite puts a content hash in these file names, so they never change.
			w.Header().Set("Cache-Control", "public, max-age=31536000, immutable")
		} else {
			w.Header().Set("Cache-Control", "no-cache")
		}
		files.ServeHTTP(w, r)
	})
}

func serveIndex(w http.ResponseWriter, r *http.Request, dist fs.FS) {
	data, err := fs.ReadFile(dist, "index.html")
	if err != nil {
		http.NotFound(w, r)
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Header().Set("Cache-Control", "no-cache")
	_, _ = w.Write(data)
}
