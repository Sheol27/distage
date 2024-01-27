#!/bin/bash

docker build -t protofiles_generator .

docker run -it --rm \
    -v $"$(pwd)":/app \
    protofiles_generator \
    # /bin/bash
    