ansible-dev
===========

Ansible playbooks for servers

Preparing notification
----------------------

```sh
$ git clone https://github.com/dceoy/ansible-dev.git
$ cd ansible-dev
$ cp example_hosts hosts
$ vim hosts   # => edit
```

Usage
-----

Set up the systems

```sh
$ ansible-playbook -i hosts provison_dev.yml
```

Set up the systems with proxy

```sh
$ ansible-playbook -i hosts provison_dev_proxied.yml
```

Set passwords

```sh
$ echo 'ansible_become_pass: password_of_dev' > group_vars/dev.yml

# encrypt
$ ansible-vault encrypt group_vars/dev.yml

# edit
$ ansible-vault edit group_vars/dev.yml
```
