#!/bin/bash

# set the password to 'password'
#echo -e "password\npassword\n" | jupyter notebook password >/dev/null

jupyter notebook --allow-root --no-browser --ip=0.0.0.0 --port=8888 --notebook-dir="/course/jupyter"
