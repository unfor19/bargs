#!/bin/bash
source bargs.sh "$@"

echo -e \
"Name:~$PERSON_NAME\n"\ # shellcheck disable=SC1091
"Age:~$AGE\n"\ # shellcheck disable=SC1091
"Gender:~$GENDER\n"\ # shellcheck disable=SC1091
"Location:~$LOCATION" | column -t -s "~"
