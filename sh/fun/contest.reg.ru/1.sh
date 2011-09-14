#!/bin/bash
#http://contest.reg.ru/index.php?id=1
RES=0;
for i in $(seq 1 999); do
if [ $(expr $i % 3) -eq 0 ]; then
 let RES=$RES+$i;
 continue
fi
if [ $(expr $i % 5) -eq 0 ]; then
 let RES=$RES+$i;
fi
done

echo $RES
