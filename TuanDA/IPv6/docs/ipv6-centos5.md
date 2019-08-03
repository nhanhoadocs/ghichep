
```sh
vi /etc/modprobe.conf
```

Thêm
```
alias net-pf-10 ipv6
```

Xóa hoặc Note : Remove if any entry like below in the modprobe.conf file:

```
#alias net-pf-10 off
#alias ipv6 off
#options ipv6 disable=1
```