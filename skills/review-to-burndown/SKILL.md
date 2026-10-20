---
name: review-to-burndown
description: File review findings, playtest bugs and tech debt that won't be fixed in the current task as Bug burndown issues in a BrainZap repo - one issue per finding, in the "Bug burndown" GitHub milestone, labelled and linked to its source. Use after a code review or playtest leaves findings unfixed, when Leo reports a small bug outside the current milestone, or when anything worth fixing would otherwise stay only in chat.
---

# File findings into Bug burndown

Findings left in chat get lost. Each one that isn't fixed now becomes its own issue. Load `brainzap-rules` first; the project's `CLAUDE.md` wins where it differs.

## 1. Decide what gets filed

- **Fix now, don't file:** anything inside the current task's scope, or a one-line fix that belongs in the same commit.
- **File:** real problems outside the task, small bugs Leo or a playtest found, tech debt you had to walk around.
- **Drop:** style nits the linter doesn't care about, and findings you couldn't confirm. Verify a finding against the code before filing; say "suspected" in the title only if Leo wants unconfirmed ones kept.
- **Not burndown:** anything big enough to need a spec (several tasks, a design choice, an ADR). Tell Leo it's a milestone candidate (`start-milestone`).

## 2. Find or create the milestone

```bash
gh api "repos/{owner}/{repo}/milestones?state=all" --jq '.[] | select(.title=="Bug burndown") | .number'
```

If it's missing, create it once:

```bash
gh api "repos/{owner}/{repo}/milestones" -f title="Bug burndown" -f description="Small bugs, review leftovers and tech debt that don't belong to a GDD milestone task. Pick these up between milestones; each is a small, self-contained fix."
```

Before filing, search open issues for a duplicate (`gh issue list --milestone "Bug burndown" --search "<keywords>"`); comment on it instead of opening a second one.

## 3. Write one issue per finding

- **Title:** the symptom in plain words, as a player or developer would notice it ("Page scrolls while drawing inside the Playgama page on Android"), not the fix.
- **Label:** `bug`, `enhancement` or `question`; add `ready-for-agent` when the fix is clear enough to hand over.
- **Body:**

```markdown
Found by <Leo in playtest / code review of Mn.x / …> (YYYY-MM-DD).

**What happens:** <steps or code path, and what goes wrong; device and browser if it matters>.

**Fix:** <the expected behaviour, or the likely fix if known; leave out if unknown>.

Part of #<spec issue> (<Mn.x task>) / found in <commit sha>.
```

```bash
gh issue create --title "<symptom>" --milestone "Bug burndown" --label bug --body-file <file>
```

## 4. Report

List the issues filed with their links, and anything you dropped and why, in one short list. When a burndown issue is fixed later, its branch is `<N>-<slug>` and its commits are `#N: <fix>`; `finish-task` covers that.
