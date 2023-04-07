#!/bin/sh
#export REPO=public.ecr.aws/evorra # AWS
export REPO=ghcr.io/evorra # GITHUB
export IMG=glue-local-activation
export VERSION=4.0.0
export DST=$REPO/$IMG:$VERSION
