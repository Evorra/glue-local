#!/bin/sh
source ./tag.sh
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO
docker push $DST

# github
# authent?
# docker push ghcr.io/evorra/glue-local:3.0.1