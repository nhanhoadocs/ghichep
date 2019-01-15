# Hướng dẫn sử dụng script discovery range IP

Author: MinhNV-KMA

Kiểm tra trạng thái của các IP trong range IP và thiết lập cảnh báo

## Thực hiện config trên zabbix server

+ Cài đặt python 3.5

```
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python35u python35u-pip python35u-devel
python3.5 -V
```

![](../images/img-discovery-zabbix/Screenshot_744.png)

+ Tải script về zabbix server

```
cd /usr/local/bin/
wget https://raw.githubusercontent.com/domanhduy/ghichep/master/DuyDM/Zabbix/scripts/discovery_ip_range.py
chmod +x discovery_ip_range.py
```

+ Test script

```
python3.5 discovery_ip_range.py 192.168.70.40 192.168.70.50
```

![](../images/img-discovery-zabbix/Screenshot_745.png)

## Thực hiện trên Dashboard zabbix

**Configuration -> Host -> Lựa chọn Zabbix server -> Dicovery**

![](../images/img-discovery-zabbix/Screenshot_746.png)

+ Tạo thêm item mới Discovery Network

![](../images/img-discovery-zabbix/Screenshot_748.png)

![](../images/img-discovery-zabbix/Screenshot_749.png)

![](../images/img-discovery-zabbix/Screenshot_750.png)

++ Name: Ping host  {#IP}

```
#IP là biến quy định cho host
```

++Update interval: 30s 

Khoảng thời gian update mới value

++ Key: icmpping[{#IP},30]

Sử dụng icmp ping 30 gói trong khoảng thời gian interval trên.

++ Type: Simple check

![](../images/img-discovery-zabbix/Screenshot_751.png)

![](../images/img-discovery-zabbix/Screenshot_752.png)

+ Tạo thêm rule mới

![](../images/img-discovery-zabbix/Screenshot_754.png)

![](../images/img-discovery-zabbix/Screenshot_755.png)

++ Name: Tên rule

++ key: Chú ý đúng cú phải và điền địa chỉ đầu và cuối của range IP

![](../images/img-discovery-zabbix/Screenshot_756.png)

+ Kiểm tra kết quả












