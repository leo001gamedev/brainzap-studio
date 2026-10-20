# S-0004: A website build and a Playgama build from one codebase

Status: Proposed
Date: 2026-10-20
Origin: vine-trail ADR-0020, ADR-0027, docs/release-checklist.md

## Context
Every game ships to Playgama (ads, Playgama Bridge SDK) and to the studio website (no ads, own analytics). Playgama has hard rules a build must pass in moderation, and one rejection already came from a technically working build.

## Decision
- **Two builds:** `npm run build` makes the website build (no Bridge, no ads, `localStorage`, GA4 per S-0006), the one CI deploys. `npm run build:playgama` (`--mode playgama`, output `dist-playgama/`) sets `VITE_PLATFORM=playgama`, loads Bridge and adds `playgama-bridge-config.json` next to `index.html`. Bridge code is dropped from the website build.
- **Load Bridge from Playgama's CDN** (`https://bridge.playgama.com/v2/stable/playgama-bridge.js`) with a `<script>` tag **in `index.html`'s head, before the game code.** Adding it at runtime got the first upload rejected: "Playgama Bridge never initialized in this archive". `init()` keeps a time limit and falls back to playing without Bridge.
- **Bridge v2 requirements:** await `bridge.initialize()`; read `platform.language`; save only through `bridge.storage`; follow the host's pause and audio-state events (apply the audio state at start); send `game_ready` at the first playable frame; show interstitials only at natural pauses (between levels, never over a win); pay rewarded ads only on the `rewarded` state.
- **No external analytics in the Playgama build.** Playgama forbids it; a CI check (`check:playgama`) fails the build if `dist-playgama/` contains GA or gtag code.
- **Listing title = in-game title, exactly** (Playgama's self-check). Search words go in the description and tags, not the name.
- **Links from the Playgama build point to the game's Playgama page,** never off-platform.
- **CI uploads the Playgama build as an artifact** on PRs and `develop`, so it can go into Playgama's QA tool before release (preview URLs are the website build and have no Bridge).

## Alternatives considered
- Bridge as an npm package (`mode: 'local'`): no CDN dependency, but every platform adapter ships in the bundle.
- One build detecting Playgama at runtime: loads Bridge on the website for nothing.

## Consequences
- Ads, `game_ready` and pause/audio handling are only truly testable in Playgama's QA tool or a draft upload.
- Moderation takes 1–5 business days on Playgama, up to 2 weeks for partner portals; plan releases around it.
- Before naming a game, a web search isn't a trademark clearance: check USPTO, IP India and WIPO before filing.
