

Thành phần network của Openstack

Neutron-server: Là thành phần để nhận các lời gọi API từ user và các project khác. Bên cạnh đó nó cũng sẽ xử lý các request này và tương tác với database và các agent thông qua giao thức AMQP

L3-agent: Nhận các yêu cầu từ neutron-server để tạo ra router thực hiện chức năng ở layer 3.

L2-agent: Nhận các yêu cầu từ neutron-server để tạo ra các switch thực hiện thức năng ở layer 2.

DHCP-agent: Nhận yêu cầu từ neutron-server để tạo ra các DHCP-server cho từng dải mạng để cung cấp IP cho các máy ảo.

![](/images/neutron/neutron1.png)

- Provider network cung cấp khả năng kết nối layer-2 đến instance với sự hỗ trợ tùy chọn cho DHCP và metadata service. Mạng này kết nối, hoặc map, với các mạng layer-2 hiện có trong data center, thường sử dụng tính năng VLAN (802.1q) tagging để xác định và tách chúng.

Bao gồm 2 loại: Flat và Vlan

- Self-service network
Các project tạo các dải mạng nội bộ khác nhau và cùng đi qua 1 virtual route , và ra ngoài theo phương thức NAT. Các mạng này được cô lập với nhau và sử dụng qua layer 3 

Bao gồm 2 loại: GRE và VXLAN

Linuxbridge + Provider network:


![](/images/neutron/neutron2.png)



Traffic flow
There are two primary types of traffic flow within a cloud infrastructure, the choice of networking technologies is influenced by the expected loads.

East/West - The internal traffic flow between workload within the cloud as well as the traffic flow between the compute nodes and storage nodes falls into the East/West category. Generally this is the heaviest traffic flow and due to the need to cater for storage access needs to cater for a minimum of hops and low latency.

North/South - The flow of traffic between the workload and all external networks, including clients and remote services. This traffic flow is highly dependant on the workload within the cloud and the type of network services being offered.