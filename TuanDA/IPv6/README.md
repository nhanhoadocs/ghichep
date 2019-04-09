# Nội dung	

### [PHẦN 1: TỔNG QUAN VỀ ĐỊA CHỈ IPv6](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/docs/ipv6-summary.md)

### PHẦN 2: LÝ THUYẾT VỀ ĐỊA CHỈ IPV6
- 2.1 Biểu diễn địa chỉ IPv6
- 2.2 Cấu trúc đánh địa chỉ. Các dạng địa chỉ IPv6
- 2.3 Định danh giao diện trong địa chỉ IPv6
- 2.4 IPv6 Header
- 2.5 Cấu hình thực tế của IPv6 trên các hệ điều hành:
    + [CentOS 6](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-centos6.md)
    + [CentOS 7](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-centos7.md)
    + [Ubuntu 16](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-ubuntu16.md)
    + [Ubuntu 18](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-ubuntu18.md)
    + [Windows 7](
    https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-windows7.md)
    + [Windows 2008](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-windows2008.md)
    + [Windows 2012](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-windows2012.md)

   - Cấu hình thực tế của IPv6 trên thiết bị mạng router Cisco
    - Cấu hình kết nối mạng IPv6: định tuyến tĩnh, định tuyến động (RIP)đường hầm

### PHẦN 3: CÁC THỦ TỤC VÀ QUY TRÌNH CƠ BẢN

- 3.1 Thủ tục ICMPv6
- 3.2 Thủ tục multicast listener discovery (MLD)
- [3.3 Thủ tục neighbor discovery - ND](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-ND.md)
- 3.4 Một số quy trình hoạt động của địa chỉ IPv6
- 3.5 Đặc tính của địa chỉ IPv6
- 3.6 Thực hành quan sát giao tiếp và hoạt động của các node IPv6.

### PHẦN 4: CÔNG NGHỆ CHUYỂN ĐỔI IPv4-IPv6

### PHẦN 5: MỘT SỐ PHẦN MỀM HỖ TRỢ IPv6
- DNS
- DHCP
- NAT64
- [APACHE](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-apache-dual.md)
- [DirectAdmin Control](https://github.com/anhtuan204/ghichep/blob/master/TuanDA/IPv6/docs/ipv6-da.md)

|Bit | Dạng địa chỉ | Chú thích|
|---|---|---|
|:: | Địa chỉ đặc biệt | |
|::1 | Địa chỉ loopback | |
|FE80::/10 | Địa chỉ link-local | |
|FEC0::/10 | Địa chỉ site local | Đã được hủy bỏ |
|2000::/3 | Địa chỉ unicast định danh toàn cầu. Trong đó:
2002::/16 – Địa chỉ của tunnel 6to4 | |
|::w.x.y.z | Địa chỉ tương thích | Dùng cho công nghệ tunnel tự động.|
|::FFFF:w.x.y.z | Địa chỉ IPv4 - map | Dùng trong biên dịch địa chỉ IPv6-IPv4 |
|FF::/8 |Địa chỉ multicast ||
|FF01::1 |Địa chỉ multicast mọi node phạm vi node||
|FF02::1 |Địa chỉ multicast mọi node phạm vi link||
|FF01::2 |Địa chỉ multicast mọi router phạm vi node||
|FF02::2 |Địa chỉ multicast mọi router phạm vi link||
|FF05::2 |Địa chỉ multicast mọi router phạm vi site||
|FF02::1:FF/104 |Địa chỉ multicast Solicited node| |