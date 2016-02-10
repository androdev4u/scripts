#!/bin/bash
# script to search for names in files and copy them to a folder


# needed for not escapeing of filenames
IFS="$(printf '\n\t')"

# folder to search
folder2search="/mnt/folder2search"
# folder to copy
folder2copy="/mnt/folder2copy"


echo "give search pattern"
read a

# search for the files to copy
i=$(find $folder2search -name "*$a*")

# copy the files to the folder
for h in $i
do
cp "$h" $folder2copy
done

