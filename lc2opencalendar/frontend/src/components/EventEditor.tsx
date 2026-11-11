import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import Icon from '../icons';
import Popover from './Popover';
import MiniMonth from './MiniMonth';
import ColorPicker from './ColorPicker';
import TimeInput from './TimeInput';
import ReminderList from './ReminderList';
import Select from './Select';
import { calendarZone } from '../calendars';
import * as T from '../time';
import { useMedia, TOUCH } from '../useMedia';
import type { FormEvent, ReactNode, RefObject } from 'react';
import type { Anchor, Calendar, Draft, Settings } from '../types';

interface EventEditorProps {
  draft: Draft;
  calendars: Calendar[];
  settings: Settings;
  tz: string;
  today: number;
  docked: boolean;
  sheet: boolean;
  anchor: Anchor | null;
  closing: boolean;
  onChange: (patch: Partial<Draft>) => void;
  onSave: () => void;
  onClose: () => void;
  onDelete: (() => void) | null;
  onToggleDock: (() => void) | null;
}

// Form to create or edit an event. Shown as a floating card next to the event,
// or docked as a panel on the left side of the calendar.
// `closing`: the floating card plays its closing animation (see Popover).
export default function EventEditor({
  draft, calendars, settings, tz, today, docked, sheet, anchor, closing, onChange, onSave, onClose, onDelete, onToggleDock,
}: EventEditorProps) {
  const titleRef = useRef<HTMLInputElement>(null);
  const [picker, setPicker] = useState(false);
  const dateBtnRef = useRef<HTMLButtonElement>(null);
  const isNew = !draft.id;
  const touch = useMedia(TOUCH);

  // Close the date picker on a press outside it and its button.
  useEffect(() => {
    if (!picker) return;
    const outside = (e: PointerEvent) => {
      if ((e.target as Element | null)?.closest?.('.date-field, .date-picker')) return;
      setPicker(false);
    };
    document.addEventListener('pointerdown', outside, true);
    return () => document.removeEventListener('pointerdown', outside, true);
  }, [picker]);

  // Put the cursor in the title. Not on touch devices: there the on-screen
  // keyboard would pop up and cover half the screen before the user asks.
  useEffect(() => {
    if (!touch) titleRef.current?.focus();
  }, [draft.id, docked]); // eslint-disable-line react-hooks/exhaustive-deps

  // The form shows the times in the event's time zone ('' = the primary one).
  const zone = draft.timeZone && draft.timeZone !== tz ? draft.timeZone : '';
  const etz = zone || tz;
  const ws = T.toWall(draft.start, etz);
  const we = T.toWall(draft.end, etz);
  const day = T.startOfDay(ws);
  const tf = settings.timeFormat;

  const setWall = (newWs: number, newWe: number) => onChange({ start: T.fromWall(newWs, etz), end: T.fromWall(newWe, etz) });

  // Time zone choices: the primary one and the "Other time zones" from
  // settings (plus the event's own, if it was removed from settings since).
  const zoneChoices = [
    '',
    ...(settings.otherTimeZones || []).filter((z) => z !== tz),
    ...(zone && !(settings.otherTimeZones || []).includes(zone) ? [zone] : []),
  ];
  const zoneOptions = zoneChoices.map((z) => ({
    value: z,
    label: `${T.zoneLabel(z || tz, draft.start)}${z ? '' : ' (primary)'}`,
  }));
  // Like the classic calendar: a new time zone keeps the clock times
  // (9am stays 9am, now in the new zone).
  const setZone = (z: string) => {
    const ntz = z || tz;
    // zoneSet: picked by hand, so changing the calendar no longer changes it.
    onChange({ timeZone: z, zoneSet: true, start: T.fromWall(ws, ntz), end: T.fromWall(we, ntz) });
  };

  const fmt = (t: number) => T.formatTime(t, tf, { compact: false });

  // Start time options: every 15 minutes of the day.
  const startOptions: number[] = [];
  for (let m = 0; m < 24 * 60; m += 15) startOptions.push(day + m * T.MINUTE);
  const startList = startOptions.map((t) => ({ value: t, label: fmt(t), text: fmt(t) }));

  // End time options: up to 24 hours after the start, with the duration shown.
  const endList: { value: number; label: string; text: string }[] = [];
  for (let m = 15; m <= 24 * 60; m += 15) {
    const t = ws + m * T.MINUTE;
    endList.push({ value: t, label: `${fmt(t)} (${T.formatDuration(m)})`, text: fmt(t) });
  }

  // Typed start time: on the same day. "3" in 12h format is 3am or 3pm,
  // whichever is closer to the current start.
  const resolveStart = (text: string, partial?: boolean) => {
    const c = T.parseTime(text, tf, partial);
    if (!c) return null;
    const ts = c.map((m) => day + m * T.MINUTE);
    return ts.reduce((a, b) => (Math.abs(b - ws) < Math.abs(a - ws) ? b : a));
  };
  // Typed end time: the first such time after the start (can be the next day).
  const resolveEnd = (text: string, partial?: boolean) => {
    const c = T.parseTime(text, tf, partial);
    if (!c) return null;
    const ts = c.map((m) => {
      let t = day + m * T.MINUTE;
      while (t <= ws) t += T.DAY;
      return t;
    });
    return Math.min(...ts);
  };

  const submit = (e: FormEvent) => {
    e.preventDefault();
    onSave();
  };

  const body = (
    <div className="editor-body">
      <input
        ref={titleRef}
        className="editor-title"
        placeholder="Add title"
        aria-label="Title"
        value={draft.title}
        maxLength={1000}
        onChange={(e) => onChange({ title: e.target.value })}
      />

      <div className="editor-row">
        <Icon name="schedule" className="row-icon" size={20} />
        <div className="editor-when">
          <div className="date-field">
            <button type="button" className="field-btn" ref={dateBtnRef} onClick={() => setPicker(!picker)} aria-label="Date">
              {T.weekdayName(ws)}, {T.formatDate(ws, settings.dateFormat)}
            </button>
            {picker && (
              <DatePicker anchorRef={dateBtnRef}>
                <MiniMonth
                  value={day}
                  today={today}
                  onPick={(d) => {
                    setPicker(false);
                    setWall(d + (ws - day), d + (we - day));
                  }}
                />
              </DatePicker>
            )}
          </div>
          <div className="time-fields">
            <TimeInput
              aria-label="Start time"
              value={ws}
              options={startList}
              resolve={resolveStart}
              format={fmt}
              onChange={(s) => setWall(s, s + (we - ws))}
            />
            <span>–</span>
            <TimeInput
              aria-label="End time"
              value={we}
              options={endList}
              resolve={resolveEnd}
              format={fmt}
              onChange={(e) => setWall(ws, e)}
            />
          </div>
        </div>
      </div>

      {zoneOptions.length > 1 && (
        <div className="editor-row">
          <Icon name="public" className="row-icon" size={20} />
          <div className="editor-calendar">
            <Select aria-label="Time zone" value={zone} options={zoneOptions} onChange={setZone} />
          </div>
        </div>
      )}

      <div className="editor-row">
        <Icon name="notes" className="row-icon" size={20} />
        <textarea
          className="editor-desc"
          placeholder="Add description"
          aria-label="Description"
          rows={docked ? 6 : 3}
          value={draft.description}
          onChange={(e) => onChange({ description: e.target.value })}
        />
      </div>

      <div className="editor-row">
        <Icon name="notifications" className="row-icon" size={20} />
        <ReminderList
          key={draft.id ?? 'new'}
          value={draft.reminders || []}
          defaultReminder={settings.defaultReminder}
          onChange={(reminders) => onChange({ reminders })}
        />
      </div>

      <div className="editor-row">
        <Icon name="calendar" className="row-icon" size={20} />
        <div className="editor-calendar">
          <Select
            aria-label="Calendar"
            value={draft.calendarId}
            options={calendars.map((c) => ({ value: c.id, label: c.name, color: c.color }))}
            onChange={(calendarId) => {
              // A new event takes the time zone of its calendar (same moment,
              // shown in that zone), until the user picks a time zone by hand.
              if (isNew && !draft.zoneSet) {
                onChange({ calendarId, timeZone: calendarZone(calendars.find((c) => c.id === calendarId), tz) });
              } else onChange({ calendarId });
            }}
          />
        </div>
      </div>

      <div className="editor-row">
        <Icon name="palette" className="row-icon" size={20} />
        <ColorPicker
          value={draft.color}
          calendar={calendars.find((c) => c.id === draft.calendarId)}
          onChange={(color) => onChange({ color })}
        />
      </div>
    </div>
  );

  const closeButton = (
    <button type="button" className="icon-btn sm" onClick={onClose} aria-label="Close" title="Close">
      <Icon name="close" size={20} />
    </button>
  );
  const saveButton = (
    <button type="submit" className="filled-btn">
      Save
    </button>
  );

  // Phones: the form is a bottom sheet. Close (left) and Save (right) sit in
  // the top bar, so the on-screen keyboard never hides Save. No Delete here:
  // it is in the details card and the long-press menu.
  if (sheet) {
    return (
      <Popover anchor={anchor} onClose={onClose} closing={closing} className="editor-popover" label={isNew ? 'New event' : 'Edit event'}>
        <form className="editor" onSubmit={submit}>
          <div className="editor-bar">
            {closeButton}
            <span className="spacer" />
            {saveButton}
          </div>
          {body}
        </form>
      </Popover>
    );
  }

  const form = (
    <form className={`editor ${docked ? 'docked' : ''}`} onSubmit={submit}>
      <div className="editor-bar" data-drag-handle={docked ? undefined : true}>
        {onToggleDock && (
          <button
            type="button"
            className="icon-btn sm"
            onClick={onToggleDock}
            aria-label={docked ? 'Undock from side panel' : 'Dock to side panel'}
            title={docked ? 'Undock from side panel' : 'Dock to side panel'}
          >
            <Icon name={docked ? 'popOut' : 'dockLeft'} size={20} />
          </button>
        )}
        {docked && <span className="editor-bar-title">{isNew ? 'New event' : 'Edit event'}</span>}
        <span className="spacer" />
        {closeButton}
      </div>

      {body}

      <div className="editor-foot">
        {onDelete && (
          <button type="button" className="text-btn danger" onClick={onDelete}>
            Delete
          </button>
        )}
        <span className="spacer" />
        {saveButton}
      </div>
    </form>
  );

  if (docked) return form;
  return (
    <Popover anchor={anchor} onClose={onClose} closing={closing} className="editor-popover" label={isNew ? 'New event' : 'Edit event'}>
      {form}
    </Popover>
  );
}

// The open date picker. Like DropdownList, it is drawn in document.body so the
// scrolling form never cuts it off, and it follows the date button every frame
// (form dragged, docked, scrolled, window resized). It sits under the button,
// or above it when there is not enough room below.
const PICKER_W = 248;
const PICKER_H = 300;
function DatePicker({ anchorRef, children }: { anchorRef: RefObject<HTMLElement | null>; children: ReactNode }) {
  const [pos, setPos] = useState<{ top: number; left: number } | null>(null);
  useLayoutEffect(() => {
    let last = '';
    let frame = 0;
    const update = () => {
      const a = anchorRef.current;
      if (a) {
        const r = a.getBoundingClientRect();
        const vv = window.visualViewport;
        const vh = vv ? vv.height + vv.offsetTop : window.innerHeight;
        const vw = window.innerWidth;
        const key = `${r.left},${r.top},${r.bottom},${vw},${vh}`;
        if (key !== last) {
          last = key;
          let top = r.bottom + 4;
          if (top + PICKER_H > vh - 8 && r.top - 4 - PICKER_H >= 8) top = r.top - 4 - PICKER_H;
          top = Math.max(8, Math.min(top, vh - 8 - PICKER_H));
          setPos({ top, left: Math.max(8, Math.min(r.left, vw - 8 - PICKER_W)) });
        }
      }
      frame = requestAnimationFrame(update);
    };
    update();
    return () => cancelAnimationFrame(frame);
  }, [anchorRef]);

  return createPortal(
    <div className="date-picker" data-popover style={pos || { visibility: 'hidden' }}>
      {children}
    </div>,
    document.body,
  );
}
