#!/usr/bin/env bash
#
# https://github.com/dceoy/ansible-dev/blob/master/roles/vim/files/install_vim.sh

set -uex

VIM_DIR="${HOME}/.vim"
VIM_SRC_DIR="${VIM_DIR}/src"
VIM_SRC_VIM_DIR="${VIM_SRC_DIR}/vim"
case "${OSTYPE}" in
  darwin*)
    ADD_OPT_ARGS='--with-lua-prefix=/usr/local'
    ;;
  linux*)
    ADD_OPT_ARGS=''
    ;;
esac

[[ -d "${VIM_SRC_DIR}" ]] || mkdir -p "${VIM_SRC_DIR}"

if [[ -d "${VIM_SRC_VIM_DIR}" ]]; then
  cd "${VIM_SRC_VIM_DIR}" && git pull --prune && cd -
else
  git clone https://github.com/vim/vim.git "${VIM_SRC_VIM_DIR}"
fi

cd "${VIM_SRC_VIM_DIR}"
set +e
./configure \
  --prefix="${VIM_DIR}" \
  --enable-luainterp \
  "${ADD_OPT_ARGS}" \
  --with-features=huge \
  --with-luajit \
  --enable-python3interp \
  --enable-largefile \
  --disable-netbeans \
  --enable-fail-if-missing \
  --enable-cscope \
  || make distclean
EXIT_CONFIGURE=${PIPESTATUS[0]}

if [[ ${EXIT_CONFIGURE} -eq 0 ]]; then
  make && make install
  cd -
else
  exit "${EXIT_CONFIGURE}"
fi
