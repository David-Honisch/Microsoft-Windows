import { useEffect, useRef } from 'react';
import Icon from '../icons';
import type { NotificationItem, SlimEvent } from '../notifications';

// In-page alert for event reminders ("Alerts" in notification settings,
// or when the browser does not allow desktop notifications).
export default function NotificationAlert({
  alerts,
  describe,
  onClose,
  closing,
}: {
  alerts: NotificationItem[];
  describe: (event: SlimEvent) => string;
  onClose: () => void;
  closing: boolean;
}) {
  const okRef = useRef<HTMLButtonElement>(null);
  useEffect(() => {
    okRef.current?.focus();
  }, [alerts.length]);

  return (
    <div className={`modal-backdrop alert-backdrop ${closing ? 'closing' : ''}`} inert={closing || undefined}>
      <div className="modal alert" role="alertdialog" aria-label="Event reminder">
        {alerts.map(({ key, event }) => (
          <div key={key} className="alert-item">
            <Icon name="notifications" size={20} className="row-icon" />
            <div>
              <div className="alert-title">{event.title || '(No title)'}</div>
              <div className="alert-when">{describe(event)}</div>
            </div>
          </div>
        ))}
        <div className="modal-foot">
          <button ref={okRef} className="text-btn" onClick={onClose}>
            OK
          </button>
        </div>
      </div>
    </div>
  );
}
