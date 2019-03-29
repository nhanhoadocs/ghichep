


Mục tiêu trong thiết kế IPv6
IPv6 được thiết kế với mục tiêu như sau:
- Không gian địa chỉ lớn hơn và dễ dàng quản lý không gian địa chỉ.
- Hỗ trợ kết nối đầu cuối-đầu cuối và loại bỏ hoàn toàn công nghệ NAT
- Quản trị TCP/IP dễ dàng hơn: DHCP được sử dụng trong IPv4 nhằm giảm cấu hình thủ công TCP/IP cho host. IPv6 được thiết kế với khả năng tự động cấu hình, không cần sử dụng máy chủ DHCP, hỗ trợ hơn nữa trong việc giảm cấu hình thủ công.
- Cấu trúc định tuyến tốt hơn: Định tuyến IPv6 được thiết kế hoàn toàn phân cấp.
- Hỗ trợ tốt hơn Multicast: Multicast là một tùy chọn của địa chỉ IPv4, tuy nhiên khả năng hỗ trợ và tính phổ dụng chưa cao.
- Hỗ trợ bảo mật tốt hơn.
- Hỗ trợ tốt hơn cho di động.
	
Biểu diễn địa chỉ IPv6

Địa chỉ IPv6 có chiều dài 128 bit, biểu diễn dưới dạng các cụm số hexa phân cách bởi dấu ::, ví dụ `2001:0DC8::1005:2F43:0BCD:FFFF`. 

Rút gọn cách viết địa chỉ IPv6:
Không như địa chỉ IPv4, địa chỉ ipv6 có rất nhiều dạng. Trong đó có những dạng chứa nhiều chữ số 0 đi liền nhau. Nếu viết toàn bộ và đầy đủ những con số này thì dãy số biểu diễn địa chỉ IPv6 thường rất dài. Do vậy, có thể rút gọn cách viết địa chỉ ipv6 theo hai quy tắc sau đây:

Quy tắc 1: Trong một nhóm 4 số hexa, có thể bỏ bớt những số 0 bên trái. Ví dụ cụm số “0000” có thể viết thành “0”, cụm số “09C0” có thể viết thành “9C0”

Quy tắc 2: Trong cả địa chỉ ipv6, một số nhóm liền nhau chứa toàn số 0 có thể không viết và chỉ viết thành “::”. Tuy nhiên, chỉ được thay thế một lần như vậy trong toàn bộ một địa chỉ ipv6. Điều này rất dễ hiểu. Nếu chúng ta thực hiện thay thế hai hay nhiều lần các nhóm số 0 bằng “::”, chúng ta sẽ không thể biết được số các số 0 trong một cụm thay thể bởi “::” để từ đó khôi phục lại chính xác địa chỉ IPv6 ban đầu.


Theo cách thức một gói tin được truyền tải đến đích, địa chỉ IPv6 bao gồm ba loại: unicast, multicast, anycast. 

-          Để hoạt động được, thiết bị IPv6 có thể và cần phải được gắn nhiều dạng địa chỉ thuộc ba loại địa chỉ đã nêu trên.

RFC 3513 - Internet Protocol Version 6 (IPv6) Addressing Architecture mô tả cấu trúc ba loại địa chỉ ipv6:

## 1. Địa chỉ unicast

![](images/image001.gif)

Địa chỉ unicast xác định một giao diện duy nhất trong phạm vi tương ứng. Trong mô hình định tuyến, các gói tin có địa chỉ đích là địa chỉ unicast chỉ được gửi tới một giao diện duy nhất.  Địa chỉ unicast được sử dụng trong giao tiếp một – một

## 2. Địa chỉ multicast

![](images/image002.gif)

Địa chỉ multicast định danh nhiều giao diện. Gói tin có địa chỉ đích là địa chỉ multicast sẽ được gửi tới tất cả các giao diện trong nhóm được gắn địa chỉ đó. Địa chỉ multicast được sử dụng trong giao tiếp một – nhiều.

Trong địa chỉ ipv6 không còn tồn tại khái niệm địa chỉ broadcast. Mọi chức năng của địa chỉ broadcast trong ipv4 được đảm nhiệm thay thế bởi địa chỉ ipv6 multicast. Ví dụ chức năng broadcast trong một subnet của địa chỉ ipv4 được đảm nhiệm bằng một loại địa chỉ ipv6 là địa chỉ multicast mọi node phạm vi link (link-local scope all-nodes multicast address FF02::1)

## 3. Địa chỉ anycast

![](images/image005.gif)

Địa chỉ anycast cũng xác định tập hợp nhiều giao diện. Tuy nhiên, trong mô hình định tuyến, gói tin có địa chỉ đích anycast chỉ được gửi tới một giao diện duy nhất trong tập hợp. Giao diện đó là giao diện “gần nhất” theo khái niệm của thủ tục định tuyến.

Địa chỉ unicast có năm dạng sau đây :

1) Địa chỉ đặc biệt (Special address)
2) Địa chỉ Link-local
3) Địa chỉ Site-local
4) Địa chỉ định danh toàn cầu (Global unicast address)
5) Địa chỉ tương thích (Compatibility address)

Địa chỉ đặc biệt:
0:0:0:0:0:0:0:0 hay còn được viết "::" là dạng địa chỉ “không định danh” được sử dụng để thể hiện rằng hiện tại node không có địa chỉ.

0:0:0:0:0:0:0:1 hay "::1" được sử dụng làm địa chỉ xác định giao diện loopback, cho phép một node gửi gói tin cho chính nó, tương đương với địa chỉ 127.0.0.1 của ipv4.











## So sánh với IPv4:
|IPv4 Address|	IPv6 Address|
|---|---|
|Internet address classes|Không sử dụng trong IPv6|
|Multicast addresses (224.0.0.0/4)|	IPv6 multicast addresses (FF00::/8)|
|Broadcast addresses	|Không sử dụng trong IPv6|
|Địa chỉ không xác định 0.0.0.0	|Địa chỉ không xác định ::|
|Địa chỉ loopback  127.0.0.1|	Địa chỉ loopback ::1|
|Public IP addresses	|Global unicast addresses|
|Private IP addresses (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16)	|Site-local addresses (FEC0::/10)|
|Autoconfigured addresses (169.254.0.0/16)|	Link-local addresses (FE80::/64)|
|Text representation: Dotted decimal notation|	Text representation: Colon hexadecimal format with suppression of leading zeros and zero compression. IPv4-compatible addresses are expressed in dotted decimal notation.|
|Network bits representation: Subnet mask in dotted decimal notation or prefix length	|Network bits representation: Prefix length notation only
|DNS name resolution: IPv4 host address (A) resource record	|DNS name resolution: IPv6 host address (AAAA) resource record|
|DNS reverse resolution: IN-ADDR.ARPA domain|	DNS reverse resolution: IP6.ARPA domain|


https://mirrors.deepspace6.net/Linux+IPv6-HOWTO/x1159.html