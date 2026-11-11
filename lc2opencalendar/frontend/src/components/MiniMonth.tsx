import { useEffect, useState } from 'react';
import Icon from '../icons';
import * as T from '../time';

// Small month calendar. Used in the sidebar, the date picker and the year view.
interface MiniMonthProps {
  // The selected day (wall time), if any.
  value?: number;
  today: number;
  onPick: (day: number) => void;
  // Year view: always show this month (no month buttons).
  month?: number;
  variant?: 'small' | 'year';
}

export default function MiniMonth({ value, today, onPick, month: fixedMonth, variant = 'small' }: MiniMonthProps) {
  const [shown, setShown] = useState(() => T.startOfMonth(fixedMonth ?? value ?? today));
  useEffect(() => {
    setShown(T.startOfMonth(fixedMonth ?? value ?? today));
  }, [fixedMonth, value, today]);

  const days = T.monthGridDays(shown);
  // Always show 6 rows so the sidebar does not jump.
  while (days.length < 42) days.push(T.addDays(days[days.length - 1], 1));
  const [y, m] = T.ymd(shown);

  return (
    <div className={`mini mini-${variant}`}>
      <div className="mini-head">
        <span className="mini-title">{variant === 'year' ? T.MONTHS[m] : `${T.MONTHS[m]} ${y}`}</span>
        {variant !== 'year' && (
          <span className="mini-nav">
            <button className="icon-btn sm" aria-label="Previous month" onClick={() => setShown(T.addMonths(shown, -1))}>
              <Icon name="chevronLeft" size={18} />
            </button>
            <button className="icon-btn sm" aria-label="Next month" onClick={() => setShown(T.addMonths(shown, 1))}>
              <Icon name="chevronRight" size={18} />
            </button>
          </span>
        )}
      </div>
      <div className="mini-grid" role="grid">
        {T.WEEKDAYS.map((d) => (
          <span key={d} className="mini-dow" aria-hidden="true">
            {d[0]}
          </span>
        ))}
        {days.map((d) => {
          const other = T.ymd(d)[1] !== m;
          const cls = [
            'mini-day',
            other && 'other',
            d === today && !(other && variant === 'year') && 'today',
            value != null && d === value && d !== today && 'selected',
          ]
            .filter(Boolean)
            .join(' ');
          return (
            <button
              key={d}
              className={cls}
              onClick={() => onPick(d)}
              aria-label={`${T.weekdayName(d)}, ${T.MONTHS[T.ymd(d)[1]]} ${T.ymd(d)[2]}`}
            >
              {T.ymd(d)[2]}
            </button>
          );
        })}
      </div>
    </div>
  );
}
