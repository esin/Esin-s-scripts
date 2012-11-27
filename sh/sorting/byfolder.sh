#!/bin/bash
# %Y - year
# %m - number of month
# %d - date of month


DATE_FORMAT=+%Y-%m-%d
DATE_LIST=$(ls --time-style=$DATE_FORMAT /bin -tlQnoGgAr --block-size=1E | grep -v ^d | cut -f4 -d' ' | sort -u | grep -v ^$)
FILE_LIST=$(ls --time-style=$DATE_FORMAT /bin -tlQnoGgAr --block-size=1E | grep -v ^d | cut -f5 -d' ' | sort -u | grep -v ^$)
#exit;
#echo $DATE_LIST
#for each in $DATE_LIST;
#do
 #echo $each
#done
