# AGENTS.md

Instructions for AI coding agents (Claude, ChatGPT/Codex, and others) working on this repository.

## About the project

**lc2opencalendar** is a Google Calendar clone you can self-host.

- (Almost) the same UI, layout and workflow as Google Calendar.
- Open source (MIT license) and fully under the user's control.

When making product or UI decisions, the default answer is: **do what Google Calendar does**, unless the owner says otherwise. Do not copy Google's logos, brand names or proprietary assets.

## Project status

First working version: day/week/month/year views, events (create, edit, move, resize, color, delete), several calendars, notifications, settings, light/dark theme, live sync between all open apps, desktop app (Electron).

Commands:

| What | Command |
| --- | --- |
| Run backend (dev) | `cd backend && go run .` (defaults in `backend.config.json`; precedence is CLI, environment, config file, then built-in defaults) |
| Run frontend (dev) | `cd frontend && npm install && npm run dev` (Vite on `:5173`, proxies `/api` to `:10085`) |
| Build app (frontend + backend) | `cd frontend && npm install && npm run build:app` |
| Build release bundle | `node build-release.mjs` |
| Backend tests | `cd backend && go test ./...` |
| Frontend build | `cd frontend && npm run build` (type-checks, then builds) |
| Frontend type check | `cd frontend && npm run typecheck` |
| Docker image | `docker build -t lc2opencalendar .` |
| Desktop app (dev) | `cd desktop && npm install && npm start` (needs a running server; enter its URL on first start) |
| Desktop installer | `cd desktop && npm run dist` (output in `desktop/dist`; build each OS on that OS) |
| Lint | none yet |

## Tech stack

| Part | Choice |
| --- | --- |
| Backend | Go |
| Frontend | React |
| Database | SQLite |
| Frontend build tool | Vite |
| Shipping | One Docker image |
| Frontend in the image | Built by Vite, then embedded into the Go binary (Go `embed`) |

Why: easy to self-host. One container, one binary, one database file, low memory use.

Smaller decisions (made in the first version; change them only after asking the owner):

| Part | Choice |
| --- | --- |
| Go HTTP routing | Standard library `net/http` (`ServeMux` with method patterns). No web framework. |
| SQLite driver | `modernc.org/sqlite` (pure Go, no CGO, so the Docker build stays simple). |
| Frontend language | TypeScript (TSX), `strict` mode (`frontend/tsconfig.json`). `npm run build` type-checks first (`tsc`), so type errors fail the build. Shared data types are in `frontend/src/types.ts`. Only `frontend/public/sw.js` stays plain JavaScript (the browser loads it as is). |
| Frontend libraries | Only `react` and `react-dom` (plus `typescript` and `@types/*` at build time). No router, state or date library. |
| Styling | One plain CSS file (`frontend/src/styles.css`) with CSS variables for light/dark themes. |
| Icons | Inline SVG paths in `frontend/src/icons.tsx` (Material Design icon shapes, Apache 2.0). |
| Time zones | Browser `Intl` API (`frontend/src/time.ts`). Go embeds `time/tzdata`. |
| Final Docker image | `alpine`, runs as a non-root user, data in `/data`. |
| Live sync | Server-Sent Events (`GET /api/stream`, `backend/live.go`). Standard library only, no WebSocket. |
| Desktop app | Electron, in `desktop/`. Plain JavaScript (CommonJS, no build step). Packaged with `electron-builder`. It loads the web app from the user's server (no data of its own, no bundled server). |

How the app works:

- API lives under `/api` (`backend/api.go`): `GET/POST /api/events`, `PUT/DELETE /api/events/{id}`, `GET/POST /api/calendars`, `PUT/DELETE /api/calendars/{id}`, `GET/PUT /api/settings`, `GET /api/health`, `GET /api/stream`.
- Live sync (`backend/live.go`, `frontend/src/live.ts`):
  - Every open app keeps one Server-Sent Events stream (`GET /api/stream`). After each successful change the server sends `{"topic": "events" | "calendars" | "settings", "client": "..."}`. Deleting a calendar sends `calendars` and `events`.
  - New write routes must be wrapped with `h.notify(handler, topics...)` in `Register`, or other apps will not see the change.
  - The app sends `X-lc2opencalendar-Client` (a random id per page load) with each request. A page skips messages with its own id (it already has the change).
  - On a message the page loads that data again with the normal API (`useLiveUpdates` in `App.tsx`). After the stream reconnects, it loads everything again (changes may have been missed).
  - Heartbeat every 25 seconds. On shutdown the hub closes all streams so `srv.Shutdown` does not wait.
- Calendars (like "My calendars" in the classic calendar):
  - Table `calendars`: name, description, color, `time_zone`, `hidden`, `is_primary`. Every event has a `calendar_id`.
  - Calendar time zone: an IANA name, or `''` for "same as the primary time zone". It is saved and can be changed, but the calendar views still use the primary time zone (like the classic calendar).
  - The calendar time zone drop-down (create form and calendar page) offers only the primary time zone and the "Other time zones" from General settings (plus the calendar's own, if it was removed from settings since). A link under it opens General → Time zone to add more.
  - There is always one primary calendar ("My calendar", made by `migrate` in `store.go`). It is listed first and cannot be deleted. New events go to it. An event sent without `calendarId` also goes to it.
  - `migrate` puts events from older databases in the primary calendar. Their color `#039be5` (the old default) becomes `''`.
  - Event color `''` means "use the calendar color" (`colorOf(event, calendar)` in `colors.ts`). New events use it. The color picker shows it as the first swatch.
  - `PUT /api/calendars/{id}` changes only the fields that are sent (e.g. `{"hidden":true}`).
  - Deleting a calendar deletes its events (after a confirm dialog).
  - Sidebar: a colored checkbox shows or hides a calendar (`hidden` is saved in the database, so it follows the user). The ⋮ button (or right-click) opens "Display this only", "Settings" and colors (`CalendarMenu.tsx`). The + button opens Settings at "Create new calendar".
  - Settings page (`SettingsPage.tsx`) has separate pages, like the classic calendar. The left menu has groups that open and close: "General" (one scrolling page: date and time, time zone, events, notifications, appearance, keyboard shortcuts; the menu jumps to each part and marks the one in view), "Add calendar" → "Create new calendar", and "Settings for my calendars" → one page per calendar (`CalendarSettings.tsx`: name, description, time zone, color, delete).
  - New calendars start with "Same as primary time zone" and a color no other calendar uses; both can be changed in the create form.
  - Calendar fields save when they lose focus; time zone and color save right away.
  - Only one menu group is open at a time. Opening a page (group title or item) opens its group and closes the others. Groups open and close with a height animation (CSS `grid-template-rows`), off when animations are off.
  - Tablets and phones (≤900px): no settings menu. Settings opens the General page only. Calendar pages open from the sidebar only (+ → Create new calendar, ⋮ → Settings); the header then shows the page name. Back always returns to the calendar.
  - Saving an event into a hidden calendar shows that calendar again.
  - Hidden calendars still send notifications (like the classic calendar).
- Events are stored as UTC Unix milliseconds. The frontend shows them in the time zone from settings.
- Time zones:
  - Settings → Time zone: "Primary time zone" (`timeZone`, '' = device) and "Other time zones" (`otherTimeZones`, up to 5 IANA names, stored as a JSON array in the settings table).
  - Day/week grid: each other time zone gets its own hour column left of the primary one (`extraZones` in `App.tsx`, `.tg-gutter.extra`). Not on phones (no room).
  - Each event has `timeZone` (`time_zone` column; '' = the primary time zone). The event form shows its times in that zone. The form's time zone drop-down offers only the primary zone and the other time zones from settings (plus the event's own if it was removed from settings), and is hidden when there is no other choice. Changing it keeps the clock times (9am stays 9am, in the new zone), like the classic calendar.
  - A new event takes the time zone of its calendar (`calendarZone` in `frontend/src/calendars.ts`). The moment stays the same (the clicked slot); the form shows it in that zone. Changing the calendar of a new event also changes the zone, until the user picks a time zone by hand (`zoneSet` on the draft, not saved).
  - The grid always draws events in the primary time zone. The details card adds a line with the time in the event's zone when it differs.
- Settings (date format, time format, time zone, default duration, default notification, notification settings, theme, animations, keyboard shortcuts) are stored in the database, so they follow the user across browsers.
- Notifications (`frontend/src/notifications.ts`):
  - Each event has `reminders`: up to 5 times in minutes before the start (0 to 4 weeks). Stored as a JSON array in the `reminders` column (added by `migrate` in `store.go` for older databases).
  - New events get the "Default notification" from settings.
  - In the event form, each notification is a number field plus a unit drop-down (minutes, hours, days, weeks), like the classic calendar (`ReminderList.tsx`). The value is stored in minutes, so the unit is not saved: a reopened event shows the largest unit that fits ("60 minutes" comes back as "1 hour"). Numbers outside 0 to 4 weeks are marked red and not saved; leaving the field puts back the last good value. Changing the unit keeps the number (capped at 4 weeks).
  - The page checks every 10 seconds which reminders are due. There is no server push, so a calendar tab must be open. Reminders more than 10 minutes late are skipped.
  - "Notifications" setting: Off, Desktop notifications (browser `Notification` API), or Alerts (dialog in the page). If the browser blocks desktop notifications, alerts are used instead.
  - Desktop notifications are shown by a small service worker (`frontend/public/sw.js`) so they can have a Snooze button. A snoozed notification shows again "Show snoozed notifications" minutes before the event (or 5 minutes later if that time has passed).
  - "Play notification sounds": a short chime made with Web Audio (no sound file).
  - Shown reminders and snoozes are kept in `localStorage`, so a reminder shows once even with several tabs open or after a reload.
  - Desktop notifications need HTTPS or `localhost` (browser rule). Headless Chromium always denies them, so tests stub `Notification.permission` and `showNotification`.
- Small per-browser preferences (current view, sidebar open) are kept in `localStorage`.
- Desktop app (`desktop/`):
  - `main.cjs` (Electron main process), `preload.cjs` (bridge), `setup.html` (first start: server URL), `icons/` (PNGs made from `assets/logo.svg`; tray icons cannot be SVG).
  - The server URL is saved in `config.json` in Electron's `userData` folder. Tray → "Change server…" opens the setup page again. If the server cannot be loaded, the setup page shows the error.
  - Closing the window only hides it. The app stays in the tray and the page keeps running (`backgroundThrottling: false`), so the normal reminder code in `notifications.ts` keeps working. Tray → Quit really quits. Only one instance runs.
  - The page talks to the app through `window.lc2opencalendarDesktop` (`frontend/src/desktop.ts`; undefined in a browser): `notify` (native notification with a Snooze button), `showWindow` (used for in-page alerts, so they are seen), `onSnooze`. In the desktop app, notification permission counts as granted and the service worker is not used.
  - The bridge only accepts calls from the server's origin. Links to other sites open in the normal browser.
  - "Start at login" starts the app hidden (`--hidden`). Linux uses an autostart `.desktop` file; Windows and macOS use Electron's login item setting.
  - If the hidden page crashes, it is loaded again.
- Animations (CSS only, in the "Animations" section at the end of `styles.css`):
  - Sidebar (grows/shrinks on wide screens, slides in on tablets and phones), event details card, floating event form and right-click menu (fade and grow), phone sheets (slide up and down), docking the form (the panel grows while the sidebar shrinks), dialogs, snackbar.
  - Closing animations: `useExit` in `frontend/src/motion.ts` keeps a closing element on the page (class `closing`) until its animation ends. Its `key` is used as a React key with a prefix (`details-3`), so siblings never share a key.
  - The "Show animations" setting (Settings → Appearance, stored as `animations`) sets `data-motion` on `<html>`. Off, or the device asks for reduced motion (`prefers-reduced-motion`): no animations at all.
  - Motion made in JavaScript (e.g. `scrollTo` with `behavior: 'smooth'`) must check `motionOn()` from `motion.ts`, because the CSS rule cannot turn it off.
  - Keep animations short (about 150 to 200 ms). `EXIT_MS` in `motion.ts` must be at least the longest closing animation.
- Drop-downs: no browser `<select>`. Use `Select.tsx` (styled list, keyboard and type-ahead). Long lists (time zones) use `SearchSelect.tsx`: type to search, the list scrolls to the best match in real time (nothing is hidden). Enter on typed text that matches nothing keeps the old value. A value not in the options shows the placeholder. Lists are drawn by `DropdownList.tsx` in `document.body` and follow their field (e.g. when the form is dragged).
- Event times use `TimeInput.tsx`: pick from the list or type any time ("9", "930", "9:30pm", "21:15"). While typing, the list scrolls to the closest option. Typed text is read by `parseTime` in `time.ts`. In 12h format, a time without am/pm picks the one closest to the current start (start field) or the first one after the start (end field).
- The event form always opens floating. The user can dock it; it is never docked by default.
- Phones and touch (breakpoints: 900px and 600px in `styles.css`):
  - Sidebar floats over the calendar and starts closed.
  - Phones (≤600px): no Today or settings button in the header; Settings is at the bottom of the sidebar.
  - Phones (≤600px): the event form and details card are sheets stuck to the bottom of the screen. No dock button, no dragging the card. In the form sheet, Close is top left and Save top right (so the keyboard never hides Save). No Delete button in the form sheet: delete from the details card or the long-press menu.
  - Touch devices (`TOUCH` in `useMedia.ts`): the event form does not focus the title on open, so the keyboard only opens when the user taps a field.
  - On-screen keyboard: Android Chrome resizes the page (`interactive-widget=resizes-content` in `index.html`). iOS Safari does not, so `keyboard.ts` measures `window.visualViewport` and sets `--kb-inset` and `--vv-height`; the sheet uses them to stay above the keyboard. The focused field in a sheet is scrolled back into view.
  - Breakpoints are shared in `frontend/src/useMedia.ts` (`NARROW`, `PHONE`); keep them in sync with `styles.css`.
  - Tap = click. Long press on an event = drag it, or open its menu if the finger does not move. Swipe left/right = next/previous period.
  - After a finger tap opens a card, the "ghost" click from the browser is cancelled (see `eatGhostClick` in `TimeGrid.tsx`).
  - Test with Playwright device emulation (e.g. `devices['Pixel 7']`) and touch events.
- Keyboard shortcuts (like the classic calendar):
  - Keys are handled in `App.tsx` (`keyHandler`). The list shown to the user is `SHORTCUT_GROUPS` in `frontend/src/shortcuts.ts`; keep both in sync.
  - `?` (or Settings menu → Keyboard shortcuts) opens `ShortcutsDialog.tsx`.
  - Setting "Enable keyboard shortcuts" (Settings → Keyboard shortcuts, stored as `keyboardShortcuts`, on by default). Off: only `Esc` works, and tooltips/menus show no keys.
  - When on, tooltips show the key ("Next week (J)", "Create (C)") and the view menu shows D/W/M/Y.
  - Phones and touch devices: no key hints, no dialog, no settings section.
- Backend configuration: `backend/backend.config.json` sets `port` and `database`; `-port` and `-database` (or `-db`) CLI options override environment variables, which override the file. Defaults are `:10085` and `lc2opencalendar.db`. Docker continues to configure these with environment variables (`:10085` and `/data/lc2opencalendar.db`).

## Folder layout

One repository, two main folders:

```
lc2opencalendar/
├── backend/     # Go code (API + serves the embedded frontend)
│   └── web/dist # frontend build is copied here before `go build` (only .gitkeep in git)
├── frontend/    # React app (Vite)
│   └── public/logo.svg  # copy of assets/logo.svg (favicon + header logo)
├── desktop/     # Electron desktop app (loads the web app from the server)
├── assets/      # project images (e.g. logo.svg, used in README)
├── Dockerfile   # builds frontend, then backend, into one image
├── README.md
├── AGENTS.md
└── CLAUDE.md
```

- The Dockerfile builds the frontend first, then the Go binary that embeds it.
- The final image only needs the Go binary. No Node.js at runtime.
- The desktop app is not part of the Docker image (`desktop` is in `.dockerignore`).

Rules:

- Keep it to **one Docker image**. Do not add services that need their own container (e.g. Postgres, Redis).
- The SQLite database file must live in a mounted volume, so data survives container updates.
- Anything not listed here (libraries, frameworks, folder layout, tools) is **not decided yet**. Ask before picking (see "How to ask" below), then add the decision here.

## How to talk

- **Keep it simple.** Short sentences, plain words. Easy to read.
- Use lists and short sections, not long paragraphs.
- Say what you did, what you did not do, and why.
- Be honest. If something failed or was skipped, say so.

## How to ask

When you are not sure about something, **stop and ask** instead of guessing.

If there are several ways to do it, give options in this format:

> **Question:** Which database should we use?
>
> **Option A — PostgreSQL**
> - Pros: ...
> - Cons: ...
>
> **Option B — SQLite**
> - Pros: ...
> - Cons: ...
>
> **My recommendation:** Option A, because ...

Always include a recommendation and a short reason.

## Git and GitHub

- **Never work on branches named `claude/*`** (or any other auto-generated agent branch name, like `codex/*`).
- Always create a branch with a clear, descriptive name. Use these prefixes:
  - `feature/` — new functionality (e.g. `feature/week-view`)
  - `fix/` — bug fixes (e.g. `fix/event-timezone-offset`)
  - `docs/` — documentation only (e.g. `docs/setup-guide`)
  - `refactor/` — code changes with no behavior change
  - `chore/` — tooling, dependencies, config
- Use lowercase and hyphens in branch names.
- Never push directly to `main`.
- Write clear commit messages: a short summary line, then details if needed.
- Do not open a pull request unless asked.

Keep branches up to date with `main`:

- Agent sessions often start from an old copy of the repository, so a new branch can be behind `main`.
- Before you start work, run `git fetch origin main`. Create new branches from `origin/main`, not from a local `main` that may be old.
- Check with `git rev-list --left-right --count origin/main...HEAD`. If the left number is not `0`, the branch is behind.
  - No commits of your own yet: `git checkout -B <branch> origin/main`.
  - Already has commits: `git merge origin/main` (this repo uses merge commits).
- Check again before every push and before opening a pull request, because `main` can move during the session.
- Exceptions: the owner says otherwise, or there is a good reason (for example, a branch that must build on another unmerged branch). If you do this, say so.

## Keeping this file up to date

This file is the single source of truth for agent instructions. `CLAUDE.md` points here.

When something important changes (stack chosen, new commands, new conventions), update this file in the same change.
