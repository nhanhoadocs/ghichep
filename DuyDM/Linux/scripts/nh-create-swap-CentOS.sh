#!/bin/bash
# Date: 29.09.2018 a Cong


echo "Nhap dung luong swap can tao GB (VD: 4)"
read swap
fallocate -l "$swap"G /swapfile
#sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sleep 3
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
echo "DONE"
