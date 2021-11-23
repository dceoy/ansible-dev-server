ansible-dev
===========

Ansible playbooks for servers

Setup
-----

```sh
$ git clone --recurse-submodules https://github.com/dceoy/ansible-dev.git
$ cd ansible-dev
$ echo -n 'your_vault_pass' > .vault_password_file
$ cp misc/example_hosts hosts
$ vim hosts   # => edit
```

Update
------

```sh
$ git pull origin master
$ git submodule update --recursive --remote
```

Usage
-----

Set up the systems

```sh
$ ansible-playbook provison.yml
```

Set passwords for sudo

```sh
# password for sudo
$ mkdir group_vars
$ echo 'ansible_become_pass: sudo_pass' > group_vars/all.yml

# encrypt
$ ansible-vault encrypt group_vars/all.yml

# edit
$ ansible-vault edit group_vars/all.yml
```
