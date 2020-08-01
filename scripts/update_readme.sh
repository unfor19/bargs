#!/bin/bash
DOCKER_FOLDER=/app
DOCKER_TAG=unfor19/replacer

update_readme(){
    local replacer_start_value=$1
    local replacer_end_value=$2
    local src_file_path=$3
    local dst_file_path=$4
    docker run --rm -v "${PWD}"/:${DOCKER_FOLDER} \
        "${DOCKER_TAG}" -sf "${DOCKER_FOLDER}/${src_file_path}" -df "${DOCKER_FOLDER}/${dst_file_path}" -sv "${replacer_start_value}" -ev "${replacer_end_value}"
}

usage_file_path=.testresults.log
test_results=$(source tests.sh)
echo -e "\`\`\`\n${test_results}\`\`\`" > "${usage_file_path}"
update_readme "<!-- replacer_start_usage -->" "<!-- replacer_end_usage -->" "${usage_file_path}" "README.md"

bargsvars_file_path=bargs_vars
bargsvars=$(cat ${bargsvars_file_path})
echo -e "\`\`\`\n${bargsvars}\n\`\`\`" > ".${bargsvars_file_path}"
update_readme "<!-- replacer_start_bargsvars -->" "<!-- replacer_end_bargsvars -->" ".${bargsvars_file_path}" "README.md"
