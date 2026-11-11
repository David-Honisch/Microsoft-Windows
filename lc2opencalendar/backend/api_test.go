package main

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"reflect"
	"strconv"
	"strings"
	"testing"
)

func newTestServer(t *testing.T) *httptest.Server {
	t.Helper()
	store, err := OpenStore(filepath.Join(t.TempDir(), "test.db"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { store.Close() })
	mux := http.NewServeMux()
	NewAPI(store, NewHub()).Register(mux)
	srv := httptest.NewServer(mux)
	t.Cleanup(srv.Close)
	return srv
}

func do(t *testing.T, srv *httptest.Server, method, path, body string) (int, string) {
	t.Helper()
	req, err := http.NewRequest(method, srv.URL+path, strings.NewReader(body))
	if err != nil {
		t.Fatal(err)
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	defer res.Body.Close()
	var sb strings.Builder
	buf := make([]byte, 4096)
	for {
		n, err := res.Body.Read(buf)
		sb.Write(buf[:n])
		if err != nil {
			break
		}
	}
	return res.StatusCode, sb.String()
}

func TestEventLifecycle(t *testing.T) {
	srv := newTestServer(t)

	code, body := do(t, srv, "POST", "/api/events",
		`{"title":"Lunch","description":"","color":"#039be5","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	if code != http.StatusCreated {
		t.Fatalf("create: %d %s", code, body)
	}
	var e Event
	if err := json.Unmarshal([]byte(body), &e); err != nil {
		t.Fatal(err)
	}
	if e.ID == 0 || e.Title != "Lunch" {
		t.Fatalf("unexpected event: %+v", e)
	}

	// Overlapping range finds it, other range does not.
	_, body = do(t, srv, "GET", "/api/events?start=2026-11-06T00:00:00Z&end=2026-11-07T00:00:00Z", "")
	if !strings.Contains(body, "Lunch") {
		t.Fatalf("list should contain event: %s", body)
	}
	_, body = do(t, srv, "GET", "/api/events?start=2026-11-07T00:00:00Z&end=2026-11-08T00:00:00Z", "")
	if strings.TrimSpace(body) != "[]" {
		t.Fatalf("list should be empty: %s", body)
	}

	code, body = do(t, srv, "PUT", "/api/events/1",
		`{"title":"Late lunch","description":"x","color":"#d50000","start":"2026-11-06T13:00:00Z","end":"2026-11-06T14:30:00Z"}`)
	if code != http.StatusOK || !strings.Contains(body, "Late lunch") {
		t.Fatalf("update: %d %s", code, body)
	}

	if code, _ = do(t, srv, "DELETE", "/api/events/1", ""); code != http.StatusNoContent {
		t.Fatalf("delete: %d", code)
	}
	if code, _ = do(t, srv, "DELETE", "/api/events/1", ""); code != http.StatusNotFound {
		t.Fatalf("second delete: %d", code)
	}
}

func TestEventValidation(t *testing.T) {
	srv := newTestServer(t)
	bad := []string{
		`{"title":"x","start":"2026-11-06T13:00:00Z","end":"2026-11-06T12:00:00Z"}`,
		`{"title":"x","start":"2026-11-06T13:00:00Z"}`,
		`{"title":"x","color":"red","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`,
		`{"title":"x","unknown":1,"start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`,
	}
	for _, b := range bad {
		if code, body := do(t, srv, "POST", "/api/events", b); code != http.StatusBadRequest {
			t.Errorf("expected 400 for %s, got %d %s", b, code, body)
		}
	}
}

func TestSettings(t *testing.T) {
	srv := newTestServer(t)

	_, body := do(t, srv, "GET", "/api/settings", "")
	var s Settings
	if err := json.Unmarshal([]byte(body), &s); err != nil {
		t.Fatal(err)
	}
	if !reflect.DeepEqual(s, defaultSettings) {
		t.Fatalf("defaults: got %+v", s)
	}

	code, body := do(t, srv, "PUT", "/api/settings", `{"timeFormat":"24h","timeZone":"Europe/Berlin","defaultDuration":30,"theme":"dark"}`)
	if code != http.StatusOK {
		t.Fatalf("put: %d %s", code, body)
	}
	_ = json.Unmarshal([]byte(body), &s)
	if s.TimeFormat != "24h" || s.TimeZone != "Europe/Berlin" || s.DefaultDuration != 30 || s.Theme != "dark" || s.DateFormat != "MDY" {
		t.Fatalf("after put: %+v", s)
	}

	code, body = do(t, srv, "PUT", "/api/settings", `{"notifications":"alerts","snoozeBefore":10,"notificationSound":false,"defaultReminder":-1}`)
	if code != http.StatusOK {
		t.Fatalf("put notifications: %d %s", code, body)
	}
	_ = json.Unmarshal([]byte(body), &s)
	if s.Notifications != "alerts" || s.SnoozeBefore != 10 || s.NotificationSound || s.DefaultReminder != -1 {
		t.Fatalf("after notification put: %+v", s)
	}

	if !s.Animations {
		t.Fatalf("animations should be on by default: %+v", s)
	}
	code, body = do(t, srv, "PUT", "/api/settings", `{"animations":false}`)
	if code != http.StatusOK {
		t.Fatalf("put animations: %d %s", code, body)
	}
	_ = json.Unmarshal([]byte(body), &s)
	if s.Animations || s.Notifications != "alerts" {
		t.Fatalf("after animations put: %+v", s)
	}

	if !s.KeyboardShortcuts {
		t.Fatalf("keyboard shortcuts should be on by default: %+v", s)
	}
	code, body = do(t, srv, "PUT", "/api/settings", `{"keyboardShortcuts":false}`)
	if code != http.StatusOK {
		t.Fatalf("put keyboardShortcuts: %d %s", code, body)
	}
	_ = json.Unmarshal([]byte(body), &s)
	if s.KeyboardShortcuts || s.Animations {
		t.Fatalf("after keyboardShortcuts put: %+v", s)
	}

	for _, b := range []string{`{"timeZone":"Mars/Base"}`, `{"defaultDuration":7}`, `{"theme":"blue"}`,
		`{"notifications":"loud"}`, `{"snoozeBefore":2}`, `{"defaultReminder":7}`} {
		if code, _ := do(t, srv, "PUT", "/api/settings", b); code != http.StatusBadRequest {
			t.Errorf("expected 400 for %s, got %d", b, code)
		}
	}
}

func TestEventReminders(t *testing.T) {
	srv := newTestServer(t)

	// Old clients that send no reminders get an empty list.
	code, body := do(t, srv, "POST", "/api/events",
		`{"title":"A","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	if code != http.StatusCreated || !strings.Contains(body, `"reminders":[]`) {
		t.Fatalf("create without reminders: %d %s", code, body)
	}

	// Duplicates are removed and the list is sorted.
	code, body = do(t, srv, "POST", "/api/events",
		`{"title":"B","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z","reminders":[30,10,30,0]}`)
	if code != http.StatusCreated || !strings.Contains(body, `"reminders":[0,10,30]`) {
		t.Fatalf("create with reminders: %d %s", code, body)
	}
	_, body = do(t, srv, "GET", "/api/events?start=2026-11-06T00:00:00Z&end=2026-11-07T00:00:00Z", "")
	if !strings.Contains(body, `"reminders":[0,10,30]`) {
		t.Fatalf("list should keep reminders: %s", body)
	}

	for _, b := range []string{
		`{"title":"x","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z","reminders":[-1]}`,
		`{"title":"x","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z","reminders":[99999999]}`,
		`{"title":"x","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z","reminders":[1,2,3,4,5,6]}`,
	} {
		if code, body := do(t, srv, "POST", "/api/events", b); code != http.StatusBadRequest {
			t.Errorf("expected 400 for %s, got %d %s", b, code, body)
		}
	}
}

func TestMigrateAddsReminders(t *testing.T) {
	path := filepath.Join(t.TempDir(), "old.db")
	db, err := sql.Open("sqlite", "file:"+path)
	if err != nil {
		t.Fatal(err)
	}
	// The events table as it was before reminders existed.
	if _, err := db.Exec(`CREATE TABLE events (
		id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '',
		color TEXT NOT NULL DEFAULT '', start_ms INTEGER NOT NULL, end_ms INTEGER NOT NULL,
		created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL);
		INSERT INTO events (title, start_ms, end_ms, created_at, updated_at) VALUES ('old', 0, 1000, 0, 0);`); err != nil {
		t.Fatal(err)
	}
	db.Close()

	store, err := OpenStore(path)
	if err != nil {
		t.Fatal(err)
	}
	defer store.Close()
	e, err := store.GetEvent(1)
	if err != nil || e.Title != "old" || e.Reminders == nil || len(e.Reminders) != 0 {
		t.Fatalf("old event after migration: %+v %v", e, err)
	}
}

func TestMigrateAddsCalendars(t *testing.T) {
	path := filepath.Join(t.TempDir(), "old.db")
	db, err := sql.Open("sqlite", "file:"+path)
	if err != nil {
		t.Fatal(err)
	}
	// The events table as it was before calendars existed.
	if _, err := db.Exec(`CREATE TABLE events (
		id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '',
		color TEXT NOT NULL DEFAULT '', start_ms INTEGER NOT NULL, end_ms INTEGER NOT NULL,
		created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, reminders TEXT NOT NULL DEFAULT '[]');
		INSERT INTO events (title, color, start_ms, end_ms, created_at, updated_at) VALUES ('blue', '#039be5', 0, 1000, 0, 0);
		INSERT INTO events (title, color, start_ms, end_ms, created_at, updated_at) VALUES ('red', '#d50000', 0, 1000, 0, 0);`); err != nil {
		t.Fatal(err)
	}
	db.Close()

	for i := 0; i < 2; i++ { // opening twice must not change anything more
		store, err := OpenStore(path)
		if err != nil {
			t.Fatal(err)
		}
		cals, err := store.ListCalendars()
		if err != nil || len(cals) != 1 || !cals[0].Primary || cals[0].Name != primaryCalendarName {
			t.Fatalf("calendars after migration: %+v %v", cals, err)
		}
		blue, _ := store.GetEvent(1)
		red, _ := store.GetEvent(2)
		if blue.CalendarID != cals[0].ID || red.CalendarID != cals[0].ID {
			t.Fatalf("events should be in the primary calendar: %+v %+v", blue, red)
		}
		// The old default color now means "calendar color"; other colors stay.
		if blue.Color != "" || red.Color != "#d50000" {
			t.Fatalf("colors after migration: %q %q", blue.Color, red.Color)
		}
		store.Close()
	}
}

func TestCalendars(t *testing.T) {
	srv := newTestServer(t)

	// A new database has one primary calendar.
	_, body := do(t, srv, "GET", "/api/calendars", "")
	var cals []Calendar
	if err := json.Unmarshal([]byte(body), &cals); err != nil || len(cals) != 1 || !cals[0].Primary {
		t.Fatalf("calendars: %s %v", body, err)
	}
	primary := cals[0]

	code, body := do(t, srv, "POST", "/api/calendars", `{"name":"  Work ","color":"#0b8043","timeZone":"Asia/Tokyo"}`)
	if code != http.StatusCreated {
		t.Fatalf("create calendar: %d %s", code, body)
	}
	var work Calendar
	_ = json.Unmarshal([]byte(body), &work)
	if work.Name != "Work" || work.Primary || work.Hidden || work.Color != "#0b8043" || work.TimeZone != "Asia/Tokyo" {
		t.Fatalf("created calendar: %+v", work)
	}
	for _, b := range []string{`{"name":" "}`, `{"name":"x","color":"green"}`, `{"name":"x","primary":true}`, `{"name":"x","timeZone":"Mars/Base"}`, `{"name":"x","timeZone":"Local"}`} {
		if code, body := do(t, srv, "POST", "/api/calendars", b); code != http.StatusBadRequest {
			t.Errorf("expected 400 for %s, got %d %s", b, code, body)
		}
	}

	// Only the sent fields change.
	code, body = do(t, srv, "PUT", "/api/calendars/"+itoa(work.ID), `{"hidden":true}`)
	_ = json.Unmarshal([]byte(body), &work)
	if code != http.StatusOK || !work.Hidden || work.Name != "Work" || work.Color != "#0b8043" || work.TimeZone != "Asia/Tokyo" {
		t.Fatalf("hide calendar: %d %s", code, body)
	}
	code, body = do(t, srv, "PUT", "/api/calendars/"+itoa(work.ID), `{"timeZone":""}`)
	_ = json.Unmarshal([]byte(body), &work)
	if code != http.StatusOK || work.TimeZone != "" {
		t.Fatalf("clear time zone: %d %s", code, body)
	}
	if code, _ := do(t, srv, "PUT", "/api/calendars/999", `{"hidden":true}`); code != http.StatusNotFound {
		t.Fatalf("update missing calendar: %d", code)
	}

	// Events: no calendarId means the primary calendar; unknown calendars are refused.
	code, body = do(t, srv, "POST", "/api/events", `{"title":"A","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	var a Event
	_ = json.Unmarshal([]byte(body), &a)
	if code != http.StatusCreated || a.CalendarID != primary.ID {
		t.Fatalf("event without calendar: %d %s", code, body)
	}
	code, body = do(t, srv, "POST", "/api/events",
		`{"calendarId":`+itoa(work.ID)+`,"title":"B","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	var b Event
	_ = json.Unmarshal([]byte(body), &b)
	if code != http.StatusCreated || b.CalendarID != work.ID {
		t.Fatalf("event in Work: %d %s", code, body)
	}
	if code, body := do(t, srv, "POST", "/api/events",
		`{"calendarId":999,"title":"C","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`); code != http.StatusBadRequest {
		t.Fatalf("event in missing calendar: %d %s", code, body)
	}
	// Move an event to another calendar.
	code, body = do(t, srv, "PUT", "/api/events/"+itoa(a.ID),
		`{"calendarId":`+itoa(work.ID)+`,"title":"A","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	if code != http.StatusOK || !strings.Contains(body, `"calendarId":`+itoa(work.ID)) {
		t.Fatalf("move event: %d %s", code, body)
	}

	// The primary calendar cannot be deleted.
	if code, _ := do(t, srv, "DELETE", "/api/calendars/"+itoa(primary.ID), ""); code != http.StatusConflict {
		t.Fatalf("delete primary: %d", code)
	}
	// Deleting a calendar deletes its events.
	if code, _ := do(t, srv, "DELETE", "/api/calendars/"+itoa(work.ID), ""); code != http.StatusNoContent {
		t.Fatalf("delete calendar: %d", code)
	}
	_, body = do(t, srv, "GET", "/api/events?start=2026-11-06T00:00:00Z&end=2026-11-07T00:00:00Z", "")
	if strings.TrimSpace(body) != "[]" {
		t.Fatalf("events of a deleted calendar should be gone: %s", body)
	}
	if code, _ := do(t, srv, "DELETE", "/api/calendars/"+itoa(work.ID), ""); code != http.StatusNotFound {
		t.Fatalf("second delete: %d", code)
	}
}

func itoa(n int64) string { return strconv.FormatInt(n, 10) }

func TestTimeZones(t *testing.T) {
	srv := newTestServer(t)

	// Other time zones: duplicates removed, order kept.
	code, body := do(t, srv, "PUT", "/api/settings", `{"otherTimeZones":["Asia/Tokyo","America/New_York","Asia/Tokyo"]}`)
	var s Settings
	_ = json.Unmarshal([]byte(body), &s)
	if code != http.StatusOK || !reflect.DeepEqual(s.OtherTimeZones, []string{"Asia/Tokyo", "America/New_York"}) {
		t.Fatalf("other time zones: %d %s", code, body)
	}
	// Changing another setting keeps them.
	_, body = do(t, srv, "PUT", "/api/settings", `{"theme":"dark"}`)
	_ = json.Unmarshal([]byte(body), &s)
	if len(s.OtherTimeZones) != 2 {
		t.Fatalf("other time zones lost: %s", body)
	}
	for _, b := range []string{`{"otherTimeZones":["Mars/Base"]}`, `{"otherTimeZones":[""]}`,
		`{"otherTimeZones":["UTC","Asia/Tokyo","Europe/Paris","Europe/Berlin","America/Chicago","Africa/Cairo"]}`} {
		if code, _ := do(t, srv, "PUT", "/api/settings", b); code != http.StatusBadRequest {
			t.Errorf("expected 400 for %s, got %d", b, code)
		}
	}

	// Events keep their time zone.
	code, body = do(t, srv, "POST", "/api/events",
		`{"title":"A","timeZone":"Asia/Tokyo","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`)
	if code != http.StatusCreated || !strings.Contains(body, `"timeZone":"Asia/Tokyo"`) {
		t.Fatalf("event with time zone: %d %s", code, body)
	}
	if code, body := do(t, srv, "POST", "/api/events",
		`{"title":"B","timeZone":"Mars/Base","start":"2026-11-06T12:00:00Z","end":"2026-11-06T13:00:00Z"}`); code != http.StatusBadRequest {
		t.Fatalf("bad event time zone: %d %s", code, body)
	}
}
