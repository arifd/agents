# Agents

Personal, implementation-independent configuration for coding agents.

This repository contains shared instructions, standards, skills, and other
agentic tooling that should apply across projects rather than belonging to any
particular source repository.

### `AGENTS.md`

`AGENTS.md` contains general engineering instructions that should apply
regardless of language, framework, or project.

Technology-specific conventions should not normally live here.

### `standards/`

`standards/` contains additional guidance for particular technologies.

The top-level `AGENTS.md` instructs agents to inspect this directory and load
relevant standards when working with those technologies.

These files describe how a technology should be used rather than how to perform
a particular task.

## Agent integrations

The contents of this repository are intentionally independent of any particular
agent implementation.

Agent-specific configuration belongs under `install/`.

Installation scripts act as adapters between this repository and the filesystem
layout expected by an agent.

It is expected to be manually invoked, and like this README, is not inteded to
be consumed by agents.
