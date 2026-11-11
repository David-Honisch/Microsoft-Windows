package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestLoadConfigUsesDefaultsWhenFileIsMissing(t *testing.T) {
	t.Setenv("lc2opencalendar_ADDR", "")
	t.Setenv("lc2opencalendar_DB", "")

	config, err := loadConfig(nil, filepath.Join(t.TempDir(), "missing.json"))
	if err != nil {
		t.Fatal(err)
	}
	if config != (serverConfig{Port: defaultPort, Database: "lc2opencalendar.db"}) {
		t.Fatalf("config = %+v, want defaults", config)
	}
}

func TestLoadConfigReadsFile(t *testing.T) {
	t.Setenv("lc2opencalendar_ADDR", "")
	t.Setenv("lc2opencalendar_DB", "")
	configPath := filepath.Join(t.TempDir(), "backend.config.json")
	if err := os.WriteFile(configPath, []byte(`{"port":":12345","database":"calendar.db"}`), 0600); err != nil {
		t.Fatal(err)
	}

	config, err := loadConfig(nil, configPath)
	if err != nil {
		t.Fatal(err)
	}
	if config != (serverConfig{Port: ":12345", Database: "calendar.db"}) {
		t.Fatalf("config = %+v, want values from file", config)
	}
}

func TestLoadConfigEnvironmentOverridesFile(t *testing.T) {
	t.Setenv("lc2opencalendar_ADDR", ":23456")
	t.Setenv("lc2opencalendar_DB", "environment.db")
	configPath := filepath.Join(t.TempDir(), "backend.config.json")
	if err := os.WriteFile(configPath, []byte(`{"port":":12345","database":"calendar.db"}`), 0600); err != nil {
		t.Fatal(err)
	}

	config, err := loadConfig(nil, configPath)
	if err != nil {
		t.Fatal(err)
	}
	if config != (serverConfig{Port: ":23456", Database: "environment.db"}) {
		t.Fatalf("config = %+v, want environment overrides", config)
	}
}

func TestLoadConfigCommandLineOverridesEnvironmentAndFile(t *testing.T) {
	t.Setenv("lc2opencalendar_ADDR", ":23456")
	t.Setenv("lc2opencalendar_DB", "environment.db")
	configPath := filepath.Join(t.TempDir(), "backend.config.json")
	if err := os.WriteFile(configPath, []byte(`{"port":":12345","database":"calendar.db"}`), 0600); err != nil {
		t.Fatal(err)
	}

	config, err := loadConfig([]string{"-port=:34567", "-db=command-line.db"}, configPath)
	if err != nil {
		t.Fatal(err)
	}
	if config != (serverConfig{Port: ":34567", Database: "command-line.db"}) {
		t.Fatalf("config = %+v, want command-line overrides", config)
	}
}

func TestLoadConfigRejectsInvalidFile(t *testing.T) {
	t.Setenv("lc2opencalendar_ADDR", "")
	t.Setenv("lc2opencalendar_DB", "")
	configPath := filepath.Join(t.TempDir(), "backend.config.json")
	if err := os.WriteFile(configPath, []byte(`{"port":`), 0600); err != nil {
		t.Fatal(err)
	}

	if _, err := loadConfig(nil, configPath); err == nil {
		t.Fatal("expected invalid config to return an error")
	}
}
