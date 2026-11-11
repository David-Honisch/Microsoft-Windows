import { useId, useRef, useState } from 'react';
import Icon from '../icons';
import DropdownList from './DropdownList';
import type { Option } from './DropdownList';
import type { ButtonHTMLAttributes, KeyboardEvent } from 'react';

type SelectProps<V extends string | number> = Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'value' | 'onChange'> & {
  value: V;
  options: Option<V>[];
  onChange: (value: V) => void;
};

// A styled drop-down, used instead of the browser's <select>.
// options: [{ value, label, color? }] (color: a dot before the label, e.g. calendars)
// Keyboard: arrows, Home/End, Enter/Space, Escape, and typing letters jumps
// to the first option that starts with them.
export default function Select<V extends string | number>({
  value,
  options,
  onChange,
  className = '',
  ...rest
}: SelectProps<V>) {
  const id = useId();
  const btnRef = useRef<HTMLButtonElement>(null);
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const typed = useRef({ text: '', at: 0 });

  const selectedIndex = Math.max(0, options.findIndex((o) => o.value === value));
  const current = options[selectedIndex];

  const openList = () => {
    setActive(selectedIndex);
    setOpen(true);
  };
  const pick = (v: V) => {
    setOpen(false);
    if (v !== value) onChange(v);
  };

  const onKeyDown = (e: KeyboardEvent<HTMLButtonElement>) => {
    const last = options.length - 1;
    const move = (i: number) => {
      e.preventDefault();
      const n = Math.max(0, Math.min(last, i));
      if (open) setActive(n);
      else pick(options[n].value); // like a closed <select>: arrows change the value
    };
    if (e.key === 'ArrowDown') {
      if (e.altKey && !open) return (e.preventDefault(), openList());
      return move((open ? active : selectedIndex) + 1);
    }
    if (e.key === 'ArrowUp') return move((open ? active : selectedIndex) - 1);
    if (e.key === 'Home') return move(0);
    if (e.key === 'End') return move(last);
    if (e.key === 'Enter' || e.key === ' ') {
      if (e.key === ' ' && typed.current.text && Date.now() - typed.current.at < 700) {
        // Space inside a type-ahead word ("New York").
      } else {
        e.preventDefault();
        if (open) pick(options[active].value);
        else openList();
        return;
      }
    }
    if (e.key === 'Escape' && open) {
      e.preventDefault();
      e.stopPropagation();
      setOpen(false);
      return;
    }
    if (e.key === 'Tab') {
      if (open) pick(options[active].value);
      return;
    }
    // Type-ahead.
    if (e.key.length === 1 && !e.ctrlKey && !e.metaKey && !e.altKey) {
      e.preventDefault();
      const now = Date.now();
      const t = now - typed.current.at < 700 ? typed.current.text + e.key : e.key;
      typed.current = { text: t, at: now };
      const q = t.toLowerCase();
      const i = options.findIndex((o) => o.label.toLowerCase().startsWith(q));
      if (i >= 0) {
        if (open) setActive(i);
        else pick(options[i].value);
      }
    }
  };

  return (
    <>
      <button
        ref={btnRef}
        type="button"
        className={`select-btn ${open ? 'open' : ''} ${className}`}
        role="combobox"
        aria-haspopup="listbox"
        aria-expanded={open}
        aria-controls={open ? id : undefined}
        aria-activedescendant={open ? `${id}-${active}` : undefined}
        onClick={() => (open ? setOpen(false) : openList())}
        onKeyDown={onKeyDown}
        onBlur={() => setOpen(false)}
        {...rest}
      >
        {current?.color && <span className="dd-dot" style={{ background: current.color }} />}
        <span className="select-value">{current?.label}</span>
        <Icon name="arrowDropDown" size={20} className="select-caret" />
      </button>
      {open && (
        <DropdownList
          id={id}
          anchorRef={btnRef}
          options={options}
          activeIndex={active}
          selectedValue={value}
          onPick={pick}
        />
      )}
    </>
  );
}
