# Studio migration – master plan

Move studio-wide knowledge out of `vine-trail` into this repo so every future game gets it. Based on the harvest audit of 2026-10-19 (5 memories, `CLAUDE.md`, GDD section 0, `NOTES.md`, ADRs 0001–0045, scripts, CI, `.claude/`).

Principle: knowledge is shared now and updates automatically (junctions into `~/.claude`). Code and CI are copied into game two and extracted only when game three arrives, pinned to a version when they are.

## Steps

- [x] **1. Studio repo and first skill.** `brainzap-studio` created; `leo-architecture-standards` moved into `skills/` and junctioned back (backup of the original in `~/.claude/backups/skills-2026-10-19/`). `link.ps1` sets up a new machine.
- [ ] **2. Global `CLAUDE.md`.** Write `CLAUDE.md` here, junction or link it to `~/.claude/CLAUDE.md`. Contents:
  - Branching: milestone branch → `develop` → `master` after full testing; push to the milestone branch, never to `develop`; `Closes #N` auto-closes only on the default branch.
  - One task per commit, message `Mn: task`.
  - ADR in the same commit for architecture, data-format or design decisions; Proposed by Claude, Accepted by Leo; accepted ADRs are superseded, never edited.
  - Ambiguity: simplest reading, log under Assumptions in `NOTES.md`, continue.
  - Leo in chat wins; docs updated afterwards.
  - Pure core with no engine imports, unit-tested before wiring; no tuning values in the view layer.
  - Default web compatibility: iOS Safari, Android Chrome, desktop Chrome/Edge/Firefox/Safari.
  - Points at `leo-architecture-standards`.
  - Then: delete the vine-trail project memories it covers (branching, milestone structure, bug burndown, CLAUDE.md-references-skill; keep the skill-location reference), and slim vine-trail's `CLAUDE.md` and GDD section 0 down to game-specific rules plus a pointer.
  - **Conflict to resolve first:** `leo-architecture-standards` §10 says the milestone PR goes "into the default branch". That contradicts develop-is-home. Fix the skill to say "into the integration branch (`develop`)".
- [ ] **3. Workflow skills.** Remove repo-specific numbers (#7, #75) from each.
  - `start-milestone`: "Mn - Name", one PRD spec issue (Problem, Solution, User Stories, Implementation Decisions with Mn.x checklist, Testing, Out of Scope, Notes), GDD section 11 entries, branch `N-mN-slug`. Replaces the override of `/to-tickets`.
  - `finish-task`: dev-costs row from `.claude/session-cost.json` (procedure in vine-trail `docs/dev-costs.md`), GDD checkboxes, commit, push to the milestone branch.
  - `review-to-burndown`: create the "Bug burndown" milestone if missing; one issue per unfixed finding, linking its source.
  - `write-adr`: GDD section 0's template and rules, plus "studio ADR or game ADR?".
  - Later: `new-game` (when game two starts), `harvest-lessons` (end of each milestone).
- [ ] **4. Studio ADRs and playbooks** (`adr/S-0001…`, each with "origin: vine-trail ADR-00xx"; vine-trail copies stay):
  - Architecture: 0002, 0006, 0009
  - Saves: 0007; additive-field-with-default pattern from 0021/0024/0032
  - Platforms and release: 0020, 0029, 0027 (Playgama title rule), 0028 (rewarded outcomes)
  - Analytics: 0036, with `docs/analytics-events.md` and `docs/analytics-setup.md`
  - Mobile web: 0031, 0033, 0043, 0018 (Web Audio unlock)
  - Live content: 0037 (+ record-shipped tests), 0038
  - Player respect: 0039, 0024, 0032, 0040
  - Sharing: 0025, 0045
  - Docs: performance budgets, release-checklist pattern
- [ ] **5. Template** – only when game two starts. Copy vine-trail, strip it, and record what had to change. Candidates: Vite configs with playgama mode, lint/format/tsconfig, `.claude/statusline.mjs` + settings, `dev-costs.md` header, CI workflows (later reusable workflows `@v1`), `package-release.ts`, `check-playgama-build.ts` (later `@brainzap/tooling`), GDD/NOTES/CONTEXT/ADR skeletons, `services/` platform, save, safeArea, analytics.

## Stays in vine-trail

ADRs 0003–0005, 0008, 0010–0017, 0019, 0022, 0023, 0026, 0030, 0035, 0041, 0042, 0044; GDD sections 1–12; `NOTES.md` entries; `content-plan.md`; `research/`; `store-listing.md`.

## Open decisions

- GitHub remote for this repo (private) – Leo creates or approves.
- Junctions now; a private plugin marketplace later if a second machine or collaborator needs it.
