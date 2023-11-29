#!/bin/bash
set -e
source .env
SOURCE_FILE='./provider.tf.template'
TARGET_FILE='./provider.tf'
if [ -z "${STATE_RESOURCE_GROUP_NAME}" ] || \
   [ -z "${STATE_STORAGE_ACCOUNT_NAME}" ] || \
   [ -z "${STATE_CONTAINER_NAME}" ] || \
   [ -z "${STATE_KEY}" ] || \
   [ -z "${STATE_ACCESS_KEY}" ];
then
    echo "please make sure you have edited the .env file"
else
    cp $SOURCE_FILE $TARGET_FILE
    sed -e "s|{{ STATE_RESOURCE_GROUP_NAME }}|$STATE_RESOURCE_GROUP_NAME|" \
        -e "s|{{ STATE_STORAGE_ACCOUNT_NAME }}|$STATE_STORAGE_ACCOUNT_NAME|" \
        -e "s|{{ STATE_CONTAINER_NAME }}|$STATE_CONTAINER_NAME|" \
        -e "s|{{ STATE_KEY }}|$STATE_KEY|" \
        -e "s|{{ STATE_ACCESS_KEY }}|$STATE_ACCESS_KEY|" \
        -i $TARGET_FILE
fi
