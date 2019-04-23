#!/bin/bash
grep -Rl "<\%@ page import=\"java.util.\*,java.io.*\"\%><" /opt/zimbra/jetty/webapps/zimbra/* >> /root/listfile
grep -Rl "<\%@page import=\"java.io.*,java.util.*,java.net.*,java.sql.*,java.text.*\"\%><" /opt/zimbra/jetty/webapps/zimbra/* >> /root/listfile
grep -Rl "request.getParameter(\"cmd\")" /opt/zimbra/jetty/webapps/zimbra/* >> /root/listfile
echo "/opt/zimbra/jetty/webapps/zimbra/downloads/justatestt.jsp" >> /root/listfile
echo "tmp/l.sh" >> /root/listfile
echo "tmp/zmcat" >> /root/listfile
echo "tmp/s.sh" >> /root/listfile
for i in $(cat /root/listfile); do
    rm -rf $i
done