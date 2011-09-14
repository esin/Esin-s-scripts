#!/bin/bash
#http://contest.reg.ru/index.php?id=20
RES="1"
for i in `seq 2 100`; do
RES=$RES*$(echo -n $i)
done

NUM=$(echo $RES | bc -q | sed '$!N;s/\\//g' | sed '$!N;s/\n//g' )
NUM=$(echo $NUM | sed '$!N;s/ //g')
SUM=0
for i in `seq 0 $(expr ${#NUM} - 1)`; do
 let SUM=$SUM+${NUM:`echo -ne $i`:1}
done
echo $SUM