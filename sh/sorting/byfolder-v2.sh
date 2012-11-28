#!/bin/bash
SOURCE=/bin		# Откуда брать файлы
DEST=1			# Складировать папки здесь
STYLE=+%Y-%m-%d			# Стиль обзывания папок
LS_OPTS="-tl --time-style=$STYLE -ogG --block-size=1P"

list=`ls $SOURCE $LS_OPTS -Q | grep -ve '^d' | grep -ve '^l' | cut -d' ' -f 4 | sort -u`
for i in $list
 do
  mkdir "$DEST/$i" -p;
  echo "Date: "$i
  cp -av `ls $SOURCE $LS_OPTS | grep $i | grep -ve '^d' | grep -ve '^l' | cut -d' ' -f 5 | sed ':^$:d' | sed 's:^:'"$SOURCE"'/:' | tr '\n' ' '` "$DEST/$i"
done
