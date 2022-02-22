#!/bin/sh
source ./tag.sh
docker build . -t $DST
