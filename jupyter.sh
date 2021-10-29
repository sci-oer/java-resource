#!/bin/bash

mkdir -p /jupyter/builtin

# add a symbolic link to the ones in the mounted volume
ln -s /course/jupyter /jupyter/persistent

jupyter lab --allow-root --no-browser --ip=0.0.0.0 --port=8888 --notebook-dir="/jupyter"
