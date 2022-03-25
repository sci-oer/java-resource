#!/bin/bash

mkdir -p /course/jupyter/notebooks/tutorials

# add a symbolic link to the ones in the mounted volume
cp -n -r -u -v /jupyter/builtin/* /course/jupyter/notebooks/tutorials/

jupyter lab --ip=0.0.0.0
