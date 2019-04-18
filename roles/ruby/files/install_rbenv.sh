#!/usr/bin/env bash
#
# https://github.com/dceoy/ansible-dev/blob/master/roles/ruby/files/install_rbenv.sh

set -uex

RBENV_DIR="${HOME}/.rbenv"
RB_BUILD_DIR="${HOME}/.rbenv/plugins/ruby-build"
RBENV="${RBENV_DIR}/bin/rbenv"
RB_MAJOR_VER=2
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
      RB_MAJOR_VER="${1}" && shift 1
      ;;
  esac
done

if [[ -d "${RBENV_DIR}" ]]; then
  cd "${RBENV_DIR}" && git pull && cd -
  cd "${RB_BUILD_DIR}" && git pull && cd -
else
  git clone https://github.com/rbenv/rbenv.git "${RBENV_DIR}"
  git clone https://github.com/rbenv/ruby-build.git "${RB_BUILD_DIR}"
fi

RB_LATEST_VER=$(
  ${RBENV} install --list \
    | awk "\$1 ~ /^${RB_MAJOR_VER}[\.\-0-9]+$/ { v=\$1 } END { print v }"
)

if [[ -f "${RBENV_DIR}/versions/${RB_LATEST_VER}/bin/ruby" ]]; then
  :
elif [[ ${ONLY_PRINT} -eq 0 ]]; then
  ${RBENV} install "${RB_LATEST_VER}" && ${RBENV} global "${RB_LATEST_VER}"
else
  echo "${RBENV} install ${RB_LATEST_VER} && ${RBENV} global ${RB_LATEST_VER}"
fi
