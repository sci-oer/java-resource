#!/bin/bash



# Copy the builtin content to the mounted volume
cp -n -r -u -v /builtin/jupyter/. /course/jupyter/notebooks/tutorials/
cp -n -r -u -v /builtin/coursework/. /course/coursework/
cp -n -r -u -v /builtin/lectures/. /course/lectures/
cp -n -r -u -v /builtin/practiceProblems/. /course/practiceProblems/

