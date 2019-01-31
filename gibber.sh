#!/bin/bash

export NEW_ENC=$(echo $3 | sed 's/\(.*\)/\L\1/')

function convertencoding {
    FILE_NAME=$1
    ORG_ENC=$(file --mime-encoding $FILE_NAME | sed -r 's/^[^:]+\:\ (.+)$/\1/' | sed 's/\(.*\)/\L\1/')
    if [ "$ORG_ENC" == "binary" ]; then
        echo "Skipping. cannot convert binary file: $FILE_NAME"
    elif [ "$ORG_ENC" == "$NEW_ENC" ]; then
        echo "Skipping. source encoding matches target encoding: $FILE_NAME"
    else
        iconv -s -f $ORG_ENC -t $NEW_ENC $FILE_NAME 2>> gibber.log 1> .utf-8.tmp
        NEW_BYTES=$(du -b .utf-8.tmp | sed -r 's/([0-9]+).*/\1/')
        if [ $NEW_BYTES -eq 0 ]; then
            echo "Conversion failed! $FILE_NAME"
            echo "$FILE_NAME" >> gibber_errlist.log
        else
            echo "$ORG_ENC -> $NEW_ENC : $FILE_NAME"
            cat .utf-8.tmp > $FILE_NAME
        fi
    fi
}
export -f convertencoding

echo "Converting all files matching the filter '$2' in path '$1' to specified encoding '$NEW_ENC'."
echo ""
find $1 -type f -iname "$2" -exec bash -c 'convertencoding "$0"' {} \;

rm .utf-8.tmp