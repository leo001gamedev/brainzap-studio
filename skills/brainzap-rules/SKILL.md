---
name: brainzap-rules
description: BrainZap Studio's standing rules for every game repo - git flow (develop is home, milestone branches and PRs), commit messages, milestone spec issues, the Bug burndown milestone, ADRs, NOTES.md assumptions, and game code structure (pure core, config, tests, browser compatibility). Load before any git, GitHub, planning, ADR or code task in a BrainZap project, and whenever creating milestones, issues, branches, commits or pull requests.
---

# BrainZap Studio – rules for every project

A project's own `CLAUDE.md` or docs win where they conflict; Leo in chat wins over both, and the docs are updated afterwards.

## Engineering standards
Follow the `leo-architecture-standards` skill (SOLID checks before refactors, surgical changes, incremental migrations, workflow conventions, transferable lessons).

## Git and GitHub
- **`develop` is home.** Each milestone gets one branch off `develop` and one PR into `develop`. `develop` merges into `master` only after thorough testing, because `master` deploys to production. Never target `master` from a milestone branch, and never push to `develop` directly; Leo merges.
- Push every commit for a milestone (tasks, review fixes, bug-burndown fixes) to that milestone's branch, even when the session started on another branch.
- `Closes #N` only auto-closes issues on merges into the default branch. Don't write that an issue closes "when merged into master"; list the issues in the milestone PR and close them by hand if needed.
- One task per commit, message `Mn: <task>` (or `#N: <fix>` for a standalone issue).
- **Milestones:** named `Mn - Name` with the next free number, each with ONE spec issue titled `Mn: Name` in PRD form (Problem Statement, Solution, User Stories, Implementation Decisions with an `Mn.1…` task checklist and blockers in brackets, Testing Decisions, Out of Scope, Further Notes). Never one issue per task; this overrides `/to-tickets`'s one-issue-per-slice default. The tasks also go in the project's GDD milestone section.
- **Bug burndown:** a review finding not fixed in the same task becomes its own issue in the "Bug burndown" milestone (create it if missing), labelled bug, enhancement or question, linking its source commit or issue. Never leave findings only in chat. How: `finish-task`'s references/filing-findings.md.

## Decisions and docs
- **ADRs** in `docs/adr/`, numbered `NNNN-short-title.md`, from the repo's `0000-template.md` (Context, Decision, Alternatives considered, Consequences). Any change to architecture, data formats or a GDD decision needs one in the same commit. Claude writes them as Proposed; Leo marks them Accepted. Never edit an accepted ADR: write a new one and mark the old "Superseded by ADR-NNNN". How, and when a studio ADR already covers it: `brainzap-playbook`'s references/writing-adrs.md.
- **Ambiguity:** choose the simplest reading, log it under Assumptions in `NOTES.md` (newest first), and continue. Don't stall. `NOTES.md` holds assumptions and deferred items only; decisions go in ADRs.
- After finishing a milestone, tick its checkboxes in the GDD and list anything deferred.

## Game code
- Game rules live in a pure core module (`src/core/` or the engine's equivalent) with no engine imports. The view layer only renders and reads input.
- Unit-test every core module before wiring it to a scene.
- No tuning values in scenes or views; they go in config (`src/config/`).
- Web games must work on iOS Safari, Android Chrome and desktop Chrome, Edge, Firefox and Safari unless the project says otherwise.
