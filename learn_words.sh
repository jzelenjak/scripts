#!/bin/bash
# Gets a word-translation pair from a random permutation of a.csv file and creates a notification with a translation, so that the user has to guess the word in the target language (in the active recall mode)
# Lines in the .csv file starting with # are treated as learned words (which the user does not want to revise)
# This script can be used as a background process to help with learning a foreign language
# NB! The file has to be in a .csv format (<word>,<translation>)

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 file [interval_in_minutes]"


# Check if the file with words has been specified
file=${1:-}
[ -z "$file" ] && { echo -e "missing file name\n$usage" >&2; exit 2; }

# Check if the specified file exists
! [ -f "$file" ] && { echo -e "file not found\n$usage" >&2; exit 2; }


# Get the interval in minutes (default: 10 minutes)
interval_min=${2:-10}
[ "$interval_min" -lt "1" ] && { echo -e "invalid interval: $interval_min\ninterval must be greater than 0" >&2; exit 2; }
interval=$(( interval_min * 60 ))


# Start the infinite loop until the process is not interrupted or killed
echo "You will get a new word every $(( interval / 60 )) $(test $interval -eq 60 && echo minute || echo minutes)"

while [[ "Jegor" != "smart" ]]; do
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
