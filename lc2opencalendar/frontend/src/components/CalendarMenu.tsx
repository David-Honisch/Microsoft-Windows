import Icon from '../icons';
import ColorPicker from './ColorPicker';
import FloatingMenu from './FloatingMenu';
import type { Calendar } from '../types';

interface CalendarMenuProps {
  calendar: Calendar;
  x: number;
  y: number;
  closing: boolean;
  onClose: () => void;
  onOnly: () => void;
  onSettings: () => void;
  onColor: (color: string) => void;
}

// Options for one calendar in the sidebar list.
export default function CalendarMenu({
  calendar,
  x,
  y,
  closing,
  onClose,
  onOnly,
  onSettings,
  onColor,
}: CalendarMenuProps) {
  return (
    <FloatingMenu x={x} y={y} closing={closing} onClose={onClose} label={`Options for ${calendar.name}`}>
      <button role="menuitem" className="menu-item" onClick={onOnly}>
        <Icon name="visibility" size={20} /> Display this only
      </button>
      <button role="menuitem" className="menu-item" onClick={onSettings}>
        <Icon name="settings" size={20} /> Settings
      </button>
      <div className="menu-divider" />
      <div className="ctx-colors">
        <ColorPicker value={calendar.color} onChange={onColor} size="sm" label="Calendar color" />
      </div>
    </FloatingMenu>
  );
}
