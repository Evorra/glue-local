#!/bin/sh

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n4q2f2p4
docker tag evorra/glue-local:2.0.1 public.ecr.aws/n4q2f2p4/glue-local:2.0.1
docker push public.ecr.aws/n4q2f2p4/glue-local:2.0.1
