#!/bin/bash

FAIL_FLAG=0
TEST_RUN_FAILED=0

runTestSuite() {
  local diffListMixed="$(cat git-diff-with-mixed-changes.txt)"
  local diffListTerraform="$(cat git-diff-with-terraform-changes.txt)"
  local diffListWorkflow="$(cat git-diff-with-workflow-changes.txt)"
  local mappingFile="test-mapping.json"
  local realKey="real-key"
  local fakeKey="fake-key"

  echo "test workflow diff detection"
  testCheckForWorkflowChanges ".github/workflows/print-tf-plan.yml" "$diffListMixed"
  testCheckForWorkflowChanges "" "$diffListTerraform"
  testCheckForWorkflowChanges ".github/workflows/path-prefix-aws-role-mapping.json" "$diffListWorkflow"
  echo ""

  echo "test terraform diff detection"
  testCheckForTerraformChanges '["apply/banana/","something/pear/"]' "$diffListMixed"
  testCheckForTerraformChanges '["apply/banana/","apply/kiwi/","something/pear/"]' "$diffListTerraform"
  testCheckForTerraformChanges "[]" "$diffListWorkflow"
  echo ""

  echo "test prepared values"
  testGetApplyMode "auto" "$realKey" "$mappingFile"
  testGetAWSRegion "eu-west-1" "$realKey" "$mappingFile"
  testGetRoleARN "role" "$realKey" "$mappingFile"
  echo ""

  echo "test prepared values with long keys which must be stripped"
  testGetApplyMode "auto" "$realKey/some/path/" "$mappingFile"
  echo ""

  echo "fail testing prepared values"
  fail testGetApplyMode "wrong" "$realKey" "$mappingFile"
  fail testGetAWSRegion "wrong" "$realKey" "$mappingFile"
  fail testGetRoleARN "wrong" "$realKey" "$mappingFile"
  echo ""

  echo "test default values"
  testGetApplyMode "manual" "$fakeKey" "$mappingFile"
  testGetAWSRegion "eu-central-1" "$fakeKey" "$mappingFile"
  testGetRoleARN "none" "$fakeKey" "$mappingFile"
  echo ""

  return $TEST_RUN_FAILED
}

testCheckForWorkflowChanges() {
  local expected="$1"
  local diffList="$2"

  local actual=$(../jj.sh "f1" "$diffList")

  assert_eq "$expected" "$actual" "checkForWorkflowChanges: comparing '$expected' to '$actual'"
}

testCheckForTerraformChanges() {
  local expected="$1"
  local diffList="$2"

  local actual=$(../jj.sh "f2" "$diffList")

  assert_eq "$expected" "$actual" "checkForTerraformChanges: comparing '$expected' to '$actual'"
}

testGetApplyMode() {
  testMapping "$1" "$2" "$3" "getApplyMode"
}

testGetAWSRegion() {
  testMapping "$1" "$2" "$3" "getAWSRegion"
}

testGetRoleARN() {
  testMapping "$1" "$2" "$3" "getRoleARN"
}

testMapping() {
  local expected="$1"
  local prefix="$2"
  local file="$3"
  local getter="$4"

  local actual=$(../me.sh "$getter" "$prefix" "$file")

  assert_eq "$expected" "$actual" "$getter: comparing $expected to $actual"
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local message="$3"

  [ $FAIL_FLAG = 1 ] && message="$3 (negative test)"

  if [[ $FAIL_FLAG != 1 && "$expected" != "$actual" ]] || [[ $FAIL_FLAG = 1 && "$expected" = "$actual" ]]; then
    echo "failed: $message" >&2
    TEST_RUN_FAILED=1
    return 1
  fi

  echo "success: $message" >&2
}

fail() {
  FAIL_FLAG=1
  "$@"
  FAIL_FLAG=0
}

if declare -f "$1" >/dev/null; then
  "$@"
else
  echo "invalid function reference" >&2
  exit 1
fi
