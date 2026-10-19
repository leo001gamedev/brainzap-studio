---
name: leo-architecture-standards
description: Personal engineering standards that apply to every project regardless of language, engine or platform. These cover coding discipline (think before coding, simplicity first, surgical changes, goal-driven verification), SOLID checks before refactors, splitting up god classes, narrow dependencies, intent-based APIs, lifecycle symmetry, hot-path performance, incremental migrations, guarding optional dependencies, async and init ordering, secure persistence, workflow (plans in the repo, no auto-commit), and surfacing transferable lessons from real judgment calls. Use when writing, reviewing or refactoring code, extracting classes or subsystems, designing module boundaries, or planning a migration in any codebase. Project CLAUDE.md rules override these.
---

# Architecture Standards

These are standing rules for any codebase. The project's own CLAUDE.md or docs win when they conflict with these. Examples are pseudocode; follow the idioms of the project's language.

## 0. Coding discipline

These rules come from the [Karpathy guidelines](https://x.com/karpathy/status/2015883857489522876) (MIT) and apply to every change. They lean toward caution over speed, so use judgment on trivial tasks.

**Think before coding.** Don't assume, don't hide confusion, and surface tradeoffs.
- State your assumptions explicitly. If you're uncertain, ask.
- If the request has several interpretations, present them rather than picking one silently.
- If a simpler approach exists, say so, and push back when it's warranted.
- If something is unclear, stop, name what's confusing, and ask.

**Simplicity first.** Write the minimum code that solves the problem and nothing speculative.
- Don't add features beyond what was asked.
- Don't build abstractions for code that's used once.
- Don't add flexibility or configurability nobody requested.
- Don't add error handling for impossible scenarios.
- If you wrote 200 lines and it could be 50, rewrite it. Ask whether a senior engineer would call it overcomplicated.

**Surgical changes.** Touch only what you must, and clean up only your own mess.
- Don't "improve" adjacent code, comments or formatting, and don't refactor what isn't broken.
- Match the existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it rather than deleting it.
- Remove imports, variables and functions that your own change made unused. Leave pre-existing dead code alone unless asked.
- The test: every changed line should trace directly to the user's request.

**Goal-driven execution.** Define success criteria and loop until they're verified.
- "Add validation" becomes "write tests for invalid inputs, then make them pass".
- "Fix the bug" becomes "write a test that reproduces it, then make it pass".
- "Refactor X" becomes "make sure the tests pass before and after".
- For multi-step tasks, state a short plan: `1. [step] → verify: [check]` — and if the work will span more than one sitting, turn it into a file instead (§10).

**Simplicity first and §1 below:** the SOLID check applies when you're *already* extracting or refactoring. It never justifies adding abstractions on its own. A strategy interface earns its place when two or more real variants exist today, not when one might appear later.

## 1. Run a SOLID check before every extraction or refactor

Before you move code out of a class, write down a short analysis (in the plan or in the reply) that answers each of these:

- **SRP**: What is the one reason this new class would change? If you need "and" to answer, split it again.
- **OCP**: Can new behaviour be added without editing it? When behaviour varies by type or mode, use a strategy interface rather than a growing `switch`.
- **LSP**: Can every implementation of this interface substitute for another without surprising the caller — no narrowed preconditions, no throwing where the base type wouldn't?
- **ISP**: What is the smallest thing it needs? Inject that and nothing more.
- **DIP**: Does it depend on an abstraction or on a concrete god object?
- **Encapsulation**: Does it expose public setters for state? Replace them with intent-based methods.

```
// Don't: hand over the whole god object
class InvoiceExporter(app: AppController)          // can reach everything

// Do: inject narrow interfaces or callbacks
class InvoiceExporter(invoices: IInvoiceReader, onDone: () -> Unit)
```

```
// Don't: public mutable state
order.status = "cancelled"; order.refundPending = true

// Do: name the intent
order.cancel(); order.requestRefund()
```

**Variant behaviour uses a strategy.** When two variants (payment providers, export formats, modes) disagree on how to do the same job, define one interface with one implementation per variant. Don't scatter `if (type == A)` checks through shared code.

## 2. Break up god classes incrementally, behind a facade

- **Check for an existing module first.** Before adding logic to a large orchestrator class, see whether a module already extracted from it owns that concern. Put the logic there.
- **Keep the old surface stable while you extract.** The original class keeps pass-through properties and event forwarders that delegate to the new module, so callers don't change in the same diff.
- **Do one extraction per step.** Each step gets its own plan file and leaves the build and tests green. Don't combine extractions.
- **Decide who owns side effects.** Plain logic classes return work (a task, promise or command) and let the lifecycle-aware owner schedule it. Keep timers, threads and long-running loops in the component that owns the lifecycle.

## 3. Pair every subscribe with an unsubscribe

Every `subscribe`, `addListener`, `on` or `register` needs a matching removal in the mirror lifecycle hook: start↔stop, mount↔unmount, init↔dispose, open↔close. Put the two calls next to each other so a reviewer can see the pair.

```
start()   { bus.subscribe(OrderPlaced, onOrderPlaced) }
dispose() { bus.unsubscribe(OrderPlaced, onOrderPlaced) }   // required
```

Prefer events for decoupling: publishers shouldn't know who listens.

## 4. Keep hot paths free of repeated lookups and allocations

- **Never repeat an expensive lookup inside a loop.** This covers DI and service-locator resolution, DOM or view queries, reflection, regex compilation and database or network calls. Do it once before the loop and reuse the result.
- **Reuse objects on hot paths.** When something is created and thrown away at high frequency, reuse or pool it, using the platform's built-in pool where one exists. Measure before pooling anything that isn't actually hot.

```
// Don't
for row in rows: db.query("SELECT rate FROM tax WHERE region = ?", row.region)

// Do
rates = db.query("SELECT region, rate FROM tax").toMap()   // once
for row in rows: row.tax = rates[row.region]
```

## 5. Migrate incrementally while two systems coexist

When a legacy and a modern system live side by side (persistence, DI, HTTP client, state management):

- **New code uses the new system.**
- **Never extend the legacy system.** Don't add new keys, endpoints or call sites to it.
- **Migrate old call sites opportunistically, scoped to this exact exception.** This is the one case where touching code beyond the user's request is sanctioned — it overrides §0's "surgical changes" rule, deliberately and only here: when your diff already touches a call site to the legacy system, and the swap is mechanical (same behaviour, just the new API), make it in the same diff. Don't widen the diff to migrate neighbouring call sites you didn't need to open. If the swap isn't mechanical — it needs real design thought — leave a note instead and stay surgical. Don't do a big-bang rewrite unless someone asks for one.
- **Record the migration state in the project docs.** Note which areas are done and which remain, so the next contributor knows which system to use.

## 6. Guard optional and third-party dependencies

Vendor SDKs, platform-only APIs and feature-flagged integrations may be absent in some builds or environments. Wrap every use of them in the project's guard, whether that's a compile-time define, a feature flag or a capability check. Never assume the API exists.

```
if (features.isEnabled(PAYMENTS) && payments.isAvailable())
    payments.checkout(cart)
```

Hide the vendor behind a project-owned interface, so the guard lives in one place rather than at every call site.

## 7. Respect async loading and initialization order

- **Don't read async data synchronously.** Stored data, remote config and network resources are asynchronous: await them or hook their completion event. Don't read them at startup as if they were already there.
- **Gate config consumers.** Config isn't valid until initialization completes, so make anything that consumes it wait for that point.
- **Make init order explicit.** When component A must initialize before B, declare it with DI dependency order or an explicit bootstrap sequence. Every new component that takes part needs its place assigned deliberately; never rely on incidental ordering. Call the choice out in your summary.
- **Start from an event, not a timer.** When something must happen "after X finishes", wire it to X's completion event. Never use a magic-number delay.

## 8. Store sensitive or tamper-prone data through a hardened layer

Credentials, tokens, entitlements, balances and anything a user could gain by editing goes through the project's secure storage (OS keystore or keychain, encrypted or signed storage, or the server). Never write it to plain key-value storage or local files. Migrate existing plain writes incrementally (see §5).

## 9. No magic strings for events, keys or analytics

Analytics event names, storage keys, config keys, routes and message types live in one constants or enum file. Call sites reference the constants.

```
// Don't
analytics.log("signup_done", ...)

// Do
analytics.log(AnalyticsEvents.SIGNUP_COMPLETED, ...)
```

## 10. Workflow

- **Inline plan vs. plan file: the line is session-span, not step-count.** If the whole task — plan, build, verify — finishes in one sitting, state the plan inline in the reply (§0) and nothing else is needed. The moment work is expected to span more than one sitting (a future session needs to pick it back up), it graduates to a file, because a file is the only form that survives a context reset.
- **Keep plans in the repo** under `.claude/plans/`: `<feature>.md` for features and `step-N-<name>.md` for refactor steps, plus a master plan for multi-step efforts. Never put them in the user-level `~/.claude/plans/`.
- **Verify docs against code.** Treat a claim in CLAUDE.md, a ticket or a plan (a class name, a command, a "done" status) as a hint. Before relying on it or repeating it, check it against the actual code.
- **Don't commit unless asked.** End the turn with a suggested 2–3 line commit message scoped to the change, and let the user commit.
- **One branch per milestone/epic tracked as sub-issues; commit each sub-task directly onto it.** The milestone gets a single branch off the integration branch, `develop` (e.g. `milestone/m1`). Each sub-task/sub-issue is a commit (or small commit group) directly on that branch, referencing its issue (`M1: rng.ts seeded RNG` or similar, plus `Refs #N` if it helps) — no separate sub-branch or per-task PR. Review each sub-task's diff on its own merits before committing it (e.g. via `/code-review` against the branch's own previous commit), same rigor as if it had its own PR; the review doesn't need a PR to happen. Once every sub-task is in, open one PR from the milestone branch into `develop`, never into the default branch. The default branch (`master`) deploys to production, so `develop` merges into it only after everything is thoroughly tested. Consequences of this shape, not bugs: (a) anything that deploys on push to the default branch fires only on a `develop` → `master` merge, never per milestone; (b) don't rely on `Closes #N` scattered across individual sub-task commits — behavior depends on merge strategy (a squash collapses every commit message into one, discarding anything not in it), and GitHub only auto-closes issues on merges into the default branch anyway. The milestone → `develop` PR's own description must list every sub-issue explicitly (`Closes #12, #13, #14...`) in one place; they close when that work reaches the default branch, or by hand when the milestone is merged into `develop`.
- **Leave a status trail on a sub-issue once its work is merged, even though it stays open.** Under the two-level model above, a sub-issue correctly stays open until the final integration-branch merge — but don't let that silence mean the issue looks untouched. The moment its own PR merges into the integration branch, remove any "ready to pick up" triage label (it's served its purpose — the work has been picked up and finished, not just made available) and leave a comment naming the PR/branch it landed in and which merge will actually close it. This is on whoever does the implementation work to handle as the last step, not something the user should have to notice and chase down separately.

## 11. Surface the lesson, not just the change

When a judgment call from one of the rules above actually gets exercised — a SOLID tradeoff, a strategy-vs-switch call, deciding a god class is (or isn't) ready to split, the migration-opportunism scoping in §5, a hot-path pooling decision, a secure-storage boundary, the plan-file threshold in §10 — end the turn with a short **Lesson** callout: 2 to 4 sentences naming the general, transferable principle behind the call, not a restatement of the diff. It should read like something worth repeating on a different stack or in an interview, not "I added a constant."

Skip it for mechanical or routine applications of these rules (pairing a subscribe with an unsubscribe, moving a string into a constants file) — only fire it when there was a real judgment call to make, so it stays a signal instead of noise on every change.

Example:

> **Lesson:** when two rules seem to conflict (don't touch unrelated code vs. migrate opportunistically), the resolution usually isn't "pick a winner" — it's finding the narrower, more specific rule and scoping it tightly enough that it stops competing with the general one.
