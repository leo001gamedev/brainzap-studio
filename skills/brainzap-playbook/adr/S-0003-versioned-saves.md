# S-0003: Versioned saves with storage fallbacks

Status: Proposed
Date: 2026-10-20
Origin: vine-trail ADR-0007, ADR-0021, ADR-0024, ADR-0032, ADR-0036

## Context
Progress must survive reloads on every target, including Safari private browsing and portal iframes that block storage. Saves live for years and gain fields with almost every milestone; a broken migration loses players' progress for good.

## Decision
- **One `SaveData` object with a `version` number**, written through the platform's storage (S-0002), falling back to `localStorage`, then to memory for the session.
- **A pure `migrate()` in core** reads any older version and any garbage: invalid entries are dropped, unknown fields ignored, missing fields filled with defaults. It is unit-tested for every past version.
- **Additive fields don't bump the version.** A new optional field reads as its default when missing (or invalid), so `version` stays as it is. Vine Trail added `ambience`, `theme` and the analytics consent answer this way.
- **Bump the version only for a changed meaning or shape**, and write the migration from every older version (Vine Trail v1 → v2 seeded solve history from stars).
- **Record what you may need later, early.** Store per-level history (solves, best results) and first-solve logs from launch; features like badges can then reward history players already have, instead of starting everyone at zero.
- **Settings survive "Reset progress"**, and so does the analytics cohort (S-0006).
- **A random `cohort` (0–99)** is drawn the first time a save loads, for comparing player groups.

## Alternatives considered
- `localStorage` only: lost or blocked in some iframes and private modes.
- Accounts and cloud saves: no cross-device sync, but no backend to run. Revisit with Android.
- A raw event log of every solve: flexible, but grows without limit and every feature must replay it.

## Consequences
- Progress works everywhere; no cross-device sync.
- An older build ignores newer fields, so don't roll back across a version bump after launch.
- Every save change is an ADR (data format), with migration tests in the same commit.
