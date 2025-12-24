#!/usr/bin/env bash
#
# Installer for rbenv and Ruby versions
#
# Usage:
#   ./install_rbenv.sh [--skip-ruby] [--skip-global] [<version_prefix]
#   ./install_rbenv.sh --print-stable-versions [<n_of_versions>]
#   ./install_rbenv.sh --version
#   ./install_rbenv.sh -h|--help
#
# Options:
#   -h, --help                Print this help message and exit
#   --version                 Print the version of this script and exit
#   --skip-ruby               Skip installing Ruby
#   --skip-global             Skip setting the installed version as the global version
#   --print-stable-versions   Print the latest stable Ruby versions and exit
#                             (without installing rbenv)
#
# Arguments:
#   <version_prefix>          Version prefix to install
#   <n_of_versions>           Number of versions to print [default: 10]

set -euo pipefail

if [[ ${#} -ge 1 ]]; then
  for a in "${@}"; do
    [[ "${a}" = '--debug' ]] && set -x && break
  done
fi

COMMAND_PATH=$(realpath "${0}")
COMMAND_NAME=$(basename "${COMMAND_PATH}")
COMMAND_VERSION='v0.1.0'
RBENV_DIR="${HOME}/.rbenv"
RUBY_BUILD_DIR="${RBENV_DIR}/plugins/ruby-build"
RBENV="${RBENV_DIR}/bin/rbenv"
SKIP_RUBY=0
SKIP_GLOBAL=0
PRINT_STABLE_VERSIONS=0
MAIN_ARGS=()

function print_version {
  echo "${COMMAND_NAME}: ${COMMAND_VERSION}"
}

function print_usage {
  sed -ne '1,2d; /^#/!q; s/^#$/# /; s/^# //p;' "${COMMAND_PATH}"
}

function abort {
  {
    if [[ ${#} -eq 0 ]]; then
      cat -
    else
      COMMAND_NAME=$(basename "${COMMAND_PATH}")
      echo "${COMMAND_NAME}: ${*}"
    fi
  } >&2
  exit 1
}

while [[ ${#} -ge 1 ]]; do
  case "${1}" in
    --debug )
      shift 1
      ;;
    --skip-ruby )
      SKIP_RUBY=1 && shift 1
      ;;
    --skip-global )
      SKIP_GLOBAL=1 && shift 1
      ;;
    --print-stable-versions )
      PRINT_STABLE_VERSIONS=1 && shift 1
      ;;
    --version )
      print_version && exit 0
      ;;
    -h | --help )
      print_usage && exit 0
      ;;
    -* )
      abort "invalid option: ${1}"
      ;;
    * )
      MAIN_ARGS+=("${1}") && shift 1
      ;;
  esac
done

if [[ ${PRINT_STABLE_VERSIONS} -eq 1 ]]; then
  [[ -f "${RBENV}" ]] || abort 'rbenv not found'
  AVAILABLE_VERSIONS="$(${RBENV} install --list-all | awk '{print $1}')"
  if [[ ${#MAIN_ARGS[@]} -eq 0 ]]; then
    n_of_versions=10
  else
    n_of_versions="${MAIN_ARGS[0]}"
  fi
  grep -e '^[0-9]\+\.[0-9]\+\.[0-9]\+$' <<< "${AVAILABLE_VERSIONS}" \
    | sort -rV \
    | awk -F. '!seen[$1"."$2]++' \
    | awk '{print $1}' \
    | head -n "${n_of_versions}"
  exit 0
else
  if [[ -d "${RBENV_DIR}" ]]; then
    printf ">>> Update rbenv:\t%s\n" "${RBENV_DIR}"
    wd="${PWD}"
    cd "${RBENV_DIR}" && git pull --prune && cd "${wd}"
    cd "${RUBY_BUILD_DIR}" && git pull --prune && cd "${wd}"
  else
    printf ">>> Install rbenv:\t%s\n" "${RBENV_DIR}"
    git clone https://github.com/rbenv/rbenv.git "${RBENV_DIR}"
    git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}"
  fi
  if [[ ${SKIP_RUBY} -eq 0 ]]; then
    printf ">>> List stable versions:\n"
    AVAILABLE_VERSIONS="$(${RBENV} install --list-all | awk '{print $1}')"
    if [[ ${#MAIN_ARGS[@]} -eq 0 ]]; then
      VERSION_CANDIDATES="$(grep -e '^[0-9]\+\.[0-9]\+\.[0-9]\+$' <<< "${AVAILABLE_VERSIONS}")"
    else
      prefix="${MAIN_ARGS[0]}"
      if [[ "${prefix}" =~ ^[0-9]+$ ]]; then
        VERSION_CANDIDATES="$(grep -e "^${prefix}\.[0-9]\+\.[0-9]\+$" <<< "${AVAILABLE_VERSIONS}" || :)"
      elif [[ "${prefix}" =~ ^[0-9]+\.[0-9]+$ ]]; then
        VERSION_CANDIDATES="$(grep -e "^${prefix}\.[0-9]\+$" <<< "${AVAILABLE_VERSIONS}" || :)"
      else
        VERSION_CANDIDATES="$(grep -e "^${prefix}" <<< "${AVAILABLE_VERSIONS}" || :)"
      fi
    fi
    if [[ -z "${VERSION_CANDIDATES}" ]]; then
      abort 'Ruby version not found'
    else
      VERSION_TO_INSTALL="$(sort -rV <<< "${VERSION_CANDIDATES}" | head -n 1)"
    fi
    if [[ -f "${RBENV_DIR}/versions/${VERSION_TO_INSTALL}/bin/ruby" ]]; then
      printf ">>> Ruby version already installed:\t%s\n" "${VERSION_TO_INSTALL}"
    else
      printf ">>> Install Ruby version:\t%s\n" "${VERSION_TO_INSTALL}"
      ${RBENV} install "${VERSION_TO_INSTALL}"
    fi
    if [[ ${SKIP_GLOBAL} -ne 1 ]]; then
      printf ">>> Set the global Ruby version:\t%s\n" "${VERSION_TO_INSTALL}"
      ${RBENV} global "${VERSION_TO_INSTALL}"
    fi
  fi
fi
