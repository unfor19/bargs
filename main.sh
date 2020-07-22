#!/bin/bash
source bargs.sh "$@"

echo -e "Name:~$person_name\nAge:~$age\nGender:~$gender\nLocation:~$location" | column -t -s "~"
