#!/bin/bash
# Gets a random word + translation from a .csv file and creates a notification with the word and its translation
# This script can be used as a background process to help with learning a foreign language
# When --active-recall option is specified, the translation is displayed first, the user has 5 seconds to recall the word, and then the answer is displayed.

# Checks if the file with the words has been specified
if [[ $# -eq 0 || ! -f $1 ]]; then
    echo "$0: could not find the file with the words"
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
echo You will get a new word every $((interval / 60)) $(test $interval -eq 60 && echo minute || echo minutes)

while [[ "Jegor" != "smart" ]]; do
    IFS=',' read word translation <<< $(shuf -n 1 $1)

    if [[ $recall ]]; then
        notify-send "How do you say" "$translation"
        sleep 5
        notify-send "Answer" "$word"
    else
        notify-send "$word" "$translation"
    fi

    sleep $interval
done
