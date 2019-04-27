To add a temporary IPv6 to your server, use this command

```sh
ip -6 addr add IPv6_address/120 dev eth0
```

To remove this temporary IPv6, use this command

```sh
ip -6 addr del IPv6_address/120 dev eth0
```


Add a static IPv6 address to your server
Edit the network interface eth0

nano /etc/sysconfig/network-scripts/ifcfg-eth0


And add the following block
...
IPV6INIT=yes
IPV6_PEERROUTES="yes"
IPV6_PRIVACY="no"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6ADDR=primary_ipv6_address/120
IPV6_DEFAULTGW=ipv6_gateway
...


Add additional IPv6 addresses to your interface
Add the following line to your network interface

IPV6ADDR_SECONDARIES="second_ipv6_address/120 third_ipv6_address/120 .../120"
The complete IPv6 block should look like this

...
IPV6INIT=yes
IPV6_PEERROUTES="yes"
IPV6_PRIVACY="no"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6ADDR=primary_ipv6_address/120
IPV6_DEFAULTGW=ipv6_gateway
IPV6ADDR_SECONDARIES="second_ipv6_address/120 third_ipv6_address/120 .../120"
...


Restart your network to bind your new IPv6 Addresses
CentOS 6
```
service network restart
```
CentOS 7
```
systemctl restart network
```