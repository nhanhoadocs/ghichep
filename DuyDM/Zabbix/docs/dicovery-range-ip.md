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

