# Cấu hình IPv6 trên Ubuntu #

## Ubuntu 16.04 ##

### Bước 1 ###

    vi /etc/network/interfaces

### Bước 2 ###

    iface inet6 static
		pre-up modprobe ipv6
		address 2405:4800:200:5005::10
		netmask 64
		gateway 2405:4800:200:5005::1
		dns-nameservers 2001:4860:4860:8888 2001:4860:4860:8844

### Bước 3 ###

    systemctl restart networking

