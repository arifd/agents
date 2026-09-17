#!/usr/bin/env bash

# Install this repository's agent configuration for Codex.
#
# The top-level AGENTS.md is always linked into CODEX_HOME. Additional
# repository directories can be linked by passing their paths as arguments.
#
# Existing files or symlinks pointing somewhere else are never overwritten.
#
# Usage:
#
#   ./install/codex.sh [directory ...]
#
# Examples:
#
#   # Install only AGENTS.md:
#   ./install/codex.sh
#
#   # Install AGENTS.md and technology-specific standards:
#   ./install/codex.sh standards
#
#   # Install AGENTS.md, standards, and skills:
#   ./install/codex.sh standards skills
#
# CODEX_HOME defaults to ~/.codex when not explicitly set.

# Exit immediately if any command exits with a non-zero status:
set -e

# Resolve the root of this repository:
repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

# Respect a custom Codex home, otherwise use the default:
codex_home="${CODEX_HOME:-"$HOME/.codex"}"

mkdir -p "$codex_home"

link() {
    source="$1"
    target="$2"

    if [ -L "$target" ]; then
        current="$(readlink "$target")"

        if [ "$current" = "$source" ]; then
            return
        fi

        echo "Refusing to replace existing symlink: $target" >&2
        echo "Currently points to: $current" >&2
        exit 1
    fi

    if [ -e "$target" ]; then
        echo "Refusing to replace existing path: $target" >&2
        exit 1
    fi

    ln -s "$source" "$target"
}

# Install the global agent instructions:
link "$repo_root/AGENTS.md" "$codex_home/AGENTS.md"

# Install any additional directories requested by the caller:
for directory in "$@"; do
    source="$repo_root/$directory"

    if [ ! -d "$source" ]; then
        echo "Directory does not exist: $source" >&2
        exit 1
    fi

    target="$codex_home/$(basename "$directory")"

    link "$source" "$target"
done
