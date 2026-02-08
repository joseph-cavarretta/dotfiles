# Global Preferences

## Environment
- All projects live under ~/dev/
- Package manager: uv (NEVER use pip or pip install)
- Python version management: pyenv
- Containers: Docker / docker compose

## Workflow
- MUST read relevant code before proposing changes
- MUST plan before executing non-trivial tasks (use plan mode)
- Keep changes focused and minimal — solve the current problem
- When uncertain, ask rather than guess
- NEVER over-engineer or add features beyond what was requested

## Code Style (Python)
- Use pathlib for file paths, NEVER os.path
- Define and validate interfaces with Pydantic models
- Use Protocols for dependency injection where applicable

## Infrastructure (Terraform / Kubernetes / Helm)
- Terraform: always run `terraform fmt` and `terraform validate` before considering changes complete
- Terraform: use variables with descriptions and type constraints, NEVER hardcode values
- Kubernetes: prefer declarative manifests, NEVER suggest imperative kubectl commands for production changes
- Helm: follow Helm chart best practices for templates (helpers in _helpers.tpl, values documented in values.yaml)
- MUST NOT include secrets, credentials, or sensitive values in any IaC files

## Testing
- Framework: pytest
- Add tests after implementation is working
- Focus tests on behavior, not implementation details
- Run tests before considering a task complete

## Git Commits
- Format: type(scope): description
- Types: feat, fix, docs, refactor, test, chore
- Subject line under 50 characters, imperative mood
- MUST NOT include Co-Authored-By lines

## Pull Requests
- MUST use the following template when drafting a PR:

```
### Summary

<summary of changes, succinct and direct.>

### Context

<context for why we made the change, and how it solves the issue.>
```

## Documentation
- NEVER create or modify README.md unless explicitly asked
- NEVER add docstrings or comments to code you didn't change
- Only comment where logic isn't self-evident
