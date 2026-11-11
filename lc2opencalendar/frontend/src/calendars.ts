// Helpers for calendars (shared by App and the event form).

import type { Calendar } from './types';

// Time zone for a new event in this calendar: the calendar's own, or ''
// (the primary time zone) when it has none or it is the primary one.
export function calendarZone(calendar: Calendar | undefined, primaryTz: string): string {
  const z = calendar?.timeZone || '';
  return z === primaryTz ? '' : z;
}

// Same order as the server: the primary calendar first, then by name.
export function sortCalendars(list: Calendar[]): Calendar[] {
  return [...list].sort(
    (a, b) =>
      Number(b.primary) - Number(a.primary) ||
      a.name.localeCompare(b.name, undefined, { sensitivity: 'base' }) ||
      a.id - b.id,
  );
}
