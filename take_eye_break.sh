#!/bin/bash
# Sends an eye break reminder every X minutes.
# By default, the break is every 20 minutes.

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 [interval_in_minutes]"


[ "$#" -gt 1 ] && { echo "too many arguments" >&2;  echo "$usage" >&2; exit 1; }

interval=${1:-20}
re='^[0-9]+$'
[[ "$interval" =~ $re ]] || { echo "invalid interval: must be an integer" >&2; exit 1; }
[[ "$interval" -lt 1 ]] && { echo "invalid interval: must be greater than 0" >&2; exit 1; }

echo "I will remind you to take an eye break every $interval $(test "$interval" -eq 1 && echo "minute" || echo "minutes")"

interval=$(( interval * 60 ))
while :; do
    sleep "$interval"
    notify-send -w -i preferences-system-privacy-symbolic -u critical "Please take an eye break" "Your eyes need some rest" # critical urgency is to make sure that the popup does not disappear
done
