#!/bin/bash
DATE_FORMAT=+%Y-%m-%d
DATE_LIST=$(ls --time-style=$DATE_FORMAT /bin -tlQnoGgAr --block-size=1E | cut -f4 -d' ' | sort -u | grep -v ^$)

#echo $DATE_LIST
for 
