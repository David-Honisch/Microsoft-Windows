import Icon from '../icons';
import ColorPicker from './ColorPicker';
import FloatingMenu from './FloatingMenu';
import type { Calendar, CalendarEvent } from '../types';

interface ContextMenuProps {
  event: CalendarEvent;
  calendar?: Calendar;
  x: number;
  y: number;
  closing: boolean;
  onClose: () => void;
  onColor: (color: string) => void;
  onEdit: () => void;
  onDelete: () => void;
}

// Right-click menu on an event: change color, edit or delete.
// `closing`: the menu plays its closing animation and ignores the user.
export default function ContextMenu({
  event,
  calendar,
  x,
  y,
  closing,
  onClose,
  onColor,
  onEdit,
  onDelete,
}: ContextMenuProps) {
  return (
    <FloatingMenu x={x} y={y} closing={closing} onClose={onClose} label="Event options">
      <button role="menuitem" className="menu-item" onClick={onEdit}>
        <Icon name="edit" size={20} /> Edit
      </button>
      <button role="menuitem" className="menu-item" onClick={onDelete}>
        <Icon name="delete" size={20} /> Delete
      </button>
      <div className="menu-divider" />
      <div className="ctx-colors">
        <ColorPicker value={event.color} calendar={calendar} onChange={onColor} size="sm" />
      </div>
    </FloatingMenu>
  );
}
