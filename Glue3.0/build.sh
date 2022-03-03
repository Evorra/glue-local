#!/bin/sh
source ./tag.sh

docker build . -t $DST_AWS
docker build . -t $DST_GITHUB
