#!/bin/sh

export REPO_AWS=public.ecr.aws/evorra
export REPO_GITHUB=ghcr.io/evorra

export IMG=glue-local
export VERSION=3.0.10

export DST_AWS=$REPO_AWS/$IMG:$VERSION
export DST_GITHUB=$REPO_GITHUB/$IMG:$VERSION
