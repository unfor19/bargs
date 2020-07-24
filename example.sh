#!/bin/bash
source bargs.sh "$@"

echo -e \
"Name:~$PERSON_NAME\n"\
"Age:~$AGE\n"\
"Gender:~$GENDER\n"\
"Location:~$LOCATION" | column -t -s "~"
