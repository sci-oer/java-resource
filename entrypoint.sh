#!/bin/bash

#NODE_ENV=production node /opt/wiki/server &
( /wiki.sh & )
( /jupyter.sh & )

bash
