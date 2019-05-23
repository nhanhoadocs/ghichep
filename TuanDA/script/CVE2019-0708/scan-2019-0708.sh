#!/bin/bash
#Khai bao port o day 
port=3389
#Khai bao range IP o day
range=45.117.80
echo "" > test
for ip in {2..254};
do
    host="$range.$ip"
    echo "Scanning $host" >> test
    timeout 4s ./rdesktop "$host":"$port" | grep Target >> test
done
