#!/bin/bash
# Computes the activity over days


# Check if the script is run in a git repository
git status 2&> /dev/null
exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo Not a git repository
    exit $exit_code
fi


# Check if an invalid option is provided
if [[ $# -ne 0 ]] && [[ "$1" != "-s" ]]; then
    echo Unrecognized option $1
    exit 1
fi

# Check if the user requested sorting by the number of insertions or deletions
order_by=1
if [ "$1" == "-s" ]; then
    if [[ "$2" == "" ]] || [[ $2 -ne 1 ]] && [[ $2 -ne 2 ]] ; then
        echo "Please give a valid option for the option -s (1 = sort by the number of insertions, 2 = sort by the number of deletions)"
        exit
    fi
    order_by="$(($2 + 1)) -n -r"
fi

# Compute the activity (#insertions,#deletions) over days and sort as needed
echo "Showing the activity over days (date,#insertions,#deletions):"
git log --no-merges --pretty=format:'%as' --shortstat |  # Get the date of a commit and the number of changes (#files changed, #insertions, #deletions)
    sed '/^$/d' |  # Remove blank lines
    sed -r 's/^(.*, [0-9]+ insertion.{0,1}\(\+\))$/\1, 0 deletions\(-\)/' |  # For the commits with only insertions, add "0 deletions(-)"
    sed -r 's/^(.* changed), ([0-9]+ deletion.{0,1}\(-\))$/\1, 0 insertions\(\+\), \2/' |  # For the commits with only deletions, add "0 insertions(+)"
    sed -r 's/^.* changed, ([0-9]+).*, ([0-9]+).*$/,\1,\2\./' |  # Extract the number of insertions and deletions and separate them with a comma. A dot will be needed in the next steps
    tr -d '\n' |  # Delete \n to merge the line with the date of a commit with the next line with the changes of this commit (side effect: everything is one huge line now. But a dot is a separator between commits)
    tr '.' '\n' |  # Since a dot acts as a separator between commits, make the separator be \n so that one commit corresponds to one line
    sort -t"," -k 1 |  # Make same dates appear next to each other
    awk -F "," '{ insertions[$1] += $2; deletions[$1] += $3 } END { for (i in insertions) { print i "," insertions[i] "," deletions[i] } }'  | # Basically, what in SQL would be GROUP BY and SUM
    sort  -t"," -k $order_by |  # Sort as requested (by date, by the number of insertions, by the number of deletions)
    tr ',' '\t'  # Make the separator to be a tab (easier to read)
