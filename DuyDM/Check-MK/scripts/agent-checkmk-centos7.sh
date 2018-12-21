#!/bin/bash
#duydm
#Install Agent Check_Mk on Centos7

echo "Nhap ip Check_Mk server"
read ipserver

yum install wget -y
wget https://check.cloud365.vn/admin/check_mk/agents/check-mk-agent-1.5.0p9-1.noarch.rpm
yum install xinetd -y
systemctl start xinetd
systemctl enable xinetd
rpm -ivh check-mk-agent-*
cp /etc/xinetd.d/check_mk /etc/xinetd.d/check_mk.bk
sed -i 's/#only_from      = 127.0.0.1 10.0.20.1 10.0.20.2/only_from      = '$ipserver'/g'  /etc/xinetd.d/check_mk
systemctl restart xinetd
systemctl status xinetd


echo "Cai dat agent check_mk Ok"
