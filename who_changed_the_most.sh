#!/bin/bash
# Gets the top contributors to a file (in the number of changed lines) inside a git repository

set -euo pipefail
IFS=$'\n\t'

umask 077


# Check if the file path has been specified and it is a valid file
file=${1:-}
[ -z "$file" ] && { echo -e "missing file name\nusage: $0 file_name" >&2; exit 2; }
[ -d "$file" ] && { echo "$file is a directory" ; exit 21; }
! [ -f "$file" ] && { echo "file not found" ; exit 1; }


# Check if the specified file is inside a git repository
git status "$file" &> /dev/null || { echo "$file is not inside a git repository" >&2 ; exit 2; }

# Get the top contributors to the specified file
git blame --line-porcelain "$file" |
    grep "^author " |
    sort |
    uniq -c |
    sed -r "s/ author//" |
    sort -nr -k 1 |
    awk '{ print $2, $1 }'

