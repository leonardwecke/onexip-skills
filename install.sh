#!/usr/bin/env bash
# Install the onexip skills for Claude Code or GitHub Copilot.
#
#   ./install.sh claude              symlink every skill into ~/.claude/skills
#   ./install.sh claude <project>    copy every skill into <project>/.claude/skills
#   ./install.sh copilot <project>   copy every skill into <project>/.agents/skills
#   ./install.sh                     ask which one
#
# The global install uses symlinks, so `git pull` in this repo updates the
# skills. Project installs use copies, because they are committed with the
# project and have to work on machines that don't have this repo checked out.
#
# An existing skill folder that differs from this repo is never deleted: it is
# moved to <target>/.backup-<timestamp>/ first.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR=""

usage() {
  sed -n '2,7p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 1
}

skill_dirs() {
  for skill_md in "$SCRIPT_DIR"/*/SKILL.md; do
    basename "$(dirname "$skill_md")"
  done
}

# Moves an existing target out of the way. Our own symlink or an unchanged
# copy is replaced directly, anything else is backed up.
clear_target() {
  local target="$1" base="$2"
  if [ -L "$target" ]; then
    rm "$target"
  elif diff -rq "$SCRIPT_DIR/$(basename "$target")" "$target" >/dev/null 2>&1; then
    rm -rf "$target"
  elif [ -e "$target" ]; then
    if [ -z "$BACKUP_DIR" ]; then
      BACKUP_DIR="$base/.backup-$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$BACKUP_DIR"
    fi
    mv "$target" "$BACKUP_DIR/"
    echo "  backed up $(basename "$target") -> $BACKUP_DIR"
  fi
}

install_global() {
  local base="$HOME/.claude/skills"
  mkdir -p "$base"
  for name in $(skill_dirs); do
    clear_target "$base/$name" "$base"
    ln -s "$SCRIPT_DIR/$name" "$base/$name"
    echo "linked $name"
  done
  echo "Done. Restart Claude Code to pick up new skills."
}

# $1: project directory, $2: skills dir inside the project
install_project() {
  local project="${1:-}" subdir="$2"
  [ -n "$project" ] || { read -r -p "Project directory: " project; }
  [ -d "$project" ] || { echo "Not a directory: $project" >&2; exit 1; }
  local base
  base="$(cd "$project" && pwd)/$subdir"
  mkdir -p "$base"
  for name in $(skill_dirs); do
    clear_target "$base/$name" "$base"
    cp -R "$SCRIPT_DIR/$name" "$base/$name"
    echo "copied $name"
  done
  echo "Done. Commit $subdir in $project, then run /setup-onexip-skills there."
}

target="${1:-}"
project="${2:-}"
if [ -z "$target" ]; then
  echo "Install onexip skills for:"
  echo "  1) Claude Code, global  (~/.claude/skills)"
  echo "  2) Claude Code, one project  (.claude/skills)"
  echo "  3) GitHub Copilot, one project  (.agents/skills)"
  read -r -p "Choice [1-3]: " choice
  case "$choice" in
    1) target=claude ;;
    2) target=claude-project ;;
    3) target=copilot ;;
    *) usage ;;
  esac
elif [ "$target" = claude ] && [ -n "$project" ]; then
  target=claude-project
fi

case "$target" in
  claude) install_global ;;
  claude-project) install_project "$project" .claude/skills ;;
  copilot) install_project "$project" .agents/skills ;;
  *) usage ;;
esac
