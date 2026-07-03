# Base Preferences

Universal foundation shared across all workstations. Each machine's `~/.claude/CLAUDE.md`
imports this file with `@CLAUDE.base.md` and then adds its own machine-specific sections
(work trackers, infrastructure conventions, shell/OS, local MCP servers) below the import.

## Environment
- All projects live under ~/dev/
- Package manager: uv (NEVER use pip or pip install)
- Python version management: pyenv

## Code
- MUST read relevant code before proposing changes
- MUST plan before executing non-trivial tasks (use plan mode)
- Keep changes focused and minimal — solve the current problem
- When uncertain, ask rather than guess
- NEVER over-engineer or add features beyond what was requested
- NEVER create or modify README.md unless explicitly asked
- NEVER add docstrings or comments to code you didn't change
- Only comment where logic isn't self-evident

## Style Guide
@~/dev/dotfiles/python-styleguide.md

## Writing style
- Prefer plain English in prose and docs. Replace jargon when a plainer word exists: "hydrate" → "fill in / look up", "wire format" → "response shape", "by construction" → "structurally", "fail-open" → "slip through silently", "canonical" → "stable", "primitive" → "feature / fallback", "well-formedness" → "consistency", "obligations" → "what X must do", "BLUF" → drop.
- Keep precise technical terms that carry specific meaning (BM25, kNN, denylist, chunk_id, NLI, OOXML, etc.).

## Testing
- Framework: pytest
- Add tests after implementation is working
- Focus tests on behavior, not implementation details
- Run tests before considering a task complete

## Git

### Branches
- Format: topic-for-change-on-branch

### Commits
- Format: `type(scope): description` — under 50 chars, imperative mood, no body, no Co-Authored-By
- Types: feat, fix, docs, refactor, test, chore

### Pull Requests
- Template: `### Summary` + `### Context` — keep BOTH sections short
- Summary: 1-3 bullets, what changed. No reasoning.
- Context: 1-3 sentences, why. No design walkthrough, no verification steps, no reasoning chains.
- If the PR is trivial (one-line fix, tag bump), Context can be a single sentence or omitted.

## MCP Restrictions
- Treat Notion as read-only — never use Notion write/delete tools

## Knowledge Base (Vault)

A vault-backed knowledge base is the standard way of working: read it at the start of a
session for grounding, update it after substantive work. If a machine has no `~/.vault/`,
these instructions simply no-op.

### Structure
- **Vault location:** `~/.vault/`
- **Templates:** `~/.vault/_templates/` — MUST read and use the matching template when creating new vault notes
- **Folders:** `wiki/` (technical reference: systems, repos, runbooks, decisions, patterns), `notes/` (working notes), `projects/` (multi-file initiatives), `plans/` (index notes pointing to full plans), `investigations/` (incident & debugging writeups), `archive/`

### Plans — two parts
1. `~/.vault/plans/<slug>.md` — short vault index note: title, date, link to plan file, project, 2–3 sentence summary. Use `_templates/plan-index.md`.
2. `~/.claude/plans/<slug>.md` — the full implementation plan: scope, approach, key files, risks.

### Before working
1. Read `~/.vault/INDEX.md` — top-level entry point for the whole vault
2. Pre-load the Core Reference pages listed there for grounding
3. Open only the specific wiki pages the task touches; skip patterns/runbooks unless the task is operational
- Fast path: single-repo task → skip INDEX.md, go straight to `wiki/repos/<repo>.md`
- Operational incident → check `investigations/` before diagnosing

### After substantive work
1. Update or create wiki pages for findings
2. Update `~/.vault/INDEX.md` to reflect new/changed pages
3. Append to `wiki/log.md` (`YYYY-MM-DD | ACTION | page | description`)
4. Lint on demand using the checklist in `~/.vault/schema.md`

### Conventions
- Filenames: lowercase, hyphens (`my-service.md`)
- Links: Obsidian `[[wiki/folder/page-name]]` syntax
- Never include real customer or tenant names — use `<tenant>`, `<slug>`, `<env>`
- Prefer updating existing pages over creating new ones
- Staleness marker: add `*(stale, YYYY-MM-DD)*` if a page is 60+ days old
- Convert relative dates to absolute when writing notes
