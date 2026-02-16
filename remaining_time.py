#!/usr/bin/env python
# Computes the remaining time until an event.
# Inspired from https://stackoverflow.com/a/54701179
# For the documentation of the datetime library, see https://docs.python.org/3/library/datetime.html

import datetime as dt
import sys

TIME_FORMAT = "%Y-%m-%d %H:%M:%S"  # YYYY-MM-DD HH:MM:SS

if len(sys.argv) == 3:
    EVENT = f"{sys.argv[1]} {sys.argv[2]}"
elif len(sys.argv) == 2:
    EVENT = sys.argv[1]
else:
    print(f"Usage: {sys.argv[0]} \"YYYY-MM-DD HH:MM:SS\"")
    print(f"       {sys.argv[0]} YYYY-MM-DD HH:MM:SS")
    exit(1)

date_end = dt.datetime.strptime(EVENT, TIME_FORMAT)
date_start = dt.datetime.now()
diff = date_end - date_start

if diff.total_seconds() <= 0:
    print("The event has already taken place")
    exit()

days = diff.days
hours = diff.seconds // 3600
minutes = (diff.seconds - hours * 3600) // 60
seconds = diff.seconds - hours * 3600 - minutes * 60

print("Time until the event:", end=" ")
print(days, "day" if days == 1 else "days", end=" ")
print(hours, "hour" if hours == 1 else "hours", end=" ")
print(minutes, "minute" if minutes == 1 else "minutes", end=" ")
print(seconds, "second" if seconds == 1 else "seconds")
