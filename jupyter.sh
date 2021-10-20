#!/bin/bash


cd /jupyter


echo 'NotebookApp.password="argon2:$argon2id$v=19$m=10240,t=10,p=8$dJL6KoAv3iPJy/cgfKS2Aw$ZR0M2UuzDXGEGJVTwwCYgg"'

echo -e "password\npassword\n" | jupyter notebook password
JUPYTER_TOKEN="" jupyter notebook --allow-root --no-browser --ip=0.0.0.0 --port=8888 --notebook-dir="/jupyter"

