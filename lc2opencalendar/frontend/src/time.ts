// Date and time helpers.

import type { DateFormat, TimeFormat } from './types';
//
// Two kinds of numbers are used in the app:
//  - "instant": real moment in time, milliseconds since epoch (what the API stores).
//  - "wall":    clock time in the user's chosen time zone, stored as milliseconds
//               and read with the UTC getters (getUTCHours, ...). Wall values make
//               calendar math easy because they have no daylight saving jumps.

export const MINUTE = 60 * 1000;
export const HOUR = 60 * MINUTE;
export const DAY = 24 * HOUR;

export const MONTHS = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];
export const WEEKDAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

export const browserTimeZone = () => Intl.DateTimeFormat().resolvedOptions().timeZone || 'UTC';

export function allTimeZones(): string[] {
  try {
    return Intl.supportedValuesOf('timeZone');
  } catch {
    return [browserTimeZone(), 'UTC'];
  }
}

// ---- Time zone conversion ----

const formatters = new Map<string, Intl.DateTimeFormat>();
function formatterFor(tz: string) {
  let f = formatters.get(tz);
  if (!f) {
    f = new Intl.DateTimeFormat('en-US', {
      timeZone: tz,
      hourCycle: 'h23',
      year: 'numeric', month: 'numeric', day: 'numeric',
      hour: 'numeric', minute: 'numeric', second: 'numeric',
    });
    formatters.set(tz, f);
  }
  return f;
}

// Offset of the time zone from UTC at the given instant, in ms.
function offsetAt(instant: number, tz: string) {
  const v: Record<string, string> = {};
  for (const p of formatterFor(tz).formatToParts(new Date(instant))) v[p.type] = p.value;
  const asUTC = Date.UTC(+v.year, +v.month - 1, +v.day, +v.hour % 24, +v.minute, +v.second);
  return asUTC - (instant - (((instant % 1000) + 1000) % 1000));
}

export const toWall = (instant: number, tz: string): number => instant + offsetAt(instant, tz);

export function fromWall(wall: number, tz: string): number {
  const guess = wall - offsetAt(wall, tz);
  return wall - offsetAt(guess, tz);
}

// Offset of the time zone from UTC at the given instant, in minutes.
export const offsetMinutes = (tz: string, instant: number): number => Math.round(offsetAt(instant, tz) / MINUTE);

// "GMT+04", "GMT-05:30", "GMT+00" (short label above the hour column).
export function gmtShort(tz: string, instant: number): string {
  const mins = offsetMinutes(tz, instant);
  const abs = Math.abs(mins);
  const m = abs % 60;
  return `GMT${mins < 0 ? '-' : '+'}${pad(Math.floor(abs / 60))}${m ? `:${pad(m)}` : ''}`;
}

// "Asia/Tokyo" -> "Tokyo", "America/Argentina/Buenos_Aires" -> "Buenos Aires".
export const zoneCity = (tz: string): string => tz.split('/').pop()!.replace(/_/g, ' ');

// "(GMT+09:00) Asia/Tokyo": for lists of time zones.
export function zoneLabel(tz: string, instant: number): string {
  const mins = offsetMinutes(tz, instant);
  const abs = Math.abs(mins);
  return `(GMT${mins < 0 ? '-' : '+'}${pad(Math.floor(abs / 60))}:${pad(abs % 60)}) ${tz.replace(/_/g, ' ')}`;
}

// ---- Wall time math ----

export const startOfDay = (w: number): number => w - (((w % DAY) + DAY) % DAY);
export const addDays = (w: number, n: number): number => w + n * DAY;
export const dayOfWeek = (w: number): number => new Date(w).getUTCDay();
export const startOfWeek = (w: number): number => addDays(startOfDay(w), -dayOfWeek(w));
export const ymd = (w: number): [number, number, number] => {
  const d = new Date(w);
  return [d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()];
};
export const makeDay = (y: number, m: number, d: number): number => Date.UTC(y, m, d);
export const startOfMonth = (w: number): number => {
  const [y, m] = ymd(w);
  return makeDay(y, m, 1);
};
export const daysInMonth = (y: number, m: number): number => new Date(Date.UTC(y, m + 1, 0)).getUTCDate();
export function addMonths(w: number, n: number): number {
  const [y, m, d] = ymd(w);
  const target = new Date(Date.UTC(y, m + n, 1));
  const ty = target.getUTCFullYear();
  const tm = target.getUTCMonth();
  return makeDay(ty, tm, Math.min(d, daysInMonth(ty, tm))) + (w - startOfDay(w));
}
export const minutesOfDay = (w: number): number => Math.round((w - startOfDay(w)) / MINUTE);
export const sameDay = (a: number, b: number): boolean => startOfDay(a) === startOfDay(b);

// Days shown in a month grid: whole weeks covering the month (5 or 6 rows).
export function monthGridDays(w: number): number[] {
  const first = startOfMonth(w);
  const [y, m] = ymd(first);
  const start = startOfWeek(first);
  const lastDay = makeDay(y, m, daysInMonth(y, m));
  const weeks = Math.ceil((lastDay - start) / DAY / 7 + 1 / 7);
  return Array.from({ length: weeks * 7 }, (_, i) => addDays(start, i));
}

// ---- Formatting (uses the user's settings) ----

const pad = (n: number) => String(n).padStart(2, '0');

export function formatTime(w: number, timeFormat: TimeFormat, { compact = true } = {}): string {
  const d = new Date(w);
  const h = d.getUTCHours();
  const m = d.getUTCMinutes();
  if (timeFormat === '24h') return `${pad(h)}:${pad(m)}`;
  const suffix = h < 12 ? 'am' : 'pm';
  const h12 = h % 12 === 0 ? 12 : h % 12;
  if (compact && m === 0) return `${h12}${suffix}`;
  return `${h12}:${pad(m)}${suffix}`;
}

// Hour label for the left side of the day/week grid.
export function formatHourLabel(hour: number, timeFormat: TimeFormat): string {
  if (timeFormat === '24h') return `${pad(hour)}:00`;
  const h12 = hour % 12 === 0 ? 12 : hour % 12;
  return `${h12} ${hour < 12 ? 'AM' : 'PM'}`;
}

// Label for a minute of the day in an extra hour column ("5:30 AM", "05:30").
export function formatMinuteLabel(minutes: number, timeFormat: TimeFormat): string {
  const m = ((minutes % (24 * 60)) + 24 * 60) % (24 * 60);
  const h = Math.floor(m / 60);
  const mm = m % 60;
  if (!mm) return formatHourLabel(h, timeFormat);
  if (timeFormat === '24h') return `${pad(h)}:${pad(mm)}`;
  return `${h % 12 === 0 ? 12 : h % 12}:${pad(mm)} ${h < 12 ? 'AM' : 'PM'}`;
}

// "1 – 2pm", "11am – 1pm", "13:00 – 14:00"
export function formatTimeRange(ws: number, we: number, timeFormat: TimeFormat): string {
  if (timeFormat === '24h') return `${formatTime(ws, timeFormat)} – ${formatTime(we, timeFormat)}`;
  const sameHalf = new Date(ws).getUTCHours() < 12 === new Date(we).getUTCHours() < 12 && sameDay(ws, we);
  const start = formatTime(ws, timeFormat);
  return `${sameHalf ? start.replace(/am|pm/, '') : start} – ${formatTime(we, timeFormat)}`;
}

export function formatDate(w: number, dateFormat: DateFormat): string {
  const [y, m, d] = ymd(w);
  if (dateFormat === 'DMY') return `${pad(d)}/${pad(m + 1)}/${y}`;
  if (dateFormat === 'YMD') return `${y}-${pad(m + 1)}-${pad(d)}`;
  return `${pad(m + 1)}/${pad(d)}/${y}`;
}

export const weekdayName = (w: number): string => WEEKDAYS[dayOfWeek(w)];
export const weekdayShort = (w: number): string => WEEKDAYS[dayOfWeek(w)].slice(0, 3);

export function formatDuration(minutes: number): string {
  if (minutes < 60) return `${minutes} mins`;
  const h = minutes / 60;
  return `${Number.isInteger(h) ? h : h.toFixed(1).replace(/\.0$/, '')} hr${h === 1 ? '' : 's'}`;
}

// Read a time the user typed: "9", "9am", "9:30", "930", "9.30 pm", "21:15".
// Returns possible minutes of the day (earliest first), or null.
// partial: the user is still typing, so "9:3" means 9:30 (for the list highlight).
// In 12h format, "3" with no am/pm could be 3am or 3pm, so both are returned.
export function parseTime(text: string, timeFormat: TimeFormat, partial = false): number[] | null {
  let s = text.trim().toLowerCase().replace(/\s+/g, '');
  let half: string | null = null;
  const suffix = s.match(/([ap])\.?(m\.?)?$/);
  if (suffix) {
    half = suffix[1];
    s = s.slice(0, suffix.index);
  }
  let h: number;
  let m = 0;
  const sep = s.match(/^(\d{1,2})[:.h](\d{0,2})$/);
  if (sep) {
    h = +sep[1];
    m = sep[2] === '' ? 0 : partial && sep[2].length === 1 ? +sep[2] * 10 : +sep[2];
  } else if (/^\d{1,4}$/.test(s)) {
    if (s.length <= 2) h = +s;
    else {
      h = +s.slice(0, -2);
      m = +s.slice(-2);
    }
  } else return null;
  if (m > 59) return null;
  if (half) {
    if (h < 1 || h > 12) return null;
    return [((h % 12) + (half === 'p' ? 12 : 0)) * 60 + m];
  }
  if (h > 23) return null;
  if (timeFormat === '12h' && h >= 1 && h <= 12) {
    return h === 12 ? [m, 12 * 60 + m] : [h * 60 + m, (h + 12) * 60 + m];
  }
  return [h * 60 + m];
}

// Notification times, in minutes before the event start.
// "At time of event", "10 minutes before", "1 hour before", "2 days before", "1 week before".
export function formatReminder(minutes: number): string {
  if (minutes === 0) return 'At time of event';
  const units: [number, string][] = [
    [7 * 24 * 60, 'week'],
    [24 * 60, 'day'],
    [60, 'hour'],
    [1, 'minute'],
  ];
  const [size, name] = units.find(([u]) => minutes % u === 0) ?? [1, 'minute'];
  const n = minutes / size;
  return `${n} ${name}${n === 1 ? '' : 's'} before`;
}

// Units for a notification time: "10 [minutes]", "2 [hours]", "3 [days]", "1 [week]".
export const REMINDER_UNITS = [
  { value: 1, one: 'minute', many: 'minutes' },
  { value: 60, one: 'hour', many: 'hours' },
  { value: 24 * 60, one: 'day', many: 'days' },
  { value: 7 * 24 * 60, one: 'week', many: 'weeks' },
];
export const MAX_REMINDER = 4 * 7 * 24 * 60; // 4 weeks, same as the backend

// The largest unit that fits exactly: 120 -> 2 hours, 90 -> 90 minutes.
export function bestReminderUnit(minutes: number): number {
  return [...REMINDER_UNITS].reverse().find((u) => minutes % u.value === 0 && minutes > 0)?.value ?? 1;
}
