#!/usr/bin/env bash

set -uex

VIM_DIR="${HOME}/.vim"
VIM_SRC_DIR="${VIM_DIR}/src"
VIM_SRC_VIM_DIR="${VIM_SRC_DIR}/vim"

[[ -d "${VIM_SRC_DIR}" ]] || mkdir -p ${VIM_SRC_DIR}

if [[ -d "${VIM_SRC_VIM_DIR}" ]]; then
  cd "${VIM_SRC_VIM_DIR}" && git pull && cd -
else
  git clone https://github.com/vim/vim.git ${VIM_SRC_VIM_DIR}
fi

cd ${VIM_SRC_VIM_DIR}
./configure --prefix="${VIM_DIR}" --enable-luainterp
make
make install
cd -
