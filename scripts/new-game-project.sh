#!/usr/bin/env bash
# scripts/new-game-project.sh
# Scaffold a new BrainZap Phaser project from the vine-trail template.
#
# Usage:
#   ./scripts/new-game-project.sh <game-name> [description]
#
# Example:
#   ./scripts/new-game-project.sh "Fruit Block Puzzle" \
#     "A Block Blast-style puzzle where every block is made of fruit."
#
# This script is safe to run in public repos. It copies the vine-trail folder
# structure and substitutes game-specific names. No tokens, secrets, or
# credentials are embedded anywhere — all secrets reference GitHub Actions
# ${{ secrets.* }} and all IDs are placeholders you set per game.

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <game-name> [description]"
  echo ""
  echo "Example:"
  echo "  $0 \"Fruit Block Puzzle\" \"A Block Blast-style fruit puzzle.\""
  exit 1
fi

GAME_NAME="$1"
GAME_DESC="${2:-A new BrainZap game built with Phaser 4 + TypeScript + Vite.}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

node "$REPO_ROOT/scripts/new-game-project.mjs" \
  --name "$GAME_NAME" \
  --description "$GAME_DESC"
