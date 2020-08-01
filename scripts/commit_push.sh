#!/bin/bash
git config --global user.email "githubactions@meirg.co.il"
git config --global user.name "githubactions"    

diff=$(git diff)
if [[ -n "${diff}" ]]; then
    git add README.md
    git commit -m "Updated by pipeline"
    git push
else
    echo "Nothing to commit"
fi
