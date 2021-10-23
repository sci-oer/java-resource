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


# if it is not interactive then print an error message with suggestion to use docker run -it instead
if [ ! -t 1 ] ; then
       # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi

    echo "${red}ERROR!! This container must be run interactivly try again with: ${yellow}`docker run -it`${normal}"
    exit -2
fi

bash


