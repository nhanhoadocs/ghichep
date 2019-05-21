
# Cấu hình network

## Chinh sua em3
```sh
/etc/sysconfig/network-scripts/ifcfg-em3
TYPE=Ethernet
BOOTPROTO=none
NAME=em3
DEVICE=em3
ONBOOT=yes
```
Tạo subinterface để nhận IP (mode trên switch là mode `trunk`):
```
/etc/sysconfig/network-scripts/ifcfg-em3.70
DEVICE=em3.70
BOOTPROTO=none
ONBOOT=yes
VLAN=yes
BRIDGE=vlan70
TYPE=Ethernet
NM_CONTROLLED=no
IPADDR=192.168.70.82
PREFIX=24
GATEWAY=192.168.70.1
```
Cấu hình DNS:
```sh
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

# Update và cài đặt package

```sh
yum update --exclude=kernel -y
yum install bridge-utils -y

yum install qemu-kvm libvirt-bin libvirt bridge-utils virt-manager -y
```

Trong đó:
- qemu-kvm: Phần phụ trợ cho KVM.
- libvirt-bin: cung cấp libvirt mà bạn cần quản lý qemu và KVM bằng libvirt.
- bridge-utils: chứa một tiện ích cần thiết để tạo và quản lý các thiết bị bridge.
- virt-manager: cung cấp giao diện đồ họa để quản lý máy ảo.
- Kiểm tra để chắc chắn rằng KVM đã được cài đặt:

```sh
# lsmod | grep kvm
kvm_intel             204800  0
kvm                   593920  1 kvm_intel
irqbypass              16384  1 kvm
```

Sửa đổi cấu hình Bridge:
/etc/sysconfig/network-scripts/ifcfg-vlan70

```sh
DEVICE=vlan70
TYPE=Bridge
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
IPADDR=192.168.70.82
PREFIX=24
GATEWAY=192.168.70.1
```

/etc/sysconfig/network-scripts/ifcfg-em3.70
```sh
DEVICE=em3.70
BOOTPROTO=none
ONBOOT=yes
VLAN=yes
BRIDGE=vlan70
TYPE=Ethernet
NM_CONTROLLED=no
```


Đối với bản Minimal để dùng được công cụ đồ họa virt-manager người dùng phải cài đặt gói x-window bằng câu lệnh

```sh
yum install "@X Window System" xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils -y
```

Start dịch vụ libvirt và cho nó khởi động cùng hệ thống

```sh
systemctl start libvirtd
systemctl enable libvirtd
```

# Cài đặt trên host KVM

Để Webvirtmgr có thể kết nối đến Host KVM và quản lý được các VM trong host KVM ta cần cấu hình một số thông tin sau trên host KVM:

Trên môi trường lab tiến hành tắt firewalld

```sh
systemctl stop firewalld
```

Nếu ko muốn bạn có thể mở port 16509 để webvirtmgr có thể kết nối đến

Bỏ comment và chỉnh sửa một số dòng sau trong file `/etc/libvirt/libvirtd.conf` :

```sh
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
listen_addr = "0.0.0.0"
auth_tcp = "none"
```

Bỏ comment các dòng trong file `/etc/libvirt/qemu.conf`
```sh
user = "root"

group = "root"
```

Bỏ comment dòng LIBVIRTD_ARGS=”--listen” trong file `/etc/sysconfig/libvirtd`

```sh
Restart libvirtd

systemctl restart libvirtd
```

## Add storage

- Kiểm tra các ổ hiện đang gắn vào server:

```
fdisk -l
```

- Tiến hành tạo phân vùng :

```
fdisk /dev/sdb
```
		m : xem hướng dẫn
		n : new partition
		p : primary
		default Partition number
		default First sector
		+890G
		w :  Ghi lại thay đổi vào đĩa - phải rất cẩn thận khi sử dụng lệnh này!!
		
![](/images/fdisk.png)

- Kiểm tra lại bằng `fdisk -l`

- Tạo PV: 
```sh
[root@kvm7082 ~]# pvcreate /dev/sdb1
  Physical volume "/dev/sdb1" successfully created.
```
- Tao VG:
```sh
[root@kvm7082 ~]# vgcreate vg-kvm /dev/sdb1 
  Volume group "vg-kvm" successfully created
```
- Tao LVM: (dung lượng nhỏ hơn)
```
[root@kvm7082 ~]# lvcreate -L 889G -n lv-kvm vg-kvm  
  Logical volume "lv-kvm" created.
```
- Dùng `lvscan` để kiểm tra lại LV đã tạo đã chính xác và ACTIVE chưa:
```
[root@kvm7082 ~]# lvscan
  ACTIVE            '/dev/vg-kvm/lv-kvm' [889.00 GiB] inherit
  ACTIVE            '/dev/centos_kvm7082/root' [213.58 GiB] inherit
```
- Format ext4
```
mkfs.ext4 /dev/vg-kvm/lv-kvm
```
- Tạo thư mục /kvm và mount:
```
mount /dev/vg-kvm/lv-kvm /kvm
```

- Sửa trong `/etc/fstab`. Thêm dòng:
```
UUID=<ID> /data ext4 defaults 0 0
```

**Để tìm ID ổ cứng dùng lệnh `blkid`**

## Add vào Webvirtmgr

Chọn host add storage:

![](/images/addkvm_1.png)

Chọn phần Storage:

![](/images/addkvm_2.png)

New Storage:

![](/images/addkvm_3.png)

Điền thông tin thư mục đã mount ở trên và chọn kiểu DIR, nhấn CREATE:

![](/images/addkvm_4.png)

# Cấu hình allow và deny

Thêm vào `/etc/hosts.allow` : 

`
sshd: 192.168.70.*,27.72.59.135
`

Thêm vào `/etc/hosts.deny` :

`
sshd: ALL
`