#!/bin/bash
IFS=$'\n'

# script to get doubble files by md5sum and remove first occurence to get a remove list for doubble files

# We read the Dir to check
echo "give dir to check"
read Dir

find $Dir  -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate > $Dir.log

# Create backup of logfile
cp $Dir.log $Dir.log_back

# get only one md5sum fom the log
# the mdsum has 32 chars, we need for the md5sumlist
cut -c 1-32 $Dir.log | uniq > $Dir-md5sums.txt

# for each md5sum in the $Dir-md5sums.txt file remove only the first occurence
# this uses the $Dir.log again
for i in $(cat $Dir-md5sums.txt) ; do
sed -i -e "0,/${i}/ s/${i}.*//" $Dir.log
done

# remove md5sums and use " for directories with spaces
sed -i -e 's/^.\{34\}/"/g' $Dir.log
sed -i -e 's/$/"/g' $Dir.log

# remove the doubble files
for b in $(cat $Dir.log) ; do
echo -n $b | xargs rm 
done
