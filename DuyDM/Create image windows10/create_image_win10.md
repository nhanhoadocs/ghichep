# Hướng dẫn tạo image windows 10 #

## 1. Chuẩn bị ## 

- Một server KVM để tạo image
    + Đã cài virt-manager và libguestfs-tool
    + Dải mạng bridge cho máy ảo. 
    + ISO VirtIO
- File ISO windows 10

Lưu ý:  Máy ảo KVM nên có cấu hình cao, dung lượng Disk size lớn và RAM cao để việc đóng image được nhanh.

## 2. Các bước cài đặt ##

**Bước 1:** Thực hiện trên host KVM, tạo file có định dạng `qcow2` cho máy ảo và lưu tại thư mục /var/lib/libvirt/images/ (áp dụng minsize 15Gb)

```sh
qemu-img create -f qcow2 /var/lib/libvirt/images/Win10.X64.en-US.img 15G
```

![](images/win10image1.png)

**Bước 2**: Copy file ISO windows 10 vào thử mục /var/lib/libvirt/images

![](images/win10image2.png)

**Bước 3**: Tạo máy ảo trên host KVM

Để sử dụng giao diện virt-manager và khởi tạo máy ảo phải cài đặt Xming để khi chạy lệnh `virt-manager`sẽ hiện ra giao diện quản lý máy ảo

![](images/win10image3.png)

Lựa chọn cách thức tạo máy ảo

![](images/win10image4.png)

**Bước 4**: Khai báo thông tin máy ảo

![](images/win10image5.png)

![](images/win10image6.png)

![](images/win10image7.png)

- Khai báo thông tin về CPU và RAM cho máy ảo

![](images/win10image8.png)

- Chỉnh sửa tên máy ảo, lựa chọn "Customize configuration before install" sau đó Finish

![](images/win10image9.png)

- Chỉnh lại "Disk bus" và "Storage Format" của Disk 1

![](images/win10image10.png)

- Lựa chọn "Add hardware", sau đó add thêm CD ROM với ISO Windows 10.

![](images/win10image11.png)

- Lựa chọn device type

![](images/win10image12.png)

- Lựa chọn "Add hardware", sau đó add thêm 1 CD ROM trống

![](images/win10image14.png)

- Trong phần "NIC", lựa chọn giải mạng Bridge

Lựa chọn dải mạng mà bridge cho VM khi tạo ra để ra internet

![](images/win10image13.png)

- Chỉnh sửa thứ tự boot -> Apply -> Begin install

![](images/win10image15.png)

![](images/win10image16.png)

**Bước 5**: Chinh sua channel

- Khi click begin -> force off máy ảo ngay lập tức

![](images/win10image17.png)

- Chỉnh sửa file .xml của máy ảo, bổ sung thêm channel trong `<devices>` (để máy host giao tiếp với máy ảo sử dụng qemu-guest-agent). Với KVM host là centos 7, chỉnh sửa lại number của vnc là port 2.

```sh
virsh list -all

virsh edit name_mayao

```
Tìm đến dòng 98

```sh
* Sửa dòng cấu hình sau, chuyển port ='2'
 <channel type='spicevmc'>
      <target type='virtio' name='com.redhat.spice.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='2'/>
    </channel>

* Thêm dòng cấu hình sau ở phía sau dòng cấu hình trên :
    <channel type='unix'>
      <target type='virtio' name='org.qemu.guest_agent.0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>

```
![](images/win10image18.png)

**Bước 6**: Cai OS

Bật máy ảo lên

![](images/win10image19.png)

![](images/win10image20.png)

![](images/win10image21.png)

![](images/win10image22.png)

![](images/win10image23.png)

- Đến bước này sẽ không thấy disk để cài phải phai mount file VirtIO để load driver cài đặt . ( nên để file iso trong thư mục /var/lib/libvirt/image)

![](images/win10image28.png)

- Quay lại phần edit cấu hình để chỉnh sửa

Chỉnh sửa CDROM add lúc trắng lúc đầu để mount file ISO vào đó.

![](images/win10image24.png)

![](images/win10image25.png)

- Broswe tới file `virtio-win.iso` vừa đưa, chọn load driver tại thư mục

![](images/win10image27.png)


![](images/win10image29.png)

![](images/win10image30.png)

![](images/win10image31.png)

![](images/win10image33.png)

![](images/win10image35.png)

![](images/win10image36.png)

- Setup OS ok

![](images/win10image37.png)

- Sau khi cài xong OS, tắt VM và sửa lại Boot từ Hard Disk và bật máy ảo

![](images/win10image38.png)

Start VM

**Bước 7**: Setup driver cho máy ảo

- NIC Driver

Vào "Device Manager" để update driver cho NIC, cài đặt Baloon network 
driver để VM nhận card mạng. Browse 

![](images/win10image39.png)

![](images/win10image40.png)

![](images/win10image41.png)

![](images/win10image42.png)

![](images/win10image43.png)

![](images/win10image44.png)

- Baloon service và driver

+ Copy /virtio-win-0.1.1/Baloon/Win10/amd64 từ CD Drive vào C:\

![](images/win10image45.png)

+ Chạy CMD, trỏ về thư mục amd64 vừa copy và chạy 

```sh
PS C:\Users\Administrator> cd C:\amd64
PS C:\amd6>. \blnsvr.exe –i
```

![](images/win10image46.png)

![](images/win10image47.png)

+ Kiểm tra Ballon service

![](images/win10image48.png)

+ Cài đặt Ballon driver

![](images/win10image49.png)

![](images/win10image50.png)

![](images/win10image51.png)

![](images/win10image52.png)

![](images/win10image53.png)

- QEMU-GA agent

+ Vào "Device Manager", chọn update driver cho PCI Simple Communication Controller. Browse : D:\vioserial\win10\amd64

![](images/win10image54.png)

![](images/win10image55.png)

Vào "Device Manager", chọn update driver cho PCI Simple Communication Controller. Browse : D:\vioserial\win10\amd64

![](images/win10image56.png)

+ Cài đặt qemu-guest-agent cho Windows 10, vào CD ROM virio và cài đặt phiên bản qemu-ga (ở đây là qemu-ga-x64)

![](images/win10image57.png)

+ Kiểm tra lại version của qemu-guest-agent & status (phải đảm bảo version >= 7.3.2)

![](images/win10image59.png)


**Buoc 8**: Chỉnh sửa tham số trên Windows

Chỉnh sửa Firewall, enable remote desktop, chỉnh sửa timezone và Active key

- Chỉnh sửa remote 

![](images/win10image60.png)

- Chỉnh sửa firewall

Mở port port firewall  : Advance setting => Windows firewall with advance => Inbound rules 
Port 80 : Windows remote management service
Port 443 : Secure Socket Tunneling Protocol 
ICMP : File and Printer Sharing
Allow Public network : 
Allow remote service : Allow an app or feature

Chuot phai vao service -> enable

![](images/win10image61.png)

![](images/win10image62.png)

![](images/win10image63.png)

Advance setting => Windows firewall with advance => Properties => Public profile => Inbound connection : Allow

![](images/win10image64.png)

![](images/win10image65.png)

- Chỉnh về zone UTC +07:00

![](images/win10image66.png)

- Active Key cho windows




