import { useEffect, useLayoutEffect, useRef } from 'react';
import type { PointerEvent as ReactPointerEvent, ReactNode } from 'react';
import type { Anchor } from '../types';
import { useMedia, PHONE } from '../useMedia';

// A floating card placed next to an anchor rectangle ({ left, right, top }).
// Without an anchor it is centered on the screen.
// Presses on the calendar itself ([data-calendar-surface]) are handled by the
// calendar, so they do not close the popover here.
// An element inside with [data-drag-handle] lets the user drag the card by hand.
// Once dragged, the card stays where the user put it.
// `closing`: the card plays its closing animation and ignores the user.
interface PopoverProps {
  anchor?: Anchor | null;
  onClose?: () => void;
  className?: string;
  children: ReactNode;
  label?: string;
  modal?: boolean;
  closing?: boolean;
}

export default function Popover({
  anchor,
  onClose,
  className = '',
  children,
  label,
  modal = false,
  closing = false,
}: PopoverProps) {
  const ref = useRef<HTMLDivElement>(null);
  const dragged = useRef<{ left: number; top: number } | null>(null); // { left, top } after the user moved the card
  // Phones: the card is a sheet stuck to the bottom of the screen (CSS places it).
  const sheet = useMedia(PHONE);

  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return;
    if (sheet) {
      el.style.left = '';
      el.style.top = '';
      return;
    }
    if (dragged.current) {
      place(el, dragged.current.left, dragged.current.top);
      return;
    }
    const w = el.offsetWidth;
    const h = el.offsetHeight;
    const vw = window.innerWidth;
    const vh = window.innerHeight;
    let left: number;
    let top: number;
    if (!anchor) {
      left = (vw - w) / 2;
      top = (vh - h) / 2;
    } else {
      if (anchor.right + 12 + w <= vw - 8) left = anchor.right + 12;
      else if (anchor.left - 12 - w >= 8) left = anchor.left - 12 - w;
      else left = (vw - w) / 2;
      top = anchor.top;
    }
    place(el, left, top);
  });

  const onPointerDown = (e: ReactPointerEvent<HTMLDivElement>) => {
    const target = e.target as Element;
    if (sheet || e.button !== 0 || !target.closest('[data-drag-handle]')) return;
    if (target.closest('button, input, select, textarea, a')) return;
    e.preventDefault();
    const el = ref.current;
    if (!el) return;
    const startX = e.clientX;
    const startY = e.clientY;
    const startLeft = el.offsetLeft;
    const startTop = el.offsetTop;
    el.classList.add('dragging');
    const move = (ev: PointerEvent) => {
      const pos = { left: startLeft + ev.clientX - startX, top: startTop + ev.clientY - startY };
      dragged.current = pos;
      place(el, pos.left, pos.top);
    };
    const up = () => {
      el.classList.remove('dragging');
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
      window.removeEventListener('pointercancel', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
    window.addEventListener('pointercancel', up);
  };

  useEffect(() => {
    if (closing) return undefined;
    const onDown = (e: PointerEvent) => {
      const t = e.target as Element;
      if (ref.current?.contains(t)) return;
      if (!modal && t.closest?.('[data-calendar-surface]')) return;
      if (t.closest?.('[data-popover]')) return;
      onClose?.();
    };
    document.addEventListener('pointerdown', onDown, true);
    return () => document.removeEventListener('pointerdown', onDown, true);
  }, [onClose, modal, closing]);

  return (
    <div
      ref={ref}
      className={`popover ${sheet ? 'sheet' : ''} ${closing ? 'closing' : ''} ${className}`}
      role="dialog"
      aria-label={label}
      aria-hidden={closing || undefined}
      inert={closing || undefined}
      data-popover
      onPointerDown={onPointerDown}
    >
      {children}
    </div>
  );
}

// Put the card at (left, top), but keep it inside the window.
function place(el: HTMLElement, left: number, top: number) {
  const maxLeft = window.innerWidth - el.offsetWidth - 8;
  const maxTop = window.innerHeight - el.offsetHeight - 8;
  el.style.left = `${Math.max(8, Math.min(left, maxLeft))}px`;
  el.style.top = `${Math.max(8, Math.min(top, maxTop))}px`;
}
