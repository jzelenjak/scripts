#!/bin/bash
# Gets the top contributors to a file (in the number of changed lines) inside a git repository

# Check if the file path has been specified
if [ -z $1 ]; then
    echo "$0: file name not specified"
    exit 2
fi

# Check if the specified file exists
if ! [ -f $1 ]; then
    if [ -d $1 ]; then
        echo "$0: $1 is a directory"
        exit 21
    else
        echo "$0: file not found"
        exit 1
    fi
fi

# Check if the specified file is inside a git repository
git status $1 2&> /dev/null
exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo "$0: file $1 is not inside a git repository"
    exit $exit_code
fi

# Get the top contributors to the specified file
echo "The file $1 has been changed the most by (#changed lines, contributor):"
git blame --line-porcelain $1 |
    grep "^author " |
    sort |
    uniq -c |
    sed -r "s/ author//" |
    sort -nr -k 1

