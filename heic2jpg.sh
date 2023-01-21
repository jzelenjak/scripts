#!/bin/bash
# Converts all files in the current directory from .HEIC format into .jpg

set -euo pipefail
IFS=$'\n\t'

umask 077

# Convert the files in the current directory from .HEIC format into .jpg
for image in *.HEIC; do
    echo "Converting $image to $(basename $image .HEIC).jpg"
    heif-convert "$image" "$(basename $image .HEIC).jpg" && rm -f "$image"
    echo "Done converting $image to $(basename $image .HEIC).jpg"
done

echo "Done"
