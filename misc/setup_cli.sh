#!/usr/bin/env bash

set -eux

case "${OSTYPE}" in
  darwin* )
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew upgrade
    brew install \
      colordiff corkscrew curl gcc git go grep jq luajit nkf nmap node p7zip \
      pandoc pbzip2 pigz python3 rename ruby shellcheck sqlite sshfs tmux \
      tree wakeonlan watch wget zsh
    brew install vim --with-lua --with-python3
    brew cask install r
    brew cleanup
    ;;
  linux* )
    if sudo -v; then
      if [[ -f '/etc/lsb-release' ]]; then
        sudo apt --version && APT='apt' || APT='apt-get'
        sudo ${APT} -y update
        sudo ${APT} -y dist-upgrade
        sudo ${APT} -y install \
          apt-file build-essential colordiff corkscrew curl git golang \
          jq libffi-dev libssl-dev luajit nkf nmap nodejs p7zip-full pandoc \
          pbzip2 pigz python3.7-dev r-base rename ruby-dev shellcheck \
          software-properties-common sqlite3 ssh sshfs time tmux traceroute \
          tree unzip vim-gnome wakeonlan wget zip zsh \
        sudo ${APT} -y autoremove
        sudo ${APT} clean
        sudo ln -s /usr/bin/python3.7 /usr/bin/python3
      elif [[ -f '/etc/redhat-release' ]];then
        sudo dnf --version && DNF='dnf' || DNF='yum'
        ${DNF} -y upgrade
        ${DNF} -y groupinstall \
          'Development Tools' 'C Development Tools and Libraries'
        ${DNF} -y install \
          colordiff corkscrew curl dnf-plugins-core git go jq kernel-devel \
          ernel-headers luajit-devel nkf nmap nodejs openssh openssl-devel \
          p7zip pandoc pbzip2 pigz python3-devel R-devel ruby-devel \
          ShellCheck sqlite-devel sshfs time tmux traceroute tree \
          vim-enhanced wol wget zsh \
        ${DNF} -y clean all
      fi
    fi
    ;;
esac

curl -SLO https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
rm -f get-pip.py

pip install -U --no-cache-dir --user \
  ansible ansible-lint csvkit docker-compose docopt flake8 flake8-bugbear \
  flake8-isort grip jupyter pandas pep8-naming pip pynvim vim-vint vulture \
  yamllint

grep -e '/zsh$' /etc/shells | tail -1 | xargs -I chsh -s {}
curl -SL \
  https://raw.githubusercontent.com/dceoy/ansible-dev/master/roles/vim/files/install_vim.sh \
  | bash

curl -SL \
  https://raw.githubusercontent.com/dceoy/ansible-dev/master/roles/cli/files/zshrc \
  -o ~/.zshrc
curl -SL \
  https://raw.githubusercontent.com/dceoy/ansible-dev/master/roles/vim/files/vimrc \
  -o ~/.vimrc

vim -c 'try | call dein#update() | finally | qall! | endtry' -N -u ~/.vimrc -U NONE -i NONE -V1 -e -s
