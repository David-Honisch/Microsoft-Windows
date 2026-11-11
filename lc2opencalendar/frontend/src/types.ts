// Shared data types (they match the JSON of the Go API, see backend/api.go).

// A calendar groups events, like "Work" or "Family".
export interface Calendar {
  id: number;
  name: string;
  description: string;
  color: string;
  // IANA name, or '' for "same as the primary time zone".
  timeZone: string;
  hidden: boolean;
  primary: boolean;
}

// Fields sent when a calendar is created or changed.
export type CalendarPatch = Partial<Omit<Calendar, 'id' | 'primary'>>;

// An event as the app keeps it: times are instants in milliseconds.
export interface CalendarEvent {
  id: number;
  calendarId: number;
  // IANA name, or '' for the primary time zone.
  timeZone: string;
  title: string;
  description: string;
  // '' means "use the calendar color".
  color: string;
  start: number;
  end: number;
  // Minutes before the start.
  reminders: number[];
}

// An event being created (no id yet) or edited in the form.
export interface Draft extends Omit<CalendarEvent, 'id'> {
  id?: number;
  // The user picked the time zone by hand (not saved).
  zoneSet?: boolean;
}

// An event as the views draw it: with wall times and the color to use.
export interface ShownEvent extends Omit<Draft, 'id'> {
  id: number | 'draft' | 'preview';
  isDraft: boolean;
  // Wall times (see time.ts).
  ws: number;
  we: number;
  dragging?: boolean;
}

export type DateFormat = 'MDY' | 'DMY' | 'YMD';
export type TimeFormat = '12h' | '24h';
export type Theme = 'system' | 'light' | 'dark';
export type NotificationMode = 'off' | 'desktop' | 'alerts';

export interface Settings {
  dateFormat: DateFormat;
  timeFormat: TimeFormat;
  // IANA name, or '' for the device time zone.
  timeZone: string;
  defaultDuration: number;
  theme: Theme;
  notifications: NotificationMode;
  snoozeBefore: number;
  notificationSound: boolean;
  // Minutes before the event, or -1 for none.
  defaultReminder: number;
  animations: boolean;
  keyboardShortcuts: boolean;
  otherTimeZones: string[];
}

export type View = 'day' | 'week' | 'month' | 'year';

// Where a floating card opens: next to this rectangle (screen pixels).
export interface Anchor {
  left: number;
  right: number;
  top: number;
}

// Props shared by the day/week grid and the month view.
export interface CalendarViewProps {
  settings: Settings;
  // Wall time of the start of today, and of now.
  today: number;
  nowWall: number;
  events: ShownEvent[];
  // A press on an empty part of the calendar. Returns true if it may create an event.
  onSurfacePointerDown: () => boolean;
  onEventClick: (ev: ShownEvent, anchor: Anchor) => void;
  onEventContext: (ev: ShownEvent, x: number, y: number) => void;
  onDayClick: (day: number) => void;
}
