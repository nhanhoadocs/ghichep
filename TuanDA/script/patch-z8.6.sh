# Ap dung cho 8.6.0
#!/bin/bash
cd /root
wget https://files.zimbra.com/downloads/8.6.0_GA/zcs-patch-8.6.0_GA_1241.tgz
tar xvzf zcs-patch-8.6.0_GA_1241.tgz
cd zcs-patch-8.6.0_GA_1241
bash ./installPatch.sh > /var/log/zimbra-patch.log
service zimbra restart