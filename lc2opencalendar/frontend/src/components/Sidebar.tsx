import Icon from '../icons';
import MiniMonth from './MiniMonth';
import CalendarList from './CalendarList';
import * as T from '../time';
import { withKey } from '../shortcuts';
import type { CalendarListProps } from './CalendarList';
import type { Phase } from '../motion';

// `phase` comes from useExit (motion.js): 'enter' and 'exit' play the
// opening and closing animations.
// `calendarList`: props for the "My calendars" list (see CalendarList).
interface SidebarProps {
  cursor: number;
  today: number;
  phase: Phase;
  onCreate: () => void;
  onPick: (day: number) => void;
  onOpenSettings: () => void;
  shortcuts: boolean;
  calendarList: CalendarListProps;
}

export default function Sidebar({
  cursor,
  today,
  phase,
  onCreate,
  onPick,
  onOpenSettings,
  shortcuts,
  calendarList,
}: SidebarProps) {
  const closing = phase === 'exit';
  return (
    <aside className={`sidebar ${phase === 'enter' ? 'entering' : ''} ${closing ? 'closing' : ''}`} inert={closing || undefined}>
      <button className="create-btn" onClick={onCreate} title={withKey('Create', 'C', shortcuts)}>
        <Icon name="add" size={28} className="create-plus" />
        <span>Create</span>
      </button>
      <MiniMonth value={T.startOfDay(cursor)} today={today} onPick={onPick} />
      <CalendarList {...calendarList} />
      {/* Phones only (the header has the settings button on bigger screens). */}
      <button className="sidebar-settings" onClick={onOpenSettings}>
        <Icon name="settings" size={22} />
        <span>Settings</span>
      </button>
    </aside>
  );
}
