import type { Theme } from '../types';

export const THEMES: { id: Theme; label: string }[] = [
  { id: 'light', label: 'Light' },
  { id: 'dark', label: 'Dark' },
  { id: 'system', label: 'Device default' },
];

export function ThemeOptions({
  theme,
  onChange,
  name,
}: {
  theme: Theme;
  onChange: (theme: Theme) => void;
  name: string;
}) {
  return (
    <div className="radio-list" role="radiogroup" aria-label="Theme">
      {THEMES.map((t) => (
        <label key={t.id} className="radio">
          <input type="radio" name={name} checked={theme === t.id} onChange={() => onChange(t.id)} />
          <span>{t.label}</span>
        </label>
      ))}
    </div>
  );
}

export default function AppearanceDialog({
  theme,
  onChange,
  onClose,
  closing,
}: {
  theme: Theme;
  onChange: (theme: Theme) => void;
  onClose: () => void;
  closing: boolean;
}) {
  return (
    <div className={`modal-backdrop ${closing ? 'closing' : ''}`} inert={closing || undefined} onPointerDown={(e) => e.target === e.currentTarget && onClose()}>
      <div className="modal" role="dialog" aria-label="Appearance">
        <h2>Appearance</h2>
        <h3>Theme</h3>
        <ThemeOptions theme={theme} onChange={onChange} name="theme-dialog" />
        <div className="modal-foot">
          <button className="text-btn" onClick={onClose}>
            Done
          </button>
        </div>
      </div>
    </div>
  );
}
