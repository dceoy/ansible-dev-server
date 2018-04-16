#!/usr/bin/env bash

set -uex

cd $(dirname ${0})
[[ -d tmp ]] || mkdir tmp
cp -a playbooks/* ../roles tmp
cd tmp

ansible-playbook test_provision.yml
