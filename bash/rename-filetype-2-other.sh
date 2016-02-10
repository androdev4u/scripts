#!/bin/bash

# needed for not escapeing of filenames
IFS="$(printf '\n\t')"


echo "give extension to rename e.g. htm"
read A

echo "give extension to rename to e.g. html"
read B

echo "give directory to search for files "
read C

for i in $(find ${C} -name "*.${A}")
do
a=$(echo ${i}| sed s/$A/$B/)
echo $a
echo "mv  ${i} ${a}"
# cp  ${i} ${a}
mv ${i} ${a}

done
