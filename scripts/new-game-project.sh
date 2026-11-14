#!/usr/bin/env bash
# Start a new BrainZap game from the studio's template repository.
#
#   scripts/new-game-project.sh "<Game Title>" [slug]
#
# It makes a private GitHub repository from the template, clones it beside this
# repo (the same way this repo was cloned), installs its dependencies and names
# the project. `npm run dev` then shows the placeholder scene.
#
# Needs gh (signed in), git and Node 22 or newer. Nothing is changed if the
# folder or the repository already exists. Optional settings:
#   BRAINZAP_TEMPLATE   owner/name of the template (default: leo001gamedev/brainzap-game-template)
#   BRAINZAP_GAMES_DIR  where the game's folder goes (default: beside this repo)
#   DRY_RUN=1           print what would happen and stop

set -euo pipefail

fail() {
  echo "$1" >&2
  exit 1
}

[ $# -ge 1 ] && [ $# -le 2 ] || fail "Usage: $0 \"<Game Title>\" [slug]"

title=$1
slug=${2:-$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')}

# The slug becomes a repository name, a folder and a Firebase project id.
slug_ok='^[a-z0-9]+(-[a-z0-9]+)*$'
[[ $slug =~ $slug_ok ]] || fail "\"$slug\" is not a usable slug: lower-case letters, digits and hyphens only."
# The same rule as the template's init-game: the title lands in JSON, HTML and TypeScript strings.
title_ok='^[[:alnum:]][[:alnum:] !:.-]*$'
[[ $title =~ $title_ok ]] || fail "The title may only use letters, digits, spaces and ! : . -"

studio=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
template=${BRAINZAP_TEMPLATE:-leo001gamedev/brainzap-game-template}
owner=${template%%/*}
dest=${BRAINZAP_GAMES_DIR:-$(dirname "$studio")}/$slug

# Clone the game the way this repo was cloned, so an SSH host alias keeps working.
origin=$(git -C "$studio" remote get-url origin 2>/dev/null || true)
ssh_origin='^(git@[^:]+:)'
if [[ $origin =~ $ssh_origin ]]; then
  url=${BASH_REMATCH[1]}$owner/$slug.git
else
  url=https://github.com/$owner/$slug.git
fi

[ ! -e "$dest" ] || fail "$dest already exists. Nothing was changed."
if gh repo view "$owner/$slug" >/dev/null 2>&1; then
  fail "The repository $owner/$slug already exists. Nothing was changed."
fi

echo "Title:      $title"
echo "Repository: $owner/$slug (private, from $template)"
echo "Folder:     $dest"
echo "Clone URL:  $url"
if [ "${DRY_RUN:-}" = 1 ]; then
  echo "Dry run: stopping here."
  exit 0
fi

gh repo create "$owner/$slug" --private --template "$template" --include-all-branches

# GitHub fills a repository made from a template a moment after creating it.
tries=0
until git ls-remote --exit-code --heads "$url" develop >/dev/null 2>&1; do
  tries=$((tries + 1))
  [ "$tries" -lt 30 ] || fail "$owner/$slug has no develop branch after a minute. Check it on GitHub, then clone $url by hand."
  sleep 2
done

gh repo edit "$owner/$slug" --default-branch develop
git clone --branch develop "$url" "$dest"
cd "$dest"
npm ci
npm run init-game -- "$title" "$slug"

cat <<EOF

$title is ready in $dest. The naming changes are not committed yet.
Next:
  cd "$dest" && npm run dev     the placeholder scene, on http://localhost:8080
  README.md, "Once per game"    Firebase project, GitHub secret and variables, icons
  the new-game skill            the brief and the GDD
  start-milestone               M0, whose first commit carries the naming and the docs
EOF
