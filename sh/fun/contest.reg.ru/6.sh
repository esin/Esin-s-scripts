#!/bin/bash
#http://contest.reg.ru/index.php?id=6
SUM=0
for i in `seq 1 100`; do
 let SUM=$SUM+i
done

SUM_2=$(echo $SUM*$SUM | bc -q)

SUM=0
for i in `seq 1 100`; do
 let SUM=$SUM+i*i
done

echo $(echo $SUM_2-$SUM | bc -q)
