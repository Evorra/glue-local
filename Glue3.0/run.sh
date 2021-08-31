#!/bin/sh

# -p 4040:4040 to expose Jupiter service
docker run -it --rm -p 4041:4041 -v $(pwd):/project --name local-glue evorra/local-glue:latest bash
