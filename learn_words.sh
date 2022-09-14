#!/bin/bash
# Gets a word + translation from a random permutation of a.csv file and creates a notification with the word and its translation.
# This script can be used as a background process to help with learning a foreign language.
# When --active-recall option is specified, the translation is displayed first, and after the popup is closed, the answer is displayed.

# Checks if the file with the words has been specified
if [[ $# -eq 0 || ! -f $1 ]]; then
    echo "$0: could not find the file with the words"
    exit 2
fi

# Gets the interval in minutes (default: 10 minutes)
interval=600
if [[ -n $2 ]]; then
    interval=$(($2 * 60))
fi

# Check if the active recall mode is on
if [[ "$3" = "--active-recall" ]]; then
    recall=1
fi

# Start the infinite loop until the process is not interrupted or killed
echo "You will get a new word every $((interval / 60)) $(test $interval -eq 60 && echo minute || echo minutes)"

while [[ "Jegor" != "smart" ]]; do
    while read pair; do
        IFS=',' read word translation <<< $pair

        if [[ "$word" == \#* ]]; then
            continue
        fi

        if [[ $recall ]]; then
            notify-send -w -i accessories-dictionary-symbolic -u critical "How do you say" "$translation"  # critical urgency is to make sure that the popup does not disappear
            notify-send -w -i accessories-dictionary-symbolic -u critical "Answer" "$word"                 # if `accessories-dictionaries-symbolic` is not found, remove this option
        else
            notify-send -w -i accessories-dictionary-symbolic -u critical "$word" "$translation"
        fi

        sleep $interval
    done < <(shuf --random-source="/dev/urandom" $1)
done
