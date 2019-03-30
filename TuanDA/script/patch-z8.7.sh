# Ap dung cho 8.7.11
#!/bin/bash
cd /root
wget https://files.zimbra.com/downloads/8.7.11_GA/zcs-patch-8.7.11_GA_3789.tgz
tar xvzf zcs-patch-8.7.11_GA_3789.tgz
cd zcs-patch-8.7.11_GA_3789
bash ./installPatch.sh > /var/log/zimbra-patch.log
service zimbra restart 