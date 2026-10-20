# S-0006: Studio analytics on GA4, one schema for every game

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0036, ADR-0021, ADR-0025, docs/analytics-events.md, docs/analytics-setup.md

## Context
BrainZap is a bundle of games, and Leo wants one dashboard with a Game dropdown: which modes players choose, which levels they start and finish, where they give up. It must separate live traffic from staging, previews and local runs, and cost nothing. Playgama forbids external analytics in its build.

## Decision
- **GA4, linked to Firebase, on the website build only.** The Playgama build keeps Playgama's Bridge analytics (S-0004).
- **Two GA4 properties:** "BrainZap Games" gets the live website only; "BrainZap Games – dev" gets previews, staging and local runs (`build_env` `live` / `staging` / `preview` / `local`). Each game is one web data stream in each. CI sets the measurement ID and `build_env` at build time; with no ID, nothing is sent.
- **One event schema for every game:** GA4's recommended game events where one fits, a few generic custom events, the same parameter names everywhere. Rules: snake_case; flat values; never a value in an event name (`level_end`, not `level_12_end`); no personal data; a game-specific moment reuses a generic event with a generic parameter.
- **Common parameters on every event:** `game_id`, `game_version`, `build_env`, `build_target` (`website` / `playgama`), `portal`, `device_type` (`mobile` / `tablet` / `desktop` / `tv`), `device_os` (`android` / `ios` / `windows` / `macos` / `linux` / `other`), `cohort` (0–99, S-0003).
- **Only generic parameters become custom dimensions:** a property has 50, shared by every game.
- **Consent first:** a one-time prompt for every player (no region detection), and a Settings row to change it. Consent Mode starts denied, so until the player agrees GA4 gets only cookieless pings. Show the prompt over the home screen, not before a newcomer's first puzzle (S-0010).
- **Vendor behind a seam:** code reports moments through intent-based functions in `services/analytics.ts`; a pure core module maps moments to events; sinks (Bridge, GA4, no-op) send them. Sending never throws and never waits.
- **Changing an event or parameter name is an ADR**, because it breaks the dashboard for every game.

## Alternatives considered
- One property with an env filter: every report needs the filter, and one miss mixes test traffic in.
- Cookieless GA4 with no prompt: every visit looks new, so retention is meaningless.
- PostHog (cookieless, 1M events free): the fallback if the prompt costs too many players.
- GameAnalytics: the cross-game dashboard is paid. Plausible: paid, built for page views.

## Consequences
- A new game adds a data stream and a `game_id`, follows the schema, and appears in the dashboard.
- Playgama numbers stay in Playgama's console: two places to look.
- Counts run low: ad blockers, Safari's 7-day limit on script-set cookies, and players who decline.
- The full event table stays in Vine Trail's `docs/analytics-events.md` (canonical) while Vine Trail is the only game sending events, because the schema still grows with its milestones and game sessions can't edit this repo. Leo, 2026-10-20: move it into this playbook when a second game starts sending events.
