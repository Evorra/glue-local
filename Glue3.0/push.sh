#!/bin/sh
source ./tag.sh
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_AWS
docker push $DST_AWS

# github
#export CR_PAT=<your PAT>
#echo $CR_PAT | docker login ghcr.io -u <your id> --password-stdin
#docker push $DST_GITHUB