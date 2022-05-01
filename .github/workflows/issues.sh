#!/bin/bash

setIssues() {
  local githubToken="$1"
  echo "JJ_ISSUES=$(getIssues "$githubToken")" >> "$GITHUB_ENV"
}

getIssues() {
  local githubToken="$1"
  curl -s -H "Authorization: token $githubToken" "https://api.github.com/repos/CodeVenom/gha-test/issues?state=open"
}

if declare -f "$1" > /dev/null
then
  "$@"
else
  echo "invalid function reference" >&2
  exit 1
fi
