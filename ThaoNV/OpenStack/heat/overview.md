# Tổng quan về heat

Heat là OpenStack Orchestration program, mục tiêu của nó là tạo ra dịch vụ có thể quản lý toàn bộ vòng đời của hạ tầng cũng như app trên nền tảng OPS.

Heat sử dụng orchestration engine để chạy các cloud application dựa theo các text file template. Heat cung cấp cả OpenStack-native ReST API và CloudFormation-compatible Query API.

### Cách hoạt động

- Heat sử dụng template để mô tả hạ tầng cho cloud app trong file text, file này có thể được đọc và viết bởi người vận hành
- Các tài nguyên hạ tầng được mô tả ở đây là: server, volume, ...
- Heat cũng có thể kết hợp với telemetry để cung cấp auto scale
- Các template cũng có thể định nghĩa mối quan hệ với nhau. Điều này giúp heat có thể gọi tới OPS API để tạo phần hạ tầng theo đúng thứ tự.
- Heat control toàn bộ vòng đời của cloud app, vì thế nếu bạn cần thay đổi hạ tầng, bạn chỉ cần update template và dùng nó để update các stack được tạo ra.


### Kiến trúc

<img src="https://i.imgur.com/PiCrE5h.png">

Heat bản chất là sự kết hợp của một loạt các python application.

- heat : heat tool là CLI tương tác với heat api để thực thi các AWS CloudFormation API. Thứ này ko required, bạn hoàn toàn có thể dùng Heat API trực tiếp.

- heat-api : Cung cấp OpenStack-native ReST API, sẽ xử lý các request và chuyển tiếp nó tới heat-engine thông qua RPC.

- heat-api-cfn : Cung cấp AWS-style Query API, tương thích với AWS CloudFormation, nó cũng sẽ xử lý các request và chuyển tiếp nó tới heat-engine thông qua RPC.

- heat-engine: thực thi chính phần việc bằng cách chạy các template và trả lại events tới các API consumer.

### Cài đặt

Môi trường:
Tham khảo hướng dẫn cài đặt [tại đây](../install-openstack-train-manual.md)

- OpenStack Train
- 1 CTL - 1 COM
- Đã cài đặt các thành phần cơ bản

-----------

Cài đặt package

`yum -y install openstack-heat-common openstack-heat-api openstack-heat-api-cfn openstack-heat-engine python-heatclient`

Tạo user

`openstack user create --domain default --project service --password Welcome123 heat`

Add role admin

`openstack role add --project service --user heat admin`

Tạo role

```
openstack role create heat_stack_owner
openstack role create heat_stack_user
```

Add admin role cho user heat owner

`openstack role add --project admin --user admin heat_stack_owner`

Tạo service entry

```
openstack service create --name heat --description "Openstack Orchestration" orchestration
openstack service create --name heat-cfn --description "Openstack Orchestration" cloudformation
```

Tạo endpoints

```
openstack endpoint create --region RegionOne orchestration public http://10.10.11.171:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration internal http://10.10.11.171:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration admin http://10.10.11.171:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne cloudformation public http://10.10.11.171:8000/v1
openstack endpoint create --region RegionOne cloudformation internal http://10.10.11.171:8000/v1
openstack endpoint create --region RegionOne cloudformation admin http://10.10.11.171:8000/v1
```

Tạo Heat domain

`openstack domain create --description "Stack projects and users" heat`

Tạo heat_domain_admin

`openstack user create --domain heat --password Welcome123 heat_domain_admin`

Add admin role

`openstack role add --domain heat --user heat_domain_admin admin`

Tạo db

```
mysql -u root -pWelcome123

create database heat;
grant all privileges on heat.* to heat@'localhost' identified by 'Welcome123';
grant all privileges on heat.* to heat@'%' identified by 'Welcome123';
flush privileges;
exit
```

Backup cấu hình

`mv /etc/heat/heat.conf /etc/heat/heat.conf.org`

Cấu hình heat

```
cat << EOF >> /etc/heat/heat.conf
# create new
[DEFAULT]
deferred_auth_method = trusts
trusts_delegated_roles = heat_stack_owner
# Heat installed server
heat_metadata_server_url = http://10.10.11.171:8000
heat_waitcondition_server_url = http://10.10.11.171:8000/v1/waitcondition
heat_watch_server_url = http://10.10.11.171:8003
heat_stack_user_role = heat_stack_user
# Heat domain name
stack_user_domain_name = heat
# Heat domain admin name
stack_domain_admin = heat_domain_admin
# Heat domain admin's password
stack_domain_admin_password = Welcome123
# RabbitMQ connection info
transport_url = rabbit://openstack:Welcome123@10.10.11.171

# MariaDB connection info
[database]
connection = mysql+pymysql://heat:Welcome123@10.10.11.171/heat

# Keystone auth info
[clients_keystone]
auth_uri = http://10.10.11.171:5000

# Keystone auth info
[ec2authtoken]
auth_uri = http://10.10.11.171:5000

[heat_api]
bind_host = 0.0.0.0
bind_port = 8004

[heat_api_cfn]
bind_host = 0.0.0.0
bind_port = 8000

# Keystone auth info
[keystone_authtoken]
www_authenticate_uri = http://10.10.11.171:5000
auth_url = http://10.10.11.171:5000
memcached_servers = 10.10.11.171:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = heat
password = Welcome123

[trustee]
auth_plugin = password
auth_url = http://10.10.11.171:5000
username = heat
password = Welcome123
user_domain_name = default
EOF
```

Phân quyền

```
chgrp heat /etc/heat/heat.conf
chmod 640 /etc/heat/heat.conf
```

Populate db

```
su -s /bin/bash heat -c "heat-manage db_sync"
```

Start service

```
systemctl start openstack-heat-api openstack-heat-api-cfn openstack-heat-engine
systemctl enable openstack-heat-api openstack-heat-api-cfn openstack-heat-engine
```

### Sử dụng cơ bản

Tạo file `stack10.yml`

```
heat_template_version: 2017-09-01
description: simple template to create vm
resources:
  myvm1:
    type: OS::Nova::Server
    properties:
      image: cirros
      flavor: tiny
      networks:
      - network: thao
```

```
heat_template_version: 2018-08-31

description: Heat Sample Template

parameters:
  ImageID:
    type: string
    description: Image used to boot a server
  NetID:
    type: string
    description: Network ID for the server

resources:
  bootable_volume:
    type: OS::Cinder::Volume
    properties:
      size: 10
      image: { get_param: ImageID }

  server1:
    type: OS::Nova::Server
    depends_on: bootable_volume
    properties:
      name: "test"
      flavor: "tiny"
      networks:
        - network: { get_param: NetID }
      block_device_mapping: [{"device_name": "vda", "volume_id": { get_resource: bootable_volume }, "delete_on_termination": true}]

outputs:
  server1_private_ip:
    description: IP address of the server in the private network
    value: { get_attr: [ server1, first_address ] }
```

Tạo stack

`openstack stack create -t stack10.yml s10`

Kiểm tra server list

`openstack server list`
