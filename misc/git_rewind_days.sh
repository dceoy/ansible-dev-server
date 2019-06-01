#!/usr/bin/env bash
#
# Usage:  ./git_rewind_days.sh <int>

set -eux

DAYS_TO_REWIND="${1}"
COMMIT_DATE=$(git log -1 | sed -ne 's/^Date: \+//p')
REWIDED_DATE=$(date -d "${COMMIT_DATE% *} - ${DAYS_TO_REWIND} days" | awk '{print $1" "$2" "$3" "$4" "$6}')" ${COMMIT_DATE##* }"

git rebase HEAD^
git commit --amend --no-edit --date "${REWIDED_DATE}"
git rebase HEAD^ --committer-date-is-author-date
