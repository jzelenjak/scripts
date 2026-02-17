#!/bin/bash
# Shows the most active days based on the number of commits.

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }


# Get the most active days
git log --pretty=format:%as |
    sort |
    uniq -c |
    sort -nr -k1,1 |
    head -n 25 | 
    awk 'BEGIN { print "Date,Commits"; } { print $2 "," $1 }' |
    column -t -s ','
