# Hướng dẫn setup L2TP/IPSec VPN trên Windows 2k19

## Bước 1: Update system 

Chạy các lệnh sau trên Powershell 

`Install-Module PSWindowsUpdate`

`Get-WindowsUpdate`

`Install-WindowsUpdate`

<img src="https://i.imgur.com/runimHw.png">

Sau khi update xong, tiến hành restart lại máy chủ

## Bước 2: Cài đặt Remote Access Role

Chạy các lệnh sau trên powershell 

```
Install-WindowsFeature RemoteAccess
Install-WindowsFeature DirectAccess-VPN -IncludeManagementTools
Install-WindowsFeature Routing -IncludeManagementTools
```

<img src="https://i.imgur.com/0JfNvIs.png">

## Bước 3: Cấu hình Routing and Remote Access

Mở `Server Manager` chọn `Tools >> Remote Access Management`

<img src="https://i.imgur.com/1Cge1MJ.png">

Click chuột phải vào local server và click vào `Configure and Enable Routing and Remote Access.`

<img src="https://i.imgur.com/6gXNDBw.png">

Chọn `Custom Configuration`

<img src="https://i.imgur.com/EErrfkm.png">

Chọn `VPN Server` và `NAT`

<img src="https://i.imgur.com/GxFzF61.png">

Finish và chọn `Start Service`

<img src="https://i.imgur.com/Y6YUsiq.png">

## Bước 4: Cấu hình VPN 

Click chuột phải vào local server và chọn "Properties"

<img src="https://i.imgur.com/IbJap3K.png">

Chọn tab `Security`, click chọn `Allow custom IPSec policy for L2TP/IKEv2 connection` và nhập pre-shared key

<img src="https://i.imgur.com/BdG4bKT.png">

Chọn tab `IPv4` Chọn `Static address pool` -> Add range

<img src="https://i.imgur.com/KRvWTh9.png">

## Bước 5: Cấu hình NAT 

Chuột phải Chọn NAT -> New Interface

<img src="https://i.imgur.com/JC4N0d1.png">

Lựa chọn `Ethernet` -> `Public interface connected to Internet` và `Enable NAT on this interface`

<img src="https://i.imgur.com/fgCJFj5.png">

Ở tab `Services and Ports` và chọn `VPN Server(L2TP/IPSec – running on this server)`

<img src="https://i.imgur.com/BfQk2nA.png">

Pop up mới hiển thị, ta tiến hành thay đổi `private address` từ `0.0.0.0` thành `127.0.0.1`

<img src="https://i.imgur.com/fAY7BgR.png">

## Bước 6: Restart Routing and Remote Access

Chuột phải vào local server -> All Tasks -> Restart 

<img src="https://i.imgur.com/tqPd6mH.png">

## Bước 7: Update firewall 

Mở firewall, chọn `New Rule`

<img src="https://i.imgur.com/20tPPMu.png">

<img src="https://i.imgur.com/3t75Cfv.png">

<img src="https://i.imgur.com/RL6qRUF.png">

<img src="https://i.imgur.com/TUdHP3L.png">

Việc này sẽ mở UDP port 1701.

Hoặc bạn có thể tắt firewall.

## Bước 8: Tạo user VPN

Vào `Computer Management` -> `Local users and group`. Chuột phải chọn `New User`

<img src="https://i.imgur.com/XOcdj59.png">

Điền thông tin, bỏ check phần `User must change the password on next login`

<img src="https://i.imgur.com/Q0My0P2.png">

Sau khi user được tạo, chuột phải chọn `Properties`

<img src="https://i.imgur.com/kjf1RBc.png">

Trong phần `Dial-in`, lựa chọn `Allow access` cho cấu hình `Network Access Permissions`.

<img src="https://i.imgur.com/UD4DtlD.png">

## Bước 9: Kết nối VPN client

Tham khảo hướng dẫn [tại đây](connect-l2tp-windows-client.md)

## Bước 10: Monitor vpn 

Tìm kiếm `Remote Access Management Console`. Bạn sẽ thấy trạng thái cũng như các kết nối tới server

<img src="https://i.imgur.com/C2glCkm.png">

Link tham khảo:

https://www.snel.com/support/how-to-set-up-an-l2tp-ipsec-vpn-on-windows-server-2019/