
## Nhược điểm của địa chỉ IPv4
 
- Cấu trúc định tuyến không hiệu quả
- Hạn chế về tính bảo mật và kết nối đầu cuối – đầu cuối:
- Nguy cơ thiếu hụt không gian địa chỉ.
- Cùng những hạn chế của IPv4 thúc đẩy sự đầu tư nghiên cứu một giao thức internet mới, khắc phục những hạn chế của giao thức IPv4 và đem lại những đặc tính mới cần thiết cho dịch vụ và cho hoạt động mạng thế hệ tiếp theo. Giao thức Internet IETF đã đưa ra, quyết định thúc đẩy thay thế cho IPv4 là IPv6 (Internet Protocol Version 6), giao thức Internet phiên bản 6, còn được gọi là giao thức IP thế hệ mới (IP Next Generation – IPng). Địa chỉ Internet phiên bản 6 có chiều dài gấp 4 lần chiều dài địa chỉ IPv4, bao gồm 128 bít.

## Mục tiêu trong thiết kế IPv6
IPv6 được thiết kế với mục tiêu như sau:
- Không gian địa chỉ lớn hơn và dễ dàng quản lý không gian địa chỉ.
- Hỗ trợ kết nối đầu cuối-đầu cuối và loại bỏ hoàn toàn công nghệ NAT
- Quản trị TCP/IP dễ dàng hơn: DHCP được sử dụng trong IPv4 nhằm giảm cấu hình thủ công TCP/IP cho host. IPv6 được thiết kế với khả năng tự động cấu hình, không cần sử dụng máy chủ DHCP, hỗ trợ hơn nữa trong việc giảm cấu hình thủ công.
- Cấu trúc định tuyến tốt hơn: Định tuyến IPv6 được thiết kế hoàn toàn phân cấp.
- Hỗ trợ tốt hơn Multicast: Multicast là một tùy chọn của địa chỉ IPv4, tuy nhiên khả năng hỗ trợ và tính phổ dụng chưa cao.
- Hỗ trợ bảo mật tốt hơn.
- Hỗ trợ tốt hơn cho di động.
	
## Biểu diễn địa chỉ IPv6

Địa chỉ IPv6 có chiều dài 128 bit, biểu diễn dưới dạng các cụm số hexa phân cách bởi dấu :, ví dụ:

`2001:0DC8::1005:2F43:0BCD:FFFF`

 1. Rút gọn cách viết địa chỉ IPv6:

- Quy tắc 1: Trong một nhóm 4 số hexa, có thể bỏ bớt những số 0 bên trái. Ví dụ cụm số “0000” có thể viết thành “0”, cụm số “09C0” có thể viết thành “9C0”

- Quy tắc 2: Trong cả địa chỉ ipv6, một số nhóm liền nhau chứa toàn số 0 có thể không viết và chỉ viết thành "::". Tuy nhiên, chỉ được thay thế một lần như vậy trong toàn bộ một địa chỉ ipv6.

 2. Phân loại:

Theo cách thức một gói tin được truyền tải đến đích, địa chỉ IPv6 bao gồm ba loại: `unicast`, `multicast`, `anycast`. 

Để hoạt động được, thiết bị IPv6 có thể và cần phải được gắn nhiều dạng địa chỉ thuộc ba loại địa chỉ đã nêu trên.

RFC 3513 - Internet Protocol Version 6 (IPv6) Addressing Architecture mô tả cấu trúc ba loại địa chỉ ipv6:

 2.1 Địa chỉ unicast

![](images/image001.gif)

Địa chỉ unicast xác định một giao diện duy nhất trong phạm vi tương ứng. Trong mô hình định tuyến, các gói tin có địa chỉ đích là địa chỉ unicast chỉ được gửi tới một interface duy nhất.  Địa chỉ unicast được sử dụng trong giao tiếp một – một

** Địa chỉ đặc biệt:
`0:0:0:0:0:0:0:0` hay còn được viết "::" là dạng địa chỉ “không định danh” được sử dụng để thể hiện rằng hiện tại node không có địa chỉ.

`0:0:0:0:0:0:0:1` hay "::1" được sử dụng làm địa chỉ xác định giao diện loopback, cho phép một node gửi gói tin cho chính nó, tương đương với địa chỉ 127.0.0.1 của ipv4.

 2.2 Địa chỉ multicast

![](images/image002.gif)

Địa chỉ multicast định danh nhiều interface. Gói tin có địa chỉ đích là địa chỉ multicast sẽ được gửi tới tất cả các interface trong nhóm được gắn địa chỉ đó. Địa chỉ multicast được sử dụng trong giao tiếp một – nhiều.

Trong địa chỉ ipv6 không còn tồn tại khái niệm địa chỉ broadcast. Mọi chức năng của địa chỉ broadcast trong ipv4 được đảm nhiệm thay thế bởi địa chỉ ipv6 multicast. Ví dụ chức năng broadcast trong một subnet của địa chỉ ipv4 được đảm nhiệm bằng một loại địa chỉ ipv6 là địa chỉ multicast mọi node phạm vi link (link-local scope all-nodes multicast address `FF02::1`)

 2.3. Địa chỉ anycast

![](images/image005.gif)

Địa chỉ anycast cũng xác định tập hợp nhiều giao diện. Tuy nhiên, trong mô hình định tuyến, gói tin có địa chỉ đích anycast chỉ được gửi tới một giao diện duy nhất trong tập hợp. Giao diện đó là giao diện “gần nhất” theo khái niệm của thủ tục định tuyến.

