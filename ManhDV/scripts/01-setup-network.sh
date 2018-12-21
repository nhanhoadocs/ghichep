#!/bin/bash
# Install Compute
# ManhDV NhanHoa Cloud Team 

source 00-setting.sh 

echo -e "\033[32m  ##### Cau hinh MNGT IP ##### \033[0m"

rm -rf /etc/sysconfig/network-scripts/ifcfg-p3p1
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-p3p1
TYPE=Ethernet
BOOTPROTO=none
NAME=p3p1
DEVICE=p3p1
ONBOOT=yes
IPADDR=$ipbond1
NETMASK=255.255.255.0
GATEWAY=192.168.70.1
DNS=8.8.8.8
EOF

echo -e "\033[32m  ##### Cau hinh DATA VM ##### \033[0m"

rm -rf /etc/sysconfig/network-scripts/ifcfg-p3p3
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-p3p3
TYPE=Ethernet
BOOTPROTO=none
NAME=p3p3
DEVICE=p3p3
ONBOOT=yes
IPADDR=$ipbond2
NETMASK=255.255.255.0
GATEWAY=192.168.70.1
DNS=8.8.8.8
EOF

echo -e "\033[32m  ##### Cau hinh bond3 ##### \033[0m"
cat << EOF> /etc/sysconfig/network-scripts/ifcfg-bond3
DEVICE=bond3
TYPE=Bond
NAME=bond3
BONDING_MASTER=yes
BOOTPROTO=none
ONBOOT=yes
BONDING_OPTS="mode=4 miimon=100 lacp_rate=1"
NM_CONTROLLED=no
IPADDR=$ipbond3
NETMASK=255.255.255.0
EOF

rm -rf /etc/sysconfig/network-scripts/ifcfg-p1p1
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-p1p1
TYPE=Ethernet
BOOTPROTO=none
NAME=p1p1
DEVICE=p1p1
MASTER=bond3
SLAVE=yes
NM_CONTROLLED=no
EOF

rm -rf /etc/sysconfig/network-scripts/ifcfg-p1p2
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-p1p2
TYPE=Ethernet
BOOTPROTO=none
NAME=p1p2
DEVICE=p1p2
MASTER=bond3
SLAVE=yes
NM_CONTROLLED=no
EOF

echo -e "\033[36m  ########### Setup moi truong ########## \033[0m"
hostnamectl set-hostname $name

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "192.168.70.11 controller1" >> /etc/hosts
echo "192.168.70.12 controller2" >> /etc/hosts
echo "192.168.70.13 controller3" >> /etc/hosts
echo "192.168.70.14 compute01" >> /etc/hosts
echo "192.168.70.15 compute02" >> /etc/hosts
echo "192.168.70.16 compute03" >> /etc/hosts
echo "192.168.70.17 compute04" >> /etc/hosts
echo "192.168.70.18 compute05" >> /etc/hosts
echo "192.168.70.19 compute06" >> /etc/hosts
echo "192.168.70.20 compute07" >> /etc/hosts

echo 'net.ipv4.conf.all.arp_ignore = 1'  >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.arp_announce = 2'  >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.rp_filter = 2'  >> /etc/sysctl.conf
echo 'net.netfilter.nf_conntrack_tcp_be_liberal = 1'  >> /etc/sysctl.conf
cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.tcp_keepalive_time = 6
net.ipv4.tcp_keepalive_intvl = 3
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
EOF
 
sysctl -p

init 6


echo -e "\033[36m  ##### Server se reboot. Hay login lai voi IP $ipbond1  ##### \033[0m"

