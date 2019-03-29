# CENTOS 7

Tương tự thêm cấu hình sau vào file :
`/etc/sysconfig/network-scripts/ifcfg-eth0`

```sh
IPV6INIT=yes
NETWORKING_IPV6=yes
IPV6ADDR="2405:4800:200:5005::4"
IPV6_DEFAULTGW="2405:4800:200:5005::1"
```