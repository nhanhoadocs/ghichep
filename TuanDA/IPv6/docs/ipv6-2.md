# Các dạng địa chỉ IPv6

Địa chỉ unicast có năm dạng sau đây :
1. Địa chỉ đặc biệt (Special address)
2. Địa chỉ Link-local
3. Địa chỉ Site-local
4. Địa chỉ định danh toàn cầu (Global unicast address)
5. Địa chỉ tương thích (Compatibility address)

## 1. Địa chỉ đặc biệt

`0:0:0:0:0:0:0:0` hay còn được viết "::" là dạng địa chỉ “không định danh” được sử dụng để thể hiện rằng hiện tại node không có địa chỉ.

`0:0:0:0:0:0:0:1` hay "::1" được sử dụng làm địa chỉ xác định giao diện loopback, cho phép một node gửi gói tin cho chính nó, tương đương với địa chỉ `127.0.0.1` của ipv4.

## 2. Địa chỉ Link-local

Trong IPv6, các node trên cùng một đường link coi nhau là các node lân cận (neighbor node).

Giao thức Neighbor Discovery (ND) là một giao thức thiết yếu, phục vụ giao tiếp giữa các node lân cận.

Địa chỉ link-local được tạo nên từ 64 bit định danh giao diện Interface và một tiền tố (prefix) quy định sẵn cho địa chỉ link-local là `FE80::/10`.

**Cấu trúc của địa chỉ link-local**

Một địa chỉ link-local cũng dựa vào interface identifier (định danh giao diện), nhưng dùng một dạng khác cho tiền tố mạng (network prefix).

Dạng địa chỉ link-local

![](../images/linklocal_1.png)


Địa chỉ link-local bắt đầu bởi 10 bit tiền tố `FE80::/10` (giá trị nhị phân `1111 1110 10`), theo sau bởi 54 bit 0. 64 bit còn lại là định danh giao diện (Interface ID).

## 3. Địa chỉ site-local
Dạng địa chỉ ipv6 Site-local được thiết kế với mục đích sử dụng trong phạm vi một mạng, tương đương với địa chỉ dùng riêng (private) trong ipv4

Địa chỉ Site-local được định nghĩa trong thời kỳ đầu phát triển IPv6. Trong quá trình sử dụng IPv6, người ta nhận thấy nhu cầu sử dụng địa chỉ dạng site-local trong tương lai phát triển của thế hệ địa chỉ ipv6 là không thực tế và không cần thiết. Do vậy, IETF đã sửa đổi RFC3513, loại bỏ đi dạng địa chỉ site-local. Chức năng của địa chỉ Site-local được thay thế bởi dạng địa chỉ IPV6 khác đang được dự thảo, là Globally Unique Local

## 3b. 


## 4. Địa chỉ định danh toàn cầu (Global unicast address)
Đây là dạng địa chỉ tương đương với địa chỉ ipv4 public. Chúng được định tuyến và có thể liên kết tới trên phạm vi toàn cầu. 

3 bít đầu tiên 001 xác định dạng địa chỉ global unicast.

![](../images/globalunicast.png)

## 5. Địa chỉ tương thích (Compatibility address)
	
Địa chỉ tương thích được định nghĩa nhằm mục đích hỗ trợ việc chuyển đổi từ địa chỉ ipv4 sang địa chỉ ipv6, bao gồm:
- Sử dụng trong công nghệ biên dịch giữa địa chỉ ipv4 – ipv6
- Hoặc được sử dụng cho một hình thức chuyển đổi được gọi là "đường hầm – tunnel", lợi dụng cơ sở hạ tầng sẵn có của mạng ipv4 kết nối các mạng ipv6 bằng cách bọc gói tin ipv6 vào trong gói tin đánh địa chỉ ipv4 để truyền đi trên mạng ipv4.

- IPv4-compatible (::x.y.z.w), được dùng khi các node IPv6/IPv4 liên lạc với nhau bằng IPv6.
- IPv4-mapped (::FFFF:x.y.z.w), được dùng khi node IPv4 liên lạc với node IPv6.
- 6to4 được dùng khi liên lạc giữa các node IPv4 và các node IPv6 thông qua định tuyến IPv4. Có định dạng kết hợp giữa prefix2002::/16 và 32-bit của địa chỉ public IPv4.


**Địa chỉ IPv4-compatible**

Địa chỉ IPv4-compatible được tạo từ 32 bit địa chỉ ipv4 và được viết như sau:

`0:0:0:0:0:0:w.x.y.z` hoặc `::w.x.y.z`

Trong đó `w.x.y.z` là địa chỉ ipv4 viết theo cách thông thường

Dạng địa chỉ IPv4-compatible được sử dụng cho công nghệ tunnel tự động. Nếu một địa chỉ IPv4-compatible được sử dụng làm địa chỉ ipv6 đích, lưu lượng ipv6 đó sẽ được tự động bọc trong gói tin có ipv4 header và gửi tới đích sử dụng cơ sở hạ tầng mạng ipv4.

Hiện nay, nhu cầu về dạng kết nối tunnel tự động này không còn nữa. Do vậy, dạng địa chỉ này cũng đã được loại bỏ không còn sử dụng trong giai đoạn phát triển tiếp theo của địa chỉ ipv6.

**Địa chỉ IPv4-mapped**

Địa chỉ IPv4-mapped cũng được tạo nên từ 32 bít địa chỉ ipv4 và có dạng như sau: `0:0:0:0:0:FFFF:w.x.y.z` hoặc `::FFFF:w.x.y.z`

Trong đó `w.x.y.z` là địa chỉ ipv4 viết theo cách thông thường.

![](../images/ipv4_mapped.png)

Ví dụ: `::FFFF:129.144.52.38`

Địa chỉ này được sử dụng để biểu diễn một node thuần ipv4 thành một node ipv6 và được sử dụng trong công nghệ biên dịch địa chỉ IPv4 – IPv6 (ví dụ công nghệ NAT-PT, phục vụ giao tiếp giữa mạng thuần địa chỉ ipv4 và mạng thuần địa chỉ ipv6). Địa chỉ IPv4-mapped không bao giờ được dùng làm địa chỉ nguồn hay địa chỉ đích của một gói tin ipv6.


**Địa chỉ 6to4**

IANA đã cấp phát một prefix địa chỉ dành riêng `2002::/16` trong vùng địa chỉ có ba bít đầu 001 (vùng địa chỉ unicast toàn cầu) để sử dụng cho một công nghệ chuyển đổi giao tiếp ipv4-ipv6 rất thông dụng có tên gọi công nghệ tunnel 6to4.

Địa chỉ 6to4 được sử dụng trong giao tiếp giữa hai node chạy đồng thời cả hai thủ tục ipv4 và ipv6 trên mạng cơ sở hạ tầng định tuyến của ipv4. Địa chỉ 6to4 được hình thành bằng cách gắn prefix `2002::/16` với 32 bít địa chỉ ipv4 (viết dưới dạng hexa), từ đó tạo nên một prefix địa chỉ /48.



## 3. Tóm tắt các dạng địa chỉ IPv6:

|Bit | Dạng địa chỉ | Chú thích|
|---|---|---|
|:: | Địa chỉ đặc biệt | |
|::1 | Địa chỉ loopback | |
|FE80::/10 | Địa chỉ link-local | |
|FEC0::/10 | Địa chỉ site local | Đã được hủy bỏ |
|2000::/3 | Địa chỉ unicast định danh toàn cầu.<p>Trong đó: 2002::/16 là Địa chỉ của tunnel 6to4  |
|::w.x.y.z | Địa chỉ tương thích | Dùng cho công nghệ tunnel tự động.|
|::FFFF:w.x.y.z | Địa chỉ IPv4 - map | Dùng trong biên dịch địa chỉ IPv6-IPv4 |
|FF::/8 |Địa chỉ multicast ||
|FF01::1 |Địa chỉ multicast mọi node phạm vi node||
|FF02::1 |Địa chỉ multicast mọi node phạm vi link||
|FF01::2 |Địa chỉ multicast mọi router phạm vi node||
|FF02::2 |Địa chỉ multicast mọi router phạm vi link||
|FF05::2 |Địa chỉ multicast mọi router phạm vi site||
|FF02::1:FF/104 |Địa chỉ multicast Solicited node||


**Tham khảo**

https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x1159.html
https://vi.wikipedia.org/wiki/%C4%90%E1%BB%8Ba_ch%E1%BB%89_IPv6