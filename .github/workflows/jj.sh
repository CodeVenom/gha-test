#!/bin/bash

prepare() {
  # find workflow and tf file changes
  local JJ_A=$(git diff "${GITHUB_SHA}^" --name-only)
  local JJ_B=$(f1 "$JJ_A")
  # TODO: do not check for tf files if workflow files have been changed, set [] instead
  local JJ_C=$(f2 "$JJ_A")

  echo "::set-output name=workflows::$JJ_B"
  echo "::set-output name=prefix-list::$JJ_C"
}

f1() {
  # TODO: add guard
  echo "$1" | grep '.github/workflows' | head -1
}

f2() {
  # TODO: add guard
  echo "$1" | grep -E '[-a-zA-Z0-9]+\.tf' | sed -E 's/[-a-zA-Z0-9]+\.tf//g' | sort -u | jq -R -s -c 'split("\n")[:-1]'
}

if declare -f "$1" > /dev/null
then
  "$@"
else
  echo "invalid function reference" >&2
  exit 1
fi
