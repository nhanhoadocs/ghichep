# Hướng dẫn cấu hình haproxy trên pfSense

Mô hình:

1 máy pfSense làm load balancer
2 máy chạy web httpd

-------------------------

**Bước 1: Cài đặt package haproxy**

Truy cập `System > Package Manager > Available Packages` tìm `haproxy` packages và cài đặt

<img src="https://i.imgur.com/6AIhEUT.png">

**Bước 2: Cấu hình haproxy**

Truy cập `Services > HAProxy > Settings`.

Tại tab này, check để enable haproxy và nhập số lượng connection cho phép ở 1 thời điểm

<img src="https://i.imgur.com/iHdE99j.png">

Port để vào trang thông tin thống kê

<img src="https://i.imgur.com/1VHi7w3.png">

Sau đó save lại

**Bước 3: Tạo backend**

Ta sẽ tạo backend tên là web và có 2 server web1 web2

<img src="https://i.imgur.com/4eOrfqx.png">

Ngoài ra cũng có thể chọn load balance algorithm

<img src="https://i.imgur.com/eefWk8N.png">

Và một số option khác của haproxy như access list, connection timeout ...

<img src="https://i.imgur.com/Cm82E3C.png">

**Bước 4: Tạo frontend**

<img src="https://i.imgur.com/56kVDtE.png">

Chọn backend vừa tạo

<img src="https://i.imgur.com/BjvIuBN.png">

Save lại và check trong `Status`-> `Haproxy Status`

<img src="https://i.imgur.com/09YR6qJ.png">

**Bước 5: Thêm rule vào card WAN cho các port ta vừa khai báo để truy cập từ bên ngoài vào**

<img src="https://i.imgur.com/mRZ7bHp.png">

Truy cập web và kiểm tra 

- Tham khảo

https://blog.devita.co/pfsense-to-proxy-traffic-for-websites-using-pfsense/
