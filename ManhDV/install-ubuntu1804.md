### Hướng dẫn cài đặt Ubuntu 18.04 trên KVM

## 1. Trên Host KVM
### 1.1. Tạo file disk máy ảo và cài đặt OS

 - Tạo file disk máy ảo
```sh
qemu-img create -f qcow2 /var/lib/libvirt/images/u18.qcow2  10G
```

 - Tạo máy ảo với tool *Virt-Manager*. Import file disk máy ảo. 
 
![u18](/ManhDV/images/u18-00.png) 

 - Chọn *OS Type* : `Linux` , *Version* : `Ubuntu 17.04`, Chọn *Broswer* tới đường dẫn của file disk.
 
![u18](/ManhDV/images/u18-01.png) 

 - Chọn file disk tại thư mục *images*
 
![u18](/ManhDV/images/u18-02.png) 

 - Chọn dung lượng RAM và CPU 
 
![u18](/ManhDV/images/u18-03.png) 

 - Đặt tên và tích vào dòng `Customize configuration before install`. Sau đó chọn *Finish*
 
![u18](/ManhDV/images/u18-04.png) 

 - Chỉnh sửa mode của card mạng thành `virtio`
 
![u18](/ManhDV/images/u18-05.png) 

 - Mount file ISO bằng cách thêm CDROM. Chọn *Add Hardware* => *Storage* => *Manage*, sau đó chọn file iso Ubuntu Server 18.04. Chú ý chọn *Device type* là `CDROM device`.
 
![u18](/ManhDV/images/u18-08.png) 

 - Tại thư mục `iso`, chọn file iso Ubuntu server 18.04
 
![u18](/ManhDV/images/u18-06.png) 

 - Chỉnh sửa Boot Option, chọn boot từ CDROM đầu tiên để cài đặt từ file ISO.
 
![u18](/ManhDV/images/u18-09.png) 

 - Sau đó chọn *Begin Installation* để bắt đầu cài đặt 
 
![u18](/ManhDV/images/u18-10.png) 

 - Chọn ngôn ngữ là *English*, sau đó ấn `ENTER`
 
![u18](/ManhDV/images/u18-11.png) 

 - Chọn *Layout* và *Variant* là `English`, chọn `Done` và ấn `ENTER`.
 
![u18](/ManhDV/images/u18-12.png) 

 - Chọn `Install Ubuntu` và ấn `ENTER`
 
![u18](/ManhDV/images/u18-13.png) 

 - Để card mạng sử dụng DHCP. Chọn `Done` và ấn `ENTER`.
 
![u18](/ManhDV/images/u18-14.png) 

 - Chọn không dùng Proxy. Chọn `Done` và ấn `ENTER`.
 
![u18](/ManhDV/images/u18-15.png) 

 - Chọn mirror Ubuntu mặc định. Chọn `Done` và ấn `ENTER`.
 
![u18](/ManhDV/images/u18-16.png) 

 - Chọn cài đặt Disk *KHÔNG DÙNG LVM*. Ấn `ENTER`.
 
![u18](/ManhDV/images/u18-17.png) 

 - Cài đặt sử dụng ổ vda. Ấn `ENTER`.
 
![u18](/ManhDV/images/u18-18.png) 

 - Chỉnh sửa lại cấu hình ổ cứng (nếu cần), sau đó chọn `DONE`.
 
![u18](/ManhDV/images/u18-19.png) 

 - `Continue` để confirm và tiếp tục cài đặt.
 
![u18](/ManhDV/images/u18-20.png) 

 - Điền các thông tin cho máy ảo. User mặc định được sử dụng là *ubuntu*.
 
![u18](/ManhDV/images/u18-21.png) 

 - Không chọn option nào, kéo xuống chọn `Done` và ấn `ENTER`.
 
![u18](/ManhDV/images/u18-22.png) 

 - Bắt đầu thực hiện cài đặt.
 
![u18](/ManhDV/images/u18-23.png) 

 - Sau khi cài đặt xong chọn *Reboot Now* để thực hiện reboot. 
 
![u18](/ManhDV/images/u18-24.png) 

 - Shutdown máy để thực hiện remove CDROM
 
![u18](/ManhDV/images/u18-25.png) 

 - Remove CDROM
 
![u18](/ManhDV/images/u18-26.png) 

