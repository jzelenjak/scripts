#!/bin/bash
# Sends eye break reminder every X minutes
# By default, the break is every 20 minutes

set -euo pipefail
IFS=$'\n\t'

umask 077


[ "$#" -gt "1" ] && { echo -e "too many arguments\nusage: $0 [interval_in_minutes]" >&2 ; exit 1; }

interval=${1:-20}
[ "$interval" -lt 1 ] && { echo -e "invalid interval\nthe interval has to be greater than 0" >&2; exit 1; }

echo "I will remind you to take an eye break every $interval minute(s)"

while :; do
    sleep "$interval"
    notify-send -w -i preferences-system-privacy-symbolic -u critical "Please take an eye break" "Your eyes are not perfect" # critical urgency is to make sure that the popup does not disappear
done
