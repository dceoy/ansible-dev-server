#!/usr/bin/env bash

set -uex

cd $(dirname ${0})
[[ -d tmp ]] || mkdir tmp
cp -a playbooks/* ../roles tmp
for r in 'arm-debian' 'centos' 'fedora' 'go' 'macos' 'python' 'r' 'ruby' 'ubuntu'; do
  cp tmp/vars.yml tmp/roles/${r}/vars/main.yml
done
cd tmp

ansible-playbook provision.yml
