#!/usr/bin/env bash

# Install this repository's instructions for Codex.
#
# Top-level entries in instructions/ are linked for live updates. Skills are
# copied into ~/.agents/skills so Codex cannot modify the repository through a
# symlink. Rerun this script after changing skills or instructions.
# Existing unrelated paths are never overwritten.
# CODEX_HOME defaults to ~/.codex.

# Exit immediately if any command exits with a non-zero status:
set -e

# Resolve the root of this repository:
repo_root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

# Respect a custom Codex home, otherwise use the default:
codex_home="${CODEX_HOME:-"$HOME/.codex"}"
agents_home="${AGENTS_HOME:-"$HOME/.agents"}"
skills_source="$repo_root/skills"
skills_target="$agents_home/skills"
skills_marker=".agents-repo-managed"

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

# Validate the repository skills before changing either destination:
if [ -e "$skills_source" ] && [ ! -d "$skills_source" ]; then
    echo "Skills source is not a directory: $skills_source" >&2
    exit 1
fi

if [ -d "$skills_source" ]; then
    if [ -L "$skills_target" ] || { [ -e "$skills_target" ] && [ ! -d "$skills_target" ]; }; then
        echo "Refusing to replace existing skills path: $skills_target" >&2
        exit 1
    fi

    while IFS= read -r -d '' source; do
        if [ ! -d "$source" ]; then
            echo "Skill is not a directory: $source" >&2
            exit 1
        fi

        target="$skills_target/$(basename "$source")"

        if [ -L "$target" ] || { [ -e "$target" ] && [ ! -d "$target" ]; }; then
            echo "Refusing to replace existing skill path: $target" >&2
            exit 1
        fi

        if [ -d "$target" ] && [ ! -f "$target/$skills_marker" ]; then
            echo "Refusing to replace unmanaged skill directory: $target" >&2
            exit 1
        fi
    done < <(find "$skills_source" -mindepth 1 -maxdepth 1 -print0)
fi

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

# Copy repository skills without touching unrelated skills in ~/.agents/skills:
if [ -d "$skills_source" ]; then
    mkdir -p "$skills_target"

    while IFS= read -r -d '' source; do
        target="$skills_target/$(basename "$source")"
        mkdir -p "$target"
        touch "$target/$skills_marker"
        rsync -a --delete --exclude="$skills_marker" "$source/" "$target/"
    done < <(find "$skills_source" -mindepth 1 -maxdepth 1 -type d -print0)

    # Remove only skills previously marked as managed by this repository:
    while IFS= read -r -d '' target; do
        skill_name="$(basename "$target")"

        if [ ! -d "$skills_source/$skill_name" ] && [ -f "$target/$skills_marker" ]; then
            rm -r "$target"
        fi
    done < <(find "$skills_target" -mindepth 1 -maxdepth 1 -type d -print0)
fi
