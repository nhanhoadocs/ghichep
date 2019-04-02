Địa chỉ unicast có năm dạng sau đây :

1) Địa chỉ đặc biệt (Special address)
2) Địa chỉ Link-local
3) Địa chỉ Site-local
4) Địa chỉ định danh toàn cầu (Global unicast address)
5) Địa chỉ tương thích (Compatibility address)













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