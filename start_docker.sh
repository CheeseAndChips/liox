#!/bin/bash
set -x
docker run -it --rm --privileged -v $(pwd):/workspace liox:latest /bin/bash
