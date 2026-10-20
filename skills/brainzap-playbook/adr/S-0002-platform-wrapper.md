# S-0002: One platform contract, an implementation per target

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0006, ADR-0020, ADR-0028

## Context
Each game ships to Playgama, the studio website and later Android. Each target has its own ads, storage, pause and analytics APIs, and some targets have none. Scenes that call an SDK directly lock the game to that target.

## Decision
- **Scenes never call a platform SDK.** `src/services/platform.ts` exposes one contract with an implementation per target, chosen at build time (`VITE_PLATFORM`), so other targets' code isn't in the bundle.
- **The contract** (grow it, don't bypass it):
  - `init()` – awaited in `main.ts` before the save is read, with a time limit; on failure the game runs without the platform (no ads, local saves).
  - `gameReady()` – at the first playable frame.
  - `gameplayStart(level)`, `gameplayStop('completed' | 'failed' | 'left', level)`, `gameplayPaused(paused, level)`.
  - `onHostChange({ paused, audioEnabled })` – `main.ts` pauses the game and mutes all sound.
  - `save()` / `load()` – see S-0003.
  - `showInterstitial()` and `showRewarded()`.
  - Analytics sinks – see S-0006.
- **Rewarded ads report how they ended:** `rewarded`, `skipped` (opened, closed without the reward) or `unavailable` (no ad, failed, no report). Pay out only on `rewarded`, and say the right thing for each: "Watch the whole video to earn it" for a skip, "No video available" only when there was none.
- **A rewarded payout is added to the player's count** and shown, not spent at once. Spending it immediately made the reward look like it never arrived (Vine Trail #81). Grant it onto the save as it is when the ad ends, so nothing saved during the ad is lost.
- **A development fake** (`?ads=test`) works only without the real SDK.

## Alternatives considered
- Calling Playgama Bridge from scenes: quick, but every new target means touching every scene.
- One build that detects the platform at runtime: the website would load the SDK for nothing and could pick up its mock behaviour.

## Consequences
- A new platform is one new implementation plus, sometimes, a contract addition.
- Platform behaviour (ads, pause, `game_ready`) can only be checked for real inside the platform's QA tool or a draft upload; unit tests use a fake.
