#!/bin/bash

# TODO: introduce functions and call em with "$@"
# TODO: use arguments instead of GITHUB_SHA and GITHUB_ENV
# TODO: do not check for tf files if workflow files have been changed, set [] instead

# find workflow and tf file changes
JJ_A=$(git diff "${GITHUB_SHA}^" --name-only)
JJ_B=$(echo "$JJ_A" | grep '.github/workflows' | head -1)
JJ_C=$(echo "$JJ_A" | grep -E '[-a-zA-Z0-9]+\.tf' | sed -E 's%/[-a-zA-Z0-9\.]+%%g' | sort -u | jq -R -s -c 'split("\n")[:-1]')

echo "::set-output name=workflows::$JJ_B"
echo "::set-output name=prefix-list::$JJ_C"
