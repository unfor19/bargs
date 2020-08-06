#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo -e \
"Name:~$person_name\n"\
"Age:~$age\n"\
"Gender:~$gender\n"\
"Location:~$location\n"\
"Favorite food:~$favorite_food\n"\
"Secret:~$secret\n"\
"Password:~$password\n"\
"OS Language:~$language\n"\
"I'm happy:~$happy\n"\
"CI Process:~$CI\n"\
"Uppercased var names:~$PERSON_NAME, $AGE years old, from $LOCATION" | column -t -s "~"
