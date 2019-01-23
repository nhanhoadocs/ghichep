#!/bin/bash
#duydm
#Install agent Centos7

rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum install zabbix-agent -y
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bk
echo "Nhap IP server zabbix"
read ipserver
sed -i 's/Server=127.0.0.1/Server='$ipserver'/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive='$ipserver'/g' /etc/zabbix/zabbix_agentd.conf


systemctl enable zabbix-agent
systemctl start zabbix-agent
systemctl restart zabbix-agent
systemctl status zabbix-agent
echo "Cai dat Ok"
