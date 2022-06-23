#!/bin/bash
# Shows the average commit time (the average time a commit has been made)

# Check if the script is running inside a git repository
git status 2&> /dev/null
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo "Not a git repository"
    exit $exit_code
fi

# Compute the average time
sum=0
total=0

while read time; do
    read hours minutes seconds <<< $time
    time_seconds=$(expr $seconds + $minutes \* 60 + $hours \* 3600)
    sum=$(($sum + $time_seconds))
    total=$(($total + 1))  # doing it with `wc -l` is better, but i don't want to run the pipeline twice or store the results in a temp file
done <<<$(git log --date=format:'%H %M %S' --pretty=format:%ad)

avg_time_seconds=$(($sum / $total))

hours=$((avg_time_seconds / 3600))
minutes=$((avg_time_seconds % 3600 / 60))

echo "Total commits found: $total"
echo The average time of a commit is $hours:$minutes
