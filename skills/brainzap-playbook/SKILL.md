---
name: brainzap-playbook
description: BrainZap Studio's proven technical decisions for HTML5 web games, learned shipping Vine Trail - stack and pure core, platform wrapper, versioned saves, website and Playgama builds, release zips, GA4 studio analytics, mobile canvas (pixel ratio, fluid layout, safe areas, Web Audio), live content that never changes, calm player-respectful design, and share cards with challenge links. Use when starting a new game, planning a milestone or ADR in one of these areas, integrating Playgama or analytics, or making a release.
---

# BrainZap playbook

Studio ADRs: decisions every BrainZap game starts from. Each file below is one decision, with its context, the alternatives already ruled out and the traps hit along the way. Read only the files the task needs.

**How they apply:**
- A new game follows them by default and cites them (`studio S-0003`) instead of re-deciding.
- A game that needs something different writes its own ADR saying which studio ADR it departs from and why (`write-adr`). A game's own ADRs and `CLAUDE.md` win inside that game.
- A game decision that turns out to fit every game is a studio candidate: tell Leo, and it's added here.
- Status `Proposed` means Leo hasn't confirmed the studio-wide version yet; it is still what Vine Trail ships.

| ADR | Decision | Read when |
| --- | --- | --- |
| [S-0001](adr/S-0001-stack-and-pure-core.md) | Phaser 4 + strict TypeScript + Vite; rules in a pure core | Starting a game, structuring code |
| [S-0002](adr/S-0002-platform-wrapper.md) | One platform contract, an implementation per target; rewarded ads report how they ended | Ads, storage, host events, a new platform |
| [S-0003](adr/S-0003-versioned-saves.md) | Versioned save with storage fallbacks; additive fields need no version bump | Any save change |
| [S-0004](adr/S-0004-website-and-playgama-builds.md) | Two builds from one codebase; Playgama Bridge rules | Builds, Playgama submission |
| [S-0005](adr/S-0005-versioned-release-zips.md) | `vX.Y.Z` tags make permanent zips in a GitHub Release | Releasing |
| [S-0006](adr/S-0006-studio-analytics.md) | GA4 on the website only, one schema for every game, consent first | Analytics events, consent |
| [S-0007](adr/S-0007-mobile-web-canvas.md) | Pixel ratio cap 3, fluid layout, background under safe areas, Web Audio | Rendering, layout, sound |
| [S-0008](adr/S-0008-shipped-content-never-changes.md) | Shipped levels are append-only; dailies pick from dated epochs | Level packs, dailies, content updates |
| [S-0009](adr/S-0009-calm-player-respect.md) | Gentle ads, reduced motion, device theme, forgiving streaks | Monetisation, motion, retention features |
| [S-0010](adr/S-0010-share-cards-and-challenge-links.md) | Share cards that work alone; challenge links to the exact puzzle | Sharing, growth |

**References:**
- [references/performance-budgets.md](references/performance-budgets.md) – download, load-time and frame-rate budgets and how to measure them.
- [references/release-test-pass.md](references/release-test-pass.md) – the manual device pass before a release.

Not here yet: the analytics event table itself. Its canonical copy is Vine Trail's `docs/analytics-events.md` until Leo decides to move it into this playbook (S-0006).
