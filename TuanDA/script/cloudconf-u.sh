#!/bin/bash
sudo ufw disable

sudo timedatectl set-timezone Asia/Ho_Chi_Minh

sudo ufw disable
timedatectl set-timezone Asia/Ho_Chi_Minh

# Disable ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf 
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

#xu ly wait 120s - u14
sed -i 's/dowait 120/dowait 3/g' /etc/init/cloud-init-nonet.conf

#cau hinh log console 
sed -i 's|GRUB_CMDLINE_LINUX_DEFAULT=""|GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"|g' /etc/default/grub
update-grub

#cai cloudinit + growpart
apt-get install cloud-utils cloud-initramfs-growroot cloud-init -y

# config datasource cloudinit

cat << EOF >/etc/cloud/cloud.cfg.d/90_dpkg.cfg
# to update this file, run dpkg-reconfigure cloud-init
datasource_list: [ Ec2 ]
EOF

#cai qemu-ag
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
apt-get update
apt-get install qemu-guest-agent -y
chkconfig service qemu-guest-agent on
service qemu-guest-agent start

#cai netplug
apt-get install netplug -y
wget https://raw.githubusercontent.com/uncelvel/create-images-openstack/master/scripts_all/netplug_ubuntu -O netplug
mv netplug /etc/netplug/netplug
chmod +x /etc/netplug/netplug

sed -i 's|link-local 169.254.0.0|#link-local 169.254.0.0|g' /etc/networks

#xoa mac
echo > /lib/udev/rules.d/75-persistent-net-generator.rules
echo > /etc/udev/rules.d/70-persistent-net.rules