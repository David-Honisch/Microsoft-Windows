import { useLayoutEffect, useRef, useState } from 'react';
import * as T from '../time';
import { colorOf, textOn } from '../colors';
import type { PointerEvent as ReactPointerEvent } from 'react';
import type { Anchor, CalendarViewProps, ShownEvent } from '../types';

interface MonthViewProps extends CalendarViewProps {
  cursor: number;
  onCreate: (day: number, anchor: Anchor) => void;
}

const ITEM_PX = 22;
const HEAD_PX = 30;

export default function MonthView({
  cursor, events, settings, today, onSurfacePointerDown, onCreate, onEventClick, onEventContext, onDayClick,
}: MonthViewProps) {
  const days = T.monthGridDays(cursor);
  const weeks = days.length / 7;
  const month = T.ymd(cursor)[1];
  const gridRef = useRef<HTMLDivElement>(null);
  const createOk = useRef(false);
  const press = useRef<{ pointerType: string; fired: boolean; timer?: number } | null>(null); // touch long-press on an event chip

  // Touch: hold an event to open its menu (phones have no right click).
  const onChipPointerDown = (e: ReactPointerEvent, ev: ShownEvent) => {
    press.current = { pointerType: e.pointerType, fired: false };
    if (e.pointerType !== 'touch' || ev.isDraft) return;
    const x = e.clientX;
    const y = e.clientY;
    const state = press.current;
    const cleanup = () => {
      clearTimeout(state.timer);
      window.removeEventListener('pointermove', onMove);
      window.removeEventListener('pointerup', cleanup);
      window.removeEventListener('pointercancel', cleanup);
    };
    const onMove = (m: PointerEvent) => {
      if (Math.abs(m.clientX - x) > 8 || Math.abs(m.clientY - y) > 8) cleanup();
    };
    state.timer = window.setTimeout(() => {
      cleanup();
      state.fired = true;
      navigator.vibrate?.(15);
      onEventContext(ev, x, y);
    }, 450);
    window.addEventListener('pointermove', onMove);
    window.addEventListener('pointerup', cleanup);
    window.addEventListener('pointercancel', cleanup);
  };
  const [maxItems, setMaxItems] = useState(3);

  // How many events fit in a cell depends on the window height.
  useLayoutEffect(() => {
    const el = gridRef.current;
    if (!el) return undefined;
    const measure = () => {
      const cellH = el.clientHeight / weeks;
      setMaxItems(Math.max(1, Math.floor((cellH - HEAD_PX - 4) / ITEM_PX)));
    };
    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);
    return () => ro.disconnect();
  }, [weeks]);

  const tf = settings.timeFormat;
  const rectOf = (el: Element): Anchor => {
    const r = el.getBoundingClientRect();
    return { left: r.left, right: r.right, top: r.top };
  };

  return (
    <div className="mv">
      <div className="mv-grid" ref={gridRef} style={{ gridTemplateRows: `repeat(${weeks}, 1fr)` }} data-calendar-surface>
        {days.map((day, i) => {
          const end = T.addDays(day, 1);
          const list = events
            .filter((ev) => ev.ws < end && (ev.we > day || (ev.ws === ev.we && ev.ws === day)))
            .sort((a, b) => a.ws - b.ws || b.we - a.we);
          const overflow = list.length > maxItems;
          const visible = overflow ? list.slice(0, maxItems - 1) : list;
          const [, m, d] = T.ymd(day);
          return (
            <div
              key={day}
              className={`mv-cell ${m !== month ? 'other' : ''}`}
              onPointerDown={(e) => {
                createOk.current = e.button === 0 && !(e.target as Element).closest('.mv-ev, .mv-date, .mv-more') && onSurfacePointerDown();
              }}
              onClick={(e) => {
                if (!createOk.current || (e.target as Element).closest('.mv-ev, .mv-date, .mv-more')) return;
                createOk.current = false;
                onCreate(day, rectOf(e.currentTarget));
              }}
            >
              <div className="mv-cell-head">
                {i < 7 && <span className="mv-dow">{T.weekdayShort(day).toUpperCase()}</span>}
                <button className={`mv-date ${day === today ? 'today' : ''}`} onClick={() => onDayClick(day)}>
                  {d === 1 ? `${T.MONTHS[m].slice(0, 3)} ${d}` : d}
                </button>
              </div>
              <div className="mv-events">
                {visible.map((ev) => {
                  const color = colorOf(ev);
                  return (
                    <button
                      key={ev.id}
                      className={`mv-ev ${ev.isDraft ? 'draft' : ''} ${ev.we <= today && !ev.isDraft ? 'past' : ''}`}
                      style={ev.isDraft ? { background: color, color: textOn(color) } : undefined}
                      onPointerDown={(e) => onChipPointerDown(e, ev)}
                      onClick={(e) => {
                        if (press.current?.fired) return; // the long press already opened the menu
                        onEventClick(ev, rectOf(e.currentTarget));
                      }}
                      onContextMenu={(e) => {
                        e.preventDefault();
                        if (press.current?.pointerType === 'touch') return;
                        onEventContext(ev, e.clientX, e.clientY);
                      }}
                    >
                      {!ev.isDraft && <span className="mv-dot" style={{ background: color }} />}
                      <span className="mv-ev-time">{T.formatTime(Math.max(ev.ws, day), tf)}</span>
                      <span className="mv-ev-title">{ev.title || '(No title)'}</span>
                    </button>
                  );
                })}
                {overflow && (
                  <button className="mv-more" onClick={() => onDayClick(day)}>
                    <span className="mv-more-long">{list.length - visible.length} more</span>
                    <span className="mv-more-short">+{list.length - visible.length}</span>
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
