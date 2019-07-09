#!/usr/bin/env bash
#
# Rewind days at the latest commit of Git logs
#
# Usage:
#   git_rewind_days.sh [--debug] [--dry-run] <int>
#   git_rewind_days.sh --version
#   git_rewind_days.sh -h|--help
#
# Options:
#   --debug           Debug mode
#   --dry-run         Execute a drt run
#   --version         Print version
#   -h, --help        Print usage
#
# Arguments:
#   <int>             Days to rewind


set -eu

if [[ ${#} -ge 1 ]]; then
  for a in "${@}"; do
    [[ "${a}" = '--debug' ]] && set -x && break
  done
fi

COMMAND_PATH=$(realpath "${0}")
COMMAND_NAME=$(basename "${COMMAND_PATH}")
COMMAND_VERSION='v0.1.0'
DRY_RUN=0
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
    '--debug' )
      shift 1
      ;;
    '--dry-run' )
      DRY_RUN=1 && shift 1
      ;;
    '--version' )
      print_version && exit 0
      ;;
    '-h' | '--help' )
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

if [[ ${#MAIN_ARGS[@]} -eq 1 ]]; then
  DAYS_TO_REWIND="${MAIN_ARGS[0]}"
  printf "DAYS_TO_REWIND:\t%d\n" "${DAYS_TO_REWIND}"
elif [[ ${#MAIN_ARGS[@]} -eq 0 ]]; then
  abort 'missing argument'
else
  abort 'too many arguments'
fi

COMMIT_DATE=$(git log -1 | sed -ne 's/^Date: \+//p')
REWIDED_DATE=$(date -d "${COMMIT_DATE% *} - ${DAYS_TO_REWIND} days" | awk '{print $1" "$2" "$3" "$4" "$6}')" ${COMMIT_DATE##* }"

if [[ ${DRY_RUN} -eq 0 ]]; then
  git rebase HEAD^
  git commit --amend --no-edit --date "${REWIDED_DATE}"
  git rebase HEAD^ --committer-date-is-author-date
else
  echo 'git rebase HEAD^'
  echo "git commit --amend --no-edit --date ${REWIDED_DATE}"
  echo 'git rebase HEAD^ --committer-date-is-author-date'
fi
