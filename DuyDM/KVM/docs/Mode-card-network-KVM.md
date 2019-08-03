# Các chế độ card mạng trong KVM


[1. NAT](#nat)

[2. Public Bridge](#pubbridge)

[3. Private Bridge](#pribridge)

Tương tự trong ảo hóa VMware, VMWare có 3 chế độ card mạng đó là Bridge, NAT và Host-only thì KVM có 3 tùy chọn cho card mạng NAT, Public Bridge và Private Bridge.

<a name="nat"></>
1. NAT

Đây là chế độ mặc định trong KVM, đơn giản ở đây hiểu chế độ NAT sẽ cấp cho mỗi VM một IP  theo dải mạng của hệ thống, chế độ này cho phép chuyển tiếp gói tin giữa lớp mạng bên trong VM với lớp mạng bên ngoài để
có thể kết nối ra internet.

Cơ chế ở đây hiểu đơn giản là một bridge cho card mạng ảo kết nối với card mạng thật để ra internet.

Card mạng ảo của vm gắn vào 1 bridge (vibr0), vibr0 mặc định có gateway, các gói tin của máy ảo sẽ đi qau đường này để đến card máy ảo thật và ra ngoài internet.

KVM cấp DHCP cho các máy dùng chế độ NAT.


<a name="pubbridge"></>
2. Public Bridge

Chế độ này sẽ cho phép các máy ảo có cùng dải mạng vật lí với card mạng thật. Để có thể làm được điều này cần thiết lập 1 bridge và cho phép nó kết nối với cổng vật lí của thiết bị thật (eth0).

<a name="pribridge"></>
3. Private Bridge

Chế độ này sẽ sử dụng một bridge riêng biệt để các VM giao tiếp với nhau mà không ảnh hưởng tới địa chỉ của KVM host.


