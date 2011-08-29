#!/bin/bash
## Name:        Friends Only Feed (FOFeeD)
## Version:     0.1
## Description: Lets read LJ-posts with *friendonly* flag in rss-aggregators
## Dependencies: coreutils, curl
## License:     GPLv3

export FOFEED_CURRENT_DIR=`dirname $(readlink -f $0)`

read_config()
{
 . "$FOFEED_CURRENT_DIR/.fofeedrc"
 touch $FOFEED_DB_FILE
 touch $FOFEED_LOG_FILE
 if [ $FOFEED_DEBUG -eq "1" ]; then env | grep "FOFEED"; fi
}

write_log()
{
 echo `date +'[%Y/%m/%d %H:%M:%S]'`" $1" >> $FOFEED_LOG_FILE
 if [ $FOFEED_DEBUG -eq "1" ]; then echo `date +'[%Y/%m/%d %H:%M:%S]'`" $1"; fi
}

download_xml()
{
 local uname=`echo $1 | sed 's/_/-/'`
 curl --user "$FOFEED_USER_LJ:$FOFEED_PASS_LJ" --digest --user-agent "$FOFEED_USER_AGENT" \
      --silent --show-error --retry-delay 10 --retry 1024 --compressed -o $FOFEED_WEB_PATH"/$1.$FOFEED_TYPE" "http://$uname.livejournal.com/data/$FOFEED_TYPE?auth=digest"
 write_log $?
}

ping_xml()
{
 local uname=`echo $1 | sed 's/_/-/'`
 local tmpfile=`mktemp`
 curl --user "$FOFEED_USER_LJ:$FOFEED_PASS_LJ" --digest --user-agent "$FOFEED_USER_AGENT" \
      --compress --silent --show-error --retry-delay 10 --retry 1024 --head -o $tmpfile "http://$uname.livejournal.com/data/$FOFEED_TYPE?auth=digest"
 write_log "($1) - Ping XML: $?"

 lastmod=`cat $tmpfile | grep "Last-Modified"`
 rm -f $tmpfile

 if [ `cat "$FOFEED_DB_FILE" | grep "$uname:$lastmod" | wc -l` -eq 1 ]
  then
   write_log "($1) - Ping XML: Allright. Already downloaded"
   return 0
  fi

 if [ `cat "$FOFEED_DB_FILE" | grep "$uname" | wc -l` -ge 1 ]
  then
   str=`cat "$FOFEED_DB_FILE" | grep -m 1 "$uname"`
   sed "/$uname/s/$str/$lastmod/g" "$FOFEED_DB_FILE" > "$FOFEED_DB_FILE"
   write_log "($1) - Ping XML: Greater than one entry"
   return 1
 fi

 if [ `cat "$FOFEED_DB_FILE" | grep "$uname" | wc -l` -eq 0 ]
  then
   echo "$uname:$lastmod" >> "$FOFEED_DB_FILE"
   write_log "($1) - Ping XML: No entry in DB"
   return 1
 fi

 if [ ! -f $FOFEED_WEB_PATH"/$1.$FOFEED_TYPE" ]
  then
   write_log "($1) - Ping XML: Didn't find $1.$FOFEED_TYPE. Downloading again"
   return 1
 fi
}

parse_friends()
{
 for fr in $FOFEED_FRIENDS_LJ;
  do
   ping_xml $fr
    if [ $? -eq 1 ] 
      then
      write_log "($fr) - Downloading posts: $?"
      download_xml $fr
    fi 
  done
}

do_work()
{
 parse_friends
}

read_config
do_work

exit 0
