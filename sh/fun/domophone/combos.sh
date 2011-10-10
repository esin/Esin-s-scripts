#!/bin/bash

COUNT=$1

remove_dup()
{
  str=$1
  cnt=$(expr ${#str} - 1 )
  s=""
  for i in `seq 0 $cnt`; do
    s+="${str:i:1}|"
  done
  b=$(echo $s | sed 's/|/\n/g' | sort -u | grep -ve '^$' | tr -d '\n')
  if [ ${#b} -eq $COUNT ]; then
    echo -e "$b\n"
  fi
}

create_seq()
{
  temp=$(mktemp)
  echo $COUNT
  let "RIGHT = 10 ** COUNT - 1"
  let "LEFT = 10 ** ( COUNT - 1 )"

  while [ $LEFT -eq $RIGHT ]; do
    remove_dup $LEFT | grep -ve '^$' >> $temp
    let LEFT+=1
  done

  cat $temp | sort -u >> $COUNT
  rm -rf $temp
}

for i in `seq 1 9`; do
  COUNT=$i
  create_seq $COUNT
done

