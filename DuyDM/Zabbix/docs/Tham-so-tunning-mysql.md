# Một số tham số tunning mysql

MySQL/MariaDB configuration file đặt tại thư mục /etc/my.cnf bất cứ thay đổi nào ở file này đều phải restart lại service mysql.

### 1. Enable InnoDB file-per-table

InnoDB được hiểu là một công cụ lưu trữ (Storage Engine). MySQL/MariaDB dử dụng InnoDB là công cụ lưu trữ cho mình.

+ Nguyên thủy mysql sử dụng các table và index chỉ mục cơ sở dữ liệu để lưu trữ trong không gian table. Điều này phù hợp với cách thử sử dụng phần storage chỉ để cho việc xử lý cơ sở dữ liệu.

+ InnoDB được sử dụng một cách linh hoạt hơn và mỗi CSDL được lưu trong một file .ibd, mỗi tệp .ibd đại diện cho table sở hữu nó. 

 innodb_file_per_table mặc định được cấu hình từ phiên MySQL 5.6 trong file /etc/my.cnf
 
Ưu điểm:

Engine này kiểm tra tính toàn vẹn và ràng buộc dữ liệu rất cao khó xảy ra tình trạng hỏng chỉ mục và crash table.

Hoạt động theo cơ chế Row Level Locking, vì vậy trong lúc thực hiện các hành động (thêm/sửa/xóa) trên một bản ghi, thì các hoạt động ở bản ghi khác trên table vẫn diễn ra bình thường.

Nhược điểm:

Chạy cần nhiều RAM, các thao tác như Insert/Update/Delete lớn thì có khi sẽ lớn hơn vì cơ chế Table Level Locking sẽ gây ra hàng đợi lớn, gây chậm quá trình xử lý hệ thống.

### 2. Lưu trữ cơ sở dữ liệu MySQL trên một phân vùng riêng biệt

Tốc độ đọc ghi của hệ điều hành ảnh hưởng tới hiệu suất của máy chủ MySQL. Lựa chọn tối ưu là lưu trữ ra một phân vùng riêng biệt với hệ điều hành.

### 3. innodb_buffer_pool_size = [Thông số ram]

InnoDB engine dùng buffer pool used cho caching data và index trên memory. Thông số này giúp cho MySQL sẽ thực hiện queries nhanh hơn. Vậy để có thể đưa ra thông số ram ta cần thực hiện như sau. Thường để ở mức 50-70% RAM.

### 4. Buffer cache/pool settings.

innodb_buffer_pool_size được set càng nhiều càng tốt. innodb_buffer_pool_size là lượng bộ nhớ để sử dụng để lưu trữ bảng, chỉ mục và một số thứ khác

Thiết lập tham số này để việc sử dụng +/- buffer cache trong cache của innodb không bị ăn vào, không bị trùng lặp với buffer cache của hệ thống.

innodb_buffer_pool_size=%ramM
innodb_flush_method=O_DIRECT


### 5. Size the log files.

innodb_log_file_size=8M

innodb_log_file_size là kích thước của tệp nhật ký cam kết (thường có hai tệp), tác động đến hiệu suất nhưng không nhiều. Không nên đặt innodb_log_file_size thành giá trị khác với kích thước của tệp hiện tại hoặc máy chủ sẽ không bắt đầu. Điều này có nghĩa rằng nếu bạn muốn thay đổi nó, bạn nên tắt máy chủ một cách rõ ràng, xóa các bản ghi hiện có và nó sẽ tạo ra các bản ghi mới.

https://stackoverrun.com/vi/q/428364

