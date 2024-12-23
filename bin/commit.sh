#!/usr/bin/env bash
# crontab to run this every 5 minutes would look like this:
# */5 * * * * bash <path-to-this-script> <path-to-target-repo> <branch-to-update>

pushd ${1}
BRANCH="${2}"

FILES_CHANGED_OR_TO_ADD=$(git status --porcelain=v1 | wc -l)

if [ "${FILES_CHANGED_OR_TO_ADD}" != "0" ]; then
    echo ${FILES_CHANGED_OR_TO_ADD}
    git add -A .
    git commit -m "Auto update"
    git pull --rebase
    if [ "${?}" != "0" ]; then
        echo "Failed to pull and rebase"
        exit 1
    fi 
    git push origin ${BRANCH}:${BRANCH}
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "Pushed git updates for $(basename ${1}) branch ${BRANCH}"
fi
