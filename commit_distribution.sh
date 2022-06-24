#!/bin/bash
# Gets the distribution of commits based on the hour of the day

# Check if the script is running inside a git repository
git st 2&> /dev/null
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo Not a git repository
    exit $exit_code
fi

# Get the distribution of commits based on the hour of the day
echo -n 'Showing the commit distribution (#commits,hour of the day) in a '

# The result has to be sorted based on the number of commits
if [ "$1" = '--sorted' ]; then
    echo 'sorted order:'

    git log --date=format:'%H' --pretty=format:'%ad' |
        sort |
        uniq -c |
        sort -nrk 1
# The result must not be sorted based on the number of commits
else
    echo 'non-sorted order:'

    git log --date=format:'%H' --pretty=format:'%ad' |
        sort |
        uniq -c
fi
