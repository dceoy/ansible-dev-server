#!/usr/bin/env bash
#
# https://github.com/dceoy/ansible-dev/blob/master/roles/python/files/install_pyenv.sh

set -uex

PYENV_DIR="${HOME}/.pyenv"
PYENV="${PYENV_DIR}/bin/pyenv"
PY_MAJOR_VER=3
ONLY_PRINT=0
while [[ ${#} -ge 1 ]]; do
  case "${1}" in
    '--only-print' )
      ONLY_PRINT=1 && shift 1
      ;;
    -* )
      echo "invalid option: ${1}" >&2
      exit 1
      ;;
    * )
      PY_MAJOR_VER="${1}" && shift 1
      ;;
  esac
done

if [[ -d "${PYENV_DIR}" ]]; then
  cd "${PYENV_DIR}" && git pull && cd -
else
  git clone https://github.com/yyuu/pyenv.git "${PYENV_DIR}"
fi

PY_LATEST_VER=$(
  ${PYENV} install --list \
    | awk "\$1 ~ /^${PY_MAJOR_VER}[\.\-0-9]+$/ { v=\$1 } END { print v }"
)

if [[ -f "${PYENV_DIR}/versions/${PY_LATEST_VER}/bin/python" ]]; then
  :
elif [[ ${ONLY_PRINT} -eq 0 ]]; then
  ${PYENV} install "${PY_LATEST_VER}" && ${PYENV} global "${PY_LATEST_VER}"
else
  echo "${PYENV} install ${PY_LATEST_VER} && ${PYENV} global ${PY_LATEST_VER}"
fi
