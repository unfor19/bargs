#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret\n"\
"OS Language:~$language\n"\
"Uppercased var names:~$PERSON_NAME, $AGE years old, lives in a $LOCATION" | column -t -s "~"
