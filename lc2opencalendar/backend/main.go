// lc2opencalendar is a self-hosted calendar.
//
// This binary serves the JSON API under /api and the embedded React frontend
// for every other path.
package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	// Embed the time zone database so the image works without system tzdata.
	_ "time/tzdata"
)

const defaultPort = ":10085"

type serverConfig struct {
	Port     string `json:"port"`
	Database string `json:"database"`
}

func main() {
	config, err := loadConfig(os.Args[1:], "backend.config.json")
	if err != nil {
		log.Fatalf("load server configuration: %v", err)
	}
	addr := config.Port
	dbPath := config.Database

	store, err := OpenStore(dbPath)
	if err != nil {
		log.Fatalf("open database %q: %v", dbPath, err)
	}
	defer store.Close()

	hub := NewHub()
	mux := http.NewServeMux()
	NewAPI(store, hub).Register(mux)
	mux.Handle("/", frontendHandler())

	srv := &http.Server{
		Addr:              addr,
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
	}
	// Live update streams stay open forever; end them so Shutdown does not wait.
	srv.RegisterOnShutdown(hub.Close)

	go func() {
		log.Printf("lc2opencalendar listening on %s (database: %s)", addr, dbPath)
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("server: %v", err)
		}
	}()

	// Stop cleanly on Ctrl+C or `docker stop`.
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt, syscall.SIGTERM)
	<-stop
	log.Print("shutting down")
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Printf("shutdown: %v", err)
	}
}

func loadConfig(args []string, configPath string) (serverConfig, error) {
	config := serverConfig{
		Port:     defaultPort,
		Database: "lc2opencalendar.db",
	}

	data, err := os.ReadFile(configPath)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		return serverConfig{}, err
	}
	if err == nil {
		var fileConfig struct {
			Port     *string `json:"port"`
			Database *string `json:"database"`
		}
		if err := json.Unmarshal(data, &fileConfig); err != nil {
			return serverConfig{}, fmt.Errorf("decode %s: %w", configPath, err)
		}
		if fileConfig.Port != nil {
			config.Port = *fileConfig.Port
		}
		if fileConfig.Database != nil {
			config.Database = *fileConfig.Database
		}
	}

	if addr := os.Getenv("lc2opencalendar_ADDR"); addr != "" {
		config.Port = addr
	}
	if dbPath := os.Getenv("lc2opencalendar_DB"); dbPath != "" {
		config.Database = dbPath
	}

	flags := flag.NewFlagSet("lc2opencalendar", flag.ContinueOnError)
	flags.SetOutput(io.Discard)
	port := flags.String("port", "", "Address to listen on (e.g. :10085)")
	database := flags.String("database", "", "Path to the SQLite database")
	flags.StringVar(database, "db", "", "Path to the SQLite database (alias for -database)")
	if err := flags.Parse(args); err != nil {
		return serverConfig{}, err
	}
	flags.Visit(func(f *flag.Flag) {
		switch f.Name {
		case "port":
			config.Port = *port
		case "database", "db":
			config.Database = *database
		}
	})
	if config.Port == "" {
		return serverConfig{}, errors.New("port must not be empty")
	}
	if config.Database == "" {
		return serverConfig{}, errors.New("database must not be empty")
	}
	return config, nil
}
