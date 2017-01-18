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
      && cd ansible-dev \
      && ansible-playbook -i docker/local_hosts provision_dev.yml

ENTRYPOINT ["/bin/zsh", "-l"]
