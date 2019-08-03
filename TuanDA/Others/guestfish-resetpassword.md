# Reset password Linux KVM qcow2 image/vm bằng libguestfs

Bước 1 : Cài đặt:

```sh
sudo yum install libguestfs-tools

#Fedora Linux user run dnf command:
sudo dnf install libguestfs-tools

#Debian/Ubuntu Linux user run apt command/apt-get command:
sudo apt install libguestfs-tools
```

Bước 2: Thực hiện reset:

- Tăt máy ảo:

```sh
virsh list
virsh shutdown test71
```

- Kiểm tra vị trí file img:

`
virsh dumpxml test71 | grep 'source file'
`

Ví dụ:       
`<source file='/var/lib/libvirt/images/testvlan71.img'/>`

- Tạo pass mới:
```sh
openssl passwd -1 P@ssW0rd#@!
$1$q04gISKd$66JBcsHHUF1mXVWGSm4VX0
```

- Sử dụng guestfish để sửa file img:

```sh
guestfish --rw -a /var/lib/libvirt/images/testvlan71.img
```

`run` để chạy backend
```sh
><fs> run
```
`list-filesystems` list các phân vùng
```sh
><fs> list-filesystems
/dev/sda1: ext4
/dev/sda3: swap
/dev/VolGroup00/LogVol01: xfs
```

`mount` mount disk 

```sh
><fs> mount /dev/VolGroup00/LogVol01 /
```

`vi /etc/shadow` edit file password để lưu lại password cũ hoặc thay thế bằng password đã hash ở trên
(ví dụ: `root:$1$2FusLVIf$UiQyH5pLQ2c59bFeWyq2j0::0:99999:7:::` )

```sh
><fs> vi /etc/shadow
```

Thay thế bằng password mới và `exit` (password nằm phía sau dấu : sau user root)
![](images/libquest.png)

Bước 3: Thực hiện start máy ảo và kiểm tra lại:
`
 virsh start test71
`

# Virt-customize
A note about virt-customize command
If you find above method difficult try the following simple command:
```sh
virsh shutdown test71
virt-customize -a /var/lib/libvirt/images/testvlan71.img --root-password password:P@ssW0rd@@ --uninstall cloud-init
```
