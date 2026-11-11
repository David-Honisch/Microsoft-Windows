import { useEffect, useLayoutEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import type { CSSProperties, RefObject } from 'react';

// One choice in a drop-down list.
export interface Option<V extends string | number> {
  value: V;
  label: string;
  // A colored dot before the label (e.g. calendars).
  color?: string;
  // TimeInput: what the field shows for this option.
  text?: string;
}

interface DropdownListProps<V extends string | number> {
  id: string;
  anchorRef: RefObject<HTMLElement | null>;
  options: Option<V>[];
  activeIndex: number;
  selectedValue: V;
  onPick: (value: V) => void;
}

// The open list of a dropdown (used by Select and TimeInput).
// It is drawn in document.body, so cards with scrolling or rounded corners
// never cut it off. It sits under the anchor, or above it when there is
// not enough room below.
// The active option (keyboard or typed text) is scrolled into the middle.
export default function DropdownList<V extends string | number>({
  id,
  anchorRef,
  options,
  activeIndex,
  selectedValue,
  onPick,
}: DropdownListProps<V>) {
  const ref = useRef<HTMLUListElement>(null);
  const [pos, setPos] = useState<CSSProperties | null>(null);

  // Follow the anchor every frame while open, so the list moves with the
  // field when the form is dragged, docked, scrolled or the window resizes.
  useLayoutEffect(() => {
    let last = '';
    let frame = 0;
    const update = () => {
      const a = anchorRef.current;
      if (a) {
        const r = a.getBoundingClientRect();
        const vv = window.visualViewport;
        const vh = vv ? vv.height + vv.offsetTop : window.innerHeight;
        const vw = window.innerWidth;
        const key = `${r.left},${r.top},${r.width},${r.height},${vw},${vh}`;
        if (key !== last) {
          last = key;
          const below = vh - r.bottom - 8;
          const above = r.top - 8;
          const up = below < 200 && above > below;
          setPos({
            left: Math.max(8, Math.min(r.left, vw - 8 - Math.max(r.width, 120))),
            minWidth: r.width,
            maxHeight: Math.max(80, Math.min(256, up ? above : below)),
            top: up ? undefined : r.bottom + 4,
            bottom: up ? window.innerHeight - r.top + 4 : undefined,
          });
        }
      }
      frame = requestAnimationFrame(update);
    };
    update();
    return () => cancelAnimationFrame(frame);
  }, [anchorRef]);

  const placed = pos !== null;

  // Keep the active option in view (centered), without scrolling the page.
  useEffect(() => {
    const list = ref.current;
    const item = list?.children[activeIndex] as HTMLElement | undefined;
    if (!list || !item) return;
    list.scrollTop = item.offsetTop - list.clientHeight / 2 + item.offsetHeight / 2;
  }, [activeIndex, placed]);

  return createPortal(
    <ul
      ref={ref}
      id={id}
      role="listbox"
      className="dd-list"
      data-popover
      style={pos ? { ...pos, position: 'fixed' } : { visibility: 'hidden', position: 'fixed' }}
      // Keep focus on the field while the user clicks or scrolls the list.
      onMouseDown={(e) => e.preventDefault()}
    >
      {options.map((o, i) => (
        <li
          key={o.value}
          id={`${id}-${i}`}
          role="option"
          aria-selected={o.value === selectedValue}
          className={`dd-item ${i === activeIndex ? 'active' : ''} ${o.value === selectedValue ? 'selected' : ''}`}
          onClick={() => onPick(o.value)}
        >
          {o.color && <span className="dd-dot" style={{ background: o.color }} />}
          {o.label}
        </li>
      ))}
    </ul>,
    document.body,
  );
}
