# Tìm hiểu về Linux Bridge

### Mục lục

[1. Giới thiệu về Linux Bridge](#gioithieu)

[2. Một số khái niệm thường sử dụng trong Linux Bridge](#tongquan)

[3. Chức năng của một switch ảo do Linux bridge tạo ra](#cautruc)

[4. Công cụ và lệnh làm việc với Linux Bridge](#tinhnang)

<a name="gioithieu"></a>
## 1. Giới thiệu về Linux Bridge

![](../images/linuxbridge/Screenshot_258.png)

Để hiểu về Linux Bridge trước tiên ta nên hiểu trong Network Bridge là gì?

- Hiểu theo nghĩa một thiết bị: 

+Bridge là thiết bị mạng thuộc lớp thứ 2 trong mô hình OSI (Data Link Layer). Bridge được sử dụng để ghép nối 2 mạng để tạo thành một mạng lớn hơn (Bridge dùng làm cầu nối giữa hai mạng Ethernet).

+Khi có một gói tin từ một máy tính thuộc mạng này chuyển tới một máy tính thuộc mạng khác, Bridge sẽ sao chép lại gói tin và và gửi nó tới mạng đích.

+Bridge là hoạt động trong suốt, các máy tính thuộc các mạng khác nhau có thể gửi các thông tin với nhau đơn giản mà không cần biết sự có mặt của Bridge.

+Một Bridge có thể xử lý được nhiều lưu thông trên mạng cũng như địa chỉ IP cùng một lúc. Tuy nhiên, Bridge chỉ kết nối những mạng cùng loại và sử dụng cho những mạng tốc độ cao sẽ khó hơn nếu chúng nằm cách xa nhau.

- Linux Bridge trong ảo hóa network

Linux bridge là một switch dạng mềm – đây là 1 trong 3 công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các thiết bị vật lý.

Linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.

Linux Bridge bản chất là một switch ảo và được sử dụng với ảo hóa KVM/QEMU. Nó là 1 module trong nhân kernel của hệ điều hành Linux. Sử dụng câu lệnh brctl để quản lý.

## 2. Một số khái niệm thường sử dụng trong Linux Bridge

![](../images/linuxbridge/11.png)

### 2.1. Port

+ Trong network, khái niệm port đại diện cho điểm vào ra của dữ liệu trên máy tính hoặc các thiết bị mạng. Port có thể là khái niệm phần mềm hoặc phần cứng. Software port là khái niệm tồn tại trong hệ điều hành. Chúng thường là các điểm vào ra cho các lưu lượng của ứng dụng. Tức là khái niệm port mức logic. Ví dụ: port 80 trên server liên kết với Web server và truyền các lưu lượng HTTP.

+ Hardware port (port khái niệm phần cứng): là các điểm kết nối lưu lượng ở mức khái niệm vật lý trên các thiết bị mạng như switch, router, máy tính, … ví dụ: router với cổng kết nối RJ45 (L2/Ethernet) kết nối tới máy tính của bạn.

+ Physical switch port: Thông thường chúng ta hay sử dụng các switch L2/ethernet với các cổng RJ45. Một đầu connector RJ45 kết nối port trên switch tới các port trên NIC của máy tính.

+ Virtual switch port: giống như các physical switch port mà tồn tại như một phần mềm trên switch ảo. cả virtual NIC và virtual port đều duy trì bởi phần mềm, được kết nối với nhau thông qua virtual cable.

### 2.2. Uplink port

Uplink port là khái niệm chỉ điểm vào ra của lưu lượng trong một switch ra các mạng bên ngoài. Nó sẽ là nơi tập trung tất cả các lưu lượng trên switch nếu muốn ra mạng ngoài.

Virtual uplink switch port được hiểu có chức năng tương đương, là điểm để các lưu lượng trên các máy guest ảo đi ra ngoài máy host thật, hoặc ra mạng ngoài. Khi thêm một interface trên máy thật vào bridge (tạo mạng bridging với interface máy thật và đi ra ngoài), thì interface trên máy thật chính là virtual uplink port.

### 2.3. Tap interface

Ethernet port trên máy ảo gọi là vNIC (Virtual NIC). Virtual port được mô phỏng với sự hỗ trợ của KVM/QEMU.

Port trên máy ảo VM chỉ có thể xử lý các frame Ethernet. Trong môi trường thực tế (không ảo hóa) interface NIC vật lý sẽ nhận và xử lý các frame Ethernet. Nó sẽ bóc lớp header và chuyển tiếp payload (thường là gói tin IP) tới lên cho hệ điều hành. Tuy nhiên, với môi trường ảo hóa, nó sẽ không làm việc vì các virtual NIC sẽ mong đợi các frame Ethernet. Chính vì thể phải có một cách khác để các gói tin chuyển tiếp ra ngoài.

Tap interface sử dụng trong Linux bridge là để chuyến tiếp frame Ethernet vào nó. Hay nói cách khác, máy ảo kết nối tới tap interface sẽ có thể nhận được các khung frame Ethernet. Và do đó, máy ảo VM có thể tiếp tục được mô phỏng như là một máy vật lý ở trong mạng.

-> Về cơ bản tap interface là một port trên switch dùng để kết nối với các máy ảo VM.

## 3. Chức năng của một switch ảo do Linux bridge tạo ra

+ STP: Spanning Tree Protocol - giao thức chống lặp gói tin trong mạng.

+ VLAN: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.

+ FDB (forwarding database): chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch. Database lưu các địa chỉ MAC mà nó học được. Khi gói tin Ethernet đến, bridge sẽ tìm kiếm trong database có chứa MAC address không. Nếu không, nó sẽ gửi gói tin đến tất cả các cổng.

## 4. Công cụ và lệnh làm việc với Linux Bridge

Linux bridge được hỗ trợ từ version nhân kernel từ 2.4 trở lên. Để sử dụng và quản lý các tính năng của linux birdge, cần cài đặt gói bridge-utilities (dùng các câu lệnh brctl để sử dụng linux bridge). Cài đặt dùng lệnh như sau:

```
+ Ubuntu

sudo apt-get install bridge-ultils -y

+ Centos

sudo yum install bridge-ultils -y

```

### 4.1. Bridge management commandline

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Tạo một bridge|	`brctl addbr <bridge>`| |	
|Xóa đi một bridge|	`brctl delbr <bridge>`| |
|Thêm một interface (port) to bridge	| `brctl addif <bridge> <ifname>`	| |
|Xóa đi một interface (port) on bridge |	`brctl delbr <bridge>`|  |	

### 4.2. FDB management commandline

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Hiển thị danh sách địa chỉ MAC trong FDB|	`brctl showmacs <bridge>`	|`bridge fdb show`|
|Sets FDB entries ageing time|	`brctl setageingtime  <bridge> <time>`|	|
|Sets FDB garbage collector interval|	`brctl setgcint <brname> <time>`| |	
|Adds FDB entry	|	|`bridge fdb add dev <interface> [dst, vni, port, via]`|
|Appends FDB entry|		|`bridge fdb append` (parameters same as for fdb add)|
|Deletes FDB entry|		|`bridge fdb delete ` (parameters same as for fdb add)|

### 4.3. STP management commandline

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Turning STP on/off	|`brctl stp <bridge> <state>`| |	
|Setting bridge priority|	`brctl setbridgeprio <bridge> <priority>`	| |
|Setting bridge forward delay|	`brctl setfd <bridge> <time>`	| |
|Setting bridge 'hello' time|	`brctl sethello <bridge> <time>`| |	
|Setting bridge maximum message age|	`brctl setmaxage <bridge> <time>`	| |
|Setting cost of the port on bridge|	`brctl setpathcost <bridge> <port> <cost>`|	`bridge link set dev <port> cost <cost>`|
|Setting bridge port priority	|`brctl setportprio <bridge> <port> <priority>`|	`bridge link set dev <port> priority <priority>`|
|Should port proccess STP BDPUs	|	|`bridge link set dev <port > guard [on, off]`|
|Should bridge might send traffic on the port it was received|		|`bridge link set dev <port> hairpin [on,off]`|
|Enabling/disabling fastleave options on port|		|`bridge link set dev <port> fastleave [on,off]`|
|Setting STP port state	|	|`bridge link set dev <port> state <state>`|

### 4.4. VLAN management commandline

|ACTION|	BRCTL|	BRIDGE|
|-|-|-|
|Creating new VLAN filter entry|		|`bridge vlan add dev <dev> [vid, pvid, untagged, self, master]`|
|Delete VLAN filter entry	|	|`bridge vlan delete dev <dev>` (parameters same as for vlan add)|
|List VLAN configuration|		|`bridge vlan show`|




