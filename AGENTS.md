# AGENTS.md

This file provides guidance to coding agents when working with this repository.

## Overview

This is an Ansible playbook repository for provisioning development servers with modern tooling. It supports multiple platforms (Fedora, CentOS, Ubuntu, macOS) and has been modernized to follow Ansible 2.12+ best practices with FQCN (Fully Qualified Collection Names), proper collection dependencies, and production-ready linting configuration.

## Key Commands

### Initial Setup

```bash
# Clone with submodules (required)
git clone --recurse-submodules https://github.com/dceoy/ansible-dev-server.git
cd ansible-dev-server

# Update submodules
git submodule update --recursive --remote

# Install required Ansible collections (MUST do this before running playbooks)
ansible-galaxy collection install -r requirements.yml

# Copy and configure inventory
cp misc/example_hosts hosts
vim hosts  # Edit to configure your target hosts
```

### Running Playbooks

```bash
# Full provisioning (recommended entry point)
ansible-playbook -K provision.yml

# Orchestrated deployment with validation
ansible-playbook site.yml

# Deploy Dropbox (separate playbook)
ansible-playbook deploy_dropbox.yml

# Run specific roles using tags
ansible-playbook provision.yml --tags "python,nodejs"
ansible-playbook provision.yml --tags "languages"
ansible-playbook provision.yml --tags "tools,cli"
```

### Testing and Linting

```bash
# Lint all playbooks and roles
ansible-lint

# Run molecule tests (requires Docker)
cd roles/python
molecule test
molecule converge  # Run without destroying
molecule verify    # Run verification only
```

### Vault Management

```bash
# Create encrypted vault file
cp group_vars/vault.yml.example group_vars/vault.yml
vim group_vars/vault.yml  # Add sensitive values
ansible-vault encrypt group_vars/vault.yml

# Edit vault file
ansible-vault edit group_vars/vault.yml

# View vault file
ansible-vault view group_vars/vault.yml
```

## Architecture

### Inventory Structure

The repository uses a group-based inventory system with four primary host groups:

- **priv_cpu**: Hosts with root privileges, CPU-only workloads (Docker installed)
- **priv_gpu**: Hosts with root privileges, GPU workloads (NVIDIA drivers + Docker)
- **no_priv_cpu**: Hosts without root privileges, CPU-only workloads
- **no_priv_gpu**: Hosts without root privileges, GPU workloads

Configuration hierarchy:

- `hosts`: Main inventory file defining host groups
- `group_vars/all.yml`: Variables applied to all hosts
- `group_vars/vault.yml`: Encrypted sensitive variables (slack_token, etc.)
- `host_vars/*.yml`: Host-specific overrides

### Playbook Execution Flow

**provision.yml** (main playbook):

1. **Play 1** (priv_cpu, priv_gpu): OS-specific base configuration
   - Validates Ansible version >= 2.12
   - Applies OS-specific roles (fedora/centos/ubuntu) based on distribution

2. **Play 2** (priv_cpu): Container setup for CPU hosts
   - Installs Docker (via submodule role)
   - Configures docker_users

3. **Play 3** (priv_gpu): GPU environment setup
   - Installs NVIDIA drivers and CUDA
   - Installs Docker with nvidia-docker support

4. **Play 4** (all groups): Development tool installation
   - Applies to all host groups
   - Conditional become based on platform (no sudo on macOS)
   - Installs: cli tools, vim, python, nodejs, ruby, go, R

**site.yml**: Orchestration wrapper that imports provision.yml with pre/post validation tasks

### Role Organization

Roles are split into three categories:

**OS Base Roles** (require root):

- `fedora`, `centos`, `ubuntu`: System package management and base configuration
- `macos`: macOS-specific setup (Homebrew, system preferences)
- `nvidia`: NVIDIA drivers and CUDA toolkit for GPU workloads

**Development Tool Roles**:

- `cli`: Git config, oh-my-zsh, custom theme, shell configuration
- `vim`: Vim with Vundle plugin manager and custom config
- `python`: pyenv-based Python version management, pip packages
- `nodejs`: npm global packages
- `ruby`: Ruby development environment
- `go`: Go language toolchain
- `r`: R statistical computing environment
- `ollama`: Local LLM runtime (optional)

**Infrastructure Roles** (in submodules):

- `submodules/ansible-container-engine/roles/docker`: Docker CE installation
- `submodules/ansible-dropbox/roles/dropbox`: Dropbox client deployment

### Key Role Patterns

**Python Role** (`roles/python`):

- Uses custom `install_pyenv.sh` script to fetch and install latest stable Python versions
- Installs multiple Python versions via pyenv
- Base requirements from `roles/python/files/requirements.txt`
- Optional pip_packages from inventory variables
- Sets global Python version to latest installed

**CLI Role** (`roles/cli`):

- Configures git with user info from `group_vars/all.yml`
- Installs oh-my-zsh with custom theme (`files/dceoy.zsh-theme`)
- Manages proxy settings in ~/.zprofile and git config
- Sets up shell aliases and color configuration

### Variable Precedence

Environment variables are consistently applied via playbook-level `environment:` blocks:

```yaml
environment:
  http_proxy: "{{ http_proxy | default('') }}"
  https_proxy: "{{ https_proxy | default('') }}"
  no_proxy: "{{ no_proxy | default('') }}"
```

Sensitive variables (slack_token) should be stored in encrypted `group_vars/vault.yml`.

### Submodules

Two Git submodules provide reusable roles:

- `submodules/ansible-container-engine`: Docker installation
- `submodules/ansible-dropbox`: Dropbox client deployment

Always update submodules before running: `git submodule update --recursive --remote`

## Modernization Features

This playbook has been modernized (see MODERNIZATION.md for details):

- **FQCN Usage**: All modules use fully qualified names (ansible.builtin._, community.general._, etc.)
- **Modern Syntax**: Uses `loop` instead of `with_items`, proper `changed_when`/`failed_when` conditions
- **Performance**: Enabled pipelining, fact caching, and parallel execution (20 forks, strategy=free)
- **Linting**: Production-profile ansible-lint configuration with FQCN enforcement
- **Collections**: Explicit collection dependencies in requirements.yml
- **Security**: Vault-based sensitive data management, no exposed credentials

## Configuration Files

- **ansible.cfg**: Performance optimizations, YAML output, SSH connection pooling
- **.ansible-lint**: Production profile with strict FQCN enforcement, excludes submodules/tests
- **requirements.yml**: Declares collection dependencies (must install before running)
- **.vault_password_file**: Vault password file path (not tracked in git)

## Tags

All roles are tagged for selective execution:

- OS tags: `os`, `fedora`, `centos`, `ubuntu`, `macos`
- Tool tags: `tools`, `cli`, `vim`, `editor`
- Language tags: `languages`, `python`, `nodejs`, `ruby`, `go`, `r`
- Infrastructure tags: `containers`, `docker`, `gpu`, `nvidia`, `dropbox`
- Validation tags: `validation`

Example: `ansible-playbook provision.yml --tags "python,nodejs"` installs only Python and Node.js.

## Important Notes

- Requires Ansible 2.12 or newer (validated in pre_tasks)
- Python 3.8+ recommended
- Must install collections before first run: `ansible-galaxy collection install -r requirements.yml`
- Vault password file must exist at `.vault_password_file` if using encrypted variables
- Submodules must be initialized: `git clone --recurse-submodules` or `git submodule update --init --recursive`
- macOS hosts automatically disable `become` (no sudo required)
- Slack notifications require `slack_token` in vault.yml (optional feature)

## File Locations Reference

When working with roles:

- Role tasks: `roles/{role_name}/tasks/main.yml`
- Role handlers: `roles/{role_name}/handlers/main.yml`
- Role defaults: `roles/{role_name}/defaults/main.yml`
- Role files: `roles/{role_name}/files/`
- Role templates: `roles/{role_name}/templates/`
- Role metadata: `roles/{role_name}/meta/main.yml`
- Molecule tests: `roles/{role_name}/molecule/default/` (only python role has tests currently)

## Serena MCP Usage (Prioritize When Available)

- **If Serena MCP is available, use it first.** Treat Serena MCP tools as the primary interface over local commands or ad-hoc scripts.
- **Glance at the Serena MCP docs/help before calling a tool** to confirm tool names, required args, and limits.
- **Use the MCP-exposed tools for supported actions** (e.g., reading/writing files, running tasks, fetching data) instead of re-implementing workflows.
- **Never hardcode secrets.** Reference environment variables or the MCP’s configured credential store; avoid printing tokens or sensitive paths.
- **If Serena MCP isn’t enabled or lacks a needed capability, say so and propose a safe fallback.** Mention enabling it via `.mcp.json` when relevant.
- **Be explicit and reproducible.** Name the exact MCP tool and arguments you intend to use in your steps.

## Web Search Instructions

For tasks requiring web search, always use Gemini CLI (`gemini` command) instead of the built-in web search tools.
Gemini CLI is an AI workflow tool that provides reliable web search capabilities.

### Usage

```sh
# Basic search query
gemini --sandbox --prompt "WebSearch: <query>"

# Example: Search for latest news
gemini --sandbox --prompt "WebSearch: What are the latest developments in AI?"
```

### Policy

When users request information that requires web search:

1. Use `gemini --sandbox --prompt` command via terminal
2. Parse and present the Gemini response appropriately

This ensures consistent and reliable web search results through the Gemini API.

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
