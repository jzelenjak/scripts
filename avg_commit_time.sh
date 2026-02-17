#!/bin/bash
# Shows the average commit time (the average time when a commit has been made) inside a Git repository.

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }

# Compute the average time of a commit
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
        printf("Total commits found: %d\n", total)
        printf("Average commit time: %02d:%02d\n", hours, minutes)
    }'

