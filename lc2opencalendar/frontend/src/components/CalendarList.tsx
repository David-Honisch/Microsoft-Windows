import Icon from '../icons';
import { textOn } from '../colors';
import type { CSSProperties } from 'react';
import type { Calendar } from '../types';

export interface CalendarListProps {
  calendars: Calendar[];
  open: boolean;
  onToggleOpen: () => void;
  onCreate: () => void;
  onToggle: (calendar: Calendar) => void;
  onMenu: (calendar: Calendar, x: number, y: number) => void;
}

// "My calendars" in the sidebar: a checkbox per calendar shows or hides its
// events. The ⋮ button opens the calendar's options (see CalendarMenu).
export default function CalendarList({ calendars, open, onToggleOpen, onCreate, onToggle, onMenu }: CalendarListProps) {
  return (
    <div className="cal-section">
      <div className="cal-section-head">
        <button
          type="button"
          className="cal-section-toggle"
          aria-expanded={open}
          onClick={onToggleOpen}
        >
          <span>My calendars</span>
          <Icon name={open ? 'expandLess' : 'expandMore'} size={20} />
        </button>
        <button
          type="button"
          className="icon-btn sm"
          onClick={onCreate}
          aria-label="Create new calendar"
          title="Create new calendar"
        >
          <Icon name="add" size={20} />
        </button>
      </div>
      {open && (
        <ul className="cal-list">
          {calendars.map((c) => (
            <li
              key={c.id}
              className="cal-item"
              onContextMenu={(e) => {
                e.preventDefault();
                onMenu(c, e.clientX, e.clientY);
              }}
            >
              <label className="cal-check" title={c.name}>
                <input
                  type="checkbox"
                  checked={!c.hidden}
                  onChange={() => onToggle(c)}
                  style={{ '--cal': c.color, '--cal-on': textOn(c.color) } as CSSProperties}
                />
                <span className="cal-name">{c.name}</span>
              </label>
              <button
                type="button"
                className="icon-btn sm cal-more"
                aria-label={`Options for ${c.name}`}
                title="Options"
                onClick={(e) => {
                  const r = e.currentTarget.getBoundingClientRect();
                  onMenu(c, r.left, r.bottom);
                }}
              >
                <Icon name="moreVert" size={18} />
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
