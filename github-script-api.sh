#!/bin/bash

###########################################
# Author: Mahesh
# Date: 11th
#
# Version: v1
#
# This script helps users communicate with GitHub REST API
# Usage:
#   ./github_rest_api.sh [GITHUB_TOKEN] [REST_ENDPOINT]
#
# Example:
#   ./github_rest_api.sh ghp_1234abcd /users/umamahesh775/repos
###########################################

if [ $# -lt 2 ]; then
    echo "Usage: $0 [GITHUB_TOKEN] [REST_ENDPOINT]"
    exit 1
fi

GITHUB_TOKEN="$1"
GITHUB_API_REST="$2"
GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

SCRIPT_NAME=$(basename "$0")
TMPFILE=$(mktemp "/tmp/${SCRIPT_NAME}.XXXXXX") || exit 1

function rest_call {
    curl -s "https://api.github.com$1" \
         -H "${GITHUB_API_HEADER_ACCEPT}" \
         -H "Authorization: token ${GITHUB_TOKEN}" >> "$TMPFILE"
}

# Detect pagination by checking 'Link' header
LAST_PAGE=$(curl -sI "https://api.github.com${GITHUB_API_REST}" \
    -H "${GITHUB_API_HEADER_ACCEPT}" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    | grep '^Link:' | sed -n 's/.*[?&]page=\([0-9]\+\)>; rel="last".*/\1/p')

# Check if pagination is used
if [ -z "$LAST_PAGE" ]; then
    # No pagination
    rest_call "${GITHUB_API_REST}"
else
    # Paginated results
    for p in $(seq 1 "$LAST_PAGE"); do
        rest_call "${GITHUB_API_REST}?page=${p}"
    done
fi

cat "$TMPFILE"
rm "$TMPFILE"

