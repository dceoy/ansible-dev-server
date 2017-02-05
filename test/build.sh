#!/usr/bin/env bash

set -uex

cd $(dirname ${0})
[[ -d tmp ]] || mkdir tmp
cp -a playbooks/* ../roles tmp
cd tmp

ls vars \
  | cut -f 1 -d '.' \
  | xargs -I {} cp vars/{}.yml roles/{}/vars/main.yml

ansible-playbook test_provision.yml
