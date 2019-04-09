Địa chỉ unicast có năm dạng sau đây :

1) Địa chỉ đặc biệt (Special address)
2) Địa chỉ Link-local
3) Địa chỉ Site-local
4) Địa chỉ định danh toàn cầu (Global unicast address)
5) Địa chỉ tương thích (Compatibility address)


#Prefixs

- 2001:DB8:0:2F3B::/64 subnet prefix for a subnet
- 2001:DB8::/48 address prefix for a summarized route
- FF00::/8 address prefix for an address range

subnet mask không sử dụng với IPv6

4) Địa chỉ định danh toàn cầu (Global unicast address)
- Định nghĩa ở RFC 3587
- ![](../images/unicast1.png)


- Cấu hình tự động ở interface


## 1) Địa chỉ đặc biệt:
`0:0:0:0:0:0:0:0` hay còn được viết "::" là dạng địa chỉ “không định danh” được sử dụng để thể hiện rằng hiện tại node không có địa chỉ.

`0:0:0:0:0:0:0:1` hay "::1" được sử dụng làm địa chỉ xác định giao diện loopback, cho phép một node gửi gói tin cho chính nó, tương đương với địa chỉ 127.0.0.1 của ipv4.

## 2) Địa chỉ Link-local

Trong IPv6, các node trên cùng một đường link coi nhau là các node lân cận (neighbor node).

Giao thức Neighbor Discovery (ND) là một giao thức thiết yếu, phục vụ giao tiếp giữa các node lân cận.

Địa chỉ link-local được tạo nên từ 64 bit định danh giao diện Interface và một tiền tố (prefix) quy định sẵn cho địa chỉ link-local là `FE80::/10`.

**Cấu trúc của địa chỉ link-local**

Một địa chỉ link-local cũng dựa vào interface identifier (định danh giao diện), nhưng dùng một dạng khác cho tiền tố mạng (network prefix).

Dạng địa chỉ link-local

|bits	| 10	| 54 |	64 |
|--|--|--|--|
|field	|prefix	|zeroes	|interface identifier|

Địa chỉ link-local bắt đầu bởi 10 bit tiền tố `FE80::/10` (giá trị nhị phân `1111 1110 10`), theo sau bởi 54 bit 0. 64 bit còn lại là định danh giao diện (Interface ID).





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
https://vi.wikipedia.org/wiki/%C4%90%E1%BB%8Ba_ch%E1%BB%89_IPv6