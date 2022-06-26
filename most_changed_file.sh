#!/bin/bash
# Gets the files with the most changes (commits) in a git repository

# Check if the directory to look from has been provided
if [[ $# -eq 0 ]]; then
    echo "$0: source directory not specified"
    exit 2
fi

# Check if the provided directory is valid
if ! [[ -d $1 ]]; then
    echo "$0: source directory not found"
    exit 1
fi

# Check if the provided directory is in a git repository
git status $1 2&> /dev/null
exit_code=$?
if [[ $exit_code -ne 0 ]]; then
    echo "$0: $1 is not in a git repository"
    exit $exit_code
fi

# Check if a limit has been specified
case $2 in
    '') limit=10 ;;
    *[!0-9]*) echo "$0: invalid value for option limit" ; exit 2 ;;
    *) limit=$2 ;;
esac

# Get the most changed files
echo "The most changed files are (file path, #commits):"
find $1 -type f -print |
    while read file; do
        echo -n "$file "
        git log --oneline $file 2> /dev/null | wc -l
    done |
sort -rn -k 2 |
head -$limit

