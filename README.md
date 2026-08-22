# ansible-dev-server

Ansible playbooks for development servers

## Setup

```sh
$ git clone https://github.com/dceoy/ansible-dev-server.git
$ cd ansible-dev-server
$ ansible-galaxy collection install -r requirements.yml
$ cp misc/example_hosts hosts
$ vim hosts   # => edit
```

## Update

```sh
$ git pull origin master
```

## Usage

Set up the systems

```sh
$ ansible-playbook -K provision.yml
```

## Host vars (Ansible Vault)

- Files in `host_vars/` are encrypted with Ansible Vault.
- Use `ansible-vault view host_vars/<host>.yml` to read and `ansible-vault edit host_vars/<host>.yml` to update.
- For new hosts, run `ansible-vault create host_vars/<host>.yml` (or `ansible-vault encrypt` on an existing file).
- `ansible.cfg` points at `./.vault_password_file`; keep it local and untracked.
