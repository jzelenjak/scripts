#!/bin/bash
# Gets the distribution of commits based on the hour of the day
# By default, the output is sorted by the hour of the day (ascending)
# If the option --sorted is specified, the output is sorted by the number of commits (descending)

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 [--sorted]"


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }

# Check if an invalid option is provided
option=${1:-}
if [ -n "$option" ] && [ "$option" != "--sorted" ]; then
    echo "unknown option: $1" >&2
    echo "$usage" >&2
    exit 1
fi

# With `uniq -c`, column 1 is the count and column 2 is the hour
sort_options='-k2,2'
if [ -n "$option" ]; then
    sort_options='-rnsk1,1'
fi

# Get the distribution of commits based on the hour of the day
git log --date=format:'%H' --pretty=format:'%ad' |
    sort |
    uniq -c |
    sort "$sort_options" |
    awk '{ print $2 ":00," $1; }' |
    awk 'BEGIN { print "Hour,Commits"; } { print $0 }' |
    column -t -s ','
