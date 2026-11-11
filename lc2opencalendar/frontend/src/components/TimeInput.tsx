import { useId, useRef, useState } from 'react';
import DropdownList from './DropdownList';
import type { Option } from './DropdownList';
import type { InputHTMLAttributes, KeyboardEvent } from 'react';

type TimeInputProps = Omit<InputHTMLAttributes<HTMLInputElement>, 'value' | 'onChange'> & {
  value: number;
  options: (Option<number> & { text: string })[];
  resolve: (text: string, partial?: boolean) => number | null;
  format: (value: number) => string;
  onChange: (value: number) => void;
};

// A time field: pick a time from the list, or type any time by hand.
// While typing, the list scrolls to the closest option (like a search).
// Enter, Tab or leaving the field keeps the typed time; Escape undoes it.
//
// options: [{ value, label, text }]  (text = what the field shows for it)
// resolve(text, partial) -> value, or null if the text is not a time
//   (partial = still typing; used only to pick the closest option)
// format(value) -> text shown in the field
export default function TimeInput({ value, options, resolve, format, onChange, ...rest }: TimeInputProps) {
  const id = useId();
  const inputRef = useRef<HTMLInputElement>(null);
  const [open, setOpen] = useState(false);
  const [text, setText] = useState<string | null>(null); // null = not editing
  const [active, setActive] = useState(-1);
  const picked = useRef<TimeInputProps['options'][number] | null>(null); // option chosen with the arrow keys

  const nearest = (v: number) => {
    let best = -1;
    let bestDiff = Infinity;
    options.forEach((o, i) => {
      const d = Math.abs(o.value - v);
      if (d < bestDiff) {
        best = i;
        bestDiff = d;
      }
    });
    return best;
  };

  const start = () => {
    setText(format(value));
    setActive(nearest(value));
    picked.current = null;
    setOpen(true);
  };

  const commit = () => {
    if (text !== null) {
      const v = picked.current && picked.current.text === text ? picked.current.value : resolve(text);
      if (v !== null && v !== value) onChange(v);
    }
    setText(null);
    setOpen(false);
  };

  const cancel = () => {
    setText(null);
    setOpen(false);
  };

  const onKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      if (!open) return start();
      const n = Math.max(0, Math.min(options.length - 1, active + (e.key === 'ArrowDown' ? 1 : -1)));
      const o = options[n];
      setActive(n);
      setText(o.text);
      picked.current = o;
    } else if (e.key === 'Enter') {
      if (!open && text === null) return; // let Enter submit the form
      e.preventDefault();
      commit();
      inputRef.current?.select();
    } else if (e.key === 'Escape' && (open || text !== null)) {
      e.preventDefault();
      e.stopPropagation();
      cancel();
      inputRef.current?.select();
    }
  };

  return (
    <>
      <input
        ref={inputRef}
        className="field-btn time-input"
        role="combobox"
        aria-autocomplete="list"
        aria-expanded={open}
        aria-controls={open ? id : undefined}
        aria-activedescendant={open && active >= 0 ? `${id}-${active}` : undefined}
        autoComplete="off"
        spellCheck={false}
        value={text ?? format(value)}
        onFocus={(e) => {
          start();
          e.target.select();
        }}
        onClick={() => !open && start()}
        onBlur={commit}
        onKeyDown={onKeyDown}
        onChange={(e) => {
          const t = e.target.value;
          setText(t);
          setOpen(true);
          picked.current = null;
          const v = resolve(t, true);
          if (v !== null) setActive(nearest(v));
        }}
        {...rest}
      />
      {open && (
        <DropdownList
          id={id}
          anchorRef={inputRef}
          options={options}
          activeIndex={active}
          selectedValue={value}
          onPick={(v) => {
            setText(null);
            setOpen(false);
            if (v !== value) onChange(v);
          }}
        />
      )}
    </>
  );
}
