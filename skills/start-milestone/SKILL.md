---
name: start-milestone
description: Turn an agreed plan, design or feature idea into a new BrainZap milestone - the next "Mn - Name" GitHub milestone, ONE spec issue in PRD form with an Mn.x task checklist, the matching GDD milestone section, and the milestone branch off develop. Use when Leo asks to create a milestone, make tickets or issues from a plan, write a spec or PRD, or start the next milestone. Replaces the one-issue-per-task output of to-tickets.
---

# Start a milestone

One milestone = one GitHub milestone + one spec issue + one GDD section + one branch. Never one issue per task. Load `brainzap-rules` first; the project's `CLAUDE.md` wins where it differs.

## 1. Gather

- The plan: from the conversation, a design handoff, `.claude/plans/`, or a grilling session. If the goal, the scope or "done when" is unclear, ask Leo before writing anything; this is the one step where asking beats assuming.
- The next free number: `gh api "repos/{owner}/{repo}/milestones?state=all" --jq '.[].title'` and the GDD's milestone headings. Take the highest `Mn` + 1. Numbers are never reused, even for a cancelled milestone.
- The model: the project's `CLAUDE.md` may name one; otherwise read the newest spec issues so tone and depth match:
  `gh issue list --state all -L 100 --json number,title,milestone --jq '[.[] | select((.milestone.title // "") | test("^M[0-9]+ - ")) | select(.title | test("^M[0-9]+: "))] | .[:3][] | "#\(.number) \(.title)"'`
- The GDD sections the milestone touches, Accepted ADRs it must not contradict, and the studio ADRs in `brainzap-playbook` for its areas (saves, platforms, analytics, layout, content, ads, sharing), so the spec builds on them instead of re-deciding.

## 2. Create the GitHub milestone

```bash
gh api "repos/{owner}/{repo}/milestones" -f title="Mn - Name" -f description="<one or two sentences: what ships, then 'Spec: see the Mn spec issue.'>"
```

## 3. Write the spec issue

Title `Mn: Name`, in the new milestone, labels `enhancement` and `ready-for-agent` (create a label only if the repo lacks it). Body sections, in this order:

- **Problem Statement** – what is wrong or missing today, for players and for Leo, with the date Leo raised it.
- **Solution** – the shape of the answer, in plain words. Link mocks or handoffs.
- **User Stories** – numbered, "As a <player / returning player / Leo>, I want …, so that …". Cover edge players: old saves, reduced motion, low-end phones, every supported browser.
- **Implementation Decisions** – grouped by area (core, save, scenes, config, analytics, ADR). Name pure core functions and where they live; name the ADR(s) this milestone needs. End with the task checklist:
  - `- [ ] Mn.1 <task>` … one line each, each a vertical slice that can be one commit; a blocker goes in brackets, e.g. `(after Mn.2)`.
- **Testing Decisions** – what a good test is here, which core modules get unit tests, prior-art tests to copy, and manual checks (devices, screenshots).
- **Out of Scope** – what this milestone deliberately leaves out.
- **Further Notes** – open questions, deferred ideas, links.

```bash
gh issue create --title "Mn: Name" --milestone "Mn - Name" --label enhancement --label ready-for-agent --body-file <file>
```

## 4. Add the GDD section

In the GDD's milestones section, after the last milestone:

```markdown
### Mn – Name

Leo, YYYY-MM-DD. Spec: #<issue> (GitHub milestone "Mn - Name"). <One-sentence summary, with ADR refs.>

- [ ] Mn.1 <same task text as the issue>
- [ ] Mn.2 …

**Done when:** <observable outcome a player or Leo can check>.
```

The task list must match the issue's checklist word for word.

## 5. Create the branch

Branch `<issue>-m<n>-<slug>` off the latest `develop`, e.g. `102-m11-studio-analytics`:

```bash
git fetch origin && git switch -c <issue>-m<n>-<slug> origin/develop
```

Commit the GDD section as the milestone's first commit, `Mn: spec and GDD section`, with any design handoff it depends on. Push the branch. Don't open the PR yet: it opens into `develop` once the tasks are in.

## 6. Report

Give Leo the milestone, the issue link, the branch, and the task list, and name any decision you had to assume (also logged in `NOTES.md`).
