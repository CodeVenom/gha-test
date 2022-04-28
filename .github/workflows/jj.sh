#!/bin/bash

JJ_A=$(git diff "${GITHUB_SHA}^" --name-only)
JJ_B=$(echo "$JJ_A" | grep '.github/workflows')
JJ_C=$(echo "$JJ_A" | grep -E '[-a-zA-Z0-9]+\.tf' | sed -E 's%/[-a-zA-Z0-9\.]+%%g' | sort -u | jq -R -s -c 'split("\n")[:-1]')

echo "$JJ_B"
echo "$JJ_C"
