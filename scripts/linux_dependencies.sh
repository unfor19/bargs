#!/bin/bash
if [[ $USER == "root" ]]; then
    apt-get update -y && apt-get install -y bsdmainutils
else
    sudo apt-get update -y && sudo apt-get install -y bsdmainutils
fi
