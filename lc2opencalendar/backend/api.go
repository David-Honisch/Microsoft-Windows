package main

import (
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"
)

// API holds the HTTP handlers for /api.
type API struct {
	store *Store
	hub   *Hub
}

func NewAPI(store *Store, hub *Hub) *API { return &API{store: store, hub: hub} }

func (a *API) Register(mux *http.ServeMux) {
	h := a.hub
	mux.HandleFunc("GET /api/health", a.health)
	mux.HandleFunc("GET /api/stream", h.stream)
	mux.HandleFunc("GET /api/events", a.listEvents)
	mux.HandleFunc("POST /api/events", h.notify(a.createEvent, "events"))
	mux.HandleFunc("PUT /api/events/{id}", h.notify(a.updateEvent, "events"))
	mux.HandleFunc("DELETE /api/events/{id}", h.notify(a.deleteEvent, "events"))
	mux.HandleFunc("GET /api/calendars", a.listCalendars)
	mux.HandleFunc("POST /api/calendars", h.notify(a.createCalendar, "calendars"))
	mux.HandleFunc("PUT /api/calendars/{id}", h.notify(a.updateCalendar, "calendars"))
	// Deleting a calendar also deletes its events.
	mux.HandleFunc("DELETE /api/calendars/{id}", h.notify(a.deleteCalendar, "calendars", "events"))
	mux.HandleFunc("GET /api/settings", a.getSettings)
	mux.HandleFunc("PUT /api/settings", h.notify(a.putSettings, "settings"))
	mux.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
		writeError(w, http.StatusNotFound, "not found")
	})
}

func (a *API) health(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

// ---- Events ----

const (
	maxTitleLen       = 1000
	maxDescriptionLen = 20000
	maxEventLength    = 366 * 24 * time.Hour
	maxBodyBytes      = 1 << 20
	maxReminders      = 5
	maxReminderMins   = 4 * 7 * 24 * 60 // 4 weeks
)

var colorRe = regexp.MustCompile(`^#[0-9a-fA-F]{6}$`)

type eventInput struct {
	// CalendarID 0 (or missing) means the primary calendar.
	CalendarID int64 `json:"calendarId"`
	// TimeZone of the event's times ('' = the primary time zone).
	TimeZone    string    `json:"timeZone"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Color       string    `json:"color"`
	Start       time.Time `json:"start"`
	End         time.Time `json:"end"`
	Reminders   []int     `json:"reminders"`
}

func (in eventInput) validate() (Event, error) {
	e := Event{
		CalendarID:  in.CalendarID,
		TimeZone:    in.TimeZone,
		Title:       strings.TrimSpace(in.Title),
		Description: in.Description,
		Color:       in.Color,
		Start:       in.Start.UTC(),
		End:         in.End.UTC(),
		Reminders:   []int{},
	}
	for _, m := range in.Reminders {
		if m < 0 || m > maxReminderMins {
			return e, errors.New("reminders must be between 0 minutes and 4 weeks before the event")
		}
		if !contains(e.Reminders, m) {
			e.Reminders = append(e.Reminders, m)
		}
	}
	sort.Ints(e.Reminders)
	switch {
	case len(e.Reminders) > maxReminders:
		return e, errors.New("too many reminders")
	case in.Start.IsZero() || in.End.IsZero():
		return e, errors.New("start and end are required")
	case !e.End.After(e.Start):
		return e, errors.New("end must be after start")
	case e.End.Sub(e.Start) > maxEventLength:
		return e, errors.New("event is too long")
	case utf8.RuneCountInString(e.Title) > maxTitleLen:
		return e, errors.New("title is too long")
	case utf8.RuneCountInString(e.Description) > maxDescriptionLen:
		return e, errors.New("description is too long")
	case e.Color != "" && !colorRe.MatchString(e.Color):
		return e, errors.New("color must look like #1a2b3c")
	case !validTimeZone(e.TimeZone):
		return e, errors.New("invalid timeZone")
	}
	return e, nil
}

// validateEvent checks the input and its calendar. It writes the error response
// and returns false when the event cannot be saved.
func (a *API) validateEvent(w http.ResponseWriter, in eventInput) (Event, bool) {
	e, err := in.validate()
	if err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return e, false
	}
	if e.CalendarID == 0 {
		if e.CalendarID, err = a.store.PrimaryCalendarID(); err != nil {
			serverError(w, err)
			return e, false
		}
	} else if _, err := a.store.GetCalendar(e.CalendarID); errors.Is(err, ErrNotFound) {
		writeError(w, http.StatusBadRequest, "calendar not found")
		return e, false
	} else if err != nil {
		serverError(w, err)
		return e, false
	}
	return e, true
}

func (a *API) listEvents(w http.ResponseWriter, r *http.Request) {
	from, err1 := time.Parse(time.RFC3339, r.URL.Query().Get("start"))
	to, err2 := time.Parse(time.RFC3339, r.URL.Query().Get("end"))
	if err1 != nil || err2 != nil {
		writeError(w, http.StatusBadRequest, "start and end query parameters must be RFC 3339 times")
		return
	}
	events, err := a.store.ListEvents(from, to)
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, events)
}

func (a *API) createEvent(w http.ResponseWriter, r *http.Request) {
	var in eventInput
	if !readJSON(w, r, &in) {
		return
	}
	e, ok := a.validateEvent(w, in)
	if !ok {
		return
	}
	created, err := a.store.CreateEvent(e)
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, created)
}

func (a *API) updateEvent(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(w, r)
	if !ok {
		return
	}
	var in eventInput
	if !readJSON(w, r, &in) {
		return
	}
	e, ok := a.validateEvent(w, in)
	if !ok {
		return
	}
	e.ID = id
	updated, err := a.store.UpdateEvent(e)
	if errors.Is(err, ErrNotFound) {
		writeError(w, http.StatusNotFound, "event not found")
		return
	}
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, updated)
}

func (a *API) deleteEvent(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(w, r)
	if !ok {
		return
	}
	err := a.store.DeleteEvent(id)
	if errors.Is(err, ErrNotFound) {
		writeError(w, http.StatusNotFound, "event not found")
		return
	}
	if err != nil {
		serverError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

// ---- Calendars ----

const (
	maxCalendarNameLen = 200
	maxCalendars       = 100
)

// calendarInput is used to create a calendar (name is required) and to
// change one (only the fields that are sent are changed).
type calendarInput struct {
	Name        *string `json:"name"`
	Description *string `json:"description"`
	Color       *string `json:"color"`
	TimeZone    *string `json:"timeZone"`
	Hidden      *bool   `json:"hidden"`
}

const maxOtherTimeZones = 5

// cleanTimeZones checks a list of other time zones and removes duplicates.
func cleanTimeZones(in []string) ([]string, error) {
	out := []string{}
	for _, z := range in {
		if z == "" || !validTimeZone(z) {
			return nil, errors.New("invalid otherTimeZones")
		}
		if !contains(out, z) {
			out = append(out, z)
		}
	}
	if len(out) > maxOtherTimeZones {
		return nil, errors.New("too many otherTimeZones")
	}
	return out, nil
}

// validTimeZone: empty (use the primary time zone) or a known IANA name.
func validTimeZone(tz string) bool {
	if tz == "" {
		return true
	}
	_, err := time.LoadLocation(tz)
	return err == nil && tz != "Local"
}

// apply copies the sent fields into c and checks them.
func (in calendarInput) apply(c *Calendar) error {
	if in.Name != nil {
		c.Name = strings.TrimSpace(*in.Name)
	}
	if in.Description != nil {
		c.Description = *in.Description
	}
	if in.Color != nil {
		c.Color = *in.Color
	}
	if in.TimeZone != nil {
		c.TimeZone = *in.TimeZone
	}
	if in.Hidden != nil {
		c.Hidden = *in.Hidden
	}
	switch {
	case c.Name == "":
		return errors.New("calendar name is required")
	case utf8.RuneCountInString(c.Name) > maxCalendarNameLen:
		return errors.New("calendar name is too long")
	case utf8.RuneCountInString(c.Description) > maxDescriptionLen:
		return errors.New("description is too long")
	case !colorRe.MatchString(c.Color):
		return errors.New("color must look like #1a2b3c")
	case !validTimeZone(c.TimeZone):
		return errors.New("invalid timeZone")
	}
	return nil
}

func (a *API) listCalendars(w http.ResponseWriter, r *http.Request) {
	list, err := a.store.ListCalendars()
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, list)
}

func (a *API) createCalendar(w http.ResponseWriter, r *http.Request) {
	var in calendarInput
	if !readJSON(w, r, &in) {
		return
	}
	c := Calendar{Color: primaryCalendarColor}
	if err := in.apply(&c); err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	n, err := a.store.CountCalendars()
	if err != nil {
		serverError(w, err)
		return
	}
	if n >= maxCalendars {
		writeError(w, http.StatusBadRequest, "too many calendars")
		return
	}
	created, err := a.store.CreateCalendar(c)
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, created)
}

func (a *API) updateCalendar(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(w, r)
	if !ok {
		return
	}
	var in calendarInput
	if !readJSON(w, r, &in) {
		return
	}
	c, err := a.store.GetCalendar(id)
	if errors.Is(err, ErrNotFound) {
		writeError(w, http.StatusNotFound, "calendar not found")
		return
	}
	if err != nil {
		serverError(w, err)
		return
	}
	if err := in.apply(&c); err != nil {
		writeError(w, http.StatusBadRequest, err.Error())
		return
	}
	updated, err := a.store.UpdateCalendar(c)
	if errors.Is(err, ErrNotFound) {
		writeError(w, http.StatusNotFound, "calendar not found")
		return
	}
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, updated)
}

func (a *API) deleteCalendar(w http.ResponseWriter, r *http.Request) {
	id, ok := pathID(w, r)
	if !ok {
		return
	}
	err := a.store.DeleteCalendar(id)
	switch {
	case errors.Is(err, ErrNotFound):
		writeError(w, http.StatusNotFound, "calendar not found")
	case errors.Is(err, ErrPrimary):
		writeError(w, http.StatusConflict, err.Error())
	case err != nil:
		serverError(w, err)
	default:
		w.WriteHeader(http.StatusNoContent)
	}
}

// ---- Settings ----

// Settings are the user preferences. An empty TimeZone means "use the browser's time zone".
type Settings struct {
	DateFormat      string `json:"dateFormat"`      // "MDY", "DMY" or "YMD"
	TimeFormat      string `json:"timeFormat"`      // "12h" or "24h"
	TimeZone        string `json:"timeZone"`        // IANA name, e.g. "Europe/Berlin"
	DefaultDuration int    `json:"defaultDuration"` // minutes
	Theme           string `json:"theme"`           // "system", "light" or "dark"
	// Notifications: "off", "desktop" (system notifications) or "alerts" (alert in the page).
	Notifications string `json:"notifications"`
	// SnoozeBefore: a snoozed notification shows again this many minutes before the event.
	SnoozeBefore int `json:"snoozeBefore"`
	// NotificationSound: play a sound with each notification.
	NotificationSound bool `json:"notificationSound"`
	// DefaultReminder: minutes before the event for new events, or -1 for no notification.
	DefaultReminder int `json:"defaultReminder"`
	// Animations: play opening and closing animations (sidebar, cards, dialogs).
	Animations bool `json:"animations"`
	// KeyboardShortcuts: single-key shortcuts (D, W, C, ?...) are on.
	KeyboardShortcuts bool `json:"keyboardShortcuts"`
	// OtherTimeZones: extra time zones (IANA names) shown next to the
	// primary one in the day/week grid and offered in the event form.
	OtherTimeZones []string `json:"otherTimeZones"`
}

var defaultSettings = Settings{
	DateFormat:      "MDY",
	TimeFormat:      "12h",
	TimeZone:        "",
	DefaultDuration: 60,
	Theme:           "system",

	Notifications:     "desktop",
	SnoozeBefore:      1,
	NotificationSound: true,
	DefaultReminder:   30,

	Animations:        true,
	KeyboardShortcuts: true,
	OtherTimeZones:    []string{},
}

var (
	allowedDateFormats = []string{"MDY", "DMY", "YMD"}
	allowedTimeFormats = []string{"12h", "24h"}
	allowedThemes      = []string{"system", "light", "dark"}
	allowedDurations   = []int{15, 20, 30, 45, 60, 90, 120}
	allowedNotify      = []string{"off", "desktop", "alerts"}
	allowedSnooze      = []int{0, 1, 5, 10, 15, 30}
	allowedDefaultRem  = []int{-1, 0, 5, 10, 15, 30, 60, 120, 1440, 2880, 10080}
)

func intSetting(raw map[string]string, key string, allowed []int, dst *int) {
	if v, ok := raw[key]; ok {
		if n, err := strconv.Atoi(v); err == nil && contains(allowed, n) {
			*dst = n
		}
	}
}

func contains[T comparable](list []T, v T) bool {
	for _, x := range list {
		if x == v {
			return true
		}
	}
	return false
}

func (a *API) loadSettings() (Settings, error) {
	s := defaultSettings
	raw, err := a.store.GetSettings()
	if err != nil {
		return s, err
	}
	if v, ok := raw["dateFormat"]; ok && contains(allowedDateFormats, v) {
		s.DateFormat = v
	}
	if v, ok := raw["timeFormat"]; ok && contains(allowedTimeFormats, v) {
		s.TimeFormat = v
	}
	if v, ok := raw["timeZone"]; ok {
		s.TimeZone = v
	}
	if v, ok := raw["defaultDuration"]; ok {
		if n, err := strconv.Atoi(v); err == nil && contains(allowedDurations, n) {
			s.DefaultDuration = n
		}
	}
	if v, ok := raw["theme"]; ok && contains(allowedThemes, v) {
		s.Theme = v
	}
	if v, ok := raw["notifications"]; ok && contains(allowedNotify, v) {
		s.Notifications = v
	}
	intSetting(raw, "snoozeBefore", allowedSnooze, &s.SnoozeBefore)
	if v, ok := raw["notificationSound"]; ok {
		s.NotificationSound = v == "true"
	}
	intSetting(raw, "defaultReminder", allowedDefaultRem, &s.DefaultReminder)
	if v, ok := raw["animations"]; ok {
		s.Animations = v == "true"
	}
	if v, ok := raw["keyboardShortcuts"]; ok {
		s.KeyboardShortcuts = v == "true"
	}
	if v, ok := raw["otherTimeZones"]; ok {
		var zones []string
		if json.Unmarshal([]byte(v), &zones) == nil {
			if zones, err := cleanTimeZones(zones); err == nil {
				s.OtherTimeZones = zones
			}
		}
	}
	return s, nil
}

func (a *API) getSettings(w http.ResponseWriter, r *http.Request) {
	s, err := a.loadSettings()
	if err != nil {
		serverError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, s)
}

// putSettings accepts a partial settings object and returns the full, saved settings.
func (a *API) putSettings(w http.ResponseWriter, r *http.Request) {
	var in struct {
		DateFormat      *string `json:"dateFormat"`
		TimeFormat      *string `json:"timeFormat"`
		TimeZone        *string `json:"timeZone"`
		DefaultDuration *int    `json:"defaultDuration"`
		Theme           *string `json:"theme"`

		Notifications     *string `json:"notifications"`
		SnoozeBefore      *int    `json:"snoozeBefore"`
		NotificationSound *bool   `json:"notificationSound"`
		DefaultReminder   *int    `json:"defaultReminder"`

		Animations        *bool `json:"animations"`
		KeyboardShortcuts *bool `json:"keyboardShortcuts"`

		OtherTimeZones *[]string `json:"otherTimeZones"`
	}
	if !readJSON(w, r, &in) {
		return
	}
	values := map[string]string{}
	if in.DateFormat != nil {
		if !contains(allowedDateFormats, *in.DateFormat) {
			writeError(w, http.StatusBadRequest, "invalid dateFormat")
			return
		}
		values["dateFormat"] = *in.DateFormat
	}
	if in.TimeFormat != nil {
		if !contains(allowedTimeFormats, *in.TimeFormat) {
			writeError(w, http.StatusBadRequest, "invalid timeFormat")
			return
		}
		values["timeFormat"] = *in.TimeFormat
	}
	if in.TimeZone != nil {
		if *in.TimeZone != "" {
			if !validTimeZone(*in.TimeZone) {
				writeError(w, http.StatusBadRequest, "invalid timeZone")
				return
			}
		}
		values["timeZone"] = *in.TimeZone
	}
	if in.DefaultDuration != nil {
		if !contains(allowedDurations, *in.DefaultDuration) {
			writeError(w, http.StatusBadRequest, "invalid defaultDuration")
			return
		}
		values["defaultDuration"] = strconv.Itoa(*in.DefaultDuration)
	}
	if in.Theme != nil {
		if !contains(allowedThemes, *in.Theme) {
			writeError(w, http.StatusBadRequest, "invalid theme")
			return
		}
		values["theme"] = *in.Theme
	}
	if in.Notifications != nil {
		if !contains(allowedNotify, *in.Notifications) {
			writeError(w, http.StatusBadRequest, "invalid notifications")
			return
		}
		values["notifications"] = *in.Notifications
	}
	if in.SnoozeBefore != nil {
		if !contains(allowedSnooze, *in.SnoozeBefore) {
			writeError(w, http.StatusBadRequest, "invalid snoozeBefore")
			return
		}
		values["snoozeBefore"] = strconv.Itoa(*in.SnoozeBefore)
	}
	if in.NotificationSound != nil {
		values["notificationSound"] = strconv.FormatBool(*in.NotificationSound)
	}
	if in.DefaultReminder != nil {
		if !contains(allowedDefaultRem, *in.DefaultReminder) {
			writeError(w, http.StatusBadRequest, "invalid defaultReminder")
			return
		}
		values["defaultReminder"] = strconv.Itoa(*in.DefaultReminder)
	}
	if in.Animations != nil {
		values["animations"] = strconv.FormatBool(*in.Animations)
	}
	if in.KeyboardShortcuts != nil {
		values["keyboardShortcuts"] = strconv.FormatBool(*in.KeyboardShortcuts)
	}
	if in.OtherTimeZones != nil {
		zones, err := cleanTimeZones(*in.OtherTimeZones)
		if err != nil {
			writeError(w, http.StatusBadRequest, err.Error())
			return
		}
		b, _ := json.Marshal(zones)
		values["otherTimeZones"] = string(b)
	}
	if err := a.store.SetSettings(values); err != nil {
		serverError(w, err)
		return
	}
	a.getSettings(w, r)
}

// ---- Helpers ----

func pathID(w http.ResponseWriter, r *http.Request) (int64, bool) {
	id, err := strconv.ParseInt(r.PathValue("id"), 10, 64)
	if err != nil || id <= 0 {
		writeError(w, http.StatusBadRequest, "invalid id")
		return 0, false
	}
	return id, true
}

func readJSON(w http.ResponseWriter, r *http.Request, dst any) bool {
	r.Body = http.MaxBytesReader(w, r.Body, maxBodyBytes)
	dec := json.NewDecoder(r.Body)
	dec.DisallowUnknownFields()
	if err := dec.Decode(dst); err != nil {
		writeError(w, http.StatusBadRequest, "invalid JSON: "+err.Error())
		return false
	}
	return true
}

func writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Cache-Control", "no-store")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func writeError(w http.ResponseWriter, status int, msg string) {
	writeJSON(w, status, map[string]string{"error": msg})
}

func serverError(w http.ResponseWriter, err error) {
	log.Printf("internal error: %v", err)
	writeError(w, http.StatusInternalServerError, "internal server error")
}
