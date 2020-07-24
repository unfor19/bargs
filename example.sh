#!/bin/bash
source bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret" | column -t -s "~"
