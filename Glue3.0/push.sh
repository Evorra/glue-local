#!/bin/sh
source ./tag.sh
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO
docker push $DST

# github
# ghcr.io/evorra/glue-local 