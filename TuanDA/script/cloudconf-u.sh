#!/bin/bash

# Check OS
if cat /etc/*release | grep CentOS; then
    echo "=========="
    echo "CentOS"
    echo "=========="
    OS="CentOS"
    VER=$(rpm --eval '%{centos_ver}')
# elif cat /etc/*release | grep ^NAME | grep Red; then
#     echo "=========="
#     echo "RedHat"
#     echo "=========="
# elif cat /etc/*release | grep ^NAME | grep Fedora; then
#     echo "==========="
#     echo "Fedorea"
#     echo "==========="
elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "=========="
    echo "Ubuntu"
    echo "=========="
    codename=$(lsb_release -c | grep Codename | awk '{print $2}')
    OS="Ubuntu"
    if [ $codename == 'trusty' ]; then VER='14'; elif [ $codename == 'xenial' ]; then  VER='16'; elif [ $codename == 'bionic' ]; then  VER='18'; fi
else
    echo "OS NOT DETECTED"
    exit 1;
fi

# Disable firewall ufw 14 16 18
sudo ufw disable
sudo timedatectl set-timezone Asia/Ho_Chi_Minh

# Disable ipv6 chung 14 16 18
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# Disable ipv6 chung 14 16 18
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y


if [ $VER == '14' ]; then  
dpkg --configure -a ; 
fi


#cai cloudinit + growpart 14 16 18
apt-get install cloud-utils cloud-initramfs-growroot cloud-init -y

#xu ly wait 120s 14
if [ $VER == '14' ]; then  
sed -i 's/dowait 120/dowait 3/g' /etc/init/cloud-init-nonet.conf ; 
fi

#cau hinh log console 
if [ $VER == '18' ]; then
sed -i 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0 console=tty1 console=ttyS0"|g' /etc/default/grub
update-grub;
elif [ $VER == '14' ]||[ $VER == '16' ]; then
sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=""|GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"|g' /etc/default/grub
update-grub;
fi

# config datasource cloudinit 14 16 18
cat << EOF >/etc/cloud/cloud.cfg.d/90_dpkg.cfg
# to update this file, run dpkg-reconfigure cloud-init
datasource_list: [ Ec2 ]
EOF

#cai qemu-ag
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
apt-get update
apt-get install qemu-guest-agent -y
service qemu-guest-agent start

#14 16
chkconfig service qemu-guest-agent on


#cai netplug chung 14 16 18
apt-get install netplug -y
wget https://raw.githubusercontent.com/uncelvel/create-images-openstack/master/scripts_all/netplug_ubuntu -O netplug
mv netplug /etc/netplug/netplug
chmod +x /etc/netplug/netplug

# 14 16 18
sed -i 's|link-local 169.254.0.0|#link-local 169.254.0.0|g' /etc/networks

#xoa mac chung 14 16 18
echo > /lib/udev/rules.d/75-persistent-net-generator.rules
echo > /etc/udev/rules.d/70-persistent-net.rules

if [ $VER == '18' ]; then
apt-get install ifupdown
cat << EOF > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
network: {config: disabled}
EOF

rm -rf /etc/netplan50-cloud-init.yaml

cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet dhcp
EOF

cloud-init clean
systemctl restart cloud-init;
fi