#!/bin/bash
# Gets the top contributors to a file (in the number of changed lines) inside a Git repository.

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 file_name"


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }

# Check if the file path has been specified and it is a valid file
file=${1:-}
[ -z "$file" ] && { echo "missing file name";  echo "$usage" >&2; exit 2; }
[ -d "$file" ] && { echo "$file is a directory" ; exit 21; }
[ -f "$file" ] || { echo "file not found" ; exit 1; }

# Exit if the file is not tracked
git blame "$file" 1>/dev/null 2>&1 || { echo "File not tracked" >&2 ; exit 0; }

# Get the top contributors to the specified file
git blame --line-porcelain "$file" |
    grep "^author " |
    sed "s/author //" |
    sort |
    uniq -c |
    sort -nr -k 1,1 |
    sed 's/^\s\+//' |
    sed 's/ /,/' |
    awk -F ',' 'BEGIN { print "Author,Lines"; } { print $2 "," $1; }' |
    column -t -s ','
