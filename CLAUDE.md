# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Ansible project for automating the setup of development servers. It supports:
- Multiple operating systems (Fedora, CentOS, Ubuntu, macOS)
- CPU-only and GPU-enabled (NVIDIA) environments
- Container runtimes (Docker, Kubernetes)
- Multiple programming languages (Python, Node.js, Ruby, Go, R)
- Development tools (vim, CLI utilities, etc.)

## Key Commands

### Running Playbooks
```bash
# Main provisioning playbook
ansible-playbook provision.yml

# Deploy Dropbox separately
ansible-playbook deploy_dropbox.yml

# Target specific hosts
ansible-playbook provision.yml --limit hostname

# Run with specific tags
ansible-playbook provision.yml --tags "python,nodejs"

# Check mode (dry run)
ansible-playbook provision.yml --check
```

### Testing
```bash
# Run the test suite
./tests/build.sh

# Test a specific role locally
ansible-playbook provision.yml --limit localhost --tags role_name
```

### Vault Operations
```bash
# Create vault password file (one-time setup)
echo -n 'your_vault_pass' > .vault_password_file

# Encrypt variables
ansible-vault encrypt group_vars/all.yml

# Edit encrypted variables
ansible-vault edit group_vars/all.yml

# View encrypted variables
ansible-vault view group_vars/all.yml
```

### Repository Management
```bash
# Update submodules
git submodule update --recursive --remote

# Initial clone with submodules
git clone --recurse-submodules https://github.com/dceoy/ansible-dev-server.git
```

## Architecture and Structure

### Inventory Organization
The `hosts` file defines four main host groups:
- `priv_cpu`: Privileged CPU-only servers (includes localhost)
- `priv_gpu`: Privileged GPU-enabled servers  
- `no_priv_cpu`: Non-privileged CPU-only servers
- `no_priv_gpu`: Non-privileged GPU-enabled servers

### Playbook Execution Flow
The main `provision.yml` playbook executes in three phases:

1. **OS Setup (with root)**: Runs OS-specific roles on privileged hosts
2. **Container Setup**: Installs Docker/Kubernetes on privileged hosts
3. **Development Tools**: Installs languages and tools on all hosts

### Role Structure
Each role follows standard Ansible patterns:
```
roles/role_name/
├── tasks/main.yml      # Main tasks
├── handlers/main.yml   # Event handlers (e.g., Slack notifications)
├── vars/main.yml       # Role-specific variables
├── files/             # Static files to copy
└── templates/         # Jinja2 templates
```

### Key Roles and Their Purposes
- **OS roles** (`fedora/`, `centos/`, `ubuntu/`, `macos/`): System-level setup
- **Container roles** (via submodules): Docker and Kubernetes setup
- **Language roles** (`python/`, `nodejs/`, `ruby/`, `go/`, `r/`): Development environments
- **Tool roles** (`cli/`, `vim/`, `nvidia/`, `ollama/`): Development utilities
- **Device role** (`edevice/`): Specific device configurations

### Variable Precedence
1. Host-specific vars in `host_vars/hostname.yml`
2. Group vars in `group_vars/groupname.yml`
3. Global vars in `hosts` under `[all:vars]`
4. Role defaults in `roles/rolename/vars/main.yml`

### Proxy Support
All playbooks respect HTTP/HTTPS proxy environment variables:
- `http_proxy`
- `https_proxy`
- `no_proxy`

### Testing Infrastructure
- Uses Docker containers for isolated testing
- Test script at `tests/build.sh` creates temporary environment
- Wercker CI for automated testing on commits

### Common Patterns
1. All roles support Slack notifications via handlers
2. Package installations use become privileges when needed
3. User-specific configurations use `ansible_user_id` variable
4. Proxy configurations are applied consistently across tools

## Development Workflow

### Adding a New Role
1. Create role structure: `mkdir -p roles/new_role/{tasks,handlers,vars,files,templates}`
2. Define tasks in `roles/new_role/tasks/main.yml`
3. Add to `provision.yml` with appropriate conditions
4. Test locally with: `ansible-playbook provision.yml --limit localhost --tags new_role`

### Modifying Existing Roles
1. Make changes to role files
2. Test with check mode first: `ansible-playbook provision.yml --check --tags role_name`
3. Run the test script: `./tests/build.sh`
4. Apply to specific hosts: `ansible-playbook provision.yml --limit hostname --tags role_name`

### Working with Submodules
The project uses git submodules for:
- `ansible-container-engine`: Docker/Kubernetes setup
- `ansible-dropbox`: Dropbox installation

Update submodules when pulling changes:
```bash
git pull origin master
git submodule update --recursive --remote
```