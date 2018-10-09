# Virtualization và hypervisors #

## 1. Virtualization ##
Virtualization cho phép nhiều phiên bản hệ điều hành chạy đồng thời trên một máy tính, đơn giản có thể hiểu là tách phần cứng khỏi một hệ điều hành duy nhất.

![](https://i.imgur.com/obNNl5Z.png)

**- Ưu điểm:**

+Nhiều máy được tạo ra với các hệ điều hành khác nhau tồn tại trên cùng một máy chủ vật lý.

+Tối ưu hóa phần cứng

+Backup hệ điều hành

+Độc lập giữa các hệ điều hành khác nhau

**- Một sô kiểu Virtualization**

- CPU virtualization
	+ full virtualization
	+ para-virtualization
	+ hardware assisted virtualization

![](https://i.imgur.com/kBjxlUu.png)

Không giống như full kiểu para chỉnh sửa OS kernel để thay thế các điều hướng nonvirtualizable bằng các hypercalls giao tiếp trực tiếp với virtualization layer hypervisor


- Memory virtualization

![](https://i.imgur.com/ADAFl8n.png)

Ngoài ảo hóa CPU việc chia sẻ bộ nhớ hệ thống vật lý và phân bổ động nó tới các máy ảo.Hệ điều hành giữ ánh xạ các virtual  page numbers cho các sphysical page numbers được lưu trữ trong các bảng trang. Tất cả các CPU x86 hiện đại bao gồm một đơn vị quản lý bộ nhớ (MMU) và bộ đệm tra cứu dịch (TLB) để tối ưu hóa hiệu suất bộ nhớ ảo

- Device and I/O virtualization

Thành phần cuối cùng cần thiết ảo hóa sau sự ảo hóa của CPU và bộ nhớ là ảo hóa thiết bị và Input / Output. Điều này liên quan đến việc quản lý việc định tuyến các yêu cầu I / O giữa các thiết bị ảo và phần cứng vật lý dùng chung
Các hypervisor ảo hóa phần cứng vật lý và phân phối mỗi máy ảo với một bộ tiêu chuẩn của các thiết bị ảo.

## 2. Hypervisors ##

A hypervisor hay virtual machine  monitor(VMM) là một phần mềm hoặc phần cứng tạo và chạy các máy ảo.

Một máy tính mà trên đó một hypervisor chạy một hoặc nhiều máy ảo được định hình là mộ máy chủ.

Mỗi máy ảo được gọi là một guest machine.

**- Một sô kiểu Hypervisors**

1, Hypervisors được cài đặt trực tiếp trên phần cứng, không yêu cầu hệ điều hành phụ trợ bổ sung mà chính đó là hệ điều hành, nhẹ như KVM, XEN.

Ưu điểm: Hệ điều hành mỏng, hypervisor có quyền truy cập trực tiếp vào hardware.

Nhược điểm: Một số máy ảo lớn không được hỗ trợ, yêu cầu phần cứng phải hỗ trợ công nghệ ảo hóa, một số vấn đề về giao diện điều khiển.

2, Loại ứng dụng được cài đặt trên hệ điều hành chứ không phải trực tiếp trên bare-metal (nền phần cứng) như VirtualBox, Vmware Workstation

Ưu điểm: Chạy trên một cấu hình lớn hơn hardware vì hệ điều hành máy chủ cơ bản kiểm soáy truy cập phần cứng, giao diện cung cấp cho người dùng dễ dàng.

Nhược điểm: ĐỘ an toàn thấp, mất quản lý tập trung, số lượng máy ảo thấp hơn.

![](https://i.imgur.com/v6KbBVe.png)



**2.1. VMware (2)**

- Tính năng

Hỗ trợ việc bridge các adapter mạng và chia sẻ ổ đĩa cứng vật lý và cac thiêt bị ngoại vị với máy ảo, các ổ đĩa cứng tạo thông qua tệp .vmdk

Snapshot và khôi phục lại trạng thái máy ảo hiệu quả.

- Kiến trúc

	+  Infrastructure: Gồm các thành phần Vmware Virtual machine file  system(VMFS), Vmware Virtual Symmetric Multi  processing(SMP), Virtual Infrestucture web access,  Vmware Vmotion, Vmware Distributed Resource  Scheduler.
	+  Storage And Arrays: Fiber Channel SAN arrays, iSCSI  SAN arrays và NAS là những công nghệ được sử dụng rộng rãi bởi VMware
	
	+ Ip Network: Mỗi máy chỉ có thể có nhiều NICs cung cấp băng thông cao.

![](https://i.imgur.com/lQ2yb1F.png)

- Ưu điểm:

	+ Mã hóa một máy để không bị xâm phạm bởi người dùng không hợp pháp.
	+ Mỗi VM có thể hỗ trợ tối đa 16 CPU và 16 core, lên tới 64Gb RAM, 20 virtual intreface trong một môi trường vmware workstation.
- Nhược điểm:

	+ Tính khả dụng cho có cấu hình máy ảo phụ thuộc khá nhiều vào phần cứng.
	+ Chi phí khá cao.
	+ Khả năng tương thích phần cứng, tương thích ứng dụng.