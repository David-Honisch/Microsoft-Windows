import { useState } from 'react';
import Icon from '../icons';
import * as T from '../time';
import { withKey } from '../shortcuts';
import type { ReactNode } from 'react';
import type { View } from '../types';

const VIEW_ITEMS: { id: View; label: string; key: string }[] = [
  { id: 'day', label: 'Day', key: 'D' },
  { id: 'week', label: 'Week', key: 'W' },
  { id: 'month', label: 'Month', key: 'M' },
  { id: 'year', label: 'Year', key: 'Y' },
];

// Shorter title for phones: "Nov 2026" instead of "November 2026".
const shorten = (text: string) => text.replace(/\b(January|February|March|April|May|June|July|August|September|October|November|December)\b/g, (m) => m.slice(0, 3));

function title(view: View, cursor: number) {
  const [y, m, d] = T.ymd(cursor);
  if (view === 'year') return `${y}`;
  if (view === 'day') return `${T.MONTHS[m]} ${d}, ${y}`;
  if (view === 'week') {
    const s = T.startOfWeek(cursor);
    const e = T.addDays(s, 6);
    const [sy, sm] = T.ymd(s);
    const [ey, em] = T.ymd(e);
    if (sm === em) return `${T.MONTHS[sm]} ${sy}`;
    if (sy === ey) return `${T.MONTHS[sm].slice(0, 3)} – ${T.MONTHS[em].slice(0, 3)} ${ey}`;
    return `${T.MONTHS[sm].slice(0, 3)} ${sy} – ${T.MONTHS[em].slice(0, 3)} ${ey}`;
  }
  return `${T.MONTHS[m]} ${y}`;
}

interface MenuAnchor {
  left: number;
  right: number;
  top: number;
  bottom: number;
}

function rectOf(el: Element): MenuAnchor {
  const r = el.getBoundingClientRect();
  return { left: r.left, right: r.right, top: r.bottom + 4, bottom: r.bottom };
}

// Small dropdown menu placed under a button.
function Menu({
  anchor,
  alignRight,
  onClose,
  children,
}: {
  anchor: MenuAnchor;
  alignRight?: boolean;
  onClose: () => void;
  children: ReactNode;
}) {
  const style = alignRight
    ? { top: anchor.top, right: window.innerWidth - anchor.right }
    : { top: anchor.top, left: anchor.left };
  return (
    <>
      <div className="menu-backdrop" onPointerDown={onClose} />
      <div className="menu" style={style} role="menu" data-popover>
        {children}
      </div>
    </>
  );
}

interface HeaderProps {
  view: View;
  cursor: number;
  onToggleSidebar: () => void;
  onToday: () => void;
  onPrev: () => void;
  onNext: () => void;
  onView: (view: View) => void;
  onOpenSettings: () => void;
  onOpenAppearance: () => void;
  onOpenShortcuts: (() => void) | null;
  shortcuts: boolean;
}

export default function Header({
  view, cursor, onToggleSidebar, onToday, onPrev, onNext, onView, onOpenSettings, onOpenAppearance, onOpenShortcuts,
  shortcuts,
}: HeaderProps) {
  const [viewMenu, setViewMenu] = useState<MenuAnchor | null>(null);
  const [gearMenu, setGearMenu] = useState<MenuAnchor | null>(null);
  const unit = view;

  return (
    <header className="header">
      <div className="header-left">
        <button className="icon-btn" aria-label="Main menu" title="Main menu" onClick={onToggleSidebar}>
          <Icon name="menu" />
        </button>
        <img src="/logo.svg" alt="" className="logo" width="40" height="40" />
        <span className="brand">lc2opencalendar</span>
      </div>
      <div className="header-nav">
        <button className="outline-btn today-btn" onClick={onToday} title={withKey('Today', 'T', shortcuts)}>
          Today
        </button>
        <button className="icon-btn" aria-label={`Previous ${unit}`} title={withKey(`Previous ${unit}`, 'K', shortcuts)} onClick={onPrev}>
          <Icon name="chevronLeft" />
        </button>
        <button className="icon-btn" aria-label={`Next ${unit}`} title={withKey(`Next ${unit}`, 'J', shortcuts)} onClick={onNext}>
          <Icon name="chevronRight" />
        </button>
        <h1 className="header-title">
          <span className="title-long">{title(view, cursor)}</span>
          <span className="title-short">{shorten(title(view, cursor))}</span>
        </h1>
      </div>
      <div className="header-right">
        <button
          className="icon-btn settings-btn"
          aria-label="Settings menu"
          title="Settings menu"
          onClick={(e) => setGearMenu(rectOf(e.currentTarget))}
        >
          <Icon name="settings" />
        </button>
        <button className="outline-btn view-btn" onClick={(e) => setViewMenu(rectOf(e.currentTarget))}>
          {VIEW_ITEMS.find((v) => v.id === view)?.label}
          <Icon name="arrowDropDown" size={20} />
        </button>
      </div>

      {viewMenu && (
        <Menu anchor={viewMenu} alignRight onClose={() => setViewMenu(null)}>
          {VIEW_ITEMS.map((v) => (
            <button
              key={v.id}
              role="menuitem"
              className={`menu-item ${v.id === view ? 'active' : ''}`}
              onClick={() => {
                onView(v.id);
                setViewMenu(null);
              }}
            >
              <span>{v.label}</span>
              {shortcuts && <span className="menu-key">{v.key}</span>}
            </button>
          ))}
        </Menu>
      )}
      {gearMenu && (
        <Menu anchor={gearMenu} alignRight onClose={() => setGearMenu(null)}>
          <button
            role="menuitem"
            className="menu-item"
            onClick={() => {
              setGearMenu(null);
              onOpenSettings();
            }}
          >
            Settings
          </button>
          <button
            role="menuitem"
            className="menu-item"
            onClick={() => {
              setGearMenu(null);
              onOpenAppearance();
            }}
          >
            Appearance
          </button>
          {onOpenShortcuts && (
            <button
              role="menuitem"
              className="menu-item"
              onClick={() => {
                setGearMenu(null);
                onOpenShortcuts();
              }}
            >
              Keyboard shortcuts
            </button>
          )}
        </Menu>
      )}
    </header>
  );
}
