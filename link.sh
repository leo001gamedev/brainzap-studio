#!/usr/bin/env bash
# Symlink every skill in this repo into ~/.claude/skills, and import CLAUDE.md into ~/.claude/CLAUDE.md.
# Linux and macOS twin of link.ps1: for a VM, or a cloud environment's setup script.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$HOME/.claude/skills"
mkdir -p "$target"

for skill in "$repo"/skills/*/; do
    skill="${skill%/}"
    name="$(basename "$skill")"
    link="$target/$name"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$skill" ]; then
        echo "ok      $name"
    elif [ -e "$link" ] || [ -L "$link" ]; then
        echo "skipped $name: $link exists and is not a link to this repo" >&2
    else
        ln -s "$skill" "$link"
        echo "linked  $name"
    fi
done

# Import the studio CLAUDE.md from the user-level one, which every project loads.
user_claude="$HOME/.claude/CLAUDE.md"
import="@$repo/CLAUDE.md"
if [ -f "$user_claude" ] && grep -qxF "$import" "$user_claude"; then
    echo "ok      CLAUDE.md import"
else
    echo "$import" >> "$user_claude"
    echo "added   CLAUDE.md import to $user_claude"
fi
