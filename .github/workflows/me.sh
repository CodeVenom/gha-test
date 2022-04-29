#!/bin/bash

extractMappedValues() {
  echo "JJ_REGION=$(getAWSRegion "$1" "$2")" >> "$GITHUB_ENV"
  echo "JJ_ROLE=$(getRoleARN "$1" "$2")" >> "$GITHUB_ENV"
}

getAWSRegion() {
  # TODO: add guard
  PREFIX=$(stripPath "$1")
  jq -r --arg PREFIX "$PREFIX" '.[$PREFIX]."aws-region" // "eu-central-1"' "$2"
}

getRoleARN() {
  # TODO: add guard
  PREFIX=$(stripPath "$1")
  jq -r --arg PREFIX "$PREFIX" '.[$PREFIX]."role-arn" // "none"' "$2"
}

stripPath() {
  echo "$1" | sed -E 's%/[-a-zA-Z0-9\.]*%%g'
}

#export JJ_TEMP=$(jq -r '."${{ matrix.tf }}"."aws-region" // "eu-central-1"' .github/workflows/path-prefix-aws-role-mapping.json)
#echo "JJ_REGION=$JJ_TEMP" >> $GITHUB_ENV
#
#export JJ_TEMP=$(jq -r '."${{ matrix.tf }}"."role-arn" // "none"' .github/workflows/path-prefix-aws-role-mapping.json)
#echo "JJ_ROLE=$JJ_TEMP" >> $GITHUB_ENV

if declare -f "$1" > /dev/null
then
  "$@"
else
  echo "invalid function reference" >&2
  exit 1
fi
