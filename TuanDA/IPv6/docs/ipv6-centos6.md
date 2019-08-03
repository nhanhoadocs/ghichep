# Cấu hình IPv6 trên OS CentOS 6

Thêm vào file `/etc/sysctl.conf`.

```sh
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```

Áp thay đổi bằng lệnh:

```
sysctl -p
```

Kiểm tra lại bằng ‘sysctl -a’

```sh
sysctl -a | grep net.ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```

Thêm cấu hình sau vào file :
`/etc/sysconfig/network-scripts/ifcfg-eth0`

```sh
IPV6INIT=yes
NETWORKING_IPV6=yes
IPV6ADDR="2405:4800:200:5005::3"
IPV6_DEFAULTGW="2405:4800:200:5005::1"
DNS2=2001:4860:4860::8888
```

Restart lại network và kiểm tra lại:

```sh
[root@Centos6 ~]# ip a | grep inet6
    inet6 ::1/128 scope host 
    inet6 2405:4800:200:5005::3/64 scope global tentative dadfailed 
    inet6 fe80::20c:29ff:feda:a409/64 scope link 
```

Kiểm tra ping đến gateway:

```sh
[root@Centos6 ~]# ping6 2405:4800:200:5005::1
PING 2405:4800:200:5005::1(2405:4800:200:5005::1) 56 data bytes
64 bytes from 2405:4800:200:5005::1: icmp_seq=1 ttl=64 time=1.54 ms
--- 2405:4800:200:5005::1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1398ms
rtt min/avg/max/mdev = 1.546/7.550/13.555/6.005 ms
```

- Kiểm tra route của IPv6
```sh
route -A inet6
ip -6 route show
```

```sh
# /sbin/route -A inet6 |grep -w "eth0"
2001:0db8:0:f101 ::/64 :: UA  256 0 0 eth0 <- Interface route for global
¬ address
fe80::/10        ::       UA  256 0 0 eth0 <- Interface route for link-local
¬ address
ff00::/8         ::       UA  256 0 0 eth0 <- Interface route for all multicast
¬ addresses
::/0             ::       UDA 256 0 0 eth0 <- Automatic default route
- command check hệ thống đã hỗ trợ IPv6 chưa:
```

```sh
[ -f /proc/net/if_inet6 ] && echo 'IPv6 ready system!' || echo 'No IPv6 support found! Compile the kernel!!'
```

```sh
cat /proc/net/if_inet6
lsmod|grep ipv6
```

**Lỗi tentative dadfailed (Duplicate Address Detection (RFC 4862))**

### 1. Hiện tượng:
- Không ping được ra ngoài theo IPv6
- Show trong cấu hình IPv6 có dòng `tentative dadfailed`
```sh
[root@Centos6 ~]# ip a | grep inet6
    inet6 ::1/128 scope host 
    inet6 2405:4800:200:5005::3/64 scope global tentative dadfailed 
    inet6 fe80::20c:29ff:feda:a409/64 scope link
```

### 2. Nguyên nhân:
- Do đã từng có 1 máy sử dụng IPv6 này với MAC khác.

### 3. Xử lý:
- Comment dòng `HWADDR=` trong `/etc/sysconfig/network-scripts/ifcfg-eth0`
- Restart lại network

### 4. Kiểm tra lại:
```sh
[root@Centos6 ~]# ip a | grep inet6                            
    inet6 ::1/128 scope host 
    inet6 2405:4800:200:5005::3/64 scope global 
    inet6 fe80::20c:29ff:feda:a409/64 scope link 
```
- Máy ảo đã ping được ra ngoài:
```sh
[root@Centos6 ~]# ping6 vnexpress.net                           
PING vnexpress.net(2001:df0:66:40::16) 56 data bytes
64 bytes from 2001:df0:66:40::16: icmp_seq=1 ttl=57 time=21.6 ms
64 bytes from 2001:df0:66:40::16: icmp_seq=2 ttl=57 time=21.7 ms
```
