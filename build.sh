#!/bin/bash

set -xe

export REPO=${REPO:-heartysoft/docker-airflow}
export TAG_TO_USE=${TRAVIS_TAG:-snapshot}
docker build -t $REPO:latest .
docker tag $REPO:latest $REPO:$TAG_TO_USE
docker build -t $REPO:latest-helm -f DockerfileHelm .
docker tag $REPO:latest-helm $REPO:$TAG_TO_USE-helm
docker build -t $REPO:latest-spark -f DockerfileSpark .
docker tag $REPO:latest-spark $REPO:$TAG_TO_USE-spark
