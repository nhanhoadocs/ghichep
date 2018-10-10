# Tìm hiểu và cài đặt iDRAC trên server DELL #

### Mục lục

[1, Tìm hiểu về iDRAC](#timhieuveidrac)

[2, Cài đặt iDRAC](#caidatidrac)

<a name="timhieuveidrac"></a>
## 1, Tìm hiểu về iDRAC ##

Đối với dòng server DELL thế hệ mới model Power Edge Server thế hệ thứ 12 của Dell thì đều có tích hợp iDRAC (Integrated Dell Remote Access Controller) cung cấp tính năng để quản lý các thông số hardware của server từ xa, troubleshoot, remote thông qua một giao diện.

- iDRAC được cấu hình thông qua một port riêng, kết nối qua đường RJ45 được cấu hình các thông số về network.

![](https://i.imgur.com/vX1r6eq.png)

<a name="caidatidrac"></a>
## 2, Cài đặt iDRAC ##

- Khởi động server DELL -> F2 để vào "System Setup"

![](https://i.imgur.com/LS3Yq8l.png)

+Đang vào chế độ Setup

![](https://i.imgur.com/5ZDD9Ld.png)

+Lựa chọn mục setup iDRAC

![](https://i.imgur.com/eqqpW6z.png)

+Cấu hình địa chỉ IP cho port iDRAC

![](https://i.imgur.com/szGqKe6.png)

+Setup user login vào iDRAC

Quay trở lại tab Setup chọn "User Configuration"

![](https://i.imgur.com/8IZ304Q.png)

Set password cho user root

![](https://i.imgur.com/MZTAgJV.png)

+ Confirm thay đổi và reboot lại server

![](https://i.imgur.com/XPf9PyL.png)

--> Quá trình cài đặt thành công login vào iDRAC thông qua địa chỉ ip và username/pass đã cấu hình ở trên.

https://ip_idrac

![](https://i.imgur.com/vGp2czy.png)

Login thành công hiển thị giao diện dưới

![](https://i.imgur.com/MgmRQWR.png)

## 3.Giám sát các thông tin trên iDRAC ##

**3.1. Tab server**
Properties: Cung cấp các thông tin chung về server và đường link truy cập nhanh tới các mục khác, cửa sổ console để remotr desktop, thao tác nhanh đối với server như Power ON /OFF..., thông tin về về server như BIOS, IP, Firmware OS.
![](https://i.imgur.com/7PSjQdi.png)

+Attached Media: Cấu hình cho phép việc đính kèm file ISO của OS lên hay không, chia sẻ file hay không.

![](https://i.imgur.com/5E8MTk2.png)

+Log: Hiển thị thông tin log đối với server có sắp xếp theo mức độ, time/date

![](https://i.imgur.com/B8tHf7c.png)

+Power / Thermal: Hiển thị các thông tin về nguồn và nhiệt độ của server

![](https://i.imgur.com/LjfVkz2.png)

+Virtual Console: Thiết lập về các thông số cho việc console tới server từ xa.

![](https://i.imgur.com/SH2KzBq.png)

+Setup: Thiết lập thứ tự boot cho server khi khởi động

![](https://i.imgur.com/c64Efcj.png)

**3.2. Tab iDRAC Settings**
Cung cấp thông tin về các thông số setup cho iDRAC như IP network, user...

![](https://i.imgur.com/l4xgN26.png)

+Network: Thông tin cấu hình network cho iDRAC

![](https://i.imgur.com/FAsZDUy.png)

+User Authentication: Thông tin liên quan đến setup user login iDRAC

![](https://i.imgur.com/MR6GTMx.png)

+Update and Rollback: Update firmware cho iDRAC
![](https://i.imgur.com/l6lAzzx.png)

+Sessions: Hiển thị phiên kết nối vào trình iDRAC

![](https://i.imgur.com/N7mcLeW.png)

**3.3. Tab Hardware**

Cung cấp đầy đủ các thông tin về phần cứng của server

![](https://i.imgur.com/h7q3CgH.png)

+Batteries: Hiển thị trạng thái của pin main

![](https://i.imgur.com/LVQ9joD.png)

+Fan: Thạng thái fan trong server

![](https://i.imgur.com/qKd96mL.png)

+CPU: Trạng thái của CPU

![](https://i.imgur.com/aC96cJU.png)

+Memory: Trạng thái RAM

![](https://i.imgur.com/QJEoR7X.png)

+Front Panel: Trạng thái biểu tượng phía mặt trước của server

![](https://i.imgur.com/khf6pBt.png)
+Network Devices: Trạng thái và thông tin về các card mạng trên server và các card cắm thêm.
![](https://i.imgur.com/UoTxwhg.png)

+Power Supplies: Thông tin trạng thái về nguồn server

![](https://i.imgur.com/4I3jQyU.png)

## 3.4. Tab chức năng storage ##

Hiển thị thông tin về storage của server: Trạng thái raid, disk...

![](https://i.imgur.com/qyo5ru4.png)
