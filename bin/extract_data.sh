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
        -w|--work-dir)
            WORK_DIR="$2"
            shift
            ;;
        *)
            echo "Usage: `basename $0` --input-file|-i [input_file] --work-dir|-w [working_directory]"
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

if [[ -z $WORK_DIR ]]
then
    echo "Please specify --work-dir"
    exit 1
fi

mkdir ${WORK_DIR}

if [[ ! $? -eq 0 ]]
then
    echo "${WORK_DIR} creation failed"
    exit 1
fi

parallel -a ${INPUT_FILE} --colsep ' ' --gnu wget --quiet --no-check-certificate {1} -O ${WORK_DIR}/{2}.xml

if [[ -n $FOREIGN_RESULTS_URL ]]
then
    wget --quiet --no-check-certificate -O ${WORK_DIR}/foreign.xml $FOREIGN_RESULTS_URL
fi
