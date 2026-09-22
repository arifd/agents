#!/usr/bin/env bash

# Install Codex links from this repository's instructions/ directory.
#
# Each top-level entry in instructions/ is linked into CODEX_HOME. Because the
# links point at the repository, edits are live; rerun this script after adding
# or removing a top-level entry. Existing unrelated paths are never overwritten.
# CODEX_HOME defaults to ~/.codex.

# Exit immediately if any command exits with a non-zero status:
set -e

# Resolve the root of this repository:
repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

# Respect a custom Codex home, otherwise use the default:
codex_home="${CODEX_HOME:-"$HOME/.codex"}"

mkdir -p "$codex_home"

# Validate every requested link before changing CODEX_HOME:
while IFS= read -r -d '' source; do
    target="$codex_home/$(basename "$source")"

    if [ -L "$target" ]; then
        current="$(readlink "$target")"

        if [ "$current" = "$source" ]; then
            continue
        fi

        # A missing source under instructions/ is a stale link this installer
        # can remove during the cleanup phase.
        case "$current" in
            "$repo_root/instructions/"*)
                if [ ! -e "$current" ]; then
                    continue
                fi
                ;;
        esac

        echo "Refusing to replace existing symlink: $target" >&2
        echo "Currently points to: $current" >&2
        exit 1
    fi

    # A regular path could be user-owned configuration.
    if [ -e "$target" ]; then
        echo "Refusing to replace existing path: $target" >&2
        exit 1
    fi
done < <(find "$repo_root/instructions" -mindepth 1 -maxdepth 1 -print0)

# Remove links left behind when a top-level instruction is deleted or moved:
while IFS= read -r -d '' target; do
    current="$(readlink "$target")"

    case "$current" in
        "$repo_root/instructions/"*)
            if [ ! -e "$current" ]; then
                rm "$target"
            fi
            ;;
    esac
done < <(find "$codex_home" -mindepth 1 -maxdepth 1 -type l -print0)

# Link every top-level instruction source into Codex home:
while IFS= read -r -d '' source; do
    target="$codex_home/$(basename "$source")"

    if [ ! -L "$target" ]; then
        ln -s "$source" "$target"
    fi
done < <(find "$repo_root/instructions" -mindepth 1 -maxdepth 1 -print0)
