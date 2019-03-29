#!/bin/bash
cd /root
wget https://files.zimbra.com/downloads/8.6.0_GA/zcs-patch-8.6.0_GA_1241.tgz
tar xvzf zcs-patch-8.6.0_GA_1241.tgz
cd zcs-patch-8.6.0_GA_1241
./installPatch.sh
service zimbra restart



