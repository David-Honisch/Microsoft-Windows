package main

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	_ "modernc.org/sqlite" // pure Go SQLite driver (no CGO)
)

// Event is a calendar event. Start and End are stored as Unix milliseconds (UTC).
type Event struct {
	ID         int64 `json:"id"`
	CalendarID int64 `json:"calendarId"`
	// TimeZone the event's times were set in (IANA name), or '' for the
	// primary time zone. Start and End are instants either way.
	TimeZone    string `json:"timeZone"`
	Title       string `json:"title"`
	Description string `json:"description"`
	// Color is empty when the event uses the color of its calendar.
	Color string    `json:"color"`
	Start time.Time `json:"start"`
	End   time.Time `json:"end"`
	// Reminders are notification times in minutes before the start (sorted, no duplicates).
	Reminders []int `json:"reminders"`
}

// Calendar groups events, like "Work" or "Family". There is always one
// primary calendar; it cannot be deleted.
type Calendar struct {
	ID          int64  `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Color       string `json:"color"`
	// TimeZone is an IANA name like "Europe/Berlin", or empty for "same as
	// the primary time zone" (the timeZone setting).
	TimeZone string `json:"timeZone"`
	// Hidden calendars stay in the list, but their events are not shown.
	Hidden  bool `json:"hidden"`
	Primary bool `json:"primary"`
}

var (
	ErrNotFound = errors.New("not found")
	ErrPrimary  = errors.New("the primary calendar cannot be deleted")
)

// Name and color of the calendar made for a new (or older) database.
const (
	primaryCalendarName  = "My calendar"
	primaryCalendarColor = "#039be5"
)

// Store wraps the SQLite database.
type Store struct {
	db *sql.DB
}

const schema = `
CREATE TABLE IF NOT EXISTS events (
	id          INTEGER PRIMARY KEY AUTOINCREMENT,
	title       TEXT    NOT NULL DEFAULT '',
	description TEXT    NOT NULL DEFAULT '',
	color       TEXT    NOT NULL DEFAULT '',
	start_ms    INTEGER NOT NULL,
	end_ms      INTEGER NOT NULL,
	created_at  INTEGER NOT NULL,
	updated_at  INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS events_start_end ON events(start_ms, end_ms);

CREATE TABLE IF NOT EXISTS calendars (
	id          INTEGER PRIMARY KEY AUTOINCREMENT,
	name        TEXT    NOT NULL,
	description TEXT    NOT NULL DEFAULT '',
	color       TEXT    NOT NULL,
	time_zone   TEXT    NOT NULL DEFAULT '',
	hidden      INTEGER NOT NULL DEFAULT 0,
	is_primary  INTEGER NOT NULL DEFAULT 0,
	created_at  INTEGER NOT NULL,
	updated_at  INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS settings (
	key   TEXT PRIMARY KEY,
	value TEXT NOT NULL
);
`

// OpenStore opens (or creates) the database file and makes sure the tables exist.
func OpenStore(path string) (*Store, error) {
	dsn := "file:" + path + "?_pragma=busy_timeout(5000)&_pragma=journal_mode(WAL)&_pragma=foreign_keys(1)"
	db, err := sql.Open("sqlite", dsn)
	if err != nil {
		return nil, err
	}
	// One connection keeps SQLite simple and avoids "database is locked" errors.
	db.SetMaxOpenConns(1)
	if _, err := db.Exec(schema); err != nil {
		db.Close()
		return nil, fmt.Errorf("create schema: %w", err)
	}
	if err := migrate(db); err != nil {
		db.Close()
		return nil, fmt.Errorf("migrate: %w", err)
	}
	return &Store{db: db}, nil
}

// migrate adds columns that older databases do not have yet, and makes sure
// there is a primary calendar.
func migrate(db *sql.DB) error {
	has, err := hasColumn(db, "events", "reminders")
	if err != nil {
		return err
	}
	if !has {
		if _, err := db.Exec(`ALTER TABLE events ADD COLUMN reminders TEXT NOT NULL DEFAULT '[]'`); err != nil {
			return err
		}
	}

	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Events made before events had a time zone.
	has, err = hasColumn(tx, "events", "time_zone")
	if err != nil {
		return err
	}
	if !has {
		if _, err := tx.Exec(`ALTER TABLE events ADD COLUMN time_zone TEXT NOT NULL DEFAULT ''`); err != nil {
			return err
		}
	}

	// Calendar tables made before calendars had a time zone.
	has, err = hasColumn(tx, "calendars", "time_zone")
	if err != nil {
		return err
	}
	if !has {
		if _, err := tx.Exec(`ALTER TABLE calendars ADD COLUMN time_zone TEXT NOT NULL DEFAULT ''`); err != nil {
			return err
		}
	}

	primary, err := ensurePrimaryCalendar(tx)
	if err != nil {
		return err
	}
	has, err = hasColumn(tx, "events", "calendar_id")
	if err != nil {
		return err
	}
	if !has {
		// Events from before calendars all go to the primary calendar.
		// They were always saved with the default color, so that color now
		// means "use the calendar color": they follow the calendar if its
		// color changes.
		if _, err := tx.Exec(`ALTER TABLE events ADD COLUMN calendar_id INTEGER NOT NULL DEFAULT 0`); err != nil {
			return err
		}
		if _, err := tx.Exec(`UPDATE events SET color = '' WHERE color = ?`, primaryCalendarColor); err != nil {
			return err
		}
	}
	// Also repairs events whose calendar is missing.
	if _, err := tx.Exec(`
		UPDATE events SET calendar_id = ?
		WHERE calendar_id NOT IN (SELECT id FROM calendars)`, primary); err != nil {
		return err
	}
	if _, err := tx.Exec(`CREATE INDEX IF NOT EXISTS events_calendar ON events(calendar_id)`); err != nil {
		return err
	}
	return tx.Commit()
}

// ensurePrimaryCalendar returns the id of the primary calendar, and creates
// it if there is none.
func ensurePrimaryCalendar(tx *sql.Tx) (int64, error) {
	var id int64
	err := tx.QueryRow(`SELECT id FROM calendars WHERE is_primary = 1 ORDER BY id LIMIT 1`).Scan(&id)
	if err == nil {
		return id, nil
	}
	if !errors.Is(err, sql.ErrNoRows) {
		return 0, err
	}
	// No primary calendar: use the oldest one, or make a new one.
	err = tx.QueryRow(`SELECT id FROM calendars ORDER BY id LIMIT 1`).Scan(&id)
	if errors.Is(err, sql.ErrNoRows) {
		now := nowMs()
		res, err := tx.Exec(`
			INSERT INTO calendars (name, color, is_primary, created_at, updated_at)
			VALUES (?, ?, 1, ?, ?)`, primaryCalendarName, primaryCalendarColor, now, now)
		if err != nil {
			return 0, err
		}
		return res.LastInsertId()
	}
	if err != nil {
		return 0, err
	}
	_, err = tx.Exec(`UPDATE calendars SET is_primary = 1 WHERE id = ?`, id)
	return id, err
}

type querier interface {
	Query(query string, args ...any) (*sql.Rows, error)
}

func hasColumn(db querier, table, column string) (bool, error) {
	rows, err := db.Query(`SELECT name FROM pragma_table_info(?)`, table)
	if err != nil {
		return false, err
	}
	defer rows.Close()
	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			return false, err
		}
		if name == column {
			return true, nil
		}
	}
	return false, rows.Err()
}

func encodeReminders(r []int) string {
	if r == nil {
		r = []int{}
	}
	b, _ := json.Marshal(r)
	return string(b)
}

func decodeReminders(s string) []int {
	r := []int{}
	_ = json.Unmarshal([]byte(s), &r)
	return r
}

func (s *Store) Close() error { return s.db.Close() }

func toMs(t time.Time) int64    { return t.UnixMilli() }
func fromMs(ms int64) time.Time { return time.UnixMilli(ms).UTC() }
func nowMs() int64              { return time.Now().UnixMilli() }

// ListEvents returns events that overlap the range [from, to).
func (s *Store) ListEvents(from, to time.Time) ([]Event, error) {
	rows, err := s.db.Query(`
		SELECT id, calendar_id, time_zone, title, description, color, start_ms, end_ms, reminders
		FROM events
		WHERE start_ms < ? AND end_ms > ?
		ORDER BY start_ms, end_ms DESC, id`, toMs(to), toMs(from))
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	events := []Event{}
	for rows.Next() {
		var e Event
		var start, end int64
		var reminders string
		if err := rows.Scan(&e.ID, &e.CalendarID, &e.TimeZone, &e.Title, &e.Description, &e.Color, &start, &end, &reminders); err != nil {
			return nil, err
		}
		e.Start, e.End = fromMs(start), fromMs(end)
		e.Reminders = decodeReminders(reminders)
		events = append(events, e)
	}
	return events, rows.Err()
}

func (s *Store) GetEvent(id int64) (Event, error) {
	var e Event
	var start, end int64
	var reminders string
	err := s.db.QueryRow(`
		SELECT id, calendar_id, time_zone, title, description, color, start_ms, end_ms, reminders
		FROM events WHERE id = ?`, id).
		Scan(&e.ID, &e.CalendarID, &e.TimeZone, &e.Title, &e.Description, &e.Color, &start, &end, &reminders)
	if errors.Is(err, sql.ErrNoRows) {
		return e, ErrNotFound
	}
	e.Start, e.End = fromMs(start), fromMs(end)
	e.Reminders = decodeReminders(reminders)
	return e, err
}

func (s *Store) CreateEvent(e Event) (Event, error) {
	now := nowMs()
	res, err := s.db.Exec(`
		INSERT INTO events (calendar_id, time_zone, title, description, color, start_ms, end_ms, reminders, created_at, updated_at)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		e.CalendarID, e.TimeZone, e.Title, e.Description, e.Color, toMs(e.Start), toMs(e.End), encodeReminders(e.Reminders), now, now)
	if err != nil {
		return e, err
	}
	id, err := res.LastInsertId()
	if err != nil {
		return e, err
	}
	return s.GetEvent(id)
}

func (s *Store) UpdateEvent(e Event) (Event, error) {
	res, err := s.db.Exec(`
		UPDATE events
		SET calendar_id = ?, time_zone = ?, title = ?, description = ?, color = ?, start_ms = ?, end_ms = ?, reminders = ?, updated_at = ?
		WHERE id = ?`,
		e.CalendarID, e.TimeZone, e.Title, e.Description, e.Color, toMs(e.Start), toMs(e.End), encodeReminders(e.Reminders), nowMs(), e.ID)
	if err != nil {
		return e, err
	}
	if n, _ := res.RowsAffected(); n == 0 {
		return e, ErrNotFound
	}
	return s.GetEvent(e.ID)
}

func (s *Store) DeleteEvent(id int64) error {
	res, err := s.db.Exec(`DELETE FROM events WHERE id = ?`, id)
	if err != nil {
		return err
	}
	if n, _ := res.RowsAffected(); n == 0 {
		return ErrNotFound
	}
	return nil
}

// ---- Calendars ----

const calendarColumns = `id, name, description, color, time_zone, hidden, is_primary`

func scanCalendar(row interface{ Scan(...any) error }) (Calendar, error) {
	var c Calendar
	err := row.Scan(&c.ID, &c.Name, &c.Description, &c.Color, &c.TimeZone, &c.Hidden, &c.Primary)
	return c, err
}

// ListCalendars returns the primary calendar first, then the others by name.
func (s *Store) ListCalendars() ([]Calendar, error) {
	rows, err := s.db.Query(`SELECT ` + calendarColumns + ` FROM calendars
		ORDER BY is_primary DESC, name COLLATE NOCASE, id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	list := []Calendar{}
	for rows.Next() {
		c, err := scanCalendar(rows)
		if err != nil {
			return nil, err
		}
		list = append(list, c)
	}
	return list, rows.Err()
}

func (s *Store) GetCalendar(id int64) (Calendar, error) {
	c, err := scanCalendar(s.db.QueryRow(`SELECT `+calendarColumns+` FROM calendars WHERE id = ?`, id))
	if errors.Is(err, sql.ErrNoRows) {
		return c, ErrNotFound
	}
	return c, err
}

func (s *Store) PrimaryCalendarID() (int64, error) {
	var id int64
	err := s.db.QueryRow(`SELECT id FROM calendars WHERE is_primary = 1 ORDER BY id LIMIT 1`).Scan(&id)
	return id, err
}

func (s *Store) CountCalendars() (int, error) {
	var n int
	err := s.db.QueryRow(`SELECT COUNT(*) FROM calendars`).Scan(&n)
	return n, err
}

func (s *Store) CreateCalendar(c Calendar) (Calendar, error) {
	now := nowMs()
	res, err := s.db.Exec(`
		INSERT INTO calendars (name, description, color, time_zone, hidden, is_primary, created_at, updated_at)
		VALUES (?, ?, ?, ?, ?, 0, ?, ?)`,
		c.Name, c.Description, c.Color, c.TimeZone, c.Hidden, now, now)
	if err != nil {
		return c, err
	}
	id, err := res.LastInsertId()
	if err != nil {
		return c, err
	}
	return s.GetCalendar(id)
}

// UpdateCalendar saves name, description, color, time zone and hidden. Primary is not changed.
func (s *Store) UpdateCalendar(c Calendar) (Calendar, error) {
	res, err := s.db.Exec(`
		UPDATE calendars SET name = ?, description = ?, color = ?, time_zone = ?, hidden = ?, updated_at = ?
		WHERE id = ?`,
		c.Name, c.Description, c.Color, c.TimeZone, c.Hidden, nowMs(), c.ID)
	if err != nil {
		return c, err
	}
	if n, _ := res.RowsAffected(); n == 0 {
		return c, ErrNotFound
	}
	return s.GetCalendar(c.ID)
}

// DeleteCalendar deletes a calendar and all of its events.
func (s *Store) DeleteCalendar(id int64) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()
	var primary bool
	err = tx.QueryRow(`SELECT is_primary FROM calendars WHERE id = ?`, id).Scan(&primary)
	if errors.Is(err, sql.ErrNoRows) {
		return ErrNotFound
	}
	if err != nil {
		return err
	}
	if primary {
		return ErrPrimary
	}
	if _, err := tx.Exec(`DELETE FROM events WHERE calendar_id = ?`, id); err != nil {
		return err
	}
	if _, err := tx.Exec(`DELETE FROM calendars WHERE id = ?`, id); err != nil {
		return err
	}
	return tx.Commit()
}

// Settings are stored as key/value text pairs.
func (s *Store) GetSettings() (map[string]string, error) {
	rows, err := s.db.Query(`SELECT key, value FROM settings`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := map[string]string{}
	for rows.Next() {
		var k, v string
		if err := rows.Scan(&k, &v); err != nil {
			return nil, err
		}
		out[k] = v
	}
	return out, rows.Err()
}

func (s *Store) SetSettings(values map[string]string) error {
	tx, err := s.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()
	for k, v := range values {
		if _, err := tx.Exec(`
			INSERT INTO settings (key, value) VALUES (?, ?)
			ON CONFLICT(key) DO UPDATE SET value = excluded.value`, k, v); err != nil {
			return err
		}
	}
	return tx.Commit()
}
