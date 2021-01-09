#!/bin/bash
source "${PWD}"/"$(dirname ${BASH_SOURCE[0]})"/bargs.sh "$@"

echo "
Name:                  ~ $person_name
Age:                   ~ $age
Gender:                ~ $gender
Location:              ~ $location
Favorite food:         ~ $favorite_food
Secret:                ~ $secret
Password:              ~ $password
OS Language:           ~ $language
I am happy:            ~ $happy
CI Process:            ~ $CI
Uppercased var names:  ~ $PERSON_NAME, $AGE years old, from $LOCATION
Username from env var: ~ $username " \
    | column -t -s "~"
