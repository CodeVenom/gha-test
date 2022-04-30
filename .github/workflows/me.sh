#!/bin/bash

extractMappedValues() {
  echo "JJ_MODE=$(getApplyMode "$1" "$2")" >> "$GITHUB_ENV"
  echo "JJ_REGION=$(getAWSRegion "$1" "$2")" >> "$GITHUB_ENV"
  echo "JJ_ROLE=$(getRoleARN "$1" "$2")" >> "$GITHUB_ENV"
}

getApplyMode() {
  # TODO: add guard
  local PREFIX=$(stripPath "$1")
  jq -r --arg PREFIX "$PREFIX" '.[$PREFIX]."apply-mode" // "manual"' "$2"
}

getAWSRegion() {
  # TODO: add guard
  local PREFIX=$(stripPath "$1")
  jq -r --arg PREFIX "$PREFIX" '.[$PREFIX]."aws-region" // "eu-central-1"' "$2"
}

getRoleARN() {
  # TODO: add guard
  local PREFIX=$(stripPath "$1")
  jq -r --arg PREFIX "$PREFIX" '.[$PREFIX]."role-arn" // "none"' "$2"
}

stripPath() {
  echo "$1" | sed -E 's%/[-a-zA-Z0-9\.]*%%g'
}

if declare -f "$1" > /dev/null
then
  "$@"
else
  echo "invalid function reference" >&2
  exit 1
fi
