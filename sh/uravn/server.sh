#!/bin/bash

#!/bin/bash
AMOUNT_TRAFF=10000000000 # bytes
PORT=34455
IP=0.0.0.0 # listen connections on all interfaces

FIFO="/tmp/$(base64 -w 16 /dev/urandom | head -n 1)"
mkfifo $FIFO
echo "Run wget/curl on other server for downloading"
echo -e "HTTP/1.1 200 OK\nContent-Length: $AMOUNT_TRAFF\r\n" > $FIFO | cat /dev/urandom > $FIFO | nc -4knvl $IP $PORT < $FIFO
