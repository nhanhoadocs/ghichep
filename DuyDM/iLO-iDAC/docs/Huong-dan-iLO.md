# Tìm hiểu và cài đặt iLO trên server #

### Mục lục

[1, Tìm hiểu về iLO](#timhieuveilo)

[2, Cài đặt iLO](#caidatilo)

<a name="timhieuveilo"></a>
## 1, Tìm hiểu về iLO ##

Đối với dòng server HP thế hệ mới iLO (intergrated Lights Out) cung cấp tính năng để quản lý các thông số hardware của server từ xa, troubleshoot, remote thông qua một giao diện. iLO là một cổng riêng biệt trên server, có chương trình và phần cứng độc lập, giúp quản lý phần cứng server độc lập, nó có chương trình WebGUI để quản lý cũng như command line tương ứng.

 iLO được cấu hình thông qua một port riêng, kết nối qua đường RJ45 được cấu hình các thông số về network.

![](https://i.imgur.com/JEUwNfU.jpg)

<a name="caidatilo"></a>
## 2, Cài đặt iLO ##

Khởi động server HP để server chạy khi thấy dòng Config iLO thì ấn phím chức năng tương ứng F8

![](https://i.imgur.com/fKD0HT8.jpg)

+ Cấu hình network cho port iLO

Tắt chế độ DHCP

Network -> DNS/DHCP

![](https://i.imgur.com/h3W8XIt.jpg)

Network -> NIC and TCP/IP

![](https://i.imgur.com/lYkEh9D.jpg)

Nhập các thông số về địa chỉ IP

![](https://i.imgur.com/yvq6nli.jpg)

+ Cấu hình password cho user

Change pass used administrator

User -> Nhập password mới -> F10 để save lại

![](https://i.imgur.com/aGAdbWC.jpg)

+ Thoát ra và khởi động lại máy

+ Login vào iLO qua địa chỉ IP và tài khoản đãn cấu hình

https://ip_iLO/

![](https://i.imgur.com/UFPbfkD.png)

Login thành công

![](https://i.imgur.com/l3JfqHG.png)

## 3.Giám sát các thông tin trên iLO ##

**3.1. Tab information**

Overview: Hiển thị tổng quan về server firmware, trạng thái tắt bật...

+ System Information: Trạng thái, thông tin về các bộ phận của server

![](https://i.imgur.com/w6X62q8.png)

+ iLO event log: Ghi lại nhật kí về việc cài đặt thông tin cho iLO

![](https://i.imgur.com/0RJkbQC.png)

+ Integrated Management Log: Thông tin nhật ký vận hành phần cứng server

![](https://i.imgur.com/48nnGtN.png)

+ 
**3.2. Tab Remote console**

Cho phép người quản thị điều khiển màn hình console của server từ xa

![](https://i.imgur.com/Zo9ElZ6.png)

**3.3. Tab Virtual Media**

Cung cấp chức nắng đính kèm file ISO phục vụ cài đặt OS từ xa và chỉnh sửa thứ tự boot của server

![](https://i.imgur.com/Txxt5MV.png)

**3.4. Power Management**

Chức năng quản lý việc bật/tắt server từ xa

![](https://i.imgur.com/HXwwaAY.png)

**3.5. Administration**

Chức năng quản lý thông tin về iLO như license, firmware, cài đặt ip, user...

+ iLO Firmware: Hiển thị firmware iLO

![](https://i.imgur.com/TB4mI4k.png)

+ User Administration: Thiết lập tài khoản login iLO

![](https://i.imgur.com/9NE0Owp.png)

+ Access Settings: Cài đặt kiểm soát truy cập tới các port của server

![](https://i.imgur.com/RstHda1.png)

+ Security: Thiết lập login tới iLO

![](https://i.imgur.com/ArFQjJQ.png)

+ Network: Thiết lập thông tin IP cho port iLO

![](https://i.imgur.com/hgoLvBJ.png)

Xin chân thành cảm ơn!





