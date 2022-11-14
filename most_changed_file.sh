#!/bin/bash
# Gets the files with the most changes (commits) that are inside a specified directory inside a git repository
# NB! The script ignores hidden files and directories
# By default, the search starts from the current directory

set -euo pipefail
IFS=$'\n\t'

umask 077

curr_dir=$(pwd)
trap "cd $curr_dir" ERR TERM

# Check if the provided directory is valid
dir=${1:-.}
! [[ -d "$dir" ]] && { echo -e "unknown directory: $dir\nusage: $0: source_directory"; exit 1; }

# Check if the specified source directory is inside a git repository
( cd "$dir" ; git status &> /dev/null ) || { echo "not a git repository" >&2 ; exit 2; }

# Get the most changed files
find "$dir" -path '*/.*' -prune -o -type f -print |  # ignore hidden files and directories
    while read file; do
        echo -n "$file "
        git log --follow --oneline "$file" 2> /dev/null | wc -l  # report changes made across file renames
    done |
awk '$2 != 0 { print $0 }' |  # exclude not changed files
sort -rn -k 2

