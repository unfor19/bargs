#!/bin/bash
error_msg(){
    local msg=$1
    echo -e "[ERROR] $msg"
    exit
}

should(){
    local expected=$1
    local test_name=$2
    local expr=$3
    echo "-------------------------------------------------------"
    echo "[LOG] $test_name - Should $expected"
    echo "[LOG] Executing: $expr"
    output_msg=$(trap '$expr' EXIT)
    output_code=$?

    echo -e "[LOG] Output: \n\n$output_msg\n"

    if [[ $expected == "pass" && $output_code -eq 0 ]]; then
        echo "[LOG] Test passed as expected"
    elif [[ $expected == "fail" && $output_code -eq 1 ]]; then
        echo "[LOG] Test failed as expected"
    else
        error_msg "Test output is not expected, terminating"
    fi
}

should pass "Default Values" "source example.sh -a 99 --gender male"
should pass "New Values" "source example.sh -a 23 --gender male -l neverland -n meir"
should fail "Empty Argument" "source example.sh -a 99 --gender"
should fail "Unknown Argument"  "source example.sh -a 99 -u meir"
