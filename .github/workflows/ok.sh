#!/bin/bash

echo "::set-output name=blub::$(echo "$1" | jq '. | length')"
