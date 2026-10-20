# S-0008: Shipped content never changes

Status: Proposed
Date: 2026-10-20
Origin: vine-trail ADR-0037, ADR-0038

## Context
Saves store results by level id, players share "Daily #142", and the website and Playgama builds go live on different days. Regenerating or reshuffling content after launch would put players' stars on puzzles they never solved and give two players different puzzles under the same daily number.

## Decision
- **A shipped level never changes:** not its id, board, solution, timing or rules. A data test holds a fingerprint of every shipped level (`npm run record-shipped` updates it at release); any change fails CI.
- **Content grows by appending.** New levels are generated after the last shipped seed, sorted among themselves, and numbered after the shipped ones. The pack builder copies shipped levels instead of rebuilding them, so regenerating is safe by construction.
- **Dailies pick from dated pool epochs.** The config lists epochs, each with a start date and the levels in its pool; a date uses the latest epoch starting on or before it. Day numbering, seeds and selection stay the same.
- **A release that adds content adds a new epoch dated a week or two later,** so every build is live before it takes effect. An epoch is never edited once its date is announced. A test records a year of picks (`npm run record-dailies`) and fails if any changes.

## Alternatives considered
- Regenerate and accept the remap: simplest code; players' progress points at the wrong puzzles.
- Freeze the daily pool: zero risk, but the dailies repeat quickly.
- Reshuffle dailies on every release: the builds disagree for days and share lines contradict each other.

## Consequences
- Difficulty can step at the join between shipped and appended levels; decide per pack whether that breather is wanted.
- Releasing content has two extra steps: pick the epoch date, and record shipped levels and dailies.
