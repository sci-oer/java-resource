#!/bin/bash

mkdir -p /course/jupyter/notebooks/builtin

# add a symbolic link to the ones in the mounted volume
cp -n -r -u -v /jupyter/builtin /course/jupyter/notebooks/builtin

jupyter lab --ip=0.0.0.0
