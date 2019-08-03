# A. Pacemaker

Pacemaker là một cluster quản lý các resource, nó có khả năng hoạt động với hầu hết các dịch vụ cluster bằng cách phát hiện và phục hồi từ node và resource-level

# B. Các thành phần bên trong của pacemaker

![](img/pcmk-internals.png)

## Cluster Information Base (CIB)

CIB sử dụng XML để biểu diễn cả cấu hình của cụm và trạng thái hiện tại của tất cả các tài nguyên trong cluster. Các nội dung của CIB được tự động giữ đồng bộ trên toàn bộ cụm và được sử dụng bởi PEngine để tính toán trạng thái lý tưởng của cluster và làm thế nào để nó đạt được.

## Cluster Resource Management Daemon (CRMd)

Các hành động resource của Pacemaker cluster được chuyển qua daemon này. Resources được quản lý bởi CRMd và có thể được truy vấn bởi các hệ thống client, di chuyển nhanh chóng và thay đổi khi cần thiết.

Mỗi node của cluster cũng bao gồm một trình quản lý tài nguyên cục bộ LRMd (Local Resource Management Daemon) hoạt động tương tự giữa CRMd và các resource. LRMd truyền lệnh từ CRMd tới các agent chẳng hạn như khởi động (start) và dừng lại (stop) hay chuyển tiếp thông tin trạng thái

## Policy Engine (PEngine)

Chịu trách nhiệm về việc bắt đầu thay đổi trạng thái trong cluster

Shoot the Other Node in the Head (STONITH)

Là giải pháp tránh trường hợp "split brain" trong cluster

Được triển khai kết hợp với một "power switch". Hoạt động như một resource trong cluster xử lý các yêu cầu về fencing. Buộc các node phải dừng lại (shutdown) và loại bỏ chúng khỏi cluster để đảm bảo toàn vẹn dữ liệu. STONITH được cấu hình trong CIB và có thể được theo dõi như là một tài nguyên cluster thông thường.

Các mô hình triển khai pacemaker

Pacemaker không có giới hạn về cách triển khai của bạn, chính điều này mà nó cho phép ta có thể triển khai theo hầu hết các mô hình như:

Active/ Active
Active/ Passive
N + 1
N + M
N to 1
N to M

