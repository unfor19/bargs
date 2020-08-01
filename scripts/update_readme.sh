#!/bin/bash
SRC_FILE_PATH=.testresults.log
DST_FILE_PATH=README.md
DOCKER_FOLDER=/app
DOCKER_SRC_PATH="${DOCKER_FOLDER}"/"${SRC_FILE_PATH}"
DOCKER_DST_PATH="${DOCKER_FOLDER}"/"${DST_FILE_PATH}"
DOCKER_TAG=unfor19/replacer

REPLACER_START_VALUE="<!-- replacer_start_usage -->"
REPLACER_END_VALUE="<!-- replacer_end_usage -->"

test_results=$(source tests.sh)

echo -e "\`\`\`\n${test_results}\n\`\`\`" > "${SRC_FILE_PATH}"

docker run --rm -v "${PWD}"/:${DOCKER_FOLDER} \
    "${DOCKER_TAG}" -sf "${DOCKER_SRC_PATH}" -df "${DOCKER_DST_PATH}" -sv "${REPLACER_START_VALUE}" -ev "${REPLACER_END_VALUE}"

