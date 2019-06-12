# Cấu hình Cobbler

## Set biến 
```
# Services IP Address on the server - IP đường PXE
IP_ADDR=192.168.22.51
IP_GATEWAY=192.168.22.1
NETMASK=255.255.255.0
NETDEVICE=eth2
NETPREFIX=24
NETWORK=192.168.22.0

DHCP_MIN_HOST=192.168.22.150
DHCP_MAX_HOST=192.168.22.200
```

## Cấu hình network server
```
echo "Setup IP  eth0"
nmcli con modify eth0 ipv4.addresses 192.168.20.51/24
nmcli con modify eth0 ipv4.method manual
nmcli con mod eth0 connection.autoconnect yes

echo "Setup IP  eth1"
nmcli con modify eth1 ipv4.addresses 192.168.21.51/24
nmcli con modify eth1 ipv4.method manual
nmcli con mod eth1 connection.autoconnect yes

echo "Setup IP  eth2"
nmcli con modify eth2 ipv4.addresses 192.168.22.51/24
nmcli con modify eth2 ipv4.gateway 192.168.22.1
nmcli con modify eth2 ipv4.dns 8.8.8.8
nmcli con modify eth2 ipv4.method manual
nmcli con modify eth2 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
```

**Hoặc sử dụng firewalld**
```
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=69/tcp --permanent
firewall-cmd --add-port=69/udp --permanent
firewall-cmd --add-port=4011/udp --permanent
firewall-cmd --reload
```

## Cài đặt
```
yum install epel-release -y
yum install wget cobbler cobbler-web dnsmasq syslinux pykickstart xinetd bind bind-utils dhcp debmirror pykickstart fence-agents-all -y

systemctl start cobblerd
systemctl enable cobblerd
systemctl start httpd
systemctl enable httpd
```

## Chỉnh các tham số
```sh
sed -i "s/127\.0\.0\.1/${IP_ADDR}/" /etc/cobbler/settings
sed -i "s/manage_dhcp: .*/manage_dhcp: 1/" /etc/cobbler/settings
sed -i "s/subnet .* netmask .* {/subnet $NETWORK netmask $NETMASK {/" /etc/cobbler/dhcp.template
sed -i "s/option routers .*/option routers             ${IP_GATEWAY};/" /etc/cobbler/dhcp.template
sed -i "s/option domain-name-servers .*/option domain-name-servers 8.8.8.8;/" /etc/cobbler/dhcp.template
sed -i "s/range dynamic-bootp .*/range dynamic-bootp        ${DHCP_MIN_HOST} ${DHCP_MAX_HOST};/" /etc/cobbler/dhcp.template
sed -i "s/disable.*/disable\t\t\t= no/" /etc/xinetd.d/tftp
sed -i "s/^@dists/#@dists/" /etc/debmirror.conf
sed -i "s/^@arches/#@arches/" /etc/debmirror.conf
```

## Restart lại các services
```sh
systemctl enable rsyncd.service
systemctl restart rsyncd.service
systemctl restart cobblerd
systemctl restart xinetd
systemctl enable xinetd
systemctl enable dhcpd
```

## Download ISO và giải nén
```sh
cd /root
wget http://mirrors.nhanhoa.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso
mkdir /mnt/centos
mount -o loop /root/CentOS-7-x86_64-Minimal-1810.iso  /mnt/centos/
cobbler import --arch=x86_64 --path=/mnt/centos --name=CentOS7
cd /var/lib/cobbler/kickstarts
wget https://raw.githubusercontent.com/MinhKMA/meditech-thuctap/master/MinhNV/ghi_chep_pxe/cobbler/centos7.ks
```

**Sử dụng openssl để sinh ra mật khẩu đã được mã hóa**
```
 openssl passwd -1
 Password: Thanglong2019#@!
 Verifying - Password: Thanglong2019#@!
 $1$gjuhkmEg$mx9FyR5xZVNZRDp7j7/no/
```
- Thay thế trong file `centos7.ks`

``` 
sed -i "s/127\.0\.0\.1/${IP_ADDR}/" /var/lib/cobbler/kickstarts/centos7.ks
cobbler profile edit --name=CentOS7-x86_64 --kickstart=/var/lib/cobbler/kickstarts/centos7.ks

cobbler get-loaders
cobbler check
cobbler sync
```

**Với máy tạo từ virt-manager nên tạo min 2GB**
**Đăng nhập web bị lỗi**:
- https://192.168.22.51/cobbler_web
```sh
yum install python-pip -y
pip install Django==1.8.19
systemctl restart httpd.service
```

**Thay đổi password web**
htdigest /etc/cobbler/users.digest "Cobbler" cobbler

**Commmand**
```
cobbler status
cobbler list
cobbler profile list
cobbler sync
cobbler distro add : thêm distro
cobbler distro copy : copy từ một distro ra một distro mới.
cobbler distro edit : sửa thông tin distro
cobbler distro find : tìm kiếm thông tin về distro
cobbler distro list : liệt kê danh sách các distro
cobbler distro remove : xóa distro nào đó khỏi hệ thống cobbler
cobbler distro rename : đổi tên cobbler
cobbler distro report : Hiển thị các thông tin chi tiết về distro
```

**Khi thay đổi cấu hình KS cần cobbler sync lại**

