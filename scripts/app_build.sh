#!/bin/bash
PROJECT_DIR="${PWD}"
DIST_DIR="${PROJECT_DIR}/dist"
echo "[LOG] Building"
[[ -d "${DIST_DIR}" ]] && rm -r "${DIST_DIR}"
mkdir "${PROJECT_DIR}/dist"

echo "[LOG] Copying files to ${DIST_DIR}"
find "${PROJECT_DIR}" -maxdepth 1 -type f \
    -iname "*.sh" -exec cp {} ${DIST_DIR} \;
cp bargs_vars ${DIST_DIR}/

[[ -z $GITHUB_SHA ]] && export GITHUB_SHA=$(git rev-parse HEAD)
SHORT_COMMIT="${GITHUB_SHA:0:8}"
mkdir -p "${DIST_DIR}/${SHORT_COMMIT}"
COMMIT_DIR="${PROJECT_DIR}/dist/${SHORT_COMMIT}"

for f in ${DIST_DIR}/*; do
    if [ -f "$f" ]; then
        filename=$(basename ${f})
        target_path="${COMMIT_DIR}/${filename}"
        echo "[LOG] Copying $filename to ${target_path}"
        cp "${f}" "${target_path}"
    fi
done

echo "[LOG] Finished building, artifacts in - ${DIST_DIR}"