#!/usr/bin/env bash

set -euox pipefail

VSCODE_EXTENSIONS_JSON="$(dirname "${0}")/vscode_extensions.json"
jq -r .recommendations[] < "${VSCODE_EXTENSIONS_JSON}" \
  | xargs -L1 -t code --install-extension
