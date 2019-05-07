#!/usr/bin/env bash
#
# https://github.com/dceoy/ansible-dev/blob/master/roles/python/files/install_pyenv.sh

set -uex

PYENV_DIR="${HOME}/.pyenv"
PYENV="${PYENV_DIR}/bin/pyenv"
[[ ${#} -ge 1 ]] && PY_MAJOR_VER="${1}" || PY_MAJOR_VER=3

if [[ -d "${PYENV_DIR}" ]]; then
  cd "${PYENV_DIR}" && git pull && cd -
else
  git clone https://github.com/yyuu/pyenv.git "${PYENV_DIR}"
fi

PY_LATEST_VER=$(
  ${PYENV} install --list \
    | awk "\$1 ~ /^${PY_MAJOR_VER}[\.\-0-9]*$/ { v=\$1 } END { print v }"
)

if [[ -z "${PY_LATEST_VER}" ]]; then
  echo 'version not found' && exit 1
elif [[ -f "${PYENV_DIR}/versions/${PY_LATEST_VER}/bin/python" ]]; then
  :
else
  ${PYENV} install "${PY_LATEST_VER}" && ${PYENV} global "${PY_LATEST_VER}"
fi
