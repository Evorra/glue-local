#!/bin/sh

IMAGE=public.ecr.aws/n4q2f2p4/glue-local:3.0

# -p 4040:4040
docker run -it --rm -v $(pwd):/project --name glue-local $IMAGE bash

# tested with at least the first part of this sample
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-samples-medicaid.html