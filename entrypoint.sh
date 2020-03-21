#!/bin/bash

set -eu
set -o pipefail

printf "Found files in workspace:\n"
ls

printf "Looking for urlchecker install...\n"
which urlchecker

COMMAND="urlchecker check "

# branch is optional
if [ ! -z "${INPUT_BRANCH}" ]; then
    COMMAND="${COMMAND} --branch ${INPUT_BRANCH}"
fi

# cleanup is optional (boolean)
if [ ! -z "${INPUT_CLEANUP}" ]; then
    COMMAND="${COMMAND} --cleanup"
fi

# subfolder is optional
if [ ! -z "${INPUT_SUBFOLDER}" ]; then
    COMMAND="${COMMAND} --subfolder ${INPUT_SUBFOLDER}"
fi


# print all defaults to true (unless set to false)
if [ "${INPUT_PRINT_ALL}" == "false" ]; then
    COMMAND="${COMMAND} --no-print"
    echo "Automated PR requested"
fi

# file types are optional
if [ ! -z "${INPUT_FILE_TYPES}" ]; then
    COMMAND="${COMMAND} --file-types ${INPUT_FILE_TYPES}"
fi


# white listed urls are optional
if [ ! -z "${INPUT_WHITE_LISTED_URLS}" ]; then
    COMMAND="${COMMAND} --white-listed-urls ${INPUT_WHITE_LISTED_URLS}"
fi

# white listed patterns are optional
if [ ! -z "${INPUT_WHITE_LISTED_PATTERNS}" ]; then
    COMMAND="${COMMAND} --white-listed-patterns ${INPUT_WHITE_LISTED_PATTERNS}"
fi

# white listed files are optional
if [ ! -z "${INPUT_WHITE_LISTED_FILES}" ]; then
    COMMAND="${COMMAND} --white-listed-files ${INPUT_WHITE_LISTED_FILES}"
fi


# retry count (optional)
if [ ! -z "${INPUT_RETRY_COUNT}" ]; then
    COMMAND="${COMMAND} --retry-count ${INPUT_RETRY_COUNT}"
fi

# timeout (optional)
if [ ! -z "${INPUT_TIMEOUT}" ]; then
    COMMAND="${COMMAND} --timeout ${INPUT_TIMEOUT}"
fi

# git path, if not defined, we assume $PWD
if [ -z "${INPUT_GIT_PATH}" ]; then
    echo "git_path not set, will use present working directory."
    COMMAND="${COMMAND} ."
else
    echo "git_path set, will use for path or clone."
    COMMAND="${COMMAND} ${INPUT_GIT_PATH}" 
fi

echo "${COMMAND}"

if [ "${INPUT_FORCE_PASS}" == "true" ]; then
    echo "Force pass requested."
    ${COMMAND} || true
else
    ${COMMAND}
fi

echo $?
