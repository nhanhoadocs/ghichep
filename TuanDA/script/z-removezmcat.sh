#!/bin/bash
iptables -A OUTPUT -s 177.53.8.84 -j DROP
iptables -A OUTPUT -p tcp -m tcp --dport 8011 -j DROP
iptables -A OUTPUT -p tcp -m tcp --dport 8081 -j DROP
service iptables save

grep -Rl "<\%@ page import=\"java.util.\*,java.io.*\"\%><" /opt/zimbra/jetty* >> /root/listfile
grep -Rl "<\%@page import=\"java.io.*,java.util.*,java.net.*,java.sql.*,java.text.*\"\%><" /opt/zimbra/jetty* >> /root/listfile
grep -Rl "request.getParameter(\"cmd\")" /opt/zimbra/jetty* >> /root/listfile
grep -Rl "<\%@page import=\"java.util.\*,javax.crypto.\*,javax.crypto.spec.\*\"%><%" /opt/zimbra/jetty* >> /root/listfile
grep -Rl "request.getParameter(\"command\")" /opt/zimbra/jetty* >> /root/listfile
grep -Rl "request.getParameter(\"pwd\")" /opt/zimbra/jetty* >> /root/listfile
echo "/opt/zimbra/jetty/webapps/zimbra/downloads/justatestt.jsp" >> /root/listfile
echo "tmp/l.sh" >> /root/listfile
echo "tmp/zmcat" >> /root/listfile
echo "tmp/s.sh" >> /root/listfile
#for i in $(cat /root/listfile); do
#    rm -rf $i
#done