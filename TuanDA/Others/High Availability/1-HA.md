# I. Giới thiệu về High Availability

Mục đích của một HA (High Availability) cluster là đảm bảo rằng các tài nguyên quan trọng được đảm bảo tính sẵn sàng phục vụ , và downtime khi có sự cố là nhỏ nhất.

# II. Các khái niệm, thuật ngữ cần biết trong HA

## 1. Cluster

Cluster là một nhóm gồm hai hay nhiều máy tính ( mỗi máy tính được gọi là một node hay member) hoạt động cùng với nhau để cung cấp một dịch vụ nào đó. Mỗi một node là một process hoạt động. Thường thì node được đồng nhất với một server do mỗi node thường được cài đặt trên một server riêng rẽ. Mục đích của cluster là:
- Storage
- High Availability
- Load Balancing
- High Performance

## 2. Resource

Resource trong cluster có thể được biết đến như các dịch vụ mà cluster cung cấp.

## 3. Pacemaker

Pacemaker là một cluster quản lý các resource, nó có khả năng hoạt động với hầu hết các dịch vụ cluster bằng cách phát hiện và phục hồi từ node và resource-level bằng các sử dụng khả năng trao đổi ( Corosync hoặc Heartbeat).

Tính năng của pacemaker bao gồm:

- Dò tìm và và khôi phục các dịch vụ lỗi
- Không yêu cầu chia sẻ không gian lưu trữ
- Hỗ trợ STONITH để đảm bảo tính toàn vẹn dữ liệu
- Hỗ trợ những cluster lớn và nhỏ
- Hỗ trợ hầu hết bất cứ cấu hình dự phòng nào
- Tự động tạo bản sao cấu hình vì vậy có thể cập nhật từ bất kì node nào
- Hỗ trợ những kiểu dịch vụ được mở rộng
- Thống nhất, có kịch bản, những công cụ quản lý cluster.

## 4. Corosync

Là một cơ sở hạ tầng mức độ thấp cung cấp thông tin tin cậy, thành viên và những thông tin quy định về cluster

## 5. Quorum

- Để duy trì tính toàn vẹn và tính có sẵn của cluster, các hệ thống cluster sử dụng khái niệm này để biết đến như là số lượng đa số để năng ngừa sự mất mát dữ liệu.
- Là giải pháp tránh trường hợp "split brain"

- "split brain" nghĩa là trường hợp mà cluster được chia làm hai phần hay nhiều hơn. Nhưng mỗi một phần này lại cho rằng chúng là phần còn lại duy nhất của cluster. Điều này có thể dẫn đến các tình huống xấu khi các phần của cluster cố gắng lưu trữ các tài nguyên được cung cấp bởi cluster. Nếu resource là một hệ thống tập tin và các node cố gắng ghi vào hệ thống tập tin đồng thời và không có sự phối hợp, sẽ dẫn tới tình trạng mất dữ liệu.

## 6. STONITH/ Fencing

STONITH là viết tắt của cụm từ Shoot Other Node In The Head đây là một kỹ thuật dành cho fencing. Fencing là kỹ thuật cô lập tài nguyên tại từng node trong Cluster. Mục tiêu STONITH là tắt hoặc khởi động lại node trong trường hợp Node trong trường hợp dịch vụ không thể khôi phục.

## 7. Các port sử dụng cho HA cluster

- 5404/udp - corosync
- 5405/udp - corosync
- 2224/tcp - pcsd
- 3121/tcp - pacemaker
- 21064/tcp - dlm

https://github.com/hocchudong/ghichep-pacemaker-corosync/blob/master/docs/pcmk-ha-overview.md
