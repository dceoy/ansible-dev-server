# ansible-dev-server

Ansible playbooks for development servers

## Setup

```sh
$ git clone --recurse-submodules https://github.com/dceoy/ansible-dev-server.git
$ cd ansible-dev-server
$ ansible-galaxy collection install -r requirements.yml
$ cp misc/example_hosts hosts
$ vim hosts   # => edit
```

## Update

```sh
$ git pull origin master
$ git submodule update --recursive --remote
```

## Usage

Set up the systems

```sh
$ ansible-playbook -K provision.yml
```
