#!/bin/bash
# Shows the most active days of the week based on the number of commits (default: all days)

# Check if the script is running inside a git repository
git status 2&> /dev/null
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo "Not a git repository"
    exit $exit_code
fi

# Get the most active days of the week (default: all)
echo "Most active days of the week are (#commits, day of the week):"

if [ $1 ]; then
    git log --pretty=format:%aD | cut -d, -f1 | sort | uniq -c | sort -rn | head -$1
else
    git log --pretty=format:%aD | cut -d, -f1 | sort | uniq -c | sort -rn
fi
