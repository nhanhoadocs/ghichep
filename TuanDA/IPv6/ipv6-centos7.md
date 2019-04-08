# CENTOS 7

1. Kiểm tra server có hỗ trợ IPv6 không:
```sh
[root@localhost ~]# sysctl -a | grep disable_ipv6
sysctl: reading key "net.ipv6.conf.all.stable_secret"
net.ipv6.conf.all.disable_ipv6 = 0
sysctl: reading key "net.ipv6.conf.default.stable_secret"
net.ipv6.conf.default.disable_ipv6 = 0
sysctl: reading key "net.ipv6.conf.ens160.stable_secret"
net.ipv6.conf.ens160.disable_ipv6 = 0
sysctl: reading key "net.ipv6.conf.lo.stable_secret"
net.ipv6.conf.lo.disable_ipv6 = 0
```
Kết quả trả về `disable_ipv6 = 0` là OS không disable IPv6

2. Cấu hình

Thêm cấu hình sau vào file :
`/etc/sysconfig/network-scripts/ifcfg-ens160`

```sh
IPV6INIT=yes
NETWORKING_IPV6=yes
IPV6ADDR="2405:4800:200:5005::15"
IPV6_DEFAULTGW="2405:4800:200:5005::1"
DNS2=2001:4860:4860::8888
```

2. Kiểm tra lại:
- Kiểm tra lại IP

```sh
[root@localhost ~]# ip a | grep inet6
    inet6 ::1/128 scope host 
    inet6 2405:4800:200:5005::15/64 scope global noprefixroute 
    inet6 fe80::d028:f0bf:6809:40/64 scope link noprefixroute 
```
- Kiểm tra lại route IPv6:

```sh
[root@localhost ~]# /sbin/route -A inet6 
Kernel IPv6 routing table
Destination                    Next Hop                   Flag Met Ref Use If
[::]/96                        [::]                       !n   1024 0     0 lo
0.0.0.0/96                     [::]                       !n   1024 0     0 lo
2002:a00::/24                  [::]                       !n   1024 0     0 lo
2002:7f00::/24                 [::]                       !n   1024 0     0 lo
2002:a9fe::/32                 [::]                       !n   1024 0     0 lo
2002:ac10::/28                 [::]                       !n   1024 0     0 lo
2002:c0a8::/32                 [::]                       !n   1024 0     0 lo
2002:e000::/19                 [::]                       !n   1024 0     0 lo
2405:4800:200:5005::/64        [::]                       U    100 2     8 ens160
3ffe:ffff::/32                 [::]                       !n   1024 0     0 lo
fe80::/64                      [::]                       U    100 0     0 ens160
[::]/0                         gateway                    UG   100 1     7 ens160
[::]/0                         [::]                       !n   -1  1    50 lo
localhost/128                  [::]                       Un   0   1     0 lo
localhost.localdomain/128      [::]                       Un   0   2     7 lo
localhost.localdomain/128      [::]                       Un   0   2     1 lo
ff00::/8                       [::]                       U    256 1     3 ens160
[::]/0                         [::]                       !n   -1  1    51 lo
```

- Kiểm tra ping:

```sh
[root@localhost ~]# ping6 2405:4800:200:5005::1
PING 2405:4800:200:5005::1(2405:4800:200:5005::1) 56 data bytes
64 bytes from 2405:4800:200:5005::1: icmp_seq=1 ttl=64 time=1.98 ms
64 bytes from 2405:4800:200:5005::1: icmp_seq=2 ttl=64 time=1.25 ms
```

```sh
[root@localhost ~]# ping6 google.com
PING google.com(hkg12s02-in-x0e.1e100.net (2404:6800:4005:802::200e)) 56 data bytes
64 bytes from hkg12s02-in-x0e.1e100.net (2404:6800:4005:802::200e): icmp_seq=1 ttl=56 time=19.4 ms
```