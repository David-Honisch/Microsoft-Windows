// Small wrapper around the Go JSON API.

import { CLIENT_ID } from './live';
import type { Calendar, CalendarEvent, CalendarPatch, Draft, Settings } from './types';

// An event as the API sends it: times are ISO strings.
type WireEvent = Omit<CalendarEvent, 'start' | 'end' | 'reminders'> & {
  start: string;
  end: string;
  reminders: number[] | null;
};

async function request<R>(method: string, path: string, body?: unknown): Promise<R> {
  const res = await fetch(path, {
    method,
    // The client id lets the live stream tell other apps who made a change.
    headers: body ? { 'Content-Type': 'application/json', 'X-lc2opencalendar-Client': CLIENT_ID } : { 'X-lc2opencalendar-Client': CLIENT_ID },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 204) return null as R;
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || `Request failed (${res.status})`);
  return data as R;
}

// Events use instants in milliseconds in the app, and ISO strings on the wire.
const fromWire = (e: WireEvent): CalendarEvent => ({
  ...e,
  start: Date.parse(e.start),
  end: Date.parse(e.end),
  reminders: e.reminders || [],
});
const toWire = (e: Draft) => ({
  calendarId: e.calendarId || 0,
  timeZone: e.timeZone || '',
  title: e.title,
  description: e.description,
  color: e.color,
  start: new Date(e.start).toISOString(),
  end: new Date(e.end).toISOString(),
  reminders: e.reminders || [],
});

export const api = {
  listEvents: async (start: number, end: number): Promise<CalendarEvent[]> => {
    const q = new URLSearchParams({
      start: new Date(start).toISOString().replace(/\.\d{3}Z$/, 'Z'),
      end: new Date(end).toISOString().replace(/\.\d{3}Z$/, 'Z'),
    });
    return (await request<WireEvent[]>('GET', `/api/events?${q}`)).map(fromWire);
  },
  createEvent: async (e: Draft) => fromWire(await request<WireEvent>('POST', '/api/events', toWire(e))),
  updateEvent: async (e: Draft) => fromWire(await request<WireEvent>('PUT', `/api/events/${e.id}`, toWire(e))),
  deleteEvent: (id: number) => request<null>('DELETE', `/api/events/${id}`),
  listCalendars: () => request<Calendar[]>('GET', '/api/calendars'),
  createCalendar: (c: CalendarPatch) => request<Calendar>('POST', '/api/calendars', c),
  // Only the fields in `patch` are changed.
  updateCalendar: (id: number, patch: CalendarPatch) => request<Calendar>('PUT', `/api/calendars/${id}`, patch),
  deleteCalendar: (id: number) => request<null>('DELETE', `/api/calendars/${id}`),
  getSettings: () => request<Partial<Settings>>('GET', '/api/settings'),
  updateSettings: (patch: Partial<Settings>) => request<Partial<Settings>>('PUT', '/api/settings', patch),
};
