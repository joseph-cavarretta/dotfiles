# Global Preferences

## Code Style
- Use type hints for all function signatures and class attributes
- Write self-documenting code; only add comments when logic isn't self-evident
- Prefer descriptive variable and function names over comments
- Use f-strings for string formatting

## Python
- Follow PEP 8 style guidelines
- Use pathlib for file paths instead of os.path
- Prefer list/dict comprehensions when readable
- Define and validate interfaces with Pydantic models
- Use protocols when applicable to enhance dependency injection

## Testing
- Add tests after implementation is working
- Use pytest as the testing framework
- Focus tests on behavior, not implementation details

## Workflow
- Keep changes focused and minimal
- Avoid over-engineering; solve the current problem

## Git Commits
- Use conventional commit format: type(scope): description
- Types: feat, fix, docs, refactor, test, chore
- Keep subject line under 50 characters
- Use imperative mood ("add feature" not "added feature")

## Repository Structure
Root-level files:
- README.md - project documentation
- Dockerfile - container definition
- pyproject.toml - UV dependency management and project metadata
- Makefile - common commands (test, lint, build, run)
- .pre-commit-config.yaml - pre-commit hooks
- pyproject.toml [tool.mypy] - type checking config

Root-level modules:
- models.py - shared Pydantic models
- protocols.py - Protocol definitions for dependency injection
- config.py - Pydantic Settings model with env var overrides

Directory structure:
- libs/ - reusable libraries, functions, and classes
- app/ - application code (entrypoints, routes, services)
- tests/ - test files mirroring source structure
