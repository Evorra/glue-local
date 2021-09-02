#!/bin/sh

#SRC=evorra/glue-local:3.0
DST=public.ecr.aws/n4q2f2p4/glue-local:3.0

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n4q2f2p4
#docker tag $SRC $DST
docker push $DST
