#!/usr/bin/env bash

set -uex

pip install jupyter jupyter_contrib_nbextensions jupyterthemes
jupyter contrib nbextension install --user

CWD="$(pwd)"
NBX_DIR="$(jupyter --data-dir)/nbextensions"

if [[ -d "${NBX_DIR}/vim_binding" ]]; then
  cd ${NBX_DIR}/vim_binding
  git pull
  cd ..
else
  [[ -d "${NBX_DIR}" ]] || mkdir -p ${NBX_DIR}
  git clone https://github.com/lambdalisue/jupyter-vim-binding ${NBX_DIR}/vim_binding
fi

jupyter nbextension enable vim_binding/vim_binding
cd ${CWD}

jt --theme oceans16 --toolbar --nbname --vimext
