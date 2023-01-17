#!/bin/bash
# Computes the average uptime of the machine in minutes and hours

set -euo pipefail
IFS=$'\n\t'

umask 077

# Compute the average uptime of the machine in minutes and hours
last |
    grep -v -F "tmux" |
    grep "system boot" |
    grep -v -E "still|running" |
    awk '{ print $NF }' |
    tr -d '()' |
    awk -F: '{ minutes += $1 * 60 + $2 ; count += 1 } END { print minutes / count " minutes" "\n" minutes / count / 60 " hours" }'

