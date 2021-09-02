#!/bin/sh

IMAGE=public.ecr.aws/n4q2f2p4/glue-local:2.0

# -p 4040:4040
docker run -it --rm -v $(pwd):/project --name glue-local $IMAGE bash
