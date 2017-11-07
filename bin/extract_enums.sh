#!/bin/bash

CUR_DIR=$(dirname $0)
source ${CUR_DIR}/../etc/settings.env

# Input parameters
while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -w|--work-dir)
            WORK_DIR="$2"
            shift
            ;;
        *)
            echo "Usage: `basename $0` --work-dir|-w [working_directory] [--with-enums]"
            exit 1
            ;;
    esac
    shift
done
# /Input parameters

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

echo "Downloading enums from $ENUMS_URL"
wget --quiet $ENUMS_URL -O ${WORK_DIR}/${ENUMS_ZIP}
if [[ $? -eq 0 ]]
then
    echo "Download complete"
else
    echo "Download failed"
    exit 1
fi

unzip -d ${WORK_DIR}/enums ${WORK_DIR}/${ENUMS_ZIP}
rm -rf ${WORK_DIR}/${ENUMS_ZIP}
