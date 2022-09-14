#!/bin/bash
# Sends eye break reminder every X minutes

if [[ "$#" -gt 1 ]]; then
    echo "$0: too many arguments" >&2
    exit 1
elif [ "$#" -eq 1 ]; then
    interval=$((60 * $1))
    echo "I will remind you to take an eye break every $1 minute(s)"
else
    interval=$((60 * 20))
    echo "I will remind you to take an eye break every 20 minutes"
fi

while :; do
    sleep $interval
    notify-send -w -i preferences-system-privacy-symbolic -u critical "Please take an eye break" "Your eyes are not perfect" # critical urgency is to make sure that the popup does not disappear
done
