# Hướng dẫn cài OpenStack Train multinode trên CentOS 7

## Mô hình

Cấu hình tối thiểu

CPU >= 4
Ram >= 8GB
Disk 2 ổ:

- vda - OS (>= 50 GB)
- vdb - Cinder LVM (>= 50 GB)



Sử dụng 2 Card mạng:

eth0: Dải Pulic API + SSH
eth1: Dải Provider VM