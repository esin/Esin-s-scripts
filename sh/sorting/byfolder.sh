#!/bin/bash
# %Y - year
# %m - number of month
# %d - date of month

PARSE_DIR=/bin
COPY_TO=1
DATE_FORMAT=+%Y-%m-%d
LS_PARAMS="--time-style=$DATE_FORMAT -tlnoGgAr --block-size=1E"
DATE_LIST=$(ls $PARSE_DIR $LS_PARAMS | grep -v ^d | grep -v ^l |cut -f4 -d' ' | sort -u | grep -v ^$)

for each in $DATE_LIST;
do
 mkdir -p $COPY_TO/$each;
 echo $each
 cp -pv `find $PARSE_DIR -type f -exec ls {} $LS_PARAMS \; | grep $each | grep -v ^d | grep -v ^l | cut -f5 -d' ' | sort -u | grep -v ^$` $COPY_TO/$each
done
