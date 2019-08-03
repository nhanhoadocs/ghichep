

![](/TC/tc_1.png)



classless qdiscs
http://tldp.org/HOWTO/Traffic-Control-HOWTO/classless-qdiscs.html

classful qdiscs
http://tldp.org/HOWTO/Traffic-Control-HOWTO/classful-qdiscs.html


http://web.opalsoft.net/qos/default.php?p=ds-21

Thông tin tổng quan:
https://lartc.org/lartc.html#LARTC.QDISC.EXPLAIN

https://wiki.archlinux.org/index.php/advanced_traffic_control

- Queueing Discipline (qdisc)
Thuật toán quản lý hàng đợi (queue), bao gồm incomming (ingress) và outgoing (egress)

- root qdisc
root qdisc là qdisc gốc được gắn vào device


- Classless qdisc
Classless qdisc thực hiện các nhiệm vụ quản lý, sắp xếp, drop gói tin

- Classful qdisc
Classful qdisc cho phép bạn tạo các lớp, hoạt động giống như các nhánh. Sau đó, bạn có thể đặt rules để filter các packet vào mỗi lớp. 

Câu lệnh xóa toàn bộ qdisc của eth0:
`tc qdisc del root dev eth0`

- fifo_fast
Qdisc mặc định, nếu không cấu hình gì, fifo_fast sẽ được set. fifo có ý nghĩa first in first out, packet đến trước sẽ được chuyển đi trước.

# Classess qdisc #
- Token Bucket Filter (TBF)

![](/TC/tc_2.png)

Nó hoạt động bằng cách tạo một virtual bucket và sau đó thả tokens ở tốc độ nhất định, lấp đầy bucket đó. Mỗi packet lấy một token từ bucket và sử dụng nó để được phép vượt qua. Nếu có quá nhiều gói đến, bucket sẽ không còn token nữa và các gói còn lại sẽ chờ thời gian nhất định cho token mới. Nếu token không  đến đủ nhanh, các gói sẽ bị hủy. Trong trường hợp ngược lại (quá ít gói được gửi), token có thể được sử dụng để cho phép burst .

Điều đó có nghĩa là qdisc này rất hữu ích để làm chậm lại 1 interface.

`tc qdisc add dev ppp0 root tbf rate 220kbit latency 50ms burst 1540`

Cấu hình này đặt TBF cho thiết bị ppp0, giới hạn tốc độ tải lên ở mức 220k, đặt độ trễ 50ms cho gói trước khi bị hủy và burst 1540.

- Stochastic Fairness Queueing (SFQ)

![](/TC/tc_3.png)

Đảm bảo packet được Round Robin 

Thí dụ:

Cấu hình này đặt SFQ trên thư mục gốc trên thiết bị eth0, định cấu hình nó thành nhiễu (thay đổi) thuật toán băm của nó cứ sau 10 giây.

`tc qdisc thêm dev eth0 root sfq perturb 10`

# Classful qdisc #

Kiếu qdisc này có thể chứa nhiều class, và các class có thể có các chính sách khác nhau, các nhánh này.

Các nhánh có tên, có dạng x:y, x là tên của root qdisc, và y là tên của class, thường root được đặt là :1 và nhánh sẽ có dạng 1:10 

```sh
                     1:   root qdisc
                      |
                     1:1    child class
                   /  |  \
                  /   |   \
                 /    |    \
                 /    |    \
              1:10  1:11  1:12   child classes
               |      |     | 
               |     11:    |    leaf class
               |            | 
               10:         12:   qdisc
              /   \       /   \
           10:1  10:2   12:1  12:2   leaf classes
```

Ví dụ việc chia class với filter (cụ thể là IP):

```sh
tc filter add dev eth0 parent 10:0 protocol ip prio 1 u32 \ 
match ip dst 4.3.2.1/32 flowid 10:1

tc filter add dev eth0 parent 10:0 protocol ip prio 1 u32 \
match ip src 1.2.3.4/32 flowid 10:1

tc filter add dev eth0 protocol ip parent 10: prio 2      \
flowid 10:2
```
Hoặc có thể chia class với iptables / ipchain:

```sh
tc filter add dev eth1 protocol ip parent 1:0 prio 1 handle 6 fw flowid 1:1

iptables -A PREROUTING -t mangle -i eth0 -j MARK --set-mark 6
```





Scheduling

Quyết định gói tin nào được chuyển tiếp, dựa vào queue và phân lớp (classifier). Thực hiện ở "egress".


Shaping

Shaping liên quan đến việc "delay" việc chuyển gói tin (transmission of packets) phù hợp với giới hạn xác định (data rate). Đồng nghĩa với việc drop gói tin để traffic đi qua với 1 giới hạn xác định. Shaping được thực hiện ở "egress".


Policing
Delay hoặc drop gói tin nhận được, được thực hiện ở "ingress".

Dropping
Khi traffic đạt một giới hạn xác định, gói tin sẽ bị "drop".
Thực hiện ở cả "ingress" và "egress".


Work-Conserving
A work-conserving qdisc always delivers a packet if one is available. In other words, it never delays a packet if the network adaptor is ready to send one (in the case of an egress qdisc).

non-Work-Conserving
Some queues, like for example the Token Bucket Filter, may need to hold on to a packet for a certain time in order to limit the bandwidth. This means that they sometimes refuse to pass a packet, even though they have one available.

Now that we have our terminology straight, let's see where all these things are.
```sh

                Userspace programs
                     ^
                     |
     +---------------+-----------------------------------------+
     |               Y                                         |
     |    -------> IP Stack                                    |
     |   |              |                                      |
     |   |              Y                                      |
     |   |              Y                                      |
     |   ^              |                                      |
     |   |  / ----------> Forwarding ->                        |
     |   ^ /                           |                       |
     |   |/                            Y                       |
     |   |                             |                       |
     |   ^                             Y          /-qdisc1-\   |
     |   |                            Egress     /--qdisc2--\  |
   -->->Ingress                       Classifier ---qdisc3---- | ->
     |   Qdisc                                   \__qdisc4__/  |
     |                                            \-qdiscN_/   |
     |                                                         |
     +---------------------------------------------------------+
```

Thanks to Jamal Hadi Salim for this ASCII representation.
The big block represents the kernel. The leftmost arrow represents traffic entering your machine from the network. It is then fed to the Ingress Qdisc which may apply Filters to a packet, and decide to drop it. This is called 'Policing'.

This happens at a very early stage, before it has seen a lot of the kernel. It is therefore a very good place to drop traffic very early, without consuming a lot of CPU power.

If the packet is allowed to continue, it may be destined for a local application, in which case it enters the IP stack in order to be processed, and handed over to a userspace program. The packet may also be forwarded without entering an application, in which case it is destined for egress. Userspace programs may also deliver data, which is then examined and forwarded to the Egress Classifier.

There it is investigated and enqueued to any of a number of qdiscs. In the unconfigured default case, there is only one egress qdisc installed, the pfifo_fast, which always receives the packet. This is called 'enqueueing'.

The packet now sits in the qdisc, waiting for the kernel to ask for it for transmission over the network interface. This is called 'dequeueing'.

This picture also holds in case there is only one network adaptor - the arrows entering and leaving the kernel should not be taken too literally. Each network adaptor has both ingress and egress hooks.

Tham khảo để sử dụng các loại qdiscs :

- Để làm chậm traffic outgoing, sử dụng Token Bucket Filter

- Nếu uplink full thực sự và muốn đảm bảo không 1 session nào có thể chiếm toàn bộ outgoing bandwidth, sử dụng Stochastical Fairness Queueing (SFQ).

- Nếu có uplink băng thông cao có thể sử dụng Random Early Drop








First you have to understand how packet traverse the filters with iptables:

        +------------+                +---------+               +-------------+
Packet -| PREROUTING |--- routing-----| FORWARD |-------+-------| POSTROUTING |- Packets
input   +------------+    decision    +---------+       |       +-------------+    out
                             |                          |
                        +-------+                    +--------+   
                        | INPUT |---- Local process -| OUTPUT |
                        +-------+                    +--------+



http://linux-ip.net/gl/tc-filters/

Example: HTTP Outbound Traffic Shaping
First , delete existing rules for eth1:

```
 /sbin/tc qdisc del dev eth1 root
```
o list current rules, enter:
# tc -s qdisc ls dev eth0

Turn on queuing discipline, enter:

```
 /sbin/tc qdisc add dev eth1 root handle 1:0 htb default 10
```

Define a class with limitations i.e. set the allowed bandwidth to 512 Kilobytes and burst bandwidth to 640 Kilobytes for port 80:

```
/sbin/tc class add dev eth1 parent 1:0 classid 1:10 htb rate 512kbps ceil 640kbps prio 0
```

Please note that port 80 is NOT defined anywhere in above class. You will use iptables mangle rule as follows:

``` 
/sbin/iptables -A OUTPUT -t mangle -p tcp --sport 80 -j MARK --set-mark 10
```

To save your iptables rules, enter (RHEL specific command):
```
/sbin/service iptables save
```

Finally, assign it to appropriate qdisc:

```
tc filter add dev eth1 parent 1:0 prio 0 protocol ip handle 10 fw flowid 1:10
```

Here is another example for port 80 and 22:
```
/sbin/tc qdisc add dev eth0 root handle 1: htb
/sbin/tc class add dev eth0 parent 1: classid 1:1 htb rate 1024kbps
/sbin/tc class add dev eth0 parent 1:1 classid 1:5 htb rate 512kbps ceil 640kbps prio 1
/sbin/tc class add dev eth0 parent 1:1 classid 1:6 htb rate 100kbps ceil 160kbps prio 0
/sbin/tc filter add dev eth0 parent 1:0 prio 1 protocol ip handle 5 fw flowid 1:5
/sbin/tc filter add dev eth0 parent 1:0 prio 0 protocol ip handle 6 fw flowid 1:6
/sbin/iptables -A OUTPUT -t mangle -p tcp --sport 80 -j MARK --set-mark 5
/sbin/iptables -A OUTPUT -t mangle -p tcp --sport 22 -j MARK --set-mark 6
```

How Do I Monitor And Test Speed On Sever?
Use the following tools
```
/sbin/tc -s -d class show dev eth0
/sbin/iptables -t mangle -n -v -L
iptraf
watch /sbin/tc -s -d class show dev eth0
```

```
tc qdisc del dev tapd90058c7-9b root
tc qdisc add dev tapd90058c7-9b root handle 1:0 htb default 10
tc class add dev tapd90058c7-9b parent 1:0 classid 1:10 htb rate 512kbps ceil 640kbps prio 0
tc filter add dev tapd90058c7-9b parent 1:0 prio 0 protocol ip handle 10 fw flowid 1:10
```
tc filter add dev tapd90058c7-9b parent ffff: protocol ip u32 match ip src 0.0.0.0/0 flowid :1 police rate 1.0mbit mtu 10000 burst 10k drop




```
tc qdisc replace dev tapd90058c7-9b root handle 1: htb default 30
tc class add dev tapd90058c7-9b parent 1: classid 1:1 htb rate 95mbit
tc class add dev tapd90058c7-9b parent 1:1 classid 1:10 htb rate 1mbit ceil 20mbit prio 1
tc qdisc add dev tapd90058c7-9b parent 1:10 fq_codel
```

```
tc qdisc add dev tapd90058c7-9b root handle 1:0 hfsc  
tc class add dev tapd90058c7-9b parent 1:0 classid 1:1 htb sc rate 1mbit ul rate 1mbit
tc class add dev tapd90058c7-9b parent 1:0 classid 1:2 htb sc rate 400kbit ul rate 400kbit
tc filter add dev tapd90058c7-9b protocol all parent 1: u32  flowid 1:2
```

To test download speed use `lftp` or `wget` command line tools.

https://www.softprayog.in/tutorials/network-traffic-control-with-tc-command-in-linux