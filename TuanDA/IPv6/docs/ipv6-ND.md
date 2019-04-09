
Neighbor Discovery Protocol (NDP, ND) là một giao thức được phát triển mới trong bộ giao thức Internet để sử dụng với giao thức Internet phiên bản 6 (IPv6). 

Nó hoạt động trong tầng liên kết dữ liệu (Data-link)của mô hình OSI, và phụ trách các quy trình giao tiếp giữa các node IPv6 trên cùng một đường kết nối và duy trì thông tin về khả năng tiếp cận của các nút lân cận đang hoạt động khác.

Giao thức định nghĩa năm loại gói tin ICMPv6 khác nhau để thực hiện các chức năng cho IPv6 tương tự như ARP, ICMP, Router Discovery và Router Redirect cho IPv4. Bao gồm 

- Neighbor Unreachability Detection (NUD)

- Inverse Neighbor Discovery cho phép các nút xác định và quảng bá một địa chỉ IPv6 tương ứng với một địa chỉ tầng liên kết nhất định, giống như Reverse ARP cho IPv4. 

- Secure Neighbor Discovery (SEND), một phần mở rộng an ninh của NDP, sử dụng các địa chỉ được tạo ra mã hóa (CGA) và Resource Public Key Infrastructure (RPKI) để cung cấp một cơ chế thay thế bảo vệ NDP bằng một phương pháp mật mã độc lập với IPsec. 

- Neighbor Discovery Proxy (ND Proxy) (RFC 4389) cung cấp một dịch vụ tương tự như IPv4 Proxy ARP và cho phép cầu nối nhiều phân đoạn mạng trong một single subnet prefix khi không thể kết nối được tại tầng liên kết.

## Chức năng
ND sử dụng tập hợp 5 thông điệp ICMPv6 sau đây để trao đổi giữa các node lân cận trên một đường kết nối:

### Thông điệp truy vấn router (Router Solicitation-RS)

Thông điệp này là ICMPv6 type 133. IPv6 host truyền gói tin Router Solicitation để định vị trí router trên một đường kết nối qua địa chỉ router multicast.Các Router tạo ra Router Advertisements gửi thông tin cho host ngay khi nhận được thông điệp này chứ không phải đợi tới thời gian dự kiến tiếp theo. 

### Thông điệp quảng bá của Router (Type 134) (Router Advertisement-RA)

Router quảng bá sự hiện diện của chúng với các thông số liên kết và Internet khác nhau. Hoặc theo định kỳ, hoặc để đáp ứng với một thông điệp Router Solicitation.

### Thông điệp truy vấn nút lân cận (Type 135) (Neighbor Solicitation-NS)

Thông điệp Neighbor Solicitation được một nút sử dụng để yêu cầu các node khác trên đường kết nối cung cấp địa chỉ tầng liên kết dữ liệu của chúng. Nó cũng được dùng để xem một nút còn hoạt động hay không. Chức năng này giống như giao thức ARP trong IPv4.

### Thông điệp quảng bá của nút lân cận (Neighbor Advertisement) (Type 136)

Neighbor Advertisement được dùng để trả lời về địa chỉ tầng liên kết của nó cho một thông điệp Neighbor Solicitation.

### Thông điệp Redirect (Type 137)
Thông điệp này được router gửi để thông báo cho host IPv6 rằng có một router khác tốt hơn có thể sử dụng làm next hop để gửi gói tin đến một đích nhất định. Khi nhận được host sẽ cập nhật hóa Destination Cache. Nếu mục từ không có trong đó thì nó sẽ được thêm vào.

## Những thông điệp trên được dùng để cung cấp các chức năng:

- Tìm kiếm Router (Router discovery)
- Tìm kiếm Prefix (Prefix discovery)
- Tìm kiếm thông số (Parameter discovery): host có thể tìm thấy hoạt động như giá trị MTU của đường kết nối, giá trị hop limit,..
- Tự động cấu hình địa chỉ (Address autoconfiguration): Host có thể cấu hình thông tin địa chỉ IP cho các giao diện, theo phương thức có hoặc không có sự hiện diện của máy chủ DHCPv6.
- Phân giải địa chỉ (Address resolution): host có thể phân giải địa chỉ tầng liên kết của một node lân cận từ địa chỉ IPv6 đã biết (tương đương chức năng của giao thức ARP trong địa chỉ IPv4).
- Quyết định đích tiếp theo (Next-hop determination)
- Khám phá khả năng có thể kết nối tới được của node lân cận (Neighbor unreachability detection): node quyết định được một node lân cận có thể còn nhận được gói tin hay không.
- Kiểm tra trùng lặp địa chỉ (Duplicate address detection)
- Chức năng chuyển hướng (Redirect function): Thông báo cho một host địa chỉ IPv6 đích tiếp theo (next hop) tốt hơn có thể sử dụng để tới được đích cuối cùng.

## Tham khảo:
https://vi.wikipedia.org/wiki/Neighbor_Discovery_Protocol
