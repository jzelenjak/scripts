#!/bin/bash
# Gets the files with the most changes (in terms of commits) inside a Git repository.
# NB! The script ignores hidden files and directories.
# By default, the search starts from the current directory, but another directory inside the repository can be specified.

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 [source_directory]"


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2; exit 2; }

# Check if the provided directory exists
dir=${1:-.}
[[ -d "$dir" ]] || { echo "unknown directory: $dir" >&2; echo "$usage" >&2; exit 1; }

# Get the most changed files
find "$dir" -path '*/.*' -prune -o -type f -print |  # ignore hidden files and directories
    while read file; do
        echo -n "$file,"
        git log --follow --oneline "$file" 2> /dev/null | wc -l  # report changes made across file renames
    done |
awk -F ',' '$2 != 0 { print $0 }' |  # exclude not changed files
sort -rn -k2,2 |
head -n 5 |
awk 'BEGIN { print "File,Commits"; } { print $0 }' |
column -t -s ','
