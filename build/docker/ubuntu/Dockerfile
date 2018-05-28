FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install git aptitude ssh sudo libffi-dev libssl-dev python3-crypto python3-dev python3-pip \
      && apt-get -y autoremove \
      && apt-get clean

RUN set -e \
      && pip3 install -U pip ansible

RUN set -e \
      && git clone https://github.com/dceoy/ansible-dev.git \
      && cp -a ansible-dev/build/playbooks /tmp \
      && cp -a ansible-dev/roles /tmp/playbooks \
      && cd /tmp/playbooks \
      && ansible-playbook provision_container.yml

ENTRYPOINT ["/usr/bin/zsh", "-lc"]
