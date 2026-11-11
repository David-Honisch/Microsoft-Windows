import { useEffect, useMemo, useRef, useState } from 'react';
import Icon from '../icons';
import Select from './Select';
import SearchSelect from './SearchSelect';
import { ThemeOptions } from './AppearanceDialog';
import { CreateCalendar, CalendarSettings } from './CalendarSettings';
import * as T from '../time';
import { deviceReducesMotion } from '../motion';
import { useMedia, NARROW } from '../useMedia';
import { REMINDER_PRESETS, notificationPermission, requestNotificationPermission, playChime } from '../notifications';
import type { ReactNode } from 'react';
import type { Option } from './DropdownList';
import type { Permission } from '../notifications';
import type { Calendar, CalendarPatch, DateFormat, NotificationMode, Settings, TimeFormat } from '../types';

const DURATIONS = [15, 20, 30, 45, 60, 90, 120];
const SNOOZE_OPTIONS = [0, 1, 5, 10, 15, 30];

const NOTIFY_OPTIONS: Option<NotificationMode>[] = [
  { value: 'off', label: 'Off' },
  { value: 'desktop', label: 'Desktop notifications' },
  { value: 'alerts', label: 'Alerts' },
];

// Explains why desktop notifications cannot show, and offers to allow them.
function PermissionNote({ permission, onAllow }: { permission: Permission; onAllow: () => void }) {
  if (permission === 'granted') return null;
  if (permission === 'default') {
    return (
      <p className="settings-note">
        Your browser needs your permission to show notifications.{' '}
        <button type="button" className="text-btn inline" onClick={onAllow}>
          Allow notifications
        </button>
      </p>
    );
  }
  return (
    <p className="settings-note">
      {permission === 'denied'
        ? 'Notifications are blocked for this site in your browser settings.'
        : 'This browser cannot show desktop notifications here (it needs HTTPS or localhost).'}{' '}
      Reminders are shown as alerts in the page instead.
    </p>
  );
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <label className="field">
      <span className="field-label">{label}</span>
      {children}
    </label>
  );
}

const MAX_OTHER_ZONES = 5; // same limit as the backend

// "Other time zones": shown as extra hour columns in the day/week grid, and
// offered in the event form. Each can be changed or removed; the last field
// adds one.
function OtherTimeZones({
  zones,
  primary,
  allZones,
  onChange,
}: {
  zones: string[];
  primary: string;
  allZones: Option<string>[];
  onChange: (zones: string[]) => void;
}) {
  const [addKey, setAddKey] = useState(0);
  const now = Date.now();
  const choicesFor = (current: string | null) =>
    allZones.filter((o) => o.value === current || (o.value !== primary && !zones.includes(o.value)));
  return (
    <div className="field other-zones">
      <span className="field-label">Other time zones</span>
      {zones.map((z, i) => (
        <div key={z} className="other-zone">
          <SearchSelect
            aria-label={`Time zone ${i + 1}`}
            value={z}
            options={choicesFor(z)}
            onChange={(v) => onChange(zones.map((x) => (x === z ? v : x)))}
          />
          <span className="other-zone-now">{T.gmtShort(z, now)}</span>
          <button
            type="button"
            className="icon-btn sm"
            aria-label={`Remove ${z.replace(/_/g, ' ')}`}
            title="Remove"
            onClick={() => onChange(zones.filter((x) => x !== z))}
          >
            <Icon name="close" size={20} />
          </button>
        </div>
      ))}
      {zones.length < MAX_OTHER_ZONES ? (
        <div className="other-zone">
          <SearchSelect
            key={addKey}
            aria-label="Add time zone"
            value=""
            options={choicesFor(null)}
            placeholder="Add time zone"
            onChange={(v) => {
              if (v) onChange([...zones, v]);
              setAddKey((k) => k + 1);
            }}
          />
        </div>
      ) : (
        <p className="settings-note">You can add up to {MAX_OTHER_ZONES} time zones.</p>
      )}
      <p className="settings-note">
        They are shown next to your primary time zone in the day and week views, and you can pick them for an event.
      </p>
    </div>
  );
}

// One group of the left menu ("General", "Add calendar", ...), like the
// classic calendar: a header that opens or closes it, and its items.
// Only one group is open at a time. The items are always on the page, so
// opening and closing can animate their height (CSS, see .settings-nav-sub).
function NavGroup({
  title,
  active,
  open,
  onToggle,
  onTitle,
  children,
}: {
  title: string;
  active: boolean;
  open: boolean;
  onToggle: () => void;
  onTitle?: () => void;
  children: ReactNode;
}) {
  return (
    <div className="settings-nav-group">
      <div className={`settings-nav-head ${active ? 'active' : ''}`}>
        <button type="button" className="settings-nav-title" onClick={onTitle ?? onToggle}>
          {title}
        </button>
        <button
          type="button"
          className="icon-btn sm"
          onClick={onToggle}
          aria-expanded={open}
          aria-label={open ? `Close ${title}` : `Open ${title}`}
        >
          <Icon name={open ? 'expandLess' : 'expandMore'} size={20} />
        </button>
      </div>
      <div className={`settings-nav-sub ${open ? 'open' : ''}`} inert={open ? undefined : true}>
        <div className="settings-nav-sub-inner">{children}</div>
      </div>
    </div>
  );
}

function NavItem({
  active,
  onClick,
  children,
  title,
}: {
  active: boolean;
  onClick: () => void;
  children: ReactNode;
  title?: string;
}) {
  return (
    <button
      type="button"
      className={`settings-nav-item ${active ? 'active' : ''}`}
      aria-current={active ? 'page' : undefined}
      onClick={onClick}
      title={title}
    >
      {children}
    </button>
  );
}

interface SettingsPageProps {
  settings: Settings;
  onChange: (patch: Partial<Settings>) => void;
  onBack: () => void;
  focus: string | null;
  calendars: Calendar[];
  onCreateCalendar: (fields: CalendarPatch) => Promise<Calendar | null>;
  onUpdateCalendar: (id: number, patch: CalendarPatch) => void;
  onDeleteCalendar: (id: number) => Promise<boolean>;
  showShortcuts: boolean;
  onViewShortcuts: () => void;
}

type Group = 'general' | 'add' | 'mine';

// The settings are split into pages, like the classic calendar:
// - "general": date and time, time zone, events, notifications, appearance,
//   keyboard shortcuts (one scrolling page; the menu jumps to each part).
// - "create-calendar": the form to add a calendar.
// - "calendar-<id>": the settings of one calendar.
// Tablets and phones (no room for the menu): Settings opens the general page
// only. Calendar pages are opened from the sidebar (+, or ⋮ → Settings).
// `focus`: the page to open first ("create-calendar", "calendar-3"), or null.
export default function SettingsPage({
  settings, onChange, onBack, focus, calendars, onCreateCalendar, onUpdateCalendar, onDeleteCalendar,
  showShortcuts, onViewShortcuts,
}: SettingsPageProps) {
  const narrow = useMedia(NARROW);
  const primaryZone = settings.timeZone || T.browserTimeZone();
  const allZones = useMemo((): Option<string>[] => T.allTimeZones().map((z) => ({ value: z, label: z.replace(/_/g, ' ') })), []);
  const zoneOptions = useMemo(
    () => [{ value: '', label: `Device time zone (${T.browserTimeZone()})` }, ...allZones],
    [allZones],
  );
  // A calendar's time zone: the primary one ('') or one of the "Other time
  // zones" from General settings (plus the calendar's own, if it was removed
  // from settings since).
  const calendarZoneOptions = (current = ''): Option<string>[] => {
    const now = Date.now();
    const others = (settings.otherTimeZones || []).filter((z) => z !== primaryZone);
    if (current && current !== primaryZone && !others.includes(current)) others.push(current);
    return [
      { value: '', label: `Same as primary time zone (${primaryZone.replace(/_/g, ' ')})` },
      ...others.map((z) => ({ value: z, label: T.zoneLabel(z, now) })),
    ];
  };
  const sample = T.makeDay(2026, 11, 31) + 13 * T.HOUR;
  const [permission, setPermission] = useState<Permission>(notificationPermission);
  const askPermission = async () => setPermission(await requestNotificationPermission());

  const [page, setPage] = useState(focus || 'general');
  // The open group of the menu. Opening a page opens its group and closes the others.
  const groupOf = (p: string): Group => (p === 'general' ? 'general' : p === 'create-calendar' ? 'add' : 'mine');
  const [openGroup, setOpenGroup] = useState<Group | null>(() => groupOf(focus || 'general'));
  const toggleGroup = (g: Group) => setOpenGroup((cur) => (cur === g ? null : g));

  // A deleted calendar's page falls back to the general page.
  const calendarId = page.startsWith('calendar-') ? Number(page.slice('calendar-'.length)) : null;
  const calendar = calendarId !== null ? calendars.find((c) => c.id === calendarId) : null;
  const shown = calendarId !== null && !calendar ? 'general' : page;

  const sections = [
    { id: 'date-time', title: 'Date and time format' },
    { id: 'time-zone', title: 'Time zone' },
    { id: 'event-settings', title: 'Event settings' },
    { id: 'notifications', title: 'Notification settings' },
    { id: 'appearance', title: 'Appearance' },
    ...(showShortcuts ? [{ id: 'shortcuts', title: 'Keyboard shortcuts' }] : []),
  ];

  // Open a page. `section`: a part of the general page to scroll to.
  const contentRef = useRef<HTMLDivElement>(null);
  const [scrollTarget, setScrollTarget] = useState<string | null>(null);
  const go = (next: string, section: string | null = null) => {
    pinned.current = section;
    if (section) setCurrent(section);
    setOpenGroup(groupOf(next));
    setPage(next);
    setScrollTarget(section || 'top');
  };
  useEffect(() => {
    const el = contentRef.current;
    if (!scrollTarget || !el) return;
    if (scrollTarget === 'top') el.scrollTop = 0;
    else document.getElementById(scrollTarget)?.scrollIntoView({ block: 'start' });
    setScrollTarget(null);
  }, [scrollTarget, shown]);

  // On the general page, the menu marks the part that is scrolled into view.
  // A part picked in the menu stays marked until the user scrolls by hand
  // (it may be too short to reach the top of the page).
  const [current, setCurrent] = useState(sections[0].id);
  const pinned = useRef<string | null>(null);
  const unpin = () => {
    pinned.current = null;
  };
  const onScroll = () => {
    const el = contentRef.current;
    if (!el || shown !== 'general' || pinned.current) return;
    const top = el.getBoundingClientRect().top + 24;
    let id = sections[0].id;
    for (const s of sections) {
      const sec = document.getElementById(s.id);
      if (sec && sec.getBoundingClientRect().top <= top) id = s.id;
    }
    // At the very bottom, the last part counts (it may be too short to reach the top).
    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 2) id = sections[sections.length - 1].id;
    setCurrent(id);
  };

  const createCalendar = async (fields: CalendarPatch) => {
    const created = await onCreateCalendar(fields);
    if (created) go(`calendar-${created.id}`);
    return created;
  };

  // Tablets and phones show a calendar page's name in the header.
  const title =
    !narrow || shown === 'general' ? 'Settings' : shown === 'create-calendar' ? 'Create new calendar' : calendar?.name;

  const nav = (
    <nav className="settings-nav" aria-label="Settings">
      <NavGroup
        title="General"
        active={shown === 'general'}
        open={openGroup === 'general'}
        onToggle={() => toggleGroup('general')}
        onTitle={() => go('general')}
      >
        {sections.map((s) => (
          <NavItem key={s.id} active={shown === 'general' && current === s.id} onClick={() => go('general', s.id)}>
            {s.title}
          </NavItem>
        ))}
      </NavGroup>
      <NavGroup
        title="Add calendar"
        active={shown === 'create-calendar'}
        open={openGroup === 'add'}
        onToggle={() => toggleGroup('add')}
        onTitle={() => go('create-calendar')}
      >
        <NavItem active={shown === 'create-calendar'} onClick={() => go('create-calendar')}>
          Create new calendar
        </NavItem>
      </NavGroup>
      <NavGroup
        title="Settings for my calendars"
        active={calendarId !== null && Boolean(calendar)}
        open={openGroup === 'mine'}
        onToggle={() => toggleGroup('mine')}
        onTitle={() => calendars[0] && go(`calendar-${calendars[0].id}`)}
      >
        {calendars.map((c) => (
          <NavItem key={c.id} active={shown === `calendar-${c.id}`} onClick={() => go(`calendar-${c.id}`)} title={c.name}>
            <span className="cal-dot" style={{ background: c.color }} />
            <span className="cal-name">{c.name}</span>
          </NavItem>
        ))}
      </NavGroup>
    </nav>
  );

  let content;
  if (shown === 'create-calendar') {
    content = (
      <section id="create-calendar">
        <h2>Create new calendar</h2>
        <CreateCalendar
          calendars={calendars}
          zoneOptions={calendarZoneOptions()}
          onAddZones={() => go('general', 'time-zone')}
          autoFocus
          onCreate={createCalendar}
        />
      </section>
    );
  } else if (calendar) {
    content = (
      <CalendarSettings
        key={calendar.id}
        calendar={calendar}
        zoneOptions={calendarZoneOptions(calendar.timeZone === primaryZone ? '' : calendar.timeZone)}
        onAddZones={() => go('general', 'time-zone')}
        onUpdate={(patch) => onUpdateCalendar(calendar.id, patch)}
        onDelete={() => onDeleteCalendar(calendar.id)}
      />
    );
  } else {
    content = (
      <>
        <section id="date-time">
          <h2>Date and time format</h2>
          <Field label="Date format">
            <Select
              value={settings.dateFormat}
              onChange={(dateFormat) => onChange({ dateFormat })}
              options={(['MDY', 'DMY', 'YMD'] as DateFormat[]).map((f) => ({ value: f, label: T.formatDate(sample, f) }))}
            />
          </Field>
          <Field label="Time format">
            <Select
              value={settings.timeFormat}
              onChange={(timeFormat) => onChange({ timeFormat })}
              options={(['12h', '24h'] as TimeFormat[]).map((f) => ({ value: f, label: T.formatTime(sample, f) }))}
            />
          </Field>
        </section>

        <section id="time-zone">
          <h2>Time zone</h2>
          <Field label="Primary time zone">
            <SearchSelect value={settings.timeZone} onChange={(timeZone) => onChange({ timeZone })} options={zoneOptions} />
          </Field>
          <OtherTimeZones
            zones={settings.otherTimeZones || []}
            primary={primaryZone}
            allZones={allZones}
            onChange={(otherTimeZones) => onChange({ otherTimeZones })}
          />
        </section>

        <section id="event-settings">
          <h2>Event settings</h2>
          <Field label="Default duration">
            <Select
              value={settings.defaultDuration}
              onChange={(defaultDuration) => onChange({ defaultDuration })}
              options={DURATIONS.map((d) => ({
                value: d,
                label: d < 60 ? `${d} minutes` : T.formatDuration(d).replace('hr', 'hour'),
              }))}
            />
          </Field>
          <Field label="Default notification">
            <Select
              value={settings.defaultReminder}
              onChange={(defaultReminder) => onChange({ defaultReminder })}
              options={[
                { value: -1, label: 'No notification' },
                ...REMINDER_PRESETS.map((m) => ({ value: m, label: T.formatReminder(m) })),
              ]}
            />
          </Field>
        </section>

        <section id="notifications">
          <h2>Notification settings</h2>
          <Field label="Notifications">
            <Select
              value={settings.notifications}
              onChange={(notifications) => {
                onChange({ notifications });
                if (notifications === 'desktop' && permission === 'default') askPermission();
              }}
              options={NOTIFY_OPTIONS}
            />
          </Field>
          {settings.notifications === 'desktop' && <PermissionNote permission={permission} onAllow={askPermission} />}
          <Field label="Show snoozed notifications">
            <Select
              value={settings.snoozeBefore}
              onChange={(snoozeBefore) => onChange({ snoozeBefore })}
              options={SNOOZE_OPTIONS.map((m) => ({
                value: m,
                label: m === 0 ? 'At time of event' : `${m} minute${m === 1 ? '' : 's'} before event`,
              }))}
            />
          </Field>
          <label className="checkbox">
            <input
              type="checkbox"
              checked={settings.notificationSound}
              onChange={(e) => {
                onChange({ notificationSound: e.target.checked });
                if (e.target.checked) playChime();
              }}
            />
            <span>Play notification sounds</span>
          </label>
        </section>

        <section id="appearance">
          <h2>Appearance</h2>
          <h3>Theme</h3>
          <ThemeOptions theme={settings.theme} onChange={(theme) => onChange({ theme })} name="theme-settings" />

          <h3>Motion</h3>
          <label className="checkbox">
            <input
              type="checkbox"
              checked={settings.animations}
              onChange={(e) => onChange({ animations: e.target.checked })}
            />
            <span>Show animations</span>
          </label>
          {settings.animations && deviceReducesMotion() && (
            <p className="settings-note">Your device is set to reduce motion, so animations are not shown.</p>
          )}
        </section>

        {showShortcuts && (
          <section id="shortcuts">
            <h2>Keyboard shortcuts</h2>
            <label className="checkbox">
              <input
                type="checkbox"
                checked={settings.keyboardShortcuts}
                onChange={(e) => onChange({ keyboardShortcuts: e.target.checked })}
              />
              <span>Enable keyboard shortcuts</span>
            </label>
            <p className="settings-note">
              {settings.keyboardShortcuts ? (
                <>Press <kbd>?</kbd> in the calendar to see the list of shortcuts.</>
              ) : (
                'Single-key shortcuts like D, W and C are off. Esc still closes things.'
              )}{' '}
              <button type="button" className="text-btn inline" onClick={onViewShortcuts}>
                View shortcuts
              </button>
            </p>
          </section>
        )}
      </>
    );
  }

  return (
    <div className="settings">
      <header className="header">
        <div className="header-left">
          <button
            className="icon-btn"
            onClick={onBack}
            aria-label="Back to calendar"
            title="Back to calendar"
          >
            <Icon name="arrowBack" />
          </button>
          <span className="brand">{title}</span>
        </div>
      </header>
      <div className="settings-body">
        {!narrow && nav}
        <div
          className="settings-content"
          ref={contentRef}
          onScroll={onScroll}
          onWheel={unpin}
          onTouchStart={unpin}
          onKeyDown={unpin}
          onPointerDown={unpin}
        >
          {content}
        </div>
      </div>
    </div>
  );
}
