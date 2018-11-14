# Hướng dẫn chỉnh sửa cơ bản file có định dạng .img sử dụng libguestfs-tools

Ở đây em guide cơ bản chỉnh sửa một file image (.img) đã được đóng image thành công nhưng vì một lý do nào đó quên config ở một đoạn nào đó mà không muốn quay lại bản snapshot và thực hiện đóng lại.
Phương án cho trường hợp này là sử dụng `libguestfs-tools` để edit lại file image.

- Công cụ `libguestfs-tools`

+ Cài đặt trên Centos 7:

```
yum install libguestfs-tools
```

+ Sơ lược về libguestfs-tools

'libguestfs' là một project có thể sử dụng một số chức năng sau:
	 
    + virt-edit: Chỉnh sửa một file bên trong một image.
	
    + virt-df: Hiển thị khoảng trống free bên trong một image.
	
    + virt-resize: resize một image.
	
    + virt-sysprep: Chuẩn bị tối ưu để đưa ra một image chuẩn (Ví dụ như: delete SSH host keys, remove MAC address info, or remove user accounts).
	
    + virt-sparsify: Làm mịn lại image.
	
    + virt-p2v: Chuyển đổi một physical machin sang một image chạy trên KVM.
	
    + virt-v2v: Chuyển đổi Xen và VMware sang KVM images.
	
- Ở đây em thực hiện libguestfs-tools để chỉnh sửa file rc.local và chmod quyền thực thi cho file file rc.local để VPS Centos nhận đủ NIC.

+ Chỉnh sửa file rc.local

![](../images/libguestfstools/Screenshot_239.png)

```
virt-edit Centos69-64bit-2NIC-V2.img /etc/rc.local
```

![](../images/libguestfstools/Screenshot_240.png)

![](../images/libguestfstools/Screenshot_241.png)

Chỉnh sửa file rc.local

Thêm đoạn script

```
for iface in $(ip -o link | cut -d: -f2 | tr -d ' ' | grep ^eth)
do
   test -f /etc/sysconfig/network-scripts/ifcfg-$iface
   if [ $? -ne 0 ]
   then
       touch /etc/sysconfig/network-scripts /ifcfg-$iface
       echo -e "DEVICE=$iface\nBOOTPROTO=dhcp\nONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-$iface
       ifup $iface
   fi
done
```

![](../images/libguestfstools/Screenshot_242.png)

+ Change quyền thực thi cho file rc.local

```
guestfish --rw -a Centos69-64bit-2NIC-V2.img

run

list-filesystems

mount /dev/sda1 /

chmod 0755 /etc/rc.local

exit
```
![](../images/libguestfstools/Screenshot_244.png)


Như vậy đã thao tác xong cho việc chỉnh sửa cơ bản image.









	


	
