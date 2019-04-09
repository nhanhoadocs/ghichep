## Ubuntu 18.04 ##

### Bước 1 ###

    vi /etc/netplan/50-cloud-init.yaml

### Bước 2 ###

    network:
    ethernets:
        ens160:
            addresses:
            - 2405:4800:200:5005::9/64
            dhcp4: true
            dhcp6: false
            gateway6: 2405:4800:200:5005::1
            nameservers:
                addresses:
                - 2001:4860:4680::8888
                search: []
    version: 2

### Bước 3 ###

    netplan apply
