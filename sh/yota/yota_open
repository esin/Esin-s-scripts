#!/bin/bash

BLANK_PAGE=http://raw.github.com/esin/Esin-s-scripts/master/sh/yota/blank.html
IS_302=`curl $BLANK_PAGE --retry 100000 --retry-delay 1 --silent --compressed --dump-header - | grep "HTTP/1.1 302 Found" | wc -l`

if [ $IS_302 -eq "1" ]; then
  curl http://hello.yota.ru/php/go.php \
   -D > /dev/null --retry 100000 --retry-delay 1 \
   --silent --compressed \
   --data "accept_lte=1&redirurl=http://www.yota.ru/&city=msk&connection_type=sa&service_id=Service_Access_Temp"
fi
