#!/usr/bin/env bash

CONTAINER_NAME=$1
TIMEOUT=$2

echo "Checking docker run process"

pgrep -f "docker run -h ${CONTAINER_NAME}" >/dev/null

if [ $? -ne 0 ]; then
  echo "Docker run seems to have failed. No process found"
  exit 1
fi

echo "Checking image download"

COUNTER=1

IMAGE_COUNT=$(docker image ls -q | wc -l)

while [ ${IMAGE_COUNT} -eq 0 ]; do
  sleep 1
  COUNTER=$(expr ${COUNTER} + 1)
  if [ ${COUNTER} -gt ${TIMEOUT} ]; then
    echo "Timeout reached. No image was loaded"
    exit 1
  fi
  IMAGE_COUNT=$(docker image ls -q | wc -l)
done

echo "Checking container start"

COUNTER=1

CONTAINER_COUNT=$(docker container ls -f name=${CONTAINER_NAME} -q | wc -l)

while [ ${CONTAINER_COUNT} -ne 1 ]; do
  sleep 1
  COUNTER=$(expr ${COUNTER} + 1)
  if [ ${COUNTER} -gt ${TIMEOUT} ]; then
    echo "Timeout reached. Container wasn't started"
    exit 1
  fi
  CONTAINER_COUNT=$(docker container ls -f name=${CONTAINER_NAME} -q | wc -l)
done

exit 0
