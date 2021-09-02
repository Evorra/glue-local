#!/bin/sh

# -p 4040:4040
docker run -it --rm -v $(pwd):/project --name local-glue evorra/glue-local:2.0.1 bash
