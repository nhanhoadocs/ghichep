```sh
hostnamectl set-hostname ns1.cloud365.vn
service NetworkManager stop
systemctl disable NetworkManager
cd /home
curl -o latest-dnsonly -L https://securedownloads.cpanel.net/latest-dnsonly
sh latest-dnsonly
```
