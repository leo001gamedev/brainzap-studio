---
name: write-adr
description: Write an Architecture Decision Record for a BrainZap project - when one is required, numbering, the template (Context, Decision, Alternatives considered, Consequences), Proposed status, superseding instead of editing, and whether the decision is game-specific or studio-wide. Use whenever a change touches architecture, a data or save format, a build or platform target, or contradicts or changes a decision in the GDD, and when Leo asks to record a decision.
---

# Write an ADR

Load `brainzap-rules` first; the project's `CLAUDE.md` wins where it differs.

## 1. Is an ADR needed?

Yes when the change:
- alters architecture (module boundaries, the core/view split, a new service, a dependency),
- changes a data format: save data, level or pack files, URLs, analytics events,
- adds or changes a build target, platform integration or release process,
- changes, narrows or contradicts a decision in the GDD or an Accepted ADR.

No for a bug fix that restores documented behaviour, a refactor with no visible effect, or tuning a value in config. An ambiguous GDD reading goes in `NOTES.md` under Assumptions instead.

## 2. Game ADR or studio ADR?

First check the studio ADRs in the `brainzap-playbook` skill: if one already covers the decision, the game follows it and cites it (`studio S-0003`) with no ADR of its own.

- **Game ADR** (`docs/adr/` in the game repo): the decision is about this game, or it departs from a studio ADR. A departure names the studio ADR and says why this game differs.
- **Studio-wide** (it would apply to every BrainZap game: platform wrapper, saves, analytics schema, release zips, browser rules): still write the game ADR, since this game is where it lands, and tell Leo it's a candidate for `brainzap-playbook`.

## 3. Write it

- Number: the next free `NNNN` in `docs/adr/` (`ls docs/adr | sort | tail -1`). Numbers are never reused.
- File: `docs/adr/NNNN-short-decision-title.md`, kebab-case, the decision not the problem ("save-v2-solve-history", not "save-problem").
- Copy the repo's `docs/adr/0000-template.md`:

```markdown
# ADR-NNNN: <short decision title>

Status: Proposed
Date: YYYY-MM-DD

## Context
What problem or force makes this decision necessary. Link the issue, milestone task and GDD section.

## Decision
What we will do, in one or two sentences, then the specifics as bullets: names, fields, files, numbers.

## Alternatives considered
- Option A: why not
- Option B: why not

## Consequences
What gets easier, what gets harder, what to revisit later. Data changes: how old saves or files migrate.
```

- Status is always `Proposed` when Claude writes it; Leo marks it Accepted.

## 4. Superseding

Never edit an Accepted ADR's decision. Write a new ADR that says which one it supersedes and why, then change only the old one's status line to `Superseded by ADR-NNNN` (or note "narrowed by ADR-NNNN" when it only changes part). A Proposed ADR from the same milestone may still be edited.

## 5. Same commit

The ADR goes in the same commit as the change it records, with the GDD updated to match. Name the ADR in the commit message, e.g. `M7: theme switch and save field (ADR-0032)`.
