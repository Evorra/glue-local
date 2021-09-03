#!/bin/sh

#SRC=evorra/glue-local:2.0.2
DST=public.ecr.aws/n4q2f2p4/glue-local:2.0.2

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n4q2f2p4
#docker tag $SRC $DST
docker push $DST
