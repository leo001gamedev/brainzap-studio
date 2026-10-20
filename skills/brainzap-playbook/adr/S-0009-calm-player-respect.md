# S-0009: Calm, player-respectful defaults

Status: Proposed
Date: 2026-10-20
Origin: vine-trail ADR-0024, ADR-0032, ADR-0039, ADR-0040

## Context
Vine Trail's pillar is "calm time that leaves you a little sharper": no time pressure, no grind, no ad pressure. Leo wants BrainZap games to earn from ads without the hyper-casual pacing that drives players off. These defaults came out of that pillar; a game with a different pillar may depart from them in its own ADR.

## Decision
**Ads**
- Interstitials at most one per 10 minutes of **active play** (a board open and not paused; menus, ads, settings and hidden tabs don't count), only after a success, never in a player's first 15 minutes of active play (saved across sessions), never after a daily, a failure or a quit, and never when the next screen teaches something.
- Rewarded ads only for optional help (hints), never to unlock content or continue.
- Every ad number lives in the monetisation config, so pacing can change without code.

**Pressure**
- No countdowns in normal play; speed is an optional reward (a bonus star), not a gate.
- Unlocks need a little care beyond simply finishing (Vine Trail: 35% of the plain-star maximum), never perfection or replays.
- Difficulty grows through technique and shape, not ever-bigger boards.
- **Streak shield:** one missed day a week keeps a daily streak (it doesn't add to it). Streaks should pull players back through value, not guilt.

**Comfort**
- Ambient motion (particles) is subtle, behind everything, switchable in Settings, and off under `prefers-reduced-motion: reduce` whatever the switch says. Feedback animations stay under 600 ms.
- A day and a night theme, with **Auto** as default following the device's dark mode live (`prefers-color-scheme`). One pure rule chooses the theme; themes are sets of values, never separate scenes. The page background and `theme-color` follow it.
- Night themes keep the play area clearly readable: at least 3:1 contrast between empty cells and the background, checked by a unit test on the theme values.

## Alternatives considered
- Hyper-casual pacing (an ad every ~3 minutes): more impressions per hour, against the pillar and likely shorter retention.
- Rewarded-only monetisation: calmer still; modelled in Vine Trail's content plan as a config switch.
- Night only, or a clock-based theme switch: dark screens put some players off; the device setting already says what the player wants.

## Consequences
- Fewer ads per hour (about 5–6 at most); revenue depends on retention.
- The save gains lifetime active-play seconds and the week's shield use (additive, S-0003).
- Each new theme is a value set plus a contrast test, not new drawing code.
