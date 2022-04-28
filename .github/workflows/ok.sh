#!/bin/bash

echo "::set-output name=bla::$(echo "$1" | jq '. | length')"
echo "::set-output name=blub::$(echo "$2" | jq '. | length')"
