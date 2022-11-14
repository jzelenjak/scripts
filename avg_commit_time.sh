#!/bin/bash
# Shows the average commit time (the average time a commit has been made) inside a git repository

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is run in a git repository
git status &> /dev/null || { echo "not a git repository" >&2 ; exit 2; }


# Compute the average time
git log --date=format:'%H %M %S' --pretty=format:%ad |
    awk '
    {
        sum += ($3 + $2 * 60 + $1 * 3600)
        total += 1
    }
    END {
        avg_time_seconds = sum / total
        hours = int(avg_time_seconds / 3600)
        minutes = int(avg_time_seconds % 3600 / 60)
        print "Total commits found:", total
        print "The average time of a commit is " hours ":" minutes
    }
    '

