#!/bin/bash

# by Joerg Neikes
# 18.06.2018

# see if xscreensaver is running so variable is not empty
a=$(ps a |grep xscre |grep -v grep| cut -d " " -f1)

if [ ! -z "${a}" ];
then
echo "xscreensaver is running with pid ${a} "
kill -9 ${a}
else 
echo "xscreensaver is not active"
fi
