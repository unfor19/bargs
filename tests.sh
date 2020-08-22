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

    echo -e "[LOG] Output:\n\n$output_msg\n"

    if [[ $expected == "pass" && $output_code -eq 0 ]]; then
        echo "[LOG] Test passed as expected"
    elif [[ $expected == "fail" && $output_code -eq 1 ]]; then
        echo "[LOG] Test failed as expected"
    else
        error_msg "Test output is not expected, terminating"
    fi
}

# bargs_vars path - pass
export USERNAME=$USER
bargs_vars_path=".testpath/.bargs_vars"
bargs_vars_dir="$(dirname $bargs_vars_path)"
[[ -d "$bargs_vars_dir" ]] && rm -r "$bargs_vars_dir"
mkdir -p "$bargs_vars_dir"
cp bargs_vars "$bargs_vars_path"
sed -i.bak 's~Willy Wonka~Oompa Looma~' "$bargs_vars_path"
export BARGS_VARS_PATH="$bargs_vars_path"
should pass "Bargs Vars Path" "source example.sh -a 33 --gender male -p mypassword"
unset BARGS_VARS_PATH
rm -r "$bargs_vars_dir"

should pass "Help Menu" "source example.sh -h"
should pass "Default Values" "source example.sh -a 99 --gender=male -p mypassword"
should pass "New Values" "source example.sh -a 23 --gender male -l=neverland -n meir -p mypassword"
should pass "Valid Options" "source example.sh -a 23 --gender male -l neverland -n meir -f pizza -p=mypassword"
should pass "Special Characters" "source example.sh -a 99 --gender male -s MxTZf+6K\HaAQlt\JWipe1oVRy -p mypassword"
should pass "Use Flag" "source example.sh -a 23 --gender male --happy -p mypassword -ci"
should fail "Empty Argument" "source example.sh -a 99 --gender -p mypassword"
should fail "Unknown Argument"  "source example.sh -a 99 -u meir -p mypassword"
should fail "Invalid Options" "source example.sh -a 23 --gender male -l neverland -n meir -f notgood -p mypassword"

# bargs_vars path - fail
mv bargs_vars bargs_vars1
should fail "Missing bargs_vars" "source example.sh -h"
mv bargs_vars1 bargs_vars
