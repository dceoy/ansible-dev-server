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

On macOS, Homebrew supplies CLI tools already present in the brew package list;
Go, npm, and uv install only tools without a Homebrew equivalent in this setup.
Oxfmt is installed through npm so that its Prettier-backed HTML formatter works.
The Vim role uses Homebrew Vim on macOS and builds Vim only on Linux.
Previously installed duplicates are not automatically removed: review
`npm ls -g --depth=0`, `uv tool list`, and `~/.go/bin` before cleaning up.
