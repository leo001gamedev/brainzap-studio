# S-0009: Ad pacing and comfort defaults; "calm" is a per-game option

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0024, ADR-0032, ADR-0039, ADR-0040; Leo, 2026-10-20

## Context
Leo wants BrainZap games to earn from ads without driving players off. Vine Trail's pillar, "calm time that leaves you a little sharper", led it to very gentle pacing (one interstitial per 10 minutes of active play), no time pressure and forgiving streaks. Leo decided (2026-10-20) that this full calm package is not the studio default: 10 minutes is too sparse for most games. The default is a moderate pacing every game starts from, plus the comfort rules that cost nothing; the calm package is an option a game takes in its own ADR, as Vine Trail did.

## Decision
**Defaults for every game**
- **Interstitials:** at most one per **2–3 minutes of active play** (default 3 minutes; a game may go down to 2). Active play means a level or round in progress and not paused; menus, ads, settings and hidden tabs don't count. Only at natural breaks (after a level or round ends), never in a player's first 3 minutes of active play (saved across sessions), and never when the next screen teaches something.
- **Rewarded ads** are always optional and report how they ended (S-0002); the player always knows what they get before watching.
- Every ad number lives in the monetisation config, so pacing can change without code.
- **Comfort:** ambient motion is switchable in Settings and off under `prefers-reduced-motion: reduce` whatever the switch says; feedback animations stay under 600 ms. The play area stays clearly readable in every theme (at least 3:1 contrast between play elements and the background, checked by a unit test on the theme values).

**The calm option** (a game takes it in its own ADR, citing this one; Vine Trail does)
- Interstitials at most one per 10 minutes of active play, only after a success, never in the first 15 minutes, never after a daily, a failure or a quit.
- Rewarded ads only for optional help (hints), never to unlock content or continue.
- No countdowns in normal play; speed is an optional reward, not a gate. Unlocks need a little care beyond finishing, never perfection or replays. Difficulty grows through technique and shape, not ever-bigger boards.
- **Streak shield:** one missed day a week keeps a daily streak (it doesn't add to it).
- A day and a night theme with **Auto** following the device's dark mode (`prefers-color-scheme`); one pure rule picks the theme, themes are value sets, and the page background and `theme-color` follow it.

## Alternatives considered
- The calm package as the default (the earlier draft): too few impressions for most games; Leo set 2–3 minutes instead.
- Hyper-casual pacing (an interstitial every round, or under 2 minutes): more impressions per hour, shorter sessions and worse retention; portals also cap frequency.
- Rewarded-only monetisation: calmest of all; a game can still choose it in config.

## Consequences
- A new game ships with 3-minute pacing unless its ADR says otherwise; about 15–20 interstitials per hour of active play at most.
- The save gains lifetime active-play seconds (additive, S-0003), for the first-minutes rule.
- A calm game writes one short ADR taking the calm option, and may tune individual numbers in config.
