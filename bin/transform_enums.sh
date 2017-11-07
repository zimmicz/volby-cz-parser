#!/bin/bash

CUR_DIR=$(dirname $0)
source ${CUR_DIR}/../etc/settings.env

# Input parameters
while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -i|--input-file)
            INPUT_FILE="$2"
            shift
            ;;
        -o|--output-file)
            OUTPUT_FILE="$2"
            shift
            ;;
        *)
            echo "Usage: `basename $0` --input-file|-i [input_file] --output-file|-o [output_file]"
            exit 1
            ;;
    esac
    shift
done
# /Input parameters

if [[ -z $INPUT_FILE ]]
then
    echo "Please specify --input-file"
    exit 1
fi

if [[ -z $OUTPUT_FILE ]]
then
    echo "Please specify --output-file"
    exit 1
fi

filename=$(basename $INPUT_FILE)
extension="${filename##*.}"

# dbf file
if [[ "dbf" = ${extension,,} ]]
then
    # browse dbf file
    # get the second column (NUTS id)
    # remove whitespace
    # remove all lines shorter than 6 characters
    # prepend URL, append NUTS id
    dbview --browse --delimiter ";" $INPUT_FILE | \
    cut -d ";" -f 2 | \
    tr -d "[:blank:]" | \
    sed -r '/^.{,5}$/d' | \
    awk -v var="${RESULTS_URL}" '{print var $0 " " $0}' \
    > $OUTPUT_FILE
# xlsx file
else
    ssconvert $INPUT_FILE $OUTPUT_FILE
    cat $OUTPUT_FILE | \
    cut -d "," -f 2 | \
    tr -d "[:blank:]" | \
    sed -r '/^.{,5}$/d' | \
    awk -v var="${RESULTS_URL}" '{print var $0 " " $0}' \
    > ${OUTPUT_FILE}.new
    mv ${OUTPUT_FILE}.new ${OUTPUT_FILE}
fi
