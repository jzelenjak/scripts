#!/bin/bash
# Computes the average uptime of the machine in hours and in minutes.

set -euo pipefail
IFS=$'\n\t'

umask 077


last |
    grep -v -F "tmux" |
    grep "system boot" |
    grep -v -E "still|running" |
    awk '{ print $NF }' |
    tr -d '()' |
    awk -F ':' '{ minutes += $1 * 60 + $2 ; count += 1 } END { printf("%0.2f hours\n", minutes / count / 60); printf("%0.2f minutes\n", minutes / count); }'
