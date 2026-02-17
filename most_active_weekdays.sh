#!/bin/bash
# Shows the most active days of the week based on the number of commits.

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }


# Get the most active days of the week
git log --pretty=format:%aD |
    cut -d, -f1 |
    sort |
    uniq -c |
    sort -rn -k1,1 |
    awk 'BEGIN { print "Weekday,Commits"; } { print $2 "," $1 }' |
    column -t -s ','
