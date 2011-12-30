#!/bin/bash
AMOUNT_TRAFF=100000 # bytes
PORT=34455
IP=0.0.0.0 # listen connections on all interfaces

FIFO=/tmp/"$(base64 -w 16 /dev/urandom | head -n 1)"
mkfifo $FIFO
echo "Run wget/curl on other server for downloading"
echo "Port: "$PORT
echo "I will send "$AMOUNT_TRAFF" bytes"
echo -e "HTTP/1.1 200 OK\nContent-Length: $AMOUNT_TRAFF\r\n" > $FIFO | cat /dev/urandom > $FIFO | nc -4nvl $IP $PORT < $FIFO > /dev/null
rm -f $FIFO
echo "Done!"
exit 0

