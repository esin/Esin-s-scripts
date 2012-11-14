#!/bin/bash

IS_302=`curl ip.qpriv.at -s -D - | grep "HTTP/1.1 302 Found" | wc -l`

if [ $IS_302 -eq "1" ]; then
  curl http://hello.yota.ru/php/go.php -d "accept_lte=1&redirurl=http://www.yota.ru/&city=msk&connection_type=sa&service_id=Service_Access_Temp"
fi
