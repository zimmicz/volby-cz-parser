#!/bin/bash

CUR_DIR=$(dirname $0)

# Input parameters
while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -i|--input-dir)
            INPUT_DIR="$2"
            shift
            ;;
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift
            ;;
        *)
            echo "Usage: `basename $0` --input-dir|-i [input_directory] --output-dir|-o [output_directory]"
            exit 1
            ;;
    esac
    shift
done
# /Input parameters

if [[ -z $INPUT_DIR ]]
then
    echo "Please specify --input-dir"
    exit 1
fi

if [[ -z $OUTPUT_DIR ]]
then
    echo "Please specify --output-dir"
    exit 1
fi

mkdir ${OUTPUT_DIR}

if [[ ! $? -eq 0 ]]
then
    echo "${OUTPUT_DIR} creation failed"
    exit 1
fi

find ${INPUT_DIR} -iname "*.xml" | parallel -j8 -u python transform_data_xml.py ${OUTPUT_DIR}
