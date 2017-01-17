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
