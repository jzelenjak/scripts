#!/bin/bash
# Gets a word-translation pair from a random permutation of a.csv file and creates a notification with a translation, so that the user has to recall the word in the target language.
# The lines in the .csv file starting with # are treated as learned words (which the user does not want to revise).
# This script can be used as a background process to help with learning words in a foreign language.
# NB! The file has to be in a .csv format (<word>,<translation>).

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 file [interval_in_minutes]"


# Check if the file with words has been specified
file=${1:-}
[ -z "$file" ] && { echo "missing file name" >&2; echo "$usage" >&2; exit 2; }

# Check if the specified file exists
! [ -f "$file" ] && { echo "file not found" >&2; echo "$usage" >&2; exit 2; }

# Get the interval in minutes (default: 10 minutes)
interval_min=${2:-10}
re='^[0-9]+$'
[[ "$interval_min" =~ $re ]] || { echo "invalid interval: must be an integer" >&2; exit 1; }
[[ "$interval_min" -lt 1 ]] && { echo "invalid interval: must be greater than 0" >&2; exit 2; }
interval=$(( interval_min * 60 ))

# Start an infinite loop until the process is interrupted or killed
echo "You will get a new word every $(( interval / 60 )) $(test "$interval" -eq 60 && echo "minute" || echo "minutes")"

while true; do
    while read pair; do
        IFS=',' read word translation <<< "$pair"

        if [[ "$word" == \#* ]]; then  # exclude the words that have been commented out
            continue
        fi

        notify-send -w -i accessories-dictionary-symbolic -u critical "How do you say" "$translation"  # critical urgency is to make sure that the popup does not disappear
        notify-send -w -i accessories-dictionary-symbolic -u critical "Answer" "$word" # if `accessories-dictionaries-symbolic` is not found, remove this option

        sleep "$interval"
    done < <(shuf --random-source="/dev/urandom" "$file")
done
