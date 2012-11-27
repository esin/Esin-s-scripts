#!/bin/bash
# %Y - year
# %m - number of month
# %d - date of month


DATE_FORMAT=+%Y-%m-%d
DATE_LIST=$(ls --time-style=$DATE_FORMAT /bin -tlnoGgAr --block-size=1E | grep -v ^d | grep -v ^l |cut -f4 -d' ' | sort -u | grep -v ^$)
#FILE_LIST=$(ls --time-style=$DATE_FORMAT /bin -tlQnoGgAr --block-size=1E | grep -v ^d | cut -f5 -d' ' | sort -u | grep -v ^$)

for each in $DATE_LIST;
do
 mkdir -p 1/$each;
 echo $each
 cp -pv `find /bin -type f -exec ls {} --time-style=$DATE_FORMAT -tlnoGgAr --block-size=1E \; | grep $each | grep -v ^d | grep -v ^l | cut -f5 -d' ' | sort -u | grep -v ^$` 1/$each
done

#find /bin -type f -exec mkdir

#for each in $FILE_LIST;
#do
# echo "/bin/$each"
#done

exit
#echo $DATE_LIST
#for each in $DATE_LIST;
#do
 #echo $each
#done
