import { useId, useRef, useState } from 'react';
import Icon from '../icons';
import DropdownList from './DropdownList';
import type { Option } from './DropdownList';
import type { InputHTMLAttributes, KeyboardEvent } from 'react';

type SearchSelectProps<V extends string | number> = Omit<InputHTMLAttributes<HTMLInputElement>, 'value' | 'onChange'> & {
  value: V;
  options: Option<V>[];
  onChange: (value: V) => void;
};

// A drop-down you can type into. While typing, the list scrolls to the best
// match in real time (nothing is hidden). Enter or a click picks it; Escape
// or leaving the field keeps the old value.
// Matching order: label starts with the text, then a part of it does
// ("berl" finds "Europe/Berlin"), then the label contains it.
export default function SearchSelect<V extends string | number>({
  value,
  options,
  onChange,
  className = '',
  ...rest
}: SearchSelectProps<V>) {
  const id = useId();
  const inputRef = useRef<HTMLInputElement>(null);
  const wrapRef = useRef<HTMLDivElement>(null);
  const [open, setOpen] = useState(false);
  const [text, setText] = useState<string | null>(null); // null = not typing
  const [active, setActive] = useState(0);

  // A value not in the options shows the placeholder (e.g. "Add time zone").
  const found = options.findIndex((o) => o.value === value);
  const selectedIndex = Math.max(0, found);
  const current = found >= 0 ? options[found] : null;

  const start = () => {
    setActive(selectedIndex);
    setText(null);
    setOpen(true);
  };
  const close = () => {
    setOpen(false);
    setText(null);
  };
  const pick = (v: V) => {
    close();
    if (v !== value) onChange(v);
  };

  const search = (t: string) => {
    const q = t.trim().toLowerCase().replace(/[\s_]+/g, ' ');
    if (!q) return -1;
    const labels = options.map((o) => o.label.toLowerCase().replace(/_/g, ' '));
    let i = labels.findIndex((l) => l.startsWith(q));
    if (i < 0) i = labels.findIndex((l) => l.split(/[/(),-]\s*/).some((part) => part.startsWith(q)));
    if (i < 0) i = labels.findIndex((l) => l.includes(q));
    return i;
  };

  const onKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    const last = options.length - 1;
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      if (!open) return start();
      setActive(Math.max(0, Math.min(last, active + (e.key === 'ArrowDown' ? 1 : -1))));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      // Typed text that matches nothing: keep the old value.
      if (open && text !== null && text.trim() && search(text) < 0) close();
      else if (open) pick(options[active].value);
      else start();
    } else if (e.key === 'Escape' && open) {
      e.preventDefault();
      e.stopPropagation();
      close();
    }
  };

  return (
    <div ref={wrapRef} className={`select-btn search-select ${open ? 'open' : ''} ${className}`}>
      <input
        ref={inputRef}
        role="combobox"
        aria-autocomplete="list"
        aria-expanded={open}
        aria-controls={open ? id : undefined}
        aria-activedescendant={open ? `${id}-${active}` : undefined}
        autoComplete="off"
        spellCheck={false}
        className="select-value"
        value={text ?? current?.label ?? ''}
        onFocus={(e) => {
          start();
          e.target.select();
        }}
        onClick={(e) => {
          if (open) return;
          start();
          e.currentTarget.select();
        }}
        onBlur={close}
        onKeyDown={onKeyDown}
        onChange={(e) => {
          const t = e.target.value;
          setText(t);
          setOpen(true);
          const i = search(t);
          if (i >= 0) setActive(i);
        }}
        {...rest}
      />
      <Icon
        name="arrowDropDown"
        size={20}
        className="select-caret"
        onMouseDown={(e) => {
          e.preventDefault();
          if (open) close();
          else inputRef.current?.focus();
        }}
      />
      {open && (
        <DropdownList
          id={id}
          anchorRef={wrapRef}
          options={options}
          activeIndex={active}
          selectedValue={value}
          onPick={pick}
        />
      )}
    </div>
  );
}
