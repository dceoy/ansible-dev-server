#!/usr/bin/env bash

set -uex

cd $(dirname ${0})
[[ -d tmp ]] || mkdir tmp
cp -a playbooks/* ../roles ../dotfiles tmp

cd tmp
ansible-playbook test_provision.yml
