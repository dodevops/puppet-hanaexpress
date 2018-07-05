#!/usr/bin/env bash

CONTAINER_NAME=$1
TIMEOUT=$2

pgrep -f "docker run -h ${CONTAINER_NAME}" >/dev/null

if [ $? -ne 0 ]
then
    echo "Docker run seems to have failed. No process found"
    exit 1
fi

COUNTER=1

while [ ${COUNTER} -lt ${TIMEOUT} ]
do
    IMAGE_COUNT=`docker image ls -q | wc -l`
    if [ ${IMAGE_COUNT} -gt 0 ]
    then
        exit 0
    fi
    sleep 1
    COUNTER=$(expr ${COUNTER} + 1)
done

echo "Timeout reached. No image was loaded"
exit 1