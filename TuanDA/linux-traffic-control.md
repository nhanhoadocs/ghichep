

![](/TC/tc_1.png)



classless qdiscs
http://tldp.org/HOWTO/Traffic-Control-HOWTO/classless-qdiscs.html

classful qdiscs
http://tldp.org/HOWTO/Traffic-Control-HOWTO/classful-qdiscs.html


http://web.opalsoft.net/qos/default.php?p=ds-21


https://lartc.org/lartc.html#LARTC.QDISC.EXPLAIN


Queueing Discipline (qdisc)
Thuật toán quản lý hàng đợi (queue), bao gồm incomming (ingress) và outgoing (egress)

root qdisc
The root qdisc is the qdisc attached to the device.


Classless qdisc
A qdisc with no configurable internal subdivisions.

Classful qdisc
A classful qdisc contains multiple classes. Some of these classes contains a further qdisc, which may again be classful, but need not be. According to the strict definition, pfifo_fast *is* classful, because it contains three bands which are, in fact, classes. However, from the user's configuration perspective, it is classless as the classes can't be touched with the tc tool.

Classes
A classful qdisc may have many classes, each of which is internal to the qdisc. A class, in turn, may have several classes added to it. So a class can have a qdisc as parent or an other class. A leaf class is a class with no child classes. This class has 1 qdisc attached to it. This qdisc is responsible to send the data from that class. When you create a class, a fifo qdisc is attached to it. When you add a child class, this qdisc is removed. For a leaf class, this fifo qdisc can be replaced with an other more suitable qdisc. You can even replace this fifo qdisc with a classful qdisc so you can add extra classes.

Classifier
Each classful qdisc needs to determine to which class it needs to send a packet. This is done using the classifier.

Filter
Classification can be performed using filters. A filter contains a number of conditions which if matched, make the filter match.

Scheduling
A qdisc may, with the help of a classifier, decide that some packets need to go out earlier than others. This process is called Scheduling, and is performed for example by the pfifo_fast qdisc mentioned earlier. Scheduling is also called 'reordering', but this is confusing.

Shaping
The process of delaying packets before they go out to make traffic confirm to a configured maximum rate. Shaping is performed on egress. Colloquially, dropping packets to slow traffic down is also often called Shaping.

Policing
Delaying or dropping packets in order to make traffic stay below a configured bandwidth. In Linux, policing can only drop a packet and not delay it - there is no 'ingress queue'.

Work-Conserving
A work-conserving qdisc always delivers a packet if one is available. In other words, it never delays a packet if the network adaptor is ready to send one (in the case of an egress qdisc).

non-Work-Conserving
Some queues, like for example the Token Bucket Filter, may need to hold on to a packet for a certain time in order to limit the bandwidth. This means that they sometimes refuse to pass a packet, even though they have one available.

Now that we have our terminology straight, let's see where all these things are.

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
     +----------------------------------------------------------+
Thanks to Jamal Hadi Salim for this ASCII representation.
The big block represents the kernel. The leftmost arrow represents traffic entering your machine from the network. It is then fed to the Ingress Qdisc which may apply Filters to a packet, and decide to drop it. This is called 'Policing'.

This happens at a very early stage, before it has seen a lot of the kernel. It is therefore a very good place to drop traffic very early, without consuming a lot of CPU power.

If the packet is allowed to continue, it may be destined for a local application, in which case it enters the IP stack in order to be processed, and handed over to a userspace program. The packet may also be forwarded without entering an application, in which case it is destined for egress. Userspace programs may also deliver data, which is then examined and forwarded to the Egress Classifier.

There it is investigated and enqueued to any of a number of qdiscs. In the unconfigured default case, there is only one egress qdisc installed, the pfifo_fast, which always receives the packet. This is called 'enqueueing'.

The packet now sits in the qdisc, waiting for the kernel to ask for it for transmission over the network interface. This is called 'dequeueing'.

This picture also holds in case there is only one network adaptor - the arrows entering and leaving the kernel should not be taken too literally. Each network adaptor has both ingress and egress hooks.

Tham khảo để sử dụng các loại qdiscs :

- Để làm chậm traffic outgoing, sử dụng Token Bucket Filter

- Nếu uplink full thực sự và muốn đảm bảo không 1 session nào có thể chiếm toàn bộ outgoing bandwidth, sử dụng Stochastical Fairness Queueing.

- Nếu có uplink băng thông cao có thể sử dụng Random Early Drop











http://linux-ip.net/gl/tc-filters/

Example: HTTP Outbound Traffic Shaping
First , delete existing rules for eth1:

```
 /sbin/tc qdisc del dev eth1 root
```

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