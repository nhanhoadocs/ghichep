#!/bin/bash
#Swap Ubuntu 16.04

# Tao swapfile
echo "Nhap dung luong swap can tao GB (VD: 4)"
read swap
fallocate -l "$swap"G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
swapon --show
sleep 3
# Chinh sua de luu cau hinh khi reboot
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
free -m

echo "DONE"
