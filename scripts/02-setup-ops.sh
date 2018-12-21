#!/bin/bash
# Install Compute
# ManhDV NhanHoa Cloud Team 

source /root/00-setting.sh 

echo -e "\033[36m  ########### Cau hinh SSH key ########## \033[0m"
sleep 3

mkdir /root/.ssh
cat << EOF > /root/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAoGDp/5RFwlyo2UoBr/4zl7vAYgjXLaZRuEY08y8akmH9C+Xw
i53pPYL9XqOEUkhof8LATlyv7WVKc4MgziQMaQsAGqXR1U3ow9HnZs1ZGChn+7HS
imQHBiE8AjKiYVVp4qG6COvlDR5JkMg3aCRo/HtjRx9CyuwXLQ1C1Q0kg3Xq5XkD
+VXOIHheMBx5EdLwa5EjmODBuvOFNauYwRHM2xITrXHpmXB7wHu0NWNyM6lB9K8O
5wpa6jhyogQ3Z/t5Dj/gxkCtbJHQ/urvw3gAN9gSBTllOwTf0bph4E9V6/274196
BZJeV1gZKTIpRxn4Fq4vsAXEB1wkNB5VGlQ2TQIDAQABAoIBAFIHP6fpPoTav8Hj
iFlruxewgAWkX+qJVuLZhducDAsy8ypSwWWnrtQ3W0A8gkFTp58xDQsHfTP+ysWq
G+1TosVXSwZWKazf3F3Lzn9WKGuivwyNNxJxduY7uWWmYEdIWJACCBToEo9THm1e
+nfZp5j7wxttccw4VOJGFhjCUBqsNdyDgmuBuS213TSQq3c8U9rsOFnxrGZp2g+S
dtDJq+tn2WpGdJamybO0aoV9BkawMUHyD//dp3yJhCDCDjO9P3e+Rn3BgU6xyd2V
k98En7lunAenaUEMpNLzOPoO/i+aIyXLwDSb3kzcbRrAiyNGR3n2DaaFsrOiFlTa
NSGP0EECgYEAzZX8DhwooZqijPn+xGAliPLhh6PuEhXfa+pS04SlDMZlRka2DwKK
htT0c36QbY9ZhVNqT4qAvHc7jRtndkv5X7WIXQueafnUjd/ebMUf27VqygNNlh5h
5lhdKknVwvJ0AdJ3gYk+alFGTSVRjg81hwwkpMH6qIsnyzkSWwTMHIsCgYEAx7T2
EIKZCXT6wliXaZsC+ooozWYll+CKQihs4ks07pk6gzZYZS50zQEMlPQb4Q32G1C3
WiswPNvyQq7EedM23PGZ1aFmhFUk8ONr73fdOSznEZUkAxpFFVZ6FiB+w/xoOWT8
NZSsxGxD8XlyldAD4s2z4u/ZysPGS5u64ohbm4cCgYEAgZZPAR3ixqrQV4ilfGcW
gdKHMpa0VBYRdNaJSubLmtfbsoaT77YsV30YcUyQAV9gkFfaJTUqnKGTmghyGPEe
yaOFxxCx1B80ShGZBHrk7/rUy211lHCmSSnd3/AWnAFz+koOJkq6Ww3MAIjLdX5E
wVF4L5pOQ7sjZEgfN9w4RK0CgYBHKLvk9iQBsqUHSvnor0tIaqJPTe5nR6L8H9ts
Zs/dlMu8pUiqBPupcI5DJRgqAQeIhCJRBsKRbO3NxOhNYG1UHOJrtK8KyCv5iY+U
LGmvTcioAzRpxpqHF+E4sSt6Oh4JFWqozOkitFEhYdzqdMxtrE5EtqIsFcY6eqsE
vQGnUQKBgG96Dbel+6NnuKlL56StjDETWAuIGAYicBtYdcUvN/BcVOJ0XtcWNbGe
QQy1UNL/X474TBYghNgdHFvRBGqqgAEbUcOD3kSYo67ay+cTfxWqwnZrvf+ulGpJ
+BFYJ3ZT7UTcdwIsHVQA53TEplzMTo0dZnux3VxrugZEpfnR+s5Z
-----END RSA PRIVATE KEY-----
EOF

cat << EOF > /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgYOn/lEXCXKjZSgGv/jOXu8BiCNctplG4RjTzLxqSYf0L5fCLnek9gv1eo4RSSGh/wsBOXK/tZUpzgyDOJAxpCwAapdHVTejD0edmzVkYKGf7sdKKZAcGITwCMqJhVWnioboI6+UNHkmQyDdoJGj8e2NHH0LK7BctDULVDSSDderleQP5Vc4geF4wHHkR0vBrkSOY4MG684U1q5jBEczbEhOtcemZcHvAe7Q1Y3IzqUH0rw7nClrqOHKiBDdn+3kOP+DGQK1skdD+6u/DeAA32BIFOWU7BN/RumHgT1Xr/bvjX3oFkl5XWBkpMilHGfgWri+wBcQHXCQ0HlUaVDZN root@controller1
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBIftl/QxdxdDLrYFF5l3VgcilfszJM6cgjvCOpE60zAp8ccYpbpKCyfrtyZgNZVYafZkvkeF/1zHJmCBjTmUuZAgDgqq0uH9erJHt5cmt4pYhQJore7h3cIFYBUM3tOpmcps4yLCXTs1+m8maHb5G0P9bYv51+WJdhUW+vzFPBkh1BmmclUGuJ0tLgkVEE0ovQWr5+L70JA+UOuMU01P1Ul51uaCKmJOyB8KZM6/Y2EtRapFzM8oOClHF8G202s/YB0x/ZG5jEoifDGYrCuJOnrI4EbIRtu8pTNA7GUDxc+czSEYZ5jC0LWuW3tdjOW+JkCCl/GMCRz7uE13M8OnL root@nhcephssd01
EOF

echo -e "\033[32m  ##### Cai dat package OpenStack ##### \033[0m"
sed -i 's|mirrorlist=http|#mirrorlist=http|'g /etc/yum.repos.d/CentOS-Base.repo
sed -i 's|#baseurl=http:\/\/mirror.centos.org\/centos\/$releasever\/os\/$basearch/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/os\/x86_64\/|'g /etc/yum.repos.d/CentOS-Base.repo
sed -i 's|#baseurl=http:\/\/mirror.centos.org\/centos\/$releasever\/updates\/$basearch\/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/updates\/x86_64\/|'g /etc/yum.repos.d/CentOS-Base.repo
sed -i 's|#baseurl=http:\/\/mirror.centos.org\/centos\/$releasever\/extras\/$basearch\/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/extras\/x86_64\/|'g /etc/yum.repos.d/CentOS-Base.repo
echo "proxy=http://192.168.70.177:3142" >> /etc/yum.conf
yum clean all
yum -y update 
yum -y install centos-release-openstack-queens
yum -y install crudini wget vim telnet
yum -y install python-openstackclient openstack-selinux python2-PyMySQL


sed -i 's|baseurl=http:\/\/mirror.centos.org\/$contentdir\/$releasever\/storage\/$basearch/ceph-luminous/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/storage\/x86_64\/ceph-luminous\/|'g  /etc/yum.repos.d/CentOS-Ceph-Luminous.repo
sed -i 's|baseurl=http:\/\/mirror.centos.org\/$contentdir\/$releasever\/cloud\/$basearch\/openstack-queens\/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/cloud\/x86_64\/openstack-queens\/|'g  /etc/yum.repos.d/CentOS-OpenStack-queens.repo
sed -i 's|baseurl=http:\/\/mirror.centos.org\/$contentdir\/$releasever\/virt\/$basearch\/kvm-common\/|baseurl=http:\/\/mirror.centos.org\/centos\/7.5.1804\/virt\/x86_64\/kvm-common\/|'g  /etc/yum.repos.d/CentOS-QEMU-EV.repo

sleep 3

echo -e "\033[32m  ##### Cai dat va cau hinh NTP ##### \033[0m"

yum clean all
yum -y install chrony
sed -i 's/server 0.centos.pool.ntp.org iburst/server 192.168.70.102 iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/#allow 192.168.0.0\/16/allow 192.168.70.0\/24/g' /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
chronyc sources

sleep 3

echo -e "\033[32m  ##### Cai dat va cau hinh Nova ##### \033[0m"

yum clean all
yum install openstack-nova-compute libvirt-client -y

cp /etc/nova/nova.conf  /etc/nova/nova.conf.org
rm -rf /etc/nova/nova.conf
 
cat << EOF > /etc/nova/nova.conf
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:dae497c1d6aa9f21660f@192.168.70.11:5672,openstack:dae497c1d6aa9f21660f@192.168.70.12:5672,openstack:dae497c1d6aa9f21660f@192.168.70.13:5672
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
block_device_allocate_retries = 60
block_device_allocate_retries_interval = 15
[api]
auth_strategy = keystone
[api_database]
[barbican]
[cache]
[cells]
[cinder]
[compute]
[conductor]
[console]
[consoleauth]
[cors]
[crypto]
[database]
[devices]
[ephemeral_storage_encryption]
[filter_scheduler]
[glance]
api_servers = http://192.168.70.10:9292
[guestfs]
[healthcheck]
[hyperv]
[ironic]
[key_manager]
[keystone]
[keystone_authtoken]
auth_url = http://192.168.70.10:5000/v3
memcached_servers = 192.168.70.11:11211,192.168.70.12:11211,192.168.70.13:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = 8f73497a804b83914530
[libvirt]
virt_type = kvm
cpu_mode = host-passthrough
hw_disk_discard = unmap
[matchmaker_redis]
[metrics]
[mks]
[neutron]
url = http://192.168.70.10:9696
auth_url = http://192.168.70.10:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = 981e8c11fb63a687c187
[notifications]
[osapi_v21]
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
rabbit_ha_queues = true
rabbit_retry_interval = 1
rabbit_retry_backoff = 2
amqp_durable_queues= true
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[pci]
[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://192.168.70.10:5000/v3
username = placement
password = 8f73497a804b83914530
[quota]
[rdp]
[remote_debug]
[scheduler]
[serial_console]
[service_user]
[spice]
[upgrade_levels]
[vault]
[vendordata_dynamic_auth]
[vmware]
[vnc]
enabled = True
server_listen = 0.0.0.0
server_proxyclient_address = $ipbond1
novncproxy_base_url = https://webconsole.cloud365.vn/vnc_auto.html
[workarounds]
[wsgi]
[xenserver]
[xvp]
EOF
sleep 3

chown root:nova /etc/nova/nova.conf
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl restart libvirtd.service openstack-nova-compute.service
sleep 3

echo -e "\033[32m  ##### Cai dat va cau hinh Neutron ##### \033[0m"

yum clean all
yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables 

cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf.org 
rm -rf /etc/neutron/neutron.conf
 
cat << EOF >> /etc/neutron/neutron.conf
[DEFAULT]
transport_url = rabbit://openstack:dae497c1d6aa9f21660f@192.168.70.11:5672,openstack:dae497c1d6aa9f21660f@192.168.70.12:5672,openstack:dae497c1d6aa9f21660f@192.168.70.13:5672
auth_strategy = keystone
[agent]
[cors]
[database]
[keystone_authtoken]
auth_uri = http://192.168.70.10:5000
auth_url = http://192.168.70.10:35357
memcached_servers = 192.168.70.11:11211,192.168.70.12:11211,192.168.70.13:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = 981e8c11fb63a687c187
[matchmaker_redis]
[nova]
[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
rabbit_ha_queues = true
rabbit_retry_interval = 1
rabbit_retry_backoff = 2
amqp_durable_queues= true
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[quotas]
[ssl]
EOF
sleep 3

echo -e "\033[35m  ##### Cau hinh Linux Bridge Agent ##### \033[0m"

cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini.org 
rm -rf /etc/neutron/plugins/ml2/linuxbridge_agent.ini
 
cat << EOF >> /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[DEFAULT]
[agent]
[linux_bridge]
physical_interface_mappings = provider:bond0 
[network_log]
[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
[vxlan]
enable_vxlan = true
local_ip = $ipbond2
l2_population = true
EOF

echo -e "\033[35m  ##### Cau hinh DHCP Agent ##### \033[0m"

cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.org
rm -rf /etc/neutron/dhcp_agent.ini

cat << EOF >> /etc/neutron/dhcp_agent.ini
[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
force_metadata = True
[agent]
[ovs]
EOF

echo -e "\033[35m  ##### Cau hinh Metadata Agent ##### \033[0m"

cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.org 
rm -rf /etc/neutron/metadata_agent.ini
 
cat << EOF >> /etc/neutron/metadata_agent.ini
[DEFAULT]
nova_metadata_host = 192.168.70.10
metadata_proxy_shared_secret = 981e8c11fb63a687c187
[agent]
[cache]
EOF


chown root:neutron /etc/neutron/metadata_agent.ini /etc/neutron/neutron.conf /etc/neutron/dhcp_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini


echo -e "\033[35m  ##### Start service Neutron va Nova ##### \033[0m"

systemctl restart libvirtd.service openstack-nova-compute
systemctl enable neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl restart neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service

echo -e "\033[35m  ########## Cau hinh tich hop Ceph ########## \033[0m"

yum clean all
yum install python-rbd -y
yum install ceph-common -y
mkdir -p /etc/ceph/

cat << EOF > /etc/ceph/ceph.client.cinder.keyring
[client.cinder]
        key = AQCkQJNbW7KwChAAnH7KD5HJA824o4PKixmKjw==
EOF

cat << EOF > /root/client.cinder.key
AQCkQJNbW7KwChAAnH7KD5HJA824o4PKixmKjw==
EOF

cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>09625166-2363-4d96-9bd0-99e41857378e</uuid>
  <usage type='ceph'>
    <name>client.cinder secret</name>
  </usage>
</secret>
EOF
sudo virsh secret-define --file secret.xml
virsh secret-set-value --secret 09625166-2363-4d96-9bd0-99e41857378e --base64 $(cat client.cinder.key)

systemctl restart openstack-nova-compute 

echo -e "\033[35m  ########## Cau hinh Migrate ########## \033[0m"

echo -e "\033[35m  ##### Cau hinh SSH key nova ##### \033[0m"
mkdir -p /var/lib/nova/.ssh
cat << EOF > /var/lib/nova/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYiz/tPlBUju/ZJ54KgP9Ub4adokiaxN9TIj+OQozX2tsDjg/Wm/ebNJ54e/ISUduGvDFlm7q/n4paD91iFrdn1ah7iAYtV8es9cjj7Gs0tWwuDKydg40d72/S8fAnxJMz3ZNGG/eHZ5u4uapEnSZmCbwx98YG/hbZwwIK5Cjb/92P2zD3Wb7DDGdgQJ3cAWBCs7LCe8kH0zu4nopAdGpEkcwesGBz3J9ZiyJKDUvnqzo1DjUl03gzy7otJ2XvaXKWwh0lByUS2u8I3hzYIhFOF9WZ31ktEPnCTmd+NoXi/mTmDRrtlHfSBokFoZq5QSHyQP7kDgsRpjROVqVGsUlB nova@compute01
EOF

cat << EOF > /var/lib/nova/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEA2Is/7T5QVI7v2SeeCoD/VG+GnaJImsTfUyI/jkKM19rbA44P
1pv3mzSeeHvyElHbhrwxZZu6v5+KWg/dYha3Z9Woe4gGLVfHrPXI4+xrNLVsLgys
nYONHe9v0vHwJ8STM92TRhv3h2ebuLmqRJ0mZgm8MffGBv4W2cMCCuQo2//dj9sw
91m+wwxnYECd3AFgQrOywnvJB9M7uJ6KQHRqRJHMHrBgc9yfWYsiSg1L56s6NQ41
JdN4M8u6LSdl72lylsIdJQclEtrvCN4c2CIRThfVmd9ZLRD5wk5nfjaF4v5k5g0a
7ZR30gaJBaGauUEh8kD+5A4LEaY0TlalRrFJQQIDAQABAoIBAQCxJuJqhVMUikdA
AUAy2auI+SBI7420SCFnkpoqGNm+cYZBV0QvzzL230pRyRyVzi/o/ybuOEPEJpH5
8gasC2eJ4+pM/VAIYkqxffYWOMDPwyg4WBgTWJ7nAY4bJeDRt+ixQrEMZy7OsH1d
106riWDzkz1KJ6jy6YXqKrYOEPA4YY4rgSkg0pocglpFQRhL3h6rds9/+dawJ2XS
U7+0B0zqMeYDEWYHhm6UAjbUTrsrisNn+bdh+1Hm4KtmwD0jEDbeoLZFR16T3bZK
9eT9O8Gr6+IDnDwGj7H9amB0bcJN8wz2WG6K9qI1+wcF6thtnASAe9VxnTHV3H5d
AMy6bittAoGBAO67VZD6JX5FhGdn+UZNDOiyhkBNy+YM7Uwzd7TIIQY7o6x50PR1
3rLLJcbyAUgpKQGQY6MswhGUAVlxB1WGyF3FG9H4hKVs0LohiSKBAVhZKbFilgxB
QDWhpESFTtJZI1y6XGOtwxfIoGRp38gxq93D4kxYcukiPcQgWu35mbbbAoGBAOg1
DpTx8RIvGTO8MiJ0FdNtXzDifbqpbjBfXvJs5RfyQ+Hrqp8wEBY6euf7kPYe02+Q
ZFiDvlC//SuxzwR4Zg5HOwnGEYmZHjA4nLgguGr1GrDE1p8YnSSwAHhXcKN7d6yD
FM4rz4k4l4Ezh2zViLe5RYLER5TNR/Cg4zyrVlUTAoGBAIkzzxR4P04X4+WOIvxd
Ufr2hyOz0miPq12tArI6hohPhFye0hF9IJU/HaH9+fCf/zov4qOoGI0Ds9bUl/N2
d/c0Ti3Zl1p/dGJU3byfyccdz1FsKHI4mg94q7DZsJhBtIoZbPm4prQnkM7E7mDe
8ziL2KYp+zizfi4WrkuwtMAbAoGBALGz+ObPiPerh5PqEEwBnrpg1xpoGmQBScxH
EDhiUahTxNNeMQMGGymHs4tZIATabmDQlZqPp9PQOYV4277GDQQcSvgd1koBHfM1
P+pBUCC6VqS03rJ+ebQb5SAzeoYB9QHWhtOI/5g58Of1cUw+1hQT+zgp0cX0m3tx
BLXnQXh1AoGBALCkK22LQTSFE2izfITopjv9voeaio+Flc6FXOYxyszRZVi5Z5Fd
8PKpYWO+cvdjdpxOiOk7KobsMonKMi5ONieNyzTHu0yUyvqc9jeHII9kKfNa6X6z
lMnIhiGsNXpTCQodh2MxIj1BwWZ3mMc/JTnL2sDf1+4L7tTgppwrrclZ
-----END RSA PRIVATE KEY-----
EOF

echo -e "\033[35m  ##### Cau hinh cold-migrate ##### \033[0m"

usermod -s /bin/bash nova
echo 'StrictHostKeyChecking no' >> /var/lib/nova/.ssh/config
chown nova:nova /var/lib/nova/.ssh/id_rsa
chmod 600 /var/lib/nova/.ssh/id_rsa
chown nova:nova /var/lib/nova/.ssh/authorized_keys
chown nova:nova /var/lib/nova/.ssh/config

echo -e "\033[35m  ##### Cau hinh live-migrate ##### \033[0m"

cp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.orig
sed -i 's|#listen_tls = 0|listen_tls = 0|'g /etc/libvirt/libvirtd.conf
sed -i 's|#listen_tcp = 1|listen_tcp = 1|'g /etc/libvirt/libvirtd.conf
sed -i 's|#tcp_port = "16509"|tcp_port = "16509"|'g /etc/libvirt/libvirtd.conf
sed -i 's|#auth_tcp = "sasl"|auth_tcp = "none"|'g /etc/libvirt/libvirtd.conf
sed -i 's|#LIBVIRTD_ARGS="--listen"|LIBVIRTD_ARGS="--listen"|'g /etc/sysconfig/libvirtd

systemctl restart libvirtd openstack-nova-compute.service

echo -e "\033[35m  ########## Cau hinh giam sat Zabbix ########## \033[0m"

rpm -Uvh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
yum install zabbix-agent -y
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bk
echo "Nhap IP server zabbix"
ipzabbix=192.168.70.101
sed -i 's/Server=127.0.0.1/Server='$ipzabbix'/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/# ListenPort=10050/ListenPort=10050/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive='$ipzabbix'/g' /etc/zabbix/zabbix_agentd.conf

systemctl enable zabbix-agent
systemctl start zabbix-agent
systemctl restart zabbix-agent
systemctl status zabbix-agent
echo "Cai dat Ok"

echo -e "\033[35m  ########## Cau hinh giam sat Zabbix ########## \033[0m"

ipcheckmk=192.168.70.103
yum install wget -y
wget https://check.cloud365.vn/admin/check_mk/agents/check-mk-agent-1.5.0p9-1.noarch.rpm
yum install xinetd -y
systemctl start xinetd
systemctl enable xinetd
rpm -ivh check-mk-agent-*
cp /etc/xinetd.d/check_mk /etc/xinetd.d/check_mk.bk
sed -i 's/#only_from      = 127.0.0.1 10.0.20.1 10.0.20.2/only_from      = '$ipcheckmk'/g'  /etc/xinetd.d/check_mk
systemctl restart xinetd
systemctl status xinetd

echo "Cai dat agent check_mk Ok"

echo -e "\033[35m  ########## Cau hinh cmd log ########## \033[0m"

wget https://raw.githubusercontent.com/nhanhoadocs/scripts/master/Utilities/cmdlog.sh
bash cmdlog.sh

echo -e "\033[35m  ########## Cau hinh CollectD ########## \033[0m"

yum -y install collectd collectd-virt
cp /etc/collectd.conf /etc/collectd.conf.orig

cd /etc
rm -rf rm -rf collectd.conf

cat << EOF > /etc/collectd.conf
LoadPlugin network
<Plugin "network">
Server "192.168.70.114" "25826"
</Plugin>
LoadPlugin virt
 <Plugin "virt">
   RefreshInterval 10
   Connection "qemu:///system"
   BlockDeviceFormat "target"
   HostnameFormat "uuid"
   InterfaceFormat "address"
   PluginInstanceFormat name
   ExtraStats "cpu_util disk_err domain_state fs_info job_stats_background perf vcpupin"
 </Plugin>
LoadPlugin write_graphite
<Plugin write_graphite>
  <Node "compute4">
    Host "192.168.70.114"
    Port "2003"
    Protocol "tcp"
    LogSendErrors true
    Prefix "collectd.compute3."
    StoreRates true
    AlwaysAppendDS false
    EscapeCharacter "_"
  </Node>
</Plugin>
Include "/etc/collectd.d"
EOF

systemctl restart collectd
systemctl enable collectd