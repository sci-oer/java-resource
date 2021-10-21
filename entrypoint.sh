#!/bin/bash

# configure git to be able to commit within the container
if [[ ! -z "${GIT_EMAIL}" ]]; then
    git config --global user.email "$GIT_EMAIL"
fi

if [[ ! -z "${GIT_NAME}" ]]; then
    git config --global user.name "$GIT_NAME"
fi

#NODE_ENV=production node /opt/wiki/server &
( /wiki.sh > /var/log/wiki.log & )
( /jupyter.sh 2>&1 >/var/log/jupyter.log  & )

bash
