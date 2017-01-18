FROM fedora

RUN set -e \
      && dnf -y upgrade \
      && dnf -y install git sudo ssh libssl-dev python-devel python-pip \
      && dnf clean all

RUN set -e \
      && pip install -U pip \
      && pip install -U ansible

RUN set -e \
      && git clone https://github.com/dceoy/ansible-dev.git \
      && cd ansible-dev \
      && ansible-playbook -i docker/local_hosts provision_dev.yml

ENTRYPOINT ["/bin/zsh", "-l"]
