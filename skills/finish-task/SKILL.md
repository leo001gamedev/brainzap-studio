---
name: finish-task
description: Close out one BrainZap milestone task (Mn.x) or Bug burndown fix - verify, review the diff, file unfixed findings as Bug burndown issues, tick the GDD checkbox, log assumptions and the dev-costs row, then commit with the Mn or #N message and push to the milestone branch. Use when a task's code is done, when Leo says finish, wrap up, commit or ship this task, or before moving to the next Mn.x task. Also use on its own to file review findings, playtest bugs or tech debt into Bug burndown (references/filing-findings.md) after any code review or playtest, or when Leo reports a small bug outside the current milestone.
---

# Finish a task

Runs after the code for one task is written. Load `brainzap-rules` first; the project's `CLAUDE.md` wins where it differs (its commands, its dev-costs rule, its branch names). Invoking this skill counts as Leo asking for the commit and push.

## 1. Find the task and the branch

- The task: its `Mn.x` line in the GDD milestone section and the spec issue's checklist, or the Bug burndown issue `#N`.
- The branch: the milestone's branch (`<spec-issue>-m<n>-<slug>`), or `<N>-<slug>` for a standalone fix. If the session is on another branch, move the work there before committing (`git stash`, `git switch`, `git stash pop`).

## 2. Verify

Run the project's checks from its `CLAUDE.md` (typically test, lint, format check, typecheck, and the build). Fix what fails. For a visible change, check it running (the `run` skill, or a Playwright screenshot), in both themes if the game has two. Don't claim done on a red check; if one can't pass yet, say so plainly.

## 3. Review the diff

Review the task's diff on its own, as if it were a PR: `/code-review` against the branch's previous commit, with the spec issue as the spec. Fix what belongs to this task. Anything real but outside it becomes a Bug burndown issue, following [references/filing-findings.md](references/filing-findings.md), not a note in chat.

## 4. Update the docs

- Tick `- [x] Mn.x` in the GDD milestone section, and in the spec issue body (`gh issue edit <n> --body-file …`), word for word.
- New assumptions go under Assumptions in `NOTES.md`, newest first, dated, naming the task.
- A change to architecture, a data format or a GDD decision needs its ADR in this same commit, written per `brainzap-playbook`'s references/writing-adrs.md.
- Last task of the milestone: list anything deferred in the GDD section and `NOTES.md` (Deferred).

## 5. Log the cost (if the project does)

If the project has `docs/dev-costs.md`, follow the procedure at the top of that file. In short: read `.claude/session-cost.json`; check `capturedAt` is from this turn and `session_id` is this session; log the delta since the previous row with the same `session_id` (or the full total for a new session) as a new row at the top of the table; never guess a split across tasks, say so under Scope. If the file is missing or stale, ask Leo to run `/cost`.

## 6. Commit and push

- One task per commit. Message `Mn: <what the task did>` (or `#N: <fix>`), the attribution lines the session requires, and nothing about issues closing on merge.
- Stage only this task's files; check `git status` for strays.
- Push to the milestone branch: `git push -u origin <branch>`. Never push to `develop` or `master`.
- Last task of the milestone: open the PR into `develop` (never `master`), listing every task and `Closes #<spec>` plus any burndown issues fixed. Leo merges.

## 7. Report

What changed, what was verified and how, the review findings filed (with issue links), the cost row, and the commit and branch. Then name the next task in the checklist.
