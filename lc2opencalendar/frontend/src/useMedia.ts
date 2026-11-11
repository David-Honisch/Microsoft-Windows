import { useEffect, useState } from 'react';

// True while the CSS media query matches. Breakpoints match styles.css.
export const NARROW = '(max-width: 900px)'; // tablets and phones
export const PHONE = '(max-width: 600px)'; // phones
// Touch-first devices (phones, tablets): tapping a field opens the on-screen keyboard.
export const TOUCH = '(hover: none) and (pointer: coarse)';

export function useMedia(query: string): boolean {
  const [matches, setMatches] = useState(() => window.matchMedia?.(query).matches ?? false);
  useEffect(() => {
    const mq = window.matchMedia?.(query);
    if (!mq) return undefined;
    setMatches(mq.matches);
    const onChange = (e: MediaQueryListEvent) => setMatches(e.matches);
    mq.addEventListener('change', onChange);
    return () => mq.removeEventListener('change', onChange);
  }, [query]);
  return matches;
}
