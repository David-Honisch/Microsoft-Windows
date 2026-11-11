// Keeps bottom sheets above the on-screen keyboard.
//
// Android Chrome shrinks the page when the keyboard opens (viewport meta
// "interactive-widget=resizes-content"), so the sheet already sits above it.
// iOS Safari does not: the keyboard covers the bottom of the page. There the
// visible area (window.visualViewport) gets smaller, so we measure it and set:
//   --kb-inset   how much of the window's bottom the keyboard covers
//   --vv-height  height of the area the user can see
// styles.css uses them to lift the sheet and limit its height.
// When the visible area changes, the focused field in a sheet is scrolled
// back into view.
export function watchKeyboard() {
  const vv = window.visualViewport;
  if (!vv) return;
  const root = document.documentElement.style;
  let frame = 0;
  const update = () => {
    frame = 0;
    const inset = Math.max(0, Math.round(window.innerHeight - vv.height - vv.offsetTop));
    root.setProperty('--kb-inset', `${inset}px`);
    root.setProperty('--vv-height', `${Math.round(vv.height)}px`);
    revealFocused();
  };
  const schedule = () => {
    if (!frame) frame = requestAnimationFrame(update);
  };
  vv.addEventListener('resize', schedule);
  vv.addEventListener('scroll', schedule);
  window.addEventListener('resize', schedule);
  // The keyboard animates in after focus; check again once it has settled.
  document.addEventListener('focusin', () => {
    schedule();
    setTimeout(schedule, 300);
  });
  update();
}

function revealFocused() {
  const el = document.activeElement as HTMLElement | null;
  if (!el || !el.closest?.('.popover.sheet')) return;
  if (!el.matches('input, textarea, [contenteditable="true"]')) return;
  el.scrollIntoView({ block: 'nearest' });
}
