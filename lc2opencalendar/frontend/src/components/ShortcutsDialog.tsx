import { SHORTCUT_GROUPS } from '../shortcuts';

// List of keyboard shortcuts. Opened with "?" or from the settings menu.
export default function ShortcutsDialog({
  enabled,
  onEnable,
  onClose,
  closing,
}: {
  enabled: boolean;
  onEnable: () => void;
  onClose: () => void;
  closing: boolean;
}) {
  return (
    <div
      className={`modal-backdrop ${closing ? 'closing' : ''}`}
      inert={closing || undefined}
      onPointerDown={(e) => e.target === e.currentTarget && onClose()}
    >
      <div className="modal shortcuts-modal" role="dialog" aria-label="Keyboard shortcuts">
        <h2>Keyboard shortcuts</h2>
        {!enabled && (
          <p className="settings-note shortcuts-off">
            Keyboard shortcuts are turned off.{' '}
            <button type="button" className="text-btn inline" onClick={onEnable}>
              Turn on
            </button>
          </p>
        )}
        <div className="shortcuts-groups">
          {SHORTCUT_GROUPS.map((g) => (
            <section key={g.title} className="shortcuts-group">
              <h3>{g.title}</h3>
              <dl>
                {g.items.map((s) => (
                  <div key={s.label} className="shortcut-row">
                    <dt>{s.label}</dt>
                    <dd>
                      {s.keys.map((k, i) => (
                        <span key={k}>
                          {i > 0 && <span className="shortcut-or">or</span>}
                          <kbd>{k}</kbd>
                        </span>
                      ))}
                    </dd>
                  </div>
                ))}
              </dl>
            </section>
          ))}
        </div>
        <div className="modal-foot">
          <button className="text-btn" onClick={onClose}>
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
