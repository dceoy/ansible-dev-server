FROM fedora:latest

RUN set -e \
      && dnf -y upgrade \
      && dnf -y install git redhat-rpm-config gcc sudo openssh openssl-devel python-devel python-pip python2-dnf \
      && dnf -y autoremove \
      && dnf clean all

RUN set -e \
      && pip install -U pip ansible

RUN set -e \
      && git clone https://github.com/dceoy/ansible-dev.git \
      && cp -a ansible-dev/build/playbooks /tmp \
      && cp -a ansible-dev/roles /tmp/playbooks \
      && cd /tmp/playbooks \
      && ansible-playbook provision_container.yml

ENTRYPOINT ["/usr/bin/zsh", "-lc"]
