#!/bin/bash
# Fetches words from a webpage of learndutch.org (that has only one table) and puts these words into a .csv file
# NB! Cookie is needed for paid courses. It can be specified with `--cookie <cookie_value>` option (cookie value must be one string. You can store it as a shell variable)
# Although this is a pretty rudimentary script, it does perform the task that i want


set -euo pipefail
IFS=$'\n\t'
umask 077

usage="usage: $0 url out_file [--cookie <cookie>]"


# Check if the URL has been specified
url=${1:-}
[ -z "$url" ] && { echo -e "missing url\n$usage" >&2; exit 2; }

# Check if the output file name has been specified
out_file_arg=${2:-}
[ -z "$out_file_arg" ] && { echo -e "missing output file\n$usage" >&2; exit 2; }
out_file="$(basename $out_file_arg .csv).csv"

trap "rm $out_file 2> /dev/null" ERR

# Check if a cookie has been specified
cookie=""
cookie_header_flag=""
cookie_arg=${3:-}
if [ -n "$cookie_arg" ]; then
    [ "$cookie_arg" != "--cookie" ] && { echo -e "unknown option: $cookie_arg\n$usage" >&2; exit 2; }

    cookie=${4:-}
    [ -z "$cookie" ] && { echo -e "missing option argument for option --cookie\n$usage" >&2; exit 2; }

    cookie="cookie: $cookie"
    cookie_header_flag="-H"
fi

# Get the words and convert them into the correct format
curl -sL "$cookie_header_flag" "$cookie" "$url" |
    sed -n '/<table .*>/,/<\/table>/p' |         # Get the table with the words
    grep "^<td.*" |                              # Get the words
    sed -ne '
        1s/.*/Nederlands,English/                # Basically, make a table header with the languages (a lazy version to accomplish the task)
        2d                                       # Delete the second line as `English` has already been placed with the above command
        1,2! {
            s/<td.*>\(.*\)<\/td>/\1/             # Get the word
            N                                    # Merge with the next line (the translation)
            s/\n//                               # Remove the embedded newline character
            s/,/;/g                              # Replace comma with a semicolon, since a comma is used as a separator between a word and translation
            s/\(.*\)<td.*>\(.*\)<\/td>/\1,\2/    # Remove html tag from the second word (translation), separate with commas

            # Replace HTML escape characters
            s/&lt;/</g
            s/&gt;/>/g
            s/&quot;/"/g ; s/&#822[01];/"/g
            s/&#39;/'\''/g ; s/&#821[67];/'\''/g
            s/&amp;/\&/g
        }
        p
    ' > $out_file

