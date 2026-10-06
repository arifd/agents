---
name: code-review
description: Review code for correctness, simplicity, clarity, maintainability, and fit with the surrounding codebase. Read-only: report findings and recommendations, but never modify files.
---

# Code Review

Review code critically and constructively. The goal is to identify real problems and meaningful opportunities to improve the code, not to maximize the number of comments.

This skill is strictly read-only. Never edit, create, delete, rename, format, or otherwise modify files. Do not apply fixes. Report findings only.

## Review priorities

Review in the following order. Earlier concerns take precedence over later ones.

### 1. Correctness

First determine what the code is intended to do, then verify that it actually does it.

Look for:

- behavior that does not match the apparent intent, specification, or surrounding contract
- bugs and incorrect assumptions
- missing or incorrectly handled edge cases
- error paths and failure modes
- boundary conditions
- state inconsistencies
- concurrency or ordering issues where relevant
- behavior that is surprising or undocumented
- tests that give false confidence or fail to exercise important behavior

Do not assume that passing tests imply correctness.

When intent is ambiguous, say so rather than inventing a requirement.

### 2. Implementation

Evaluate whether the implementation expresses the intended behavior in the simplest and clearest reasonable form.

Prefer code that minimizes the number of concepts a reader must understand.

Look for:

- unnecessary complexity
- over-engineering
- premature or unjustified abstraction
- excessive indirection
- unnecessary layers, wrappers, helpers, or configuration
- duplicated logic that would benefit meaningfully from abstraction
- complicated control flow that could be expressed more directly
- abstractions that merely relocate complexity rather than remove it
- abstractions whose cost exceeds the value they provide
- code that solves a more general problem than the one actually required

Do not oppose abstraction categorically. An abstraction is valuable when it meaningfully reduces duplication, isolates a coherent concept, clarifies a boundary, or makes the implementation easier to reason about.

Prefer removing concepts over reorganizing the same complexity.

Do not suggest changes merely because you would have written the code differently.

### 3. Documentation

Evaluate documentation from the perspective of a capable reader who has never seen the codebase before.

Documentation should provide information that cannot be understood easily from the code itself.

Pay particular attention to public APIs, function boundaries, module boundaries, non-obvious invariants, assumptions, side effects, and surprising behavior.

Look for:

- missing context needed to use or modify the code safely
- undocumented parameters, return behavior, errors, side effects, or invariants where these are not obvious
- comments that explain what the code does instead of why it does it
- stale or misleading documentation
- documentation that merely repeats names or implementation details
- excessive comments that make the important information harder to find

Prefer clear code over comments that compensate for unclear code.

The goal is sufficient documentation with minimal noise.

### 4. Naming

Names should make the code easier to understand without requiring additional context.

Check that names are:

- clear
- concise
- descriptive
- intuitive
- consistent with the surrounding codebase
- appropriate to the domain
- specific enough to distinguish related concepts

Flag names that are vague, misleading, unnecessarily verbose, inconsistent, or dependent on knowledge that a new reader would not have.

Prefer domain language when the domain provides a precise term.

### 5. Tests

Where tests are present or relevant, evaluate whether they provide meaningful confidence in the behavior.

Check that:

- important behavior is covered
- edge cases and failure paths are represented where appropriate
- tests exercise observable behavior rather than incidental implementation details
- assertions are strong enough to detect realistic regressions
- test names and structure communicate the intended contract

Do not request tests mechanically. Recommend additional tests when they protect meaningful behavior or expose a plausible failure mode.

### 6. Codebase fit

Review the code as part of the existing system, not in isolation.

Check whether it:

- follows established conventions and patterns where those patterns remain appropriate
- uses existing concepts and utilities rather than creating unnecessary alternatives
- places responsibilities in the appropriate modules or layers
- preserves clear boundaries
- avoids introducing unnecessary coupling
- remains consistent with the vocabulary and mental model of the surrounding code

Consistency is valuable, but do not defend an existing pattern when it clearly makes the code worse.

### 7. Other material concerns

Surface other issues when they are concrete and relevant, including:

- security vulnerabilities
- meaningful performance problems
- resource leaks
- unsafe handling of external input
- unnecessary dependencies
- dead or unreachable code
- compatibility problems

Do not manufacture speculative security, performance, or scalability concerns without evidence that they matter for this code.

## Review approach

Before reporting findings:

1. Understand the purpose and expected behavior of the code.
2. Read enough surrounding code to understand its conventions and contracts.
3. Trace important execution paths rather than reviewing individual lines in isolation.
4. Examine relevant tests and documentation where available.
5. Distinguish actual problems from personal stylistic preference.
6. Prefer a small number of high-confidence, high-value findings over exhaustive commentary.

For every potential finding, ask:

- Is this actually a problem?
- What concrete consequence could it have?
- Is the proposed alternative meaningfully better?
- Would I still raise this if a human engineer had written the code this way?

If the answer is unclear, either omit the finding or explicitly describe the uncertainty.

## Findings

Order findings by importance, not by file position.

For each finding, include:

- **Severity:** `critical`, `major`, `minor`, or `suggestion`
- **Location:** file and line or relevant symbol
- **Issue:** a concise description of the problem
- **Why it matters:** the concrete consequence or maintenance cost
- **Recommendation:** the direction of a better solution, without modifying the code

Use severity consistently:

- **critical** — likely security vulnerability, data loss, severe correctness failure, or similarly serious issue
- **major** — correctness problem or significant design issue that should normally be addressed
- **minor** — localized issue with a real but limited impact
- **suggestion** — non-essential improvement with a clear benefit

Do not inflate severity.

## Review output

Start with the findings, ordered from most to least important.

Do not produce comments simply to demonstrate that every review category was considered.

If a category has no meaningful findings, omit it.

After the findings, provide a short summary of the overall review and mention any important uncertainties or areas that could not be verified.

If there are no meaningful findings, say so explicitly.

## Constraints

This is a read-only review.

Never:

- modify files
- apply fixes
- reformat code
- create or delete files
- perform git operations
- commit changes
- change branches
- stage files

You may inspect files, search the codebase, read tests and documentation, and run non-mutating analysis when appropriate.

The final output is the review, not a modified codebase.
