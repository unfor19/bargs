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

# Any push
[[ -z $GITHUB_SHA ]] && export GITHUB_SHA=$(git rev-parse HEAD)
SHORT_COMMIT="SHORT_COMMIT=${GITHUB_SHA:0:8}"
COMMIT="COMMIT=${GITHUB_SHA}"
echo -e "${COMMIT}\n${SHORT_COMMIT}" > "${DIST_DIR}/version"

# Release
GITHUB_REF=$(echo "${GITHUB_REF}" | grep 'refs\/tags\/v')
version=$(echo "${GITHUB_REF}" | sed "s|refs\/tags\/v||g")
if [[ -n "$version" ]]; then
    echo -e "VERSION=${version}" >> "${DIST_DIR}/version"
    mkdir -p "${DIST_DIR}/${version}"
    find "${DIST_DIR}" -maxdepth 1 -type f \
        -exec cp {} "${DIST_DIR}/${version}" \;
fi

echo "[LOG] Finished building, artifacts in - ${DIST_DIR}"
