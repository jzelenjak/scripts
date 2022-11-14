#!/bin/bash
# Shows the most active days based on the number of commits

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is run in a git repository
git status &> /dev/null || { echo "not a git repository" >&2 ; exit 2; }


# Get the most active days
git log --pretty=format:%as | sort | uniq -c | sort -nr | awk '{ print $2, $1 }'
