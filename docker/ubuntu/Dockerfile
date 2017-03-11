FROM ubuntu

RUN set -e \
      && apt-get -y update \
      && apt-get -y upgrade \
      && apt-get -y install git aptitude sudo ssh libssl-dev python-dev python-pip \
      && apt-get clean

RUN set -e \
      && pip install -U pip \
      && pip install -U ansible

RUN set -e \
      && git clone https://github.com/dceoy/ansible-dev.git \
      && cp -a ansible-dev/docker/playbooks /tmp \
      && cp -a ansible-dev/roles /tmp/playbooks \
      && cd /tmp/playbooks \
      && sed -ie '/docker-engine/d' roles/ubuntu/vars/main.yml \
      && ansible-playbook provision_container.yml

ENTRYPOINT ["/usr/bin/zsh", "-l"]
