#  Cài đặt

## Chuẩn bị:

- Set hostname + ip
```sh
hostnamectl set-hostname ceph1
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

- Update
```sh
yum install epel-release -y
yum update -y
```

- Cấu hình IP

(Thực hiện trên 3 node )

```sh

nmcli c modify ens160 ipv4.addresses 172.16.3.224/20
nmcli c modify ens160 ipv4.gateway 172.16.10.1
nmcli c modify ens160 ipv4.dns 8.8.8.8
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

nmcli c modify ens192 ipv4.addresses 10.10.22.224/24
nmcli c modify ens192 ipv4.method manual
nmcli con mod ens192 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

- Cấu hình file `/etc/hosts` ( Lưu ý diền IP dải <CEPH_COM> )
```sh
cat << EOF >> /etc/hosts
172.16.3.224 ceph1
EOF
```

## 3.2 Cài đặt Chronyd
```sh
yum -y install chrony
timedatectl set-timezone Asia/Ho_Chi_Minh

# Ở đây làm NTP server
yum -y install chrony
sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/#allow 192.168.0.0\/16/allow 172.16.4.0\/24/g' /etc/chrony.conf
```

## 3.3 Cài đặt CEPH

```sh
yum install -y wget 
wget https://download.ceph.com/rpm-luminous/el7/noarch/ceph-deploy-2.0.1-0.noarch.rpm --no-check-certificate
rpm -ivh ceph-deploy-2.0.1-0.noarch.rpm
```

- Cài đặt python-setuptools để ceph-deploy có thể hoạt động ổn định.
```
curl https://bootstrap.pypa.io/ez_setup.py | python
```

- Tao SSH KEY (o day su dung user root de deploy Ceph):
```sh
ssh-keygen
```

```sh
ssh-copy-id root@ceph1
```

-
```sh
mkdir /ceph-deploy && cd /ceph-deploy
ceph-deploy new ceph1
```
- Kiểm tra lại thông tin folder ceph-deploy:
	- `ceph.conf` : file config được tự động khởi tạo
	- `ceph-deploy-ceph.log` : file log của toàn bộ thao tác đối với việc sử dụng lệnh ceph-deploy.
	- `ceph.mon.keyring` : Key monitoring được ceph sinh ra tự động để khởi tạo Cluster.
	
- Bổ sung thêm vào file `ceph.conf`

```sh
cat << EOF >> /ceph-deploy/ceph.conf
osd pool default size = 2
osd pool default min size = 1
osd crush chooseleaf type = 0
osd pool default pg num = 128
osd pool default pgp num = 128

public network = 172.16.0.0/20
cluster network = 10.10.22.0/24
EOF
```

-	`public network` : Đường trao đổi thông tin giữa các node Ceph và cũng là đường client kết nối vào.
-	`cluster network` : Đường đồng bộ dữ liệu.

- Cài đặt CEPH Luminous
```sh
ceph-deploy install --release luminous ceph1

```

- Kiểm tra sau khi cài đặt

ceph -v 

- Khởi tạo cluster với các node mon (Monitor-quản lý) dựa trên file ceph.conf
```sh
ceph-deploy mon create-initial
```
- Sau khi thực hiện lệnh phía trên sẽ sinh thêm ra 05 file : 
- ceph.bootstrap-mds.keyring, 
- ceph.bootstrap-mgr.keyring, 
- ceph.bootstrap-osd.keyring, 
- ceph.client.admin.keyring 
và ceph.bootstrap-rgw.keyring.
 
Quan sát bằng lệnh `ll -alh`

Để node ceph1 có thể thao tác với cluster chúng ta cần gán cho node ceph1 với quyền admin bằng cách bổ sung cho node này admin.keying
```sh
ceph-deploy admin ceph1
```

5. Khởi tạo MGR
Ceph-mgr là thành phần cài đặt cần khởi tạo từ bản lumious, có thể cài đặt trên nhiều node hoạt động theo cơ chế Active-Passive.

Cài đặt ceph-mgr trên ceph1
```sh
ceph-deploy mgr create ceph1
```

Ceph-mgr hỗ trợ dashboard để quan sát trạng thái của cluster, Enable mgr dashboard trên host ceph01.
```sh
ceph mgr module enable dashboard
ceph mgr services
```

http://ceph1:7000
```sh
ceph-deploy disk zap ceph1 /dev/sdb
ceph-deploy osd create --data /dev/sdb ceph1
ceph-deploy disk zap ceph1 /dev/sdc
ceph-deploy osd create --data /dev/sdc ceph1
ceph-deploy disk zap ceph1 /dev/sdd
ceph-deploy osd create --data /dev/sdc ceph1
```

#####
Tren cac node CTL va cOM
```sh
yum install -y python-rbd ceph-common
```

#pool ceph
ceph osd pool create volumes 128 128
ceph osd pool create vms 128 128
ceph osd pool create images 128 128




- Điều chỉnh Crushmap để có thể Replicate trên OSD thay vì trên HOST
```sh
cd /home/cephuser/ceph-deploy/
sudo ceph osd getcrushmap -o crushmap
sudo crushtool -d crushmap -o crushmap.decom
sudo sed -i 's|step choose firstn 0 type osd|step chooseleaf firstn 0 type osd|g' crushmap.decom
#Sua dong nay de co the thay duoc cac OSD / vi replicatie dua vao OSD chu khong phai host
sudo crushtool -c crushmap.decom -o crushmap.new
sudo ceph osd setcrushmap -i crushmap.new
```

- Khởi tạo ban đầu trước khi sử dụng pool
```sh 
rbd pool init volumes
rbd pool init vms
rbd pool init images
```

#Glance

- Tạo key `glance`
```sh 
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images' 
```   

- Chuyển key glance sang node glance (Ở đây Glance cài trên Controller)
```sh 
ceph auth get-or-create client.glance | ssh 172.16.3.220 sudo tee /etc/ceph/ceph.client.glance.keyring
```
```
ssh 172.16.3.220 sudo tee /etc/ceph/ceph.conf < /etc/ceph/ceph.conf
ssh 172.16.3.221 sudo tee /etc/ceph/ceph.conf < /etc/ceph/ceph.conf
ceph-deploy admin controller compute
````

### 4.2 Thực hiện trên Node Controller

- Set quyền cho các key
```sh 
sudo chown glance:glance /etc/ceph/ceph.client.glance.keyring
sudo chmod 0640 /etc/ceph/ceph.client.glance.keyring
```

- Thêm cấu hinh `/etc/glance/glance-api.conf ` trên node Controller
```sh 
[DEFAULT]
show_image_direct_url = True

[glance_store]
show_image_direct_url = True
default_store = rbd
stores = file,http,rbd
rbd_store_pool = images
rbd_store_user = glance
rbd_store_ceph_conf = /etc/ceph/ceph.conf
rbd_store_chunk_size = 8
```

- Restart lại dịch vụ glance trên cả node Controller
```sh 
systemctl restart openstack-glance-*
```

- Source credential
```sh 
source admin-openrc
```

- Tạo thử images
```sh
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
openstack image create "cirros-ceph-1" \
--file cirros-0.3.5-x86_64-disk.img \
--disk-format qcow2 --container-format bare \
--public \
--os-region-name RegionOne
```
- Kiểm tra iamge tạo trên region nào:
```sh
openstack image list --os-region-name RegionOne
openstack image list --os-region-name RegionTwo
```

#CINDER

- Tạo key `cinder`
```sh
ceph auth get-or-create client.cinder mon 'allow r, allow command "osd blacklist", allow command "blacklistop"' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rwx pool=images' > ceph.client.cinder.keyring
```

ceph auth get-or-create client.cinder | ssh 172.16.3.220 sudo tee /etc/ceph/ceph.client.cinder.keyring
ceph auth get-or-create client.cinder | ssh 172.16.3.221 sudo tee /etc/ceph/ceph.client.cinder.keyring

ceph auth get-key client.cinder | ssh 172.16.3.220 tee /root/client.cinder
ceph auth get-key client.cinder | ssh 172.16.3.221 tee /root/client.cinder

- Set quyền cho các key
```sh 
sudo chown cinder:cinder /etc/ceph/ceph.client.cinder*
sudo chmod 0640 /etc/ceph/ceph.client.cinder*
```

### 5.3 Thao tác trên Node Compute

- Khởi tạo 1 `uuid` mới cho Cinder
```sh
uuidgen
```
> Output 
```sh 
4fe9880c-3b87-4261-ad51-65e9ebae7a66
```
> Lưu ý UUID này sẽ sử dụng chung cho các Compute nên chỉ cần tạo lần đầu tiên

- Tạo file xml cho phép Ceph RBD (Rados Block Device) xác thực với libvirt thông qua `uuid` vừa tạo
```sh 
cat > ceph-secret.xml <<EOF
<secret ephemeral='no' private='no'>
<uuid>4fe9880c-3b87-4261-ad51-65e9ebae7a66</uuid>
<usage type='ceph'>
	<name>client.cinder secret</name>
</usage>
</secret>
EOF
```

```sh
[root@compute01 ~]# sudo virsh secret-define --file ceph-secret.xml
Secret 4fe9880c-3b87-4261-ad51-65e9ebae7a66 created
```

- Gán giá trị của `client.cinder` cho `uuid`
```sh 
virsh secret-set-value --secret 4fe9880c-3b87-4261-ad51-65e9ebae7a66 --base64 $(cat /root/client.cinder)
```
> Output 
```sh 
Secret value set   
```


### 5.4 Quay lại node Controller
- Bổ sung cấu hinh `/etc/cinder/cinder.conf` tren cac node controller
```sh 
[DEFAULT]
my_ip = 172.16.0.243
transport_url = rabbit://openstack:dae497c1d6aa9f21660f@172.16.0.243:5672,openstack:dae497c1d6aa9f21660f@172.16.0.244:5672,openstack:dae497c1d6aa9f21660f@172.16.0.245:5672
auth_strategy = keystone
osapi_volume_listen = 172.16.0.243
glance_api_version = 2
notification_driver = messagingv2
enabled_backends = ceph
backup_driver = cinder.backup.drivers.ceph
backup_ceph_conf = /etc/ceph/ceph.conf
backup_ceph_user = cinder-backup
backup_ceph_chunk_size = 134217728
backup_ceph_pool = backups
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true
host=ceph

[ceph]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
volume_backend_name = ceph
rbd_pool = volumes
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = -1
rbd_user = cinder
rbd_secret_uuid = 4fe9880c-3b87-4261-ad51-65e9ebae7a66
report_discard_supported = true
```

- Enable cinder-backup và restart dịch vụ cinder 
```sh 
systemctl enable openstack-cinder-backup.service
systemctl start openstack-cinder-backup.service
```

- Restart lại dịch vụ trên Node Controller
```sh 
systemctl restart openstack-cinder-api.service openstack-cinder-volume.service openstack-cinder-scheduler.service openstack-cinder-backup.service
```

- Source credential
```sh 
source admin-openrc
```

- Tạo volume type node controller
```sh
cinder type-create ceph
cinder type-key ceph set volume_backend_name=ceph
```

> Lưu ý kiểm tra lại xem đang dùng Region nào









