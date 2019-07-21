# Tạo pool và thực hiện mount RBD vào Ceph-Client

### CEPH 1
- MNGT : 172.16.0.235
- CEPH COM : 10.10.13.235
- CEPH REPLICATION : 10.10.14.235

### CEPH 2
- MNGT : 172.16.0.236
- CEPH COM : 10.10.13.236
- CEPH REPLICATION : 10.10.14.236

### CEPH 3
- MNGT : 172.16.0.237
- CEPH COM : 10.10.13.237
- CEPH REPLICATION : 10.10.14.237

### CEPH - Client
- MNGT : 172.16.2.7
- CEPH COM : 10.10.13.234

## 1. Trên node Ceph cài đặt Ceph-Client:
- CentOS:
```sh
yum install ceph-common -y
```

- Ubuntu:
```sh 
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-luminous/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
```

- Update và cài đặt ceph-common
```sh 
apt-get -y update
apt-get install -y ceph-common
```

- Copy key và config sang node Client
```sh
cd /ceph-deploy
scp ceph.conf root@10.10.13.234:/etc/ceph/
scp ceph.client.admin.keyring root@10.10.13.234:/etc/ceph/
```

Đứng trên Node Client kiểm tra kết nối Ceph
```
ceph -s
```

## 2. 
Khỏi tạo pool cho cụm Ceph sử dụng : https://ceph.com/pgcalc/

Kiểm tra

Thao tác trên Node Ceph create image
```ssh
rbd create {pool-name}/{images} --size {size}G
```

- Ví dụ:
```sh
[root@ceph1 ceph-deploy]# rbd create volumes/vm01 --size 20G                       
[root@ceph1 ceph-deploy]# rbd ls -p volumes
vm01
[root@ceph1 ceph-deploy]# rbd info volumes/vm01
rbd image 'vm01':
        size 20GiB in 5120 objects
        order 22 (4MiB objects)
        block_name_prefix: rbd_data.5e3c6b8b4567
        format: 2
        features: layering, exclusive-lock, object-map, fast-diff, deep-flatten
        flags: 
        create_timestamp: Tue May 28 16:52:58 2019

```


# Thao tác Load rbd module (trên Client)
```sh
sudo modprobe rbd
```

Map images to a block device
```sh
sudo rbd map vol01 --pool datastore --name client.admin [-m {mon-IP}] [-k /path/to/ceph.client.admin.keyring]
```

Ví dụ:
```sh
sudo rbd map vm01 --pool volumes --name client.admin -m 10.10.13.235 -k /path/to/ceph.client.admin.keyring
```

- Nếu trên node Client báo lỗi `rbd: image vm01: image uses unsupported features: 0x38` :
```sh
#trên node Ceph
rbd feature disable volumes/vm01 exclusive-lock object-map fast-diff deep-flatten
```

**Auto mount khi reboot**

- Add config vào rbdmap trên ceph client
```sh
echo "{pool-name}/{images}            id=admin,keyring=/etc/ceph/ceph.client.admin.keyring" >> /etc/ceph/rbdmap
```
```sh
echo "images/vol2           id=admin,keyring=/etc/ceph/ceph.client.admin.keyring" >> /etc/ceph/rbdmap
```

- Kiểm tra
```sh
sudo modprobe rbd
rbd feature disable {pool-name}/{images}  exclusive-lock object-map fast-diff deep-flatten
systemctl start rbdmap && systemctl enable rbdmap
```

```sh
sudo modprobe rbd
rbd feature disable images/vol2  exclusive-lock object-map fast-diff deep-flatten
systemctl start rbdmap && systemctl enable rbdmap
```

- Chỉnh file `/etc/lvm/lvm.conf`
```sh
	# By default we accept every block device:
		types = [ "rbd", 1024 ]
		filter = [ "r|/dev/sdb1|", "r|/dev/disk/|", "r|/dev/block/|", "a/.*/" ]

	# Or `partprobe rbd0`
```

- Tạo physical volume cho LVM : 

`pvcreate /dev/rbd0p1`

- Device /dev/rbd0p1 not found (or ignored by filtering).
/etc/lvm/lvm.conf

--> Solutions http://ceph-devel.vger.kernel.narkive.com/UZvvBAGo/poor-read-performance-on-rbd-lvm-lvm-overload
dir = "/dev"
scan = [ "/dev/rbd" ,"/dev" ]
preferred_names = [ ]
#filter = [ "a/.*/" ]
filter = [ "a|/dev/sd*|", "a|/dev/rbd*|", "r|.*|"  ]
types = [ "rbd", 250 ]

- Check physical volume:
`
pvscan
`

- Tạo volume group
`
vgcreate VG1 /dev/rbd0p1
`

- Check volume group
`
vgscan
`

- Create Logical Volume 
`
lvcreate -L 19G -n LV VG1
`

- Format & mount Lv
`
mkfs -t ext4 /dev/VG1/LV

mkdir /mnt/mountpoint
mount -t ext4 /dev/VG1/LV /mnt/mountpoint
`

Resizing a Logical Volume:
```sh
rbd resize --size 25000 volumes/vm01
```

Ví dụ:
```sh
[root@ceph1 ceph-deploy]# rbd ls -p volumes
vm01
[root@ceph1 ceph-deploy]# rbd info volumes/vm01
rbd image 'vm01':
        size 20GiB in 5120 objects
        order 22 (4MiB objects)
        block_name_prefix: rbd_data.5e3c6b8b4567
        format: 2
        features: layering
        flags: 
        create_timestamp: Tue May 28 16:52:58 2019
[root@ceph1 ceph-deploy]# rbd resize --size 25000 volumes/vm01
Resizing image: 100% complete...done.
[root@ceph1 ceph-deploy]# rbd info volumes/vm01                
rbd image 'vm01':
        size 24.4GiB in 6250 objects
        order 22 (4MiB objects)
        block_name_prefix: rbd_data.5e3c6b8b4567
        format: 2
        features: layering
        flags: 
        create_timestamp: Tue May 28 16:52:58 2019
```

- Thực hiện fdisk rbd0
```sh
fdisk /dev/rbd0
```
- Sau khi tạo thêm 1 partition:
```sh
root@nhanhoa-vm:/etc/ceph# fdisk -l
Disk /dev/sda: 16 GiB, 17179869184 bytes, 33554432 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc948f912

Device     Boot    Start      End  Sectors  Size Id Type
/dev/sda1  *        2048 31553535 31551488   15G 83 Linux
/dev/sda2       31555582 33552383  1996802  975M  5 Extended
/dev/sda5       31555584 33552383  1996800  975M 82 Linux swap / Solaris

Disk /dev/rbd0: 24.4 GiB, 26214400000 bytes, 51200000 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 4194304 bytes / 4194304 bytes
Disklabel type: dos
Disk identifier: 0x2dc95128

Device      Boot    Start      End  Sectors  Size Id Type
/dev/rbd0p1          8192 41943039 41934848   20G 83 Linux
/dev/rbd0p2      41943040 51199999  9256960  4.4G 83 Linux
```

- The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8)
```sh
partprobe /dev/rbd0
```

- Kiểm tra lại partition:
```sh
cat /proc/partitions 
```

- Tạo PV từ rbd0p2
```sh
pvcreate /dev/rbd0p2
```

- Extend VG:
```sh
vgextend VG1 /dev/rbd0p2
```

- Extend LV:
```sh
lvextend -L+4G /dev/VG1/LV 

resize2fs /dev/VG1/LV 
```
