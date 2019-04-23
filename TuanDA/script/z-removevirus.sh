#!/bin/bash
for i in $(cat /root/listfile); do
    rm -rf $i
done