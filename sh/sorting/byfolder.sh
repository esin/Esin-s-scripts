#!/bin/bash
# %Y - year
# %m - number of month
# %d - date of month

function usage() {
  echo "Usage: `basename $0` 'Dir to parse files' 'Dir to copy files' "
  exit
}

PARSE_DIR=$1
COPY_TO=$2

if [ $# -ne 2 ]
then
  usage
fi

DATE_FORMAT=+%Y-%m-%d
LS_PARAMS="--time-style=$DATE_FORMAT -tlnoGgAr --block-size=1E"
DATE_LIST=$(ls $PARSE_DIR $LS_PARAMS | grep -v ^d | grep -v ^l |cut -f4 -d' ' | sort -u | grep -v ^$)

for each in $DATE_LIST;
do
 mkdir -p $COPY_TO/$each;
 echo $each
 cp -pv `find $PARSE_DIR -type f -exec ls {} $LS_PARAMS \; | grep $each | grep -v ^d | grep -v ^l | cut -f5 -d' ' | sort -u | grep -v ^$` $COPY_TO/$each
done
