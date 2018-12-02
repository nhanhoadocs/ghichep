# Tìm hiểu về Linux Bridge

### Mục lục

[1. Giới thiệu về Linux Bridge](#gioithieu)

[2. Tổng quan về Linux Bridge](#tongquan)

[3. Cấu trúc và các thành phần](#cautruc)

[4. Các tính năng của Linux bridge](#tinhnang)

<a name="gioithieu"></a>
## 1. Giới thiệu về Linux Bridge

![](../images/linuxbridge/Screenshot_258.png)

Để hiểu về Linux Bridge trước tiên ta nên hiểu trong Network Bridge là gì?

- Hiểu theo nghĩa một thiết bị: 

+ Bridge là thiết bị mạng thuộc lớp thứ 2 trong mô hình OSI (Data Link Layer). Bridge được sử dụng để ghép nối 2 mạng để tạo thành một mạng lớn hơn (Bridge dùng làm cầu nối giữa hai mạng Ethernet).

+ Khi có một gói tin từ một máy tính thuộc mạng này chuyển tới một máy tính thuộc mạng khác, Bridge sẽ sao chép lại gói tin và và gửi nó tới mạng đích.

+ Bridge là hoạt động trong suốt, các máy tính thuộc các mạng khác nhau có thể gửi các thông tin với nhau đơn giản mà không cần biết sự có mặt của Bridge.

+ Một Bridge có thể xử lý được nhiều lưu thông trên mạng cũng như địa chỉ IP cùng một lúc. Tuy nhiên, Bridge chỉ kết nối những mạng cùng loại và sử dụng cho những mạng tốc độ cao sẽ khó hơn nếu chúng nằm cách xa nhau.

- Linux Bridge trong ảo hóa network

Linux bridge là một switch dạng mềm – đây là 1 trong 3 công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các thiết bị vật lý.

Linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.






