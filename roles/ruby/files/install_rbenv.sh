#!/usr/bin/env bash
#
# Usage:
#   ./install_rbenv.sh [<ruby_major_version>]

set -eoux pipefail

RBENV_DIR="${HOME}/.rbenv"
RB_BUILD_DIR="${HOME}/.rbenv/plugins/ruby-build"
RBENV="${RBENV_DIR}/bin/rbenv"
[[ ${#} -ge 1 ]] && RB_MAJOR_VER="${1}" || RB_MAJOR_VER='[0-9]+'

if [[ -d "${RBENV_DIR}" ]]; then
  cd "${RBENV_DIR}" && git pull --prune && cd -
  cd "${RB_BUILD_DIR}" && git pull --prune && cd -
else
  git clone https://github.com/rbenv/rbenv.git "${RBENV_DIR}"
  git clone https://github.com/rbenv/ruby-build.git "${RB_BUILD_DIR}"
fi

RB_LATEST_VER=$(
  ${RBENV} install --list \
    | awk "\$1 ~ /^${RB_MAJOR_VER}[\.\-0-9]*$/ { v=\$1 } END { print v }"
)

if [[ -z "${RB_LATEST_VER}" ]]; then
  echo 'version not found' && exit 1
elif [[ -f "${RBENV_DIR}/versions/${RB_LATEST_VER}/bin/ruby" ]]; then
  :
else
  ${RBENV} install "${RB_LATEST_VER}" && ${RBENV} global "${RB_LATEST_VER}"
fi
