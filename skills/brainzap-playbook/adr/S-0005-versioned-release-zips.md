# S-0005: Versioned release zips from tags

Status: Accepted
Date: 2026-10-20
Origin: vine-trail ADR-0029

## Context
Portal submissions are zips. Hand-made zips left no record of which code went where, and one hand-zip on Windows broke an upload: PowerShell 5.1's `Compress-Archive` writes backslash paths.

## Decision
- **Version:** `package.json`'s `version`, bumped by hand before each submission: patch for fixes, minor for features.
- **Names** carry build, version and short commit: `<game>-<web|playgama>-v<version>-<commit>.zip`.
- **`npm run release`** builds both targets and zips them into `releases/` (git-ignored) with `fflate`: forward slashes, `index.html` at the root. Never zip by hand. (`tar -a` on Windows stored files uncompressed, twice the size; `zip` isn't on Windows by default.)
- **CI on PRs and `develop`** uploads both builds as versioned artifacts (14 days) for testing; in a PR the commit is the PR head, not the merge commit.
- **Release workflow:** pushing tag `v<version>` runs the checks, refuses a tag that doesn't match `package.json`, builds both zips and attaches them to a GitHub Release. Releases are permanent: the record of what was submitted and deployed.
- **The game shows its version and commit** (Settings' bottom line), from the same build info the zips use.

## Alternatives considered
- Version from date or CI run number: no manual bump, but says nothing about the change and differs between local and CI builds.
- A release on every merge to `master`: `master` deploys the website, and portal submissions don't follow that schedule.

## Consequences
- One small dev dependency (`fflate`).
- Each submission is: bump, merge, tag, push the tag, upload the Release's zip.
