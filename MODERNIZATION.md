# Ansible Playbook Modernization

This document outlines the modernization changes applied to this Ansible repository to follow current best practices and ensure compatibility with Ansible 2.12+.

## Summary of Changes

### 1. Core Configuration Updates

#### ansible.cfg
- Added performance optimizations (pipelining, fact caching, forking)
- Configured modern callback plugins (YAML output)
- Set up SSH connection optimizations
- Added privilege escalation defaults

#### requirements.yml
- Created to declare collection dependencies
- Includes: ansible.builtin, ansible.posix, community.general, community.docker

#### .ansible-lint
- Added production-profile linting configuration
- Configured FQCN enforcement
- Set up proper exclusions for submodules and tests

### 2. Playbook Modernization

#### provision.yml
- Added gather_facts and become directives explicitly
- Replaced `var if var is defined else ''` with `var | default('')`
- Added pre_tasks for Ansible version validation
- Added tags to all roles for selective execution
- Added post_tasks for completion notification
- Set conditional become for macOS compatibility

#### deploy_dropbox.yml
- Added platform validation pre_task
- Modernized variable defaults
- Added proper tags

#### site.yml (new)
- Created orchestration playbook
- Includes validation tasks
- Provides single entry point for deployments

### 3. Security Improvements

- Moved sensitive variables from hosts file to group_vars structure
- Created vault.yml.example for sensitive data template
- Updated .gitignore to protect sensitive files
- Removed exposed Slack token from version control

### 4. Role Structure Updates

#### All Roles
- Added meta/main.yml with galaxy_info for all roles
- Created defaults/main.yml directories
- Standardized role metadata

#### Task Modernization (all roles)
- Replaced `with_items` with `loop`
- Added FQCN to all module calls:
  - `ansible.builtin.*` for built-in modules
  - `community.general.*` for community modules
  - `ansible.posix.*` for POSIX modules
- Replaced `ignore_errors: true` with `failed_when: false`
- Added proper `changed_when` conditions for shell tasks
- Simplified multi-line when conditions

### 5. Testing Infrastructure

#### Molecule Tests
- Created example molecule test for python role
- Includes multi-platform testing (Ubuntu, Fedora)
- Added converge and verify playbooks
- Configured for Docker driver

### 6. Module Updates

Key module replacements with FQCN:
- `apt` → `ansible.builtin.apt`
- `yum` → `ansible.builtin.yum`
- `dnf` → `ansible.builtin.dnf`
- `package` → `ansible.builtin.package`
- `pip` → `ansible.builtin.pip`
- `git` → `ansible.builtin.git`
- `file` → `ansible.builtin.file`
- `copy` → `ansible.builtin.copy`
- `template` → `ansible.builtin.template`
- `shell` → `ansible.builtin.shell`
- `command` → `ansible.builtin.command`
- `npm` → `community.general.npm`
- `mount` → `ansible.posix.mount`

## Benefits of Modernization

1. **Future Compatibility**: Ready for Ansible 2.12+ and future versions
2. **Explicit Module Sources**: FQCN usage prevents ambiguity
3. **Better Performance**: Fact caching, pipelining, and parallel execution
4. **Enhanced Security**: Proper vault usage and sensitive data handling
5. **Improved Maintainability**: Consistent structure and modern syntax
6. **Better Error Handling**: Explicit failure conditions
7. **Testing Ready**: Molecule infrastructure for automated testing

## Migration Guide

To use the modernized playbooks:

1. Install required collections:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

2. Set up vault for sensitive data:
   ```bash
   cp group_vars/vault.yml.example group_vars/vault.yml
   # Edit with your values
   ansible-vault encrypt group_vars/vault.yml
   ```

3. Run playbooks as before:
   ```bash
   ansible-playbook provision.yml
   ```

4. Use tags for selective execution:
   ```bash
   ansible-playbook provision.yml --tags "python,nodejs"
   ```

5. Run tests (requires Docker):
   ```bash
   cd roles/python
   molecule test
   ```

## Compatibility Notes

- Requires Ansible 2.12 or newer
- Python 3.8+ recommended
- Collections must be installed before running playbooks
- Vault password file still required for encrypted variables