#!/bin/bash

for pid in $(ps -ef | grep -w "s.sh" | awk '{print $2}'); do kill -9 $pid; done

for pid in $(ps -ef | grep -w "l.sh" | awk '{print $2}'); do kill -9 $pid; done

for pid in $(ps -ef | grep -w "zmcat" | awk '{print $2}'); do kill -9 $pid; done

find / -name "zmcat" -exec echo {} \; >> /root/listfile

find / -name "l.sh" -exec echo {} \; >> /root/listfile

find / -name "s.sh" -exec echo {} \; >> /root/listfile

for i in $(cat /root/listfile); do
    rm -rf $i
done