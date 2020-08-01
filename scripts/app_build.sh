#!/bin/bash
PROJECT_DIR="${PWD}"
DIST_DIR="${PROJECT_DIR}/dist"
echo "[LOG] Building"
[[ -d "${DIST_DIR}" ]] && rm -r "${DIST_DIR}"
mkdir "${DIST_DIR}"

echo "[LOG] Copying files to ${DIST_DIR}"
find "${PROJECT_DIR}" -maxdepth 1 -type f \
    -iname "*.sh" -exec cp {} ${DIST_DIR} \;
cp bargs_vars ${DIST_DIR}/

[[ -z $GITHUB_SHA ]] && export GITHUB_SHA=$(git rev-parse HEAD)
SHORT_COMMIT="${GITHUB_SHA:0:8}"
echo "${SHORT_COMMIT}" > "${DIST_DIR}/version"

echo "[LOG] Finished building, artifacts in - ${DIST_DIR}"
