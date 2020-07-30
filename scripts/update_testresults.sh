#!/bin/bash
# Requires perl

error_msg(){
    local msg=$1
    echo -e "[ERROR] $msg"
    export DEBUG=1
    exit 1
}

testresults_filename=".testresults.log"
[[ ! -f "${testresults_filename}" ]] && error_msg "[ERROR] ${testresults_filename} doesn't exist.\n[FIX] bash tests.sh > ${testresults_filename}"
testresults=$(cat "${testresults_filename}")
perl -i  -p0e 's~(?<=testresults_output\n)(.*)(?=```)~'"${testresults}"'\r~gs' README.md