# ansible-dev-server

Ansible playbooks for development servers

[![CI/CD](https://github.com/dceoy/ansible-dev-server/actions/workflows/ci.yml/badge.svg)](https://github.com/dceoy/ansible-dev-server/actions/workflows/ci.yml)

## Setup

```sh
git clone https://github.com/dceoy/ansible-dev-server.git
cd ansible-dev-server
ansible-galaxy collection install -r requirements.yml
cp misc/example_hosts hosts
vim hosts   # => edit
```

## Update

```sh
git pull origin master
```

## Usage

Set up the systems

```sh
ansible-playbook --vault-password-file ./.vault_password_file -K provision.yml
```

## Host vars (Ansible Vault)

- Files in `host_vars/` are encrypted with Ansible Vault.
- Use `ansible-vault view host_vars/<host>.yml` to read and `ansible-vault edit host_vars/<host>.yml` to update.
- For new hosts, run `ansible-vault create host_vars/<host>.yml` (or `ansible-vault encrypt` on an existing file).
- Pass the local `.vault_password_file` explicitly when running against encrypted host vars; keep it untracked.

## Package installation policy

Only the current stable Ubuntu (26.10), Fedora (44), and CentOS Stream (10)
releases are supported. Older Linux releases do not have compatibility paths.

On Linux, APT/DNF provides CLI tools available in the distribution repository.
CentOS enables EPEL before installing system packages. Go, npm, and uv manage
only the remaining tools, with no fallback installation for missing system
packages. Ubuntu's APT `yq` is not Mike Farah's Go implementation, so Ubuntu
continues to install the Go-based `yq` separately.

On macOS, Homebrew takes precedence over language-specific package managers.
SQLFluff is installed via Homebrew on macOS, APT on Ubuntu, and uv on Fedora/CentOS.
Oxfmt is installed through npm to retain its Prettier-backed HTML formatter.
The Vim role uses the same source-build installer on all operating systems,
including macOS, regardless of whether a system Vim is also installed.

Already installed duplicate binaries are not automatically uninstalled; review
`npm ls -g --depth=0`, `uv tool list`, and `~/.go/bin` before removing them.
