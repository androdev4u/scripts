#!/bin/bash
# script to show hiden files


# needed for not escapeing of filenames
IFS="$(printf '\n\t')"

# folder to search
folder2search="/mnt/folder2search"
# folder to copy
folder2copy="/mnt/folder2copy"


echo "give folder 2 search"
read folder2search

du -sch .[!.]* $folder2search | grep -v $folder2search |  sort -h
