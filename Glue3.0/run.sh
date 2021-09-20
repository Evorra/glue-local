#!/bin/sh
source ./tag.sh
docker run -it --rm -p 4040:4040 -v $(pwd):/project -v ${HOME}/.aws:/root/.aws --name glue-local $DST bash

# tested with at least the first part of this sample
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-python-samples-medicaid.html