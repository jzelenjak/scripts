#!/bin/bash
# Gets the distribution of commits based on the hour of the day
# By default, the output is sorted by the hour of the day (chronologically)
# If the option --sorted is specified, the output is sorted by the number of commits


set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is run in a git repository
git status &> /dev/null || { echo "not a git repository" >&2 ; exit 2; }


# Check if an invalid option is provided
option=${1:-}
if [ -n "$option" ] && [ "$option" != "--sorted" ]; then
    echo "unknown option: $1" >&2
    echo "usage: $0 [--sorted]" >&2
    exit 1
fi


# Get the distribution of commits based on the hour of the day

# The result has to be sorted based on the number of commits
if [ -n "$option" ]; then
    git log --date=format:'%H' --pretty=format:'%ad' |
        sort |
        uniq -c |
        sort -nrk 1 |
        awk '{ print $2, $1 }'
# The result must not be sorted based on the number of commits
else
    git log --date=format:'%H' --pretty=format:'%ad' |
        sort |
        uniq -c |
        awk '{ print $2, $1 }'
fi
