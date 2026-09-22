# Agents

Personal, implementation-independent configuration for coding agents.

This repository contains reusable instructions, standards, skills, and other
agentic tooling that should apply across projects rather than belonging to any
particular source repository.

### `instructions/AGENTS.md`

`instructions/AGENTS.md` contains general engineering instructions that should
apply regardless of language, framework, or project.

Technology-specific conventions should not normally live here.

### `instructions/standards/`

`instructions/standards/` contains additional guidance for particular
technologies.

The top-level `AGENTS.md` instructs agents to inspect this directory and load
relevant standards when working with those technologies.

These files describe how a technology should be used rather than how to perform
a particular task.

## Agent integrations

The contents of `instructions/` are intentionally independent of any particular
model or harness.

Agent-specific configuration belongs under `install/`.

Installation scripts act as adapters between this repository and the filesystem
layout expected by a harness. `install/codex.sh` creates symlinks for every
top-level entry in `instructions/`, so edits and nested additions are available
to Codex immediately. Rerun it after adding or removing a top-level entry.

It is expected to be manually invoked, and like this README, is not intended to
be consumed by agents.
