#!/bin/bash

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
yum install epel-release -y
yum update -y
service iptables stop
chkconfig iptables off
iptables -F
iptables -X
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
yum -y install wget vim 

# Cấu hình interface tự động up khi boot 
sed -i 's|ONBOOT=no|ONBOOT=yes|g' /etc/sysconfig/network-scripts/ifcfg-eth0

# Xóa `HWADDR` và UUID trong config
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0

#Cài đặt cloud-utils-growpart để resize đĩa cứng lần đầu boot

yum install cloud-utils-growpart dracut-modules-growroot cloud-init -y

#Rebuild initrd file (Có thể mất 1-2p)
rpm -qa kernel | sed 's/^kernel-//'  | xargs -I {} dracut -f /boot/initramfs-{}.img {}

#Cấu hình grub để đẩy log ra console
sed -Ei "s/rhgb/console=tty0/g" /boot/grub/grub.conf
sed -Ei "s/quiet/console=ttyS0,115200n8/g" /boot/grub/grub.conf
#Để máy ảo trên OpenStack có thể nhận được Cloud-init cần thay đổi cấu hình mặc định bằng cách sửa đổi file /etc/cloud/cloud.cfg.
sed -i 's/disable_root: 1/disable_root: 0/g' /etc/cloud/cloud.cfg
sed -i 's/ssh_pwauth:   0/ssh_pwauth:   1/g' /etc/cloud/cloud.cfg
sed -i 's/name: centos/name: root/g' /etc/cloud/cloud.cfg

#Để sau khi boot máy ảo, có thể nhận đủ các NIC gắn vào:
cat << EOF >> /etc/rc.local
for iface in \$(ip -o link | cut -d: -f2 | tr -d ' ' | grep ^eth)
do
   test -f /etc/sysconfig/network-scripts/ifcfg-\$iface
   if [ \$? -ne 0 ]
   then
       touch /etc/sysconfig/network-scripts/ifcfg-\$iface
       echo -e "DEVICE=\$iface\nBOOTPROTO=dhcp\nONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-\$iface
       ifup \$iface
   fi
done
EOF

#Disable Default routing (để VM có thể nhận metadata từ Cloud-init nhanh hơn)
echo "NOZEROCONF=yes" >> /etc/sysconfig/network

#Xóa nội dung 75-persistent-net-generator.rules (Tránh việc thay đổi label card mạng)
echo "" > /lib/udev/rules.d/75-persistent-net-generator.rules

#Cài đặt, kích hoạt và khởi động qemu-guest-agent service
yum install qemu-guest-agent -y
chkconfig qemu-ga on
service qemu-ga start

chkconfig qemu-guest-agent on
service qemu-guest-agent start

qemu-ga --version 
service qemu-ga status
service qemu-guest-agent status
 

#Đảm bảo interface eth0 có thể nhận DHCP (Remove config static IP của VM đóng template)
cat << EOF >> /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=dhcp
IPV4_FAILURE_FATAL=yes
NAME="System eth0"
EOF

#Clean all
yum clean all
# Xóa last logged
rm -f /var/log/wtmp /var/log/btmp
# Xóa history 
history -c
#Tắt VM
poweroff