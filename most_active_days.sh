#!/bin/bash
# Shows the most active days based on the number of commits (default: all days)

# Check if the script is running inside a git repository
git status 2&> /dev/null
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo "Not a git repository"
    exit $exit_code
fi

# Get the most active days (default: all)
echo "Most active days are (#commits, date):"

if [ $1 ]; then
    git log --pretty=format:%as | sort | uniq -c | sort -nr | head -$1
else
    git log --pretty=format:%as | sort | uniq -c | sort -nr
fi
