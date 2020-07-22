#!/bin/bash
source bargs.sh "$@"

echo -e "Name:~$person_name\nAge:~$age\nGender:~$gender" | column -t -s "~"
