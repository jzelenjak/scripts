#!/bin/bash
# Computes the activity inside a Git repository over days.
# By default, the output is sorted by the date (chronologically).
# If the option -s is specified, the available option arguments are:
#  1 = sort by the number of insertions
#  2 = sort by the number of deletions

set -euo pipefail
IFS=$'\n\t'

umask 077

usage="usage: $0 [-s 1 | -s 2]"


# Check if the script is running inside a Git repository
git status &> /dev/null || { echo "not a git repository" >&2 ; exit 2; }

# Check if an invalid option is provided
sorting=${1:-}
if [[ -n "$sorting" ]] && [[ "$sorting" != "-s" ]]; then
    echo "unknown option: $1" >&2
    echo "$usage" >&2
    exit 1
fi

# Check if the output needs to be sorted by the number of insertions or deletions
order_by=1
sort_options=""
if [ "$sorting" ]; then
    sort_order=${2:-}
    [[ -z "$sort_order" ]] && { echo "missing option argument for option -s" >&2; echo "$usage" >&2; exit 1; }

    # See https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923#806923
    if ! [[ "$sort_order" =~ 1 ]] && ! [[ "$sort_order" =~ 2 ]]; then
        echo "unrecognized option argument for option -s: $sort_order" >&2
        echo "$usage" >&2
        exit 1
    fi

    order_by="$(($sort_order + 1))"
    sort_options="-nr"
fi

# Compute the activity (#insertions,#deletions) over days and sort as needed
git log --no-merges --pretty=format:'%as' --shortstat |  # Get the date of a commit and the number of changes (#files changed, #insertions, #deletions)
    sed '/^$/d' |  # Remove blank lines
    sed -r 's/^(.*, [0-9]+ insertion.{0,1}\(\+\))$/\1, 0 deletions\(-\)/' |  # For the commits with only insertions, add "0 deletions(-)"
    sed -r 's/^(.* changed), ([0-9]+ deletion.{0,1}\(-\))$/\1, 0 insertions\(\+\), \2/' |  # For the commits with only deletions, add "0 insertions(+)"
    sed -r 's/^.* changed, ([0-9]+).*, ([0-9]+).*$/,\1,\2\./' |  # Extract the number of insertions and deletions and separate them with a comma. A dot will be needed in the next steps
    tr -d '\n' |  # Delete \n to merge the line with the date of a commit with the next line with the changes of this commit (side effect: everything is one huge line now. But a dot is a separator between commits)
    tr '.' '\n' |  # Since a dot acts as a separator between commits, make the separator be \n so that one commit corresponds to one line
    sort -t ',' -k 1,1 |  # Make same dates appear next to each other
    awk -F ',' '{ insertions[$1] += $2; deletions[$1] += $3 } END { for (date in insertions) { print date "," insertions[date] "," deletions[date] } }'  | # Basically, what in SQL would be GROUP BY and SUM
    sort  -t ',' -k "$order_by","$order_by" $sort_options |  # Sort as requested (by date, by the number of insertions, or by the number of deletions)
    awk -F ',' 'BEGIN { print "Date,Insertions,Deletions"; } { print $0 }' |  # Print the header
    tr ',' '\t' |  # Make the separator be a tab (easier to read)
    column -t -s $'\t'  # Align the columns
