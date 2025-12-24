# Repository Guidelines

## Project Structure & Module Organization

- `provision.yml` is the main playbook that applies OS and tool roles to target hosts.
- `roles/` contains role implementations (e.g., `roles/ubuntu`, `roles/python`, `roles/nodejs`). Each role follows standard Ansible layout: `tasks/`, `handlers/`, `defaults/`, `vars/`, `meta/`.
- `hosts` is the inventory file; `group_vars/` and `host_vars/` hold group/host-specific settings.
- `misc/` holds examples (e.g., `misc/example_hosts`), and `requirements.yml` lists required collections.

## Build, Test, and Development Commands

- `ansible-galaxy collection install -r requirements.yml` installs required collections.
- `cp misc/example_hosts hosts` seeds the inventory; edit `hosts` for your environment.
- `ansible-playbook -K provision.yml` runs the full provisioning flow (prompts for sudo password when needed).
- `ansible-playbook --syntax-check provision.yml` is a quick sanity check before running (optional but recommended).
- `git submodule update --recursive --remote` keeps submodules in sync.

## Coding Style & Naming Conventions

- YAML is the primary format; use 2-space indentation and consistent key ordering within files.
- Role and task names are lowercase and descriptive; keep task `name` fields imperative and specific.
- Variables use `snake_case` and are defined in `group_vars/`, `host_vars/`, or role `defaults/`/`vars/`.

## Testing Guidelines

- There is no automated test suite in this repository.
- Validate changes with `ansible-playbook --syntax-check provision.yml` and, if possible, run on a non-production host first.

## Commit & Pull Request Guidelines

- Commit messages are short, imperative, and capitalized (e.g., "Fix Ansible warnings", "Update packages").
- PRs should describe the target hosts/roles, list any inventory or variable changes, and note how you validated the change.

## Security & Configuration Tips

- The inventory can include secrets (e.g., Slack tokens); keep sensitive values out of Git and prefer vault/encrypted storage.
- `ansible.cfg` references `./.vault_password_file`; keep this file local and untracked.

## Serena MCP Usage (Prioritize When Available)

- **If Serena MCP is available, use it first.** Treat Serena MCP tools as the primary interface over local commands or ad-hoc scripts.
- **Glance at the Serena MCP docs/help before calling a tool** to confirm tool names, required args, and limits.
- **Use the MCP-exposed tools for supported actions** (e.g., reading/writing files, running tasks, fetching data) instead of re-implementing workflows.
- **Never hardcode secrets.** Reference environment variables or the MCP’s configured credential store; avoid printing tokens or sensitive paths.
- **If Serena MCP isn’t enabled or lacks a needed capability, say so and propose a safe fallback.** Mention enabling it via `.mcp.json` when relevant.
- **Be explicit and reproducible.** Name the exact MCP tool and arguments you intend to use in your steps.

## Code Design Principles

Follow Robert C. Martin's SOLID and Clean Code principles:

### SOLID Principles

1. **SRP (Single Responsibility)**: One reason to change per class; separate concerns (e.g., storage vs formatting vs calculation)
2. **OCP (Open/Closed)**: Open for extension, closed for modification; use polymorphism over if/else chains
3. **LSP (Liskov Substitution)**: Subtypes must be substitutable for base types without breaking expectations
4. **ISP (Interface Segregation)**: Many specific interfaces over one general; no forced unused dependencies
5. **DIP (Dependency Inversion)**: Depend on abstractions, not concretions; inject dependencies

### Clean Code Practices

- **Naming**: Intention-revealing, pronounceable, searchable names (`daysSinceLastUpdate` not `d`)
- **Functions**: Small, single-task, verb names, 0-3 args, extract complex logic
- **Classes**: Follow SRP, high cohesion, descriptive names
- **Error Handling**: Exceptions over error codes, no null returns, provide context, try-catch-finally first
- **Testing**: TDD, one assertion/test, FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely), Arrange-Act-Assert pattern
- **Code Organization**: Variables near usage, instance vars at top, public then private functions, conceptual affinity
- **Comments**: Self-documenting code preferred, explain "why" not "what", delete commented code
- **Formatting**: Consistent, vertical separation, 88-char limit, team rules override preferences
- **General**: DRY, KISS, YAGNI, Boy Scout Rule, fail fast

## Development Methodology

Follow Martin Fowler's Refactoring, Kent Beck's Tidy Code, and t_wada's TDD principles:

### Core Philosophy

- **Small, safe changes**: Tiny, reversible, testable modifications
- **Separate concerns**: Never mix features with refactoring
- **Test-driven**: Tests provide safety and drive design
- **Economic**: Only refactor when it aids immediate work

### TDD Cycle

1. **Red** → Write failing test
2. **Green** → Minimum code to pass
3. **Refactor** → Clean without changing behavior
4. **Commit** → Separate commits for features vs refactoring

### Practices

- **Before**: Create TODOs, ensure coverage, identify code smells
- **During**: Test-first, small steps, frequent tests, two hats rule
- **Refactoring**: Extract function/variable, rename, guard clauses, remove dead code, normalize symmetries
- **TDD Strategies**: Fake it, obvious implementation, triangulation

### When to Apply

- Rule of Three (3rd duplication)
- Preparatory (before features)
- Comprehension (as understanding grows)
- Opportunistic (daily improvements)

### Key Rules

- One assertion per test
- Separate refactoring commits
- Delete redundant tests
- Human-readable code first

> "Make the change easy, then make the easy change." - Kent Beck
