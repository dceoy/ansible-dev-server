#!/usr/bin/env bash

set -uex

cd $(dirname ${0})
cp -a ../roles ../dotfiles .
ansible-playbook test_provision.yml
