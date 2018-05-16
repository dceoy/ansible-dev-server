#!/usr/bin/env bash

set -uex

VIM_DIR="${HOME}/.vim"
VIM_SRC_DIR="${VIM_DIR}/src"
VIM_SRC_VIM_DIR="${VIM_SRC_DIR}/vim"
case "${OSTYPE}" in
  darwin*)
    ADD_OPT_ARGS="--with-lua-prefix=/usr/local"
    ;;
  linux*)
    ADD_OPT_ARGS=''
    ;;
esac
WD="${PWD}"

[[ -d "${VIM_SRC_DIR}" ]] || mkdir -p "${VIM_SRC_DIR}"

if [[ -d "${VIM_SRC_VIM_DIR}" ]]; then
  cd "${VIM_SRC_VIM_DIR}" && git pull
else
  git clone https://github.com/vim/vim.git "${VIM_SRC_VIM_DIR}"
fi

cd "${VIM_SRC_VIM_DIR}"
./configure \
  --prefix="${VIM_DIR}" \
  --enable-luainterp \
  "${ADD_OPT_ARGS}" \
  --with-features=huge \
  --with-luajit \
  --enable-python3interp \
  --enable-rubyinterp \
  --enable-largefile \
  --disable-netbeans \
  --enable-fail-if-missing \
  --enable-cscope
make && make install
cd "${WD}"
