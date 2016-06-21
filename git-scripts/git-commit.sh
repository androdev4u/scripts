#!/bin/bash
echo "Please give string for modification pattern."
read a
# echo $a
git commit -a -S -m  "$a"
