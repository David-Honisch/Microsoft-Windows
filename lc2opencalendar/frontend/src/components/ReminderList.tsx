import { useRef, useState } from 'react';
import Icon from '../icons';
import Select from './Select';
import { REMINDER_PRESETS, MAX_REMINDERS } from '../notifications';
import * as T from '../time';

// One notification: a number and a unit, "[30] [minutes ▾] ✕".
// The value is stored in minutes before the event (up to 4 weeks).
function Reminder({
  value,
  onChange,
  onRemove,
}: {
  value: number;
  onChange: (minutes: number) => void;
  onRemove: () => void;
}) {
  // The unit the user picked. It stays even when the number would fit a bigger
  // unit ("60 minutes" does not jump to "1 hour" while typing).
  const [unit, setUnit] = useState(() => T.bestReminderUnit(value));
  const [text, setText] = useState<string | null>(null); // null = not editing
  const shownUnit = value % unit === 0 ? unit : T.bestReminderUnit(value);

  const amount = value / shownUnit;
  const max = Math.floor(T.MAX_REMINDER / shownUnit);
  const typed = text === null ? null : /^\d+$/.test(text.trim()) ? Number(text.trim()) : NaN;
  const invalid = typed !== null && !(typed >= 0 && typed <= max);

  const emit = (minutes: number) => {
    if (minutes !== value) onChange(minutes);
  };

  const onText = (t: string) => {
    setText(t);
    const n = /^\d+$/.test(t.trim()) ? Number(t.trim()) : NaN;
    if (n >= 0 && n <= max) emit(n * shownUnit);
  };

  const onUnit = (u: number) => {
    // Keep the number, change the unit. Too big for the new unit: use the largest allowed.
    const n = Math.min(amount, Math.floor(T.MAX_REMINDER / u));
    setUnit(u);
    setText(null);
    emit(n * u);
  };

  const n = text === null ? amount : null;
  return (
    <div className="reminder">
      <input
        className={`reminder-number ${invalid ? 'invalid' : ''}`}
        type="text"
        inputMode="numeric"
        aria-label="Notification time"
        aria-invalid={invalid}
        title={invalid ? `Enter a number from 0 to ${max}` : undefined}
        value={text ?? String(amount)}
        onFocus={(e) => e.target.select()}
        onChange={(e) => onText(e.target.value)}
        onBlur={() => setText(null)} // invalid text goes back to the saved value
        onKeyDown={(e) => {
          if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
            e.preventDefault();
            const next = Math.max(0, Math.min(max, amount + (e.key === 'ArrowUp' ? 1 : -1)));
            setText(null);
            emit(next * shownUnit);
          }
        }}
      />
      <Select
        className="reminder-unit"
        aria-label="Notification time unit"
        value={shownUnit}
        options={T.REMINDER_UNITS.map((u) => ({ value: u.value, label: (n ?? typed) === 1 ? u.one : u.many }))}
        onChange={onUnit}
      />
      <button
        type="button"
        className="icon-btn sm"
        aria-label="Remove notification"
        title="Remove notification"
        onClick={onRemove}
      >
        <Icon name="close" size={18} />
      </button>
    </div>
  );
}

// The notification rows in the event form, and "Add notification".
// Rows have stable keys, so each row keeps its unit when a row above it is removed.
export default function ReminderList({
  value,
  defaultReminder,
  onChange,
}: {
  value: number[];
  defaultReminder: number;
  onChange: (reminders: number[]) => void;
}) {
  const ids = useRef<{ list: number[]; next: number }>({ list: [], next: 0 });
  const r = ids.current;
  while (r.list.length < value.length) r.list.push(r.next++);
  r.list.length = value.length;

  const add = () => {
    const wanted = [defaultReminder, 30, 10, 60, 1440, ...REMINDER_PRESETS];
    const next = wanted.find((m) => m >= 0 && !value.includes(m));
    if (next !== undefined) onChange([...value, next]);
  };
  const remove = (i: number) => {
    r.list.splice(i, 1);
    onChange(value.filter((_, j) => j !== i));
  };

  return (
    <div className="reminders">
      {value.map((m, i) => (
        <Reminder
          key={r.list[i]}
          value={m}
          onChange={(v) => onChange(value.map((x, j) => (j === i ? v : x)))}
          onRemove={() => remove(i)}
        />
      ))}
      {value.length < MAX_REMINDERS && (
        <button type="button" className="text-btn add-reminder" onClick={add}>
          Add notification
        </button>
      )}
    </div>
  );
}
