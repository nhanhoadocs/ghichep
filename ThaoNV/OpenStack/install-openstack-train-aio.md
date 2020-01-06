# Hướng dẫn cài OpenStack Train all in one trên CentOS 7

## Mô hình

Cấu hình tối thiểu AIO

CPU >= 4
Ram >= 8GB
Disk 2 ổ:

- vda - OS (>= 50 GB)
- vdb - Cinder LVM (>= 50 GB)



Sử dụng 2 Card mạng:

eth0: Dải Pulic API + SSH
eth1: Dải Provider VM

## Phần 1: Chuẩn bị môi trường

- Cấu hình network

```
echo "Setup IP eth0"
nmcli c modify eth0 ipv4.addresses 10.10.11.175/24
nmcli c modify eth0 ipv4.gateway 10.10.11.1
nmcli c modify eth0 ipv4.dns 8.8.8.8
nmcli c modify eth0 ipv4.method manual
nmcli con mod eth0 connection.autoconnect yes


echo "Setup IP eth1"
nmcli c modify eth1 ipv4.addresses 10.10.12.175/24
nmcli c modify eth1 ipv4.method manual
nmcli con mod eth1 connection.autoconnect yes
```

Chỉnh file `/etc/hosts`

```

```

Tắt Firewall, SELinux

```
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
```

Update hệ điều hành

```
yum install -y epel-release
yum update -y
```

Cấu hình đồng bộ thời gian

```
timedatectl set-timezone Asia/Ho_Chi_Minh

yum -y install chrony
sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf

systemctl enable chronyd.service
systemctl restart chronyd.service
chronyc sources
```

Khai báo repo và cài đặt các package cho OpenStack

```
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo

yum update -y
yum install -y centos-release-openstack-train \
   open-vm-tools python2-PyMySQL vim telnet wget curl
yum install -y python-openstackclient openstack-selinux
yum upgrade -y
```

- Cài đặt MySQL

```
yum install mariadb mariadb-server python2-PyMySQL -y
```

```
cat << EOF >> /etc/my.cnf.d/openstack.cnf
[mysqld]
bind-address = 10.10.11.175

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
```

Enable và start MySQL

```
systemctl enable mariadb.service --now
```

Config mysql

`mysql_secure_installation`

Cài đặt RabbitMQ

`yum install rabbitmq-server -y`

Start va enable

`systemctl enable rabbitmq-server.service --now`

Tạo user và gán quyền

```
rabbitmqctl add_user openstack Welcome123
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
```

- Cài đặt Memcached

```
yum install memcached python-memcached -y
sed -i "s/-l 127.0.0.1,::1/-l 10.10.11.175/g" /etc/sysconfig/memcached
systemctl enable memcached.service --now
```

## Phần 2: Cài đặt keystone

```
mysql -uroot -pWelcome123
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost'  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Welcome123';
FLUSH PRIVILEGES;
exit;
```

- Cài package

`yum install openstack-keystone httpd mod_wsgi -y`

- Backup cấu hình

`mv /etc/keystone/keystone.{conf,conf.bk}`

- Cấu hình cho Keystone

```
cat << EOF >> /etc/keystone/keystone.conf
[DEFAULT]
[application_credential]
[assignment]
[auth]
[cache]
[catalog]
[cors]
[credential]
[database]
connection = mysql+pymysql://keystone:Welcome123@10.10.11.175/keystone
[domain_config]
[endpoint_filter]
[endpoint_policy]
[eventlet_server]
[federation]
[fernet_receipts]
[fernet_tokens]
[healthcheck]
[identity]
[identity_mapping]
[jwt_tokens]
[ldap]
[memcache]
[oauth1]
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[policy]
[profiler]
[receipt]
[resource]
[revoke]
[role]
[saml]
[security_compliance]
[shadow_users]
[token]
provider = fernet
[tokenless_auth]
[totp]
[trust]
[unified_limit]
[wsgi]
EOF
```

- Phân quyền

```
chown root:keystone /etc/keystone/keystone.conf
```

- Populate db

`su -s /bin/sh -c "keystone-manage db_sync" keystone`

- Khởi tạo key repo

```
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

- Bootstrap service

```
keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://10.10.11.175:5000/v3/ \
  --bootstrap-internal-url http://10.10.11.175:5000/v3/ \
  --bootstrap-public-url http://10.10.11.175:5000/v3/ \
  --bootstrap-region-id RegionOne
```

- Cấu hình apache cho keystone

`sed -i 's|#ServerName www.example.com:80|ServerName 10.10.11.175|g' /etc/httpd/conf/httpd.conf`

- Create symlink cho keystone api

```
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
```

- Start service 

`systemctl enable httpd.service --now`

- Tạo file biến môi trường openrc-admin cho tài khoản quản trị

```
cat << EOF >> admin-openrc
export export OS_REGION_NAME=RegionOne
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://10.10.11.175:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
```

### Tạo domain, projects, users, và roles

- Tạo project service 

```
openstack project create --domain default \
  --description "Service Project" service
```

- Tạo project myproject 

```
openstack project create --domain default \
  --description "Demo Project" myproject
```

- Tạo user `myuser`

```
openstack user create --domain default \
  --password Welcome123 myuser
```

- Tạo role `myrole`

`openstack role create myrole`

- Thêm role `myrole` cho user `myuser`

`openstack role add --project myproject --user myuser myrole`

- Kiểm tra 

`openstack token issue`

## Phần 3: Glance 

- Đăng nhập vào MySQL

`mysql -uroot -pWelcome123`

- Create DB và User cho Glance

```
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost'  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Welcome123';
FLUSH PRIVILEGES;
exit;
```

Tạo user glance

`source admin-openrc`

`openstack user create --domain default --password Welcome123 glance`

Thêm roles admin cho user glance trên project service

`openstack role add --project service --user glance admin`

Kiểm tra lại user glance

`openstack role list --user glance --project service`

Khởi tạo dịch vụ glance

`openstack service create --name glance --description "OpenStack Image" image`

Tạo các enpoint cho glane

```
openstack endpoint create --region RegionOne image public http://10.10.11.175:9292
openstack endpoint create --region RegionOne image internal http://10.10.11.175:9292
openstack endpoint create --region RegionOne image admin http://10.10.11.175:9292
```

Cài đặt package

`yum install -y openstack-glance`

Backup cấu hình glance-api

`mv /etc/glance/glance-api.{conf,conf.bk}`

Cấu hình glance-api

```
cat << EOF >> /etc/glance/glance-api.conf
[DEFAULT]
[cinder]
[cors]
[database]
connection = mysql+pymysql://glance:Welcome123@10.10.11.175/glance
[file]
[glance.store.http.store]
[glance.store.rbd.store]
[glance.store.sheepdog.store]
[glance.store.swift.store]
[glance.store.vmware_datastore.store]
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
[image_format]
[keystone_authtoken]
www_authenticate_uri  = http://10.10.11.175:5000
auth_url = http://10.10.11.175:5000
memcached_servers = 10.10.11.175:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = Welcome123
[oslo_concurrency]
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[paste_deploy]
flavor = keystone
[profiler]
[store_type_location_strategy]
[task]
[taskflow_executor]
EOF
```

Phân quyền lại file cấu hình

`chown root:glance /etc/glance/glance-api.conf`

- Populate db

`su -s /bin/sh -c "glance-manage db_sync" glance`

- Enable service 

`systemctl enable openstack-glance-api.service --now`

- Download image 

`wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img`

- Upload image 

```
openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img \
--disk-format qcow2 --container-format bare --public
```

- Kiểm tra lại 

`openstack image list`

## Phần 4: Placement service 

- Tạo db 

```
mysql -u root -pWelcome123
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' \
  IDENTIFIED BY 'Welcome123';
```

- Tạo user

`source admin-openrc`

`openstack user create --domain default --password Welcome123 placement`

- Gán role 

`openstack role add --project service --user placement admin`

- Tạo service 

```
openstack service create --name placement \
  --description "Placement API" placement
```

- Tạo endpoint 

```
openstack endpoint create --region RegionOne \
  placement public http://10.10.11.175:8778
openstack endpoint create --region RegionOne \
  placement internal http://10.10.11.175:8778
openstack endpoint create --region RegionOne \
  placement admin http://10.10.11.175:8778
```

- Cài đặt service 

`yum install openstack-placement-api -y`

- Backup cấu hình

`mv /etc/placement/placement.{conf,conf.bk}`

- Cấu hình

```
cat << EOF >> /etc/placement/placement.conf
[DEFAULT]
[api]
auth_strategy = keystone
[cors]
[keystone_authtoken]
auth_url = http://10.10.11.175:5000/v3
memcached_servers = 10.10.11.175:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = Welcome123
[oslo_policy]
[placement]
[placement_database]
connection = mysql+pymysql://placement:Welcome123@10.10.11.175/placement
[profiler]
EOF
```

- Phân quyền 

`chown root:placement /etc/placement/placement.conf`

- Populate db 

`su -s /bin/sh -c "placement-manage db sync" placement`

- Thêm cấu hình virtualhost

```
cp /etc/httpd/conf.d/00-placement-api.conf /etc/httpd/conf.d/00-placement-api.conf.org
cat << 'EOF' >> /etc/httpd/conf.d/00-placement-api.conf


<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>
EOF
```

- Restart http 

`systemctl restart httpd`

- Verify 

`placement-status upgrade check`

## Phần 5: Cài đặt nova 

- Tạo db 

```
mysql -u root -pWelcome123
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
exit
```

- Tạo user

`source admin-openrc`

`openstack user create --domain default --password Welcome123 nova`

- Thêm role admin 

`openstack role add --project service --user nova admin`

- Tạo service nova 

```
openstack service create --name nova \
  --description "OpenStack Compute" compute
```

- Tạo endpoint 

```
openstack endpoint create --region RegionOne \
  compute public http://10.10.11.175:8774/v2.1
openstack endpoint create --region RegionOne \
  compute internal http://10.10.11.175:8774/v2.1
openstack endpoint create --region RegionOne \
  compute admin http://10.10.11.175:8774/v2.1
```

- Cài package 

`yum install openstack-nova-api openstack-nova-conductor openstack-nova-novncproxy openstack-nova-scheduler openstack-nova-compute -y`

- Backup cấu hình nova

`mv /etc/nova/nova.{conf,conf.bk}`

- Cấu hình cho nova

```
cat << EOF >> /etc/nova/nova.conf
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:Welcome123@10.10.11.175:5672/
my_ip = 10.10.11.175
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
allow_resize_to_same_host=True
[api]
auth_strategy = keystone
[api_database]
connection = mysql+pymysql://nova:Welcome123@10.10.11.175/nova_api
[barbican]
[cache]
[cinder]
[compute]
[conductor]
[console]
[consoleauth]
[cors]
[database]
connection = mysql+pymysql://nova:Welcome123@10.10.11.175/nova
[devices]
[ephemeral_storage_encryption]
[filter_scheduler]
[glance]
api_servers = http://10.10.11.175:9292
[guestfs]
[healthcheck]
[hyperv]
[ironic]
[key_manager]
[keystone]
[keystone_authtoken]
www_authenticate_uri = http://10.10.11.175:5000/
auth_url = http://10.10.11.175:5000/
memcached_servers = 10.10.11.175:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = Welcome123
[libvirt]
virt_type = qemu
[metrics]
[mks]
[neutron]
[notifications]
[osapi_v21]
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[pci]
[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://10.10.11.175:5000/v3
username = placement
password = Welcome123
[powervm]
[privsep]
[profiler]
[quota]
[rdp]
[remote_debug]
[scheduler]
discover_hosts_in_cells_interval = 300
[serial_console]
[service_user]
[spice]
[upgrade_levels]
[vault]
[vendordata_dynamic_auth]
[vmware]
[vnc]
enabled = true
server_listen = 0.0.0.0
server_proxyclient_address = 10.10.11.175
novncproxy_base_url = http://10.10.11.175:6080/vnc_auto.html
[workarounds]
[wsgi]
[xenserver]
[xvp]
[zvm]
EOF
```

- Phân quyền 

`chown root:nova /etc/nova/nova.conf`

- Populate nova_api db 

`su -s /bin/sh -c "nova-manage api_db sync" nova`

- Register cell0 db 

`su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova`

- Tạo cell1

`su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova`

- Populate nova db

`su -s /bin/sh -c "nova-manage db sync" nova`

- Verify 

```
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
```

- Start & enable 

```
systemctl enable --now \
    openstack-nova-api.service \
    openstack-nova-scheduler.service \
    openstack-nova-conductor.service \
    openstack-nova-novncproxy.service \
    openstack-nova-compute \
    libvirtd.service
```

- Discover compute host

`su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`

- verify 

```
source admin-openrc
openstack compute service list
nova-status upgrade check
```

## Phần 6: Cài đặt neutron 

- Tạo db 

```
mysql -u root -pWelcome123
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY 'Welcome123';
exit
```

- Tạo user 

`openstack user create --domain default --password Welcome123 neutron`

- Gan role 

`openstack role add --project service --user neutron admin`

- Tao service

```
openstack service create --name neutron \
  --description "OpenStack Networking" network
```

- Tao endpoint 

```
openstack endpoint create --region RegionOne \
  network public http://10.10.11.175:9696
openstack endpoint create --region RegionOne \
  network internal http://10.10.11.175:9696
openstack endpoint create --region RegionOne \
  network admin http://10.10.11.175:9696
```

- Cai package 

```
yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables -y
```

- Backup cấu hình neutron

`mv /etc/neutron/neutron.{conf,conf.bk}`

- Cấu hình neutron

```
cat << EOF >> /etc/neutron/neutron.conf
[DEFAULT]
core_plugin = ml2
service_plugins = router
transport_url = rabbit://openstack:Welcome123@10.10.11.175
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
[cors]
[database]
connection = mysql+pymysql://neutron:Welcome123@10.10.11.175/neutron
[keystone_authtoken]
www_authenticate_uri = http://10.10.11.175:5000
auth_url = http://10.10.11.175:5000
memcached_servers = 10.10.11.175:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = Welcome123
[nova]
auth_url = http://10.10.11.175:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = Welcome123
[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[privsep]
[ssl]
EOF
```

- Backup config ml2_config

`mv /etc/neutron/plugins/ml2/ml2_conf.{ini,ini.bk}`

- Cấu hình ml2_config

```
cat << EOF >> /etc/neutron/plugins/ml2/ml2_conf.ini
[DEFAULT]
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security
[ml2_type_flat]
flat_networks = provider
[securitygroup]
enable_ipset = true
EOF
```

- Backup lại config linuxbridge_agent

`mv /etc/neutron/plugins/ml2/linuxbridge_agent.{ini,init.bk}`

- Cấu hình cho linuxbridge_agent

```
cat << EOF >> /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[DEFAULT]
[linux_bridge]
physical_interface_mappings = provider:eth1
[vxlan]
enable_vxlan = true
local_ip = 10.10.11.175
l2_population = true
[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
EOF
```

- Thêm rule

```
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
echo 'net.bridge.bridge-nf-call-ip6tables = 1' >> /etc/sysctl.conf
modprobe br_netfilter
/sbin/sysctl -p
```

- Backup cấu hình l3_agent

`mv /etc/neutron/l3_agent.{ini,ini.bk}`

- Cấu hình l3_agent

```
cat << EOF >> /etc/neutron/l3_agent.ini
[DEFAULT]
interface_driver = linuxbridge
EOF
```

- Backup cấu hình dhcp_agent

`mv /etc/neutron/dhcp_agent.{ini,ini.bk}`

- Cấu hình dhcp agent

```
cat << EOF >> /etc/neutron/dhcp_agent.ini
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
EOF
```

- Backup cấu hình metadata_agent

`mv /etc/neutron/metadata_agent.{ini,ini.bk}`

- Cấu hình metadata agent

```
cat << EOF >> /etc/neutron/metadata_agent.ini
[DEFAULT]
nova_metadata_host = 10.10.11.175
metadata_proxy_shared_secret = Welcome123
EOF
```

- Phân quyền 

`chown root:neutron /etc/neutron/neutron.conf /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/l3_agent.ini /etc/neutron/dhcp_agent.ini /etc/neutron/metadata_agent.ini`

- Bổ sung cấu hình file `/etc/nova/nova.conf`

```
[neutron]
url = http://10.10.11.175:9696
auth_url = http://10.10.11.175:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = Welcome123
service_metadata_proxy = true
metadata_proxy_shared_secret = Welcome123
```

- Tạo symlink 

`ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini`

- Populate db 

```
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
```

- Restart `Compute API`

`systemctl restart openstack-nova-api.service`

- Enable service 

`systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service neutron-l3-agent.service --now`

## Phần 7: Cài đặt horizon 

- Cài đặt packages

`yum install -y openstack-dashboard`

- Tạo file direct

```
filehtml=/var/www/html/index.html
touch $filehtml
cat << EOF >> $filehtml
<html>
<head>
<META HTTP-EQUIV="Refresh" Content="0.5; URL=http://10.10.11.175/dashboard">
</head>
<body>
<center> <h1>Redirecting to OpenStack Dashboard</h1> </center>
</body>
</html>
EOF
```

- Backup file cấu hình

`cp /etc/openstack-dashboard/{local_settings,local_settings.bk}`

- Chỉnh sửa cấu hình file `/etc/openstack-dashboard/local_settings`

```
ALLOWED_HOSTS = ['*',]
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 3,
}
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': '10.10.11.175:11211',
    }
}
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
OPENSTACK_HOST = "10.10.11.175"
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "myrole"

TIME_ZONE = "Asia/Ho_Chi_Minh"
WEBROOT = '/dashboard/'
```

Thêm config httpd cho dashboard

`echo "WSGIApplicationGroup %{GLOBAL}" >> /etc/httpd/conf.d/openstack-dashboard.conf`

Restart service httpd và memcached

`systemctl restart httpd.service memcached.service`