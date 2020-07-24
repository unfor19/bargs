#!/bin/bash
[[ $USER == "root" ]] && apt-get update -y && apt-get install -y bsdmainutils \
    || sudo apt-get update -y && sudo apt-get install -y bsdmainutils