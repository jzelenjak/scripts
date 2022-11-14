#!/bin/bash
# Shows the most active days of the week based on the number of commits (default: all days)


set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is run in a git repository
git status &> /dev/null || { echo "not a git repository" >&2 ; exit 2; }


# Get the most active days of the week (default: all)
git log --pretty=format:%aD | cut -d, -f1 | sort | uniq -c | sort -rn | awk '{ print $2, $1 }'
