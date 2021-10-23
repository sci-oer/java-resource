#!/bin/bash

# configure git to be able to commit within the container
if [[ ! -z "${GIT_EMAIL}" ]]; then
    git config --global user.email "$GIT_EMAIL"
fi

if [[ ! -z "${GIT_NAME}" ]]; then
    git config --global user.name "$GIT_NAME"
fi


# Setup directories in the potentially mounted volume
LOGDIR="/course/logs"
mkdir -p "/course/wiki" "/course/jupyter" "/course/work" $LOGDIR


# copy the wiki database if it is not already there
if [[ ! -f "/course/wiki/database.sqlite" ]]; then
    cp /opt/wiki/database.sqlite /course/wiki/database.sqlite
fi


#NODE_ENV=production node /opt/wiki/server &
( /wiki.sh > $LOGDIR/wiki-out.log 2> $LOGDIR/wiki-err.log  & )
( /jupyter.sh > $LOGDIR/jupyter-out.log 2> $LOGDIR/jupyter-err.log   & )

cat /motd.txt

bash
