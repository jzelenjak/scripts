#!/bin/bash
# Fetches words from a webpage of learndutch.org (that has only one table) and puts these words into a .csv file
# NB! Cookie is needed for paid courses. It can be specified with `--cookie <cookie_value>` option (cookie value must be one string. You can store it as a shell variable)
# Although this is a pretty rudimentary script, it does perform the task that i want

# Check if the URL has been specified
if [ -z $1 ] ; then
    echo "$0: URL not specified"
    exit 2
fi

# Check if the output file name has been specified
if [ -z $2 ] ; then
    echo "$0: output file name not specified"
    exit 2
fi

# Check if a cookie has been specified
if [ "$3" == "--cookie" ] && [ "$4" != "" ]; then
    cookie="cookie: $4"
    cookie_header_flag="-H "
fi

# Get the words and convert them into the correct format
curl -sL $cookie_header_flag "$cookie" $1 |
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
    ' > $2.csv

