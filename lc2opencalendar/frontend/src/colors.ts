import type { Calendar } from './types';

// Event colors. Similar to the classic calendar palette.
export const COLORS = [
  { name: 'Red', value: '#d50000' },
  { name: 'Pink', value: '#e67c73' },
  { name: 'Orange', value: '#f4511e' },
  { name: 'Yellow', value: '#f6bf26' },
  { name: 'Light green', value: '#33b679' },
  { name: 'Green', value: '#0b8043' },
  { name: 'Blue', value: '#039be5' },
  { name: 'Indigo', value: '#3f51b5' },
  { name: 'Lavender', value: '#7986cb' },
  { name: 'Purple', value: '#8e24aa' },
  { name: 'Gray', value: '#616161' },
];

export const DEFAULT_COLOR = '#039be5';

// An event without its own color uses the color of its calendar.
export const colorOf = (e: { color?: string }, calendar?: Calendar): string => e.color || calendar?.color || DEFAULT_COLOR;

// A color for a new calendar: the first one in the palette that no calendar uses yet.
export function unusedColor(calendars: Calendar[]): string {
  const used = new Set(calendars.map((c) => c.color));
  return (COLORS.find((c) => !used.has(c.value)) || COLORS[calendars.length % COLORS.length]).value;
}

// Pick dark or light text so it is readable on the event color.
export function textOn(hex: string): string {
  const n = parseInt(hex.slice(1), 16);
  const r = (n >> 16) & 255;
  const g = (n >> 8) & 255;
  const b = n & 255;
  return 0.299 * r + 0.587 * g + 0.114 * b > 186 ? '#1f1f1f' : '#ffffff';
}
