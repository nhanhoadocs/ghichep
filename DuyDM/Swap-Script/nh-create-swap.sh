#!/bin/bash
# Date: 29.09.2018
# Cach thuc hien
# wget https://gist.githubusercontent.com/congto/3278014e1b64906789070b94963a8648/raw/e686b9ae91b155b9090a9cfaced612286a225163/nh-create-swap.sh
# bash nh-create-swap.sh


sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab

echo "DONE"
