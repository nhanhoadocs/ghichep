
![](images/pf_1.png)

- remove hết config card LAN và config IP dải WAN để managerment ở dải WAN trước.

![](images/pf_4.png)

Chuyển qua tab `System/Advanced/Networking`
Kéo xuống phần `Network Interfaces`. Check vào tùy chọn `Disable hardware checksum offload` sau rồi save lại.

![](images/pf_3.png)

Mục đích là để sử dụng được với device model là `virtio`. Nếu không check vào tùy chọn này, sau này khi tạo vpn mode tap sẽ gặp lỗi máy ping được nhưng không thể ssh.

Lưu ý: Nếu ở trên bạn chọn device model là `pcnet` thì không cần check vào tùy chọn này.

Tại tab System/Certificate Manager/CA, chọn `Add` để thêm một CA mới, CA này sẽ xác thực tất cả các certificate của server VPN và user VPN khi kết nối tới PFSense OpenVPN


![](images/pf_5.png)

Tại tab System/Certificate Manager/Certificate, tạo cho server VPN
- Tạo CA :

![](images/pf_6.png)

- Tạo cert:

![](images/pf_7.png)

- Tại tab System/UserManager, tạo user được VPN

![](images/pf_9.png)

Tại VPN server 
- Tại tab `System/Packet Manager`, cài đặt Plugin `openvpn-client-export`
- Nếu không hiển thị Package Avaiable cần update lên phiên bản Lastest Stable
![](images/pf_10.png)






