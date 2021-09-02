#!/bin/sh

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 980036580614.dkr.ecr.eu-west-1.amazonaws.com
docker tag evorra/glue-local:2.0.1 980036580614.dkr.ecr.eu-west-1.amazonaws.com/glue-local:2.0.1
docker push 980036580614.dkr.ecr.eu-west-1.amazonaws.com/glue-local:2.0.1