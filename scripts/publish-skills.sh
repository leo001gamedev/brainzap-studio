#!/usr/bin/env bash
# Zip the changed skills, attach them to a GitHub Release, and open an issue asking Leo to upload them on claude.ai.
# claude.ai has no API for personal account skills (anthropics/claude-code#93163), so the upload itself stays manual.
# Zips are named <skill>-<short sha>.zip so the uploader can tell which commit a zip came from; the folder inside stays <skill>.
# Env: CHANGED and REMOVED (space-separated skill names), plus GH_TOKEN and the usual GITHUB_* variables.
set -euo pipefail

changed="${CHANGED:-}"
removed="${REMOVED:-}"
short="${GITHUB_SHA:0:7}"
repo_url="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY"
tag="skills-$(date -u +%Y%m%d)-$short"

mkdir -p dist
assets=()
for name in $changed; do
    (cd skills && zip -qr "../dist/$name-$short.zip" "$name")
    assets+=("dist/$name-$short.zip")
done

steps=""
for name in $changed; do
    steps+="- [ ] \`$name\`: download [$name-$short.zip]($repo_url/releases/download/$tag/$name-$short.zip), then on claude.ai go to Settings > Skills and replace \`$name\` with it (or upload it, if it's new, and turn it on)"$'\n'
done
for name in $removed; do
    steps+="- [ ] \`$name\` was deleted: remove it from claude.ai Settings > Skills"$'\n'
done

if [ ${#assets[@]} -gt 0 ]; then
    gh release create "$tag" "${assets[@]}" \
        --target "$GITHUB_SHA" \
        --title "Skills $short" \
        --notes "Skill zips built from $short. Upload them on claude.ai, Settings > Skills."
fi

title_names="$(echo $changed $removed | sed 's/ /, /g')"
gh issue create \
    --title "Upload changed skills: $title_names" \
    --body "Commit [$short]($repo_url/commit/$GITHUB_SHA) changed skills that Claude loads from Leo's claude.ai account. claude.ai has no upload API for personal accounts, so this step is manual.

$steps
Running sessions pick up an upload within about 10 minutes. Close this issue once every box is ticked; an open issue means claude.ai is behind this repo."
