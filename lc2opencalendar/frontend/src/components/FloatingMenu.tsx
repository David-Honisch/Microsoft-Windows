import { useEffect, useLayoutEffect, useRef } from 'react';
import type { ReactNode } from 'react';

// A small menu shown at a point (right-click menu, calendar options).
// It closes on a press outside it or when the window is resized.
// `closing`: the menu plays its closing animation and ignores the user.
interface FloatingMenuProps {
  x: number;
  y: number;
  closing: boolean;
  onClose: () => void;
  label: string;
  children: ReactNode;
}

export default function FloatingMenu({ x, y, closing, onClose, label, children }: FloatingMenuProps) {
  const ref = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return;
    const left = Math.min(x, window.innerWidth - el.offsetWidth - 8);
    const top = Math.min(y, window.innerHeight - el.offsetHeight - 8);
    el.style.left = `${Math.max(8, left)}px`;
    el.style.top = `${Math.max(8, top)}px`;
    // Grow out of the clicked point, even when the menu is moved to fit.
    el.style.transformOrigin = `${x - el.offsetLeft}px ${y - el.offsetTop}px`;
  }, [x, y]);

  useEffect(() => {
    if (closing) return undefined;
    const onDown = (e: PointerEvent) => {
      if (!ref.current?.contains(e.target as Node)) onClose();
    };
    const onResize = () => onClose();
    document.addEventListener('pointerdown', onDown, true);
    window.addEventListener('resize', onResize);
    return () => {
      document.removeEventListener('pointerdown', onDown, true);
      window.removeEventListener('resize', onResize);
    };
  }, [onClose, closing]);

  return (
    <div
      ref={ref}
      className={`ctx-menu ${closing ? 'closing' : ''}`}
      role="menu"
      aria-label={label}
      inert={closing || undefined}
      onContextMenu={(e) => e.preventDefault()}
    >
      {children}
    </div>
  );
}
