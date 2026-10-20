# Studio migration – master plan

Move studio-wide knowledge out of `vine-trail` into this repo so every future game gets it. Based on the harvest audit of 2026-10-19 (5 memories, `CLAUDE.md`, GDD section 0, `NOTES.md`, ADRs 0001–0045, scripts, CI, `.claude/`).

Principle: knowledge is shared now and updates automatically (claude.ai account skills, see Delivery). Code and CI are copied into game two and extracted only when game three arrives, pinned to a version when they are.

## Steps

- [x] **1. Studio repo and first skill.** `brainzap-studio` created; `leo-architecture-standards` moved into `skills/` and junctioned back (backup of the original in `~/.claude/backups/skills-2026-10-19/`). `link.ps1` sets up a new machine.
- [x] **2. Global `CLAUDE.md`.** Done 2026-10-19: `~/.claude/CLAUDE.md` is one `@` import of this repo's `CLAUDE.md` (written by `link.ps1`, without a BOM); skill §10 now targets `develop`; four vine-trail memories deleted, the fifth updated; vine-trail `CLAUDE.md` and GDD section 0 point here. The rules now live in `skills/brainzap-rules/SKILL.md`; `CLAUDE.md` imports it (see Delivery). Original contents:
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
- [x] **3. Workflow skills.** Done 2026-10-20: `start-milestone`, `finish-task`, `review-to-burndown`, `write-adr` in `skills/`; dry-run of start-milestone and write-adr in vine-trail gave M14, `<issue>-m14-sound-pack` and ADR-0046. Remove repo-specific numbers (#7, #75) from each.
  - `start-milestone`: "Mn - Name", one PRD spec issue (Problem, Solution, User Stories, Implementation Decisions with Mn.x checklist, Testing, Out of Scope, Notes), GDD section 11 entries, branch `N-mN-slug`. Replaces the override of `/to-tickets`.
  - `finish-task`: dev-costs row from `.claude/session-cost.json` (procedure in vine-trail `docs/dev-costs.md`), GDD checkboxes, commit, push to the milestone branch.
  - `review-to-burndown`: create the "Bug burndown" milestone if missing; one issue per unfixed finding, linking its source.
  - `write-adr`: GDD section 0's template and rules, plus "studio ADR or game ADR?".
  - Later: `new-game` (when game two starts; its `CLAUDE.md` names the studio rules and `leo-architecture-standards` explicitly, Leo's preference), `harvest-lessons` (end of each milestone).
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

## Delivery (decided 2026-10-20)

**Skills are published to Leo's claude.ai account**, which delivers them to every terminal or VM signed in to it, to cloud sessions and to Desktop. Each game repo's `CLAUDE.md` carries a short pointer to `brainzap-rules`, which makes the rules apply in cloud sessions. On this PC, `~/.claude/CLAUDE.md` also imports them so they're always loaded. Publishing: a push to `master` that changes a skill runs the **Skills** workflow, which checks it, releases the zip and opens an "Upload changed skills" issue; Leo uploads on claude.ai and closes it (README). The upload can't be automated for a personal account (no API, anthropics/claude-code#93163; Team/Enterprise could sync from GitHub on push instead). Checked 2026-10-20: a README-only push skipped publishing; a manual run released both zips and opened issue #1.

Tried and dropped (2026-10-19/20), in order:
- **Plugin / private marketplace:** cloud sessions don't install plugins, even repo-enabled ones, and a plugin can't ship a `CLAUDE.md`.
- **Cloud setup script cloning this repo:** a plain clone failed (`could not read Username`); setup scripts get no environment variables, so a token there was empty (`len=0`); the GitHub proxy only serves repositories attached to the session; and setup results are cached for about 7 days.
- **Syncing a copy into each game repo with a GitHub Action:** Leo rejected copies in every repo.
- Removed with them: `link.sh`, the skill junction in `~/.claude/skills/` (the synced account copy would clash with it), the cloud setup script and `STUDIO_TOKEN`.

Checked: a cloud session on vine-trail listed `anthropic-skills:leo-architecture-standards` after the upload (2026-10-20). Locally, a headless session outside any repo answers from `skills/brainzap-rules/SKILL.md` through the nested import.
