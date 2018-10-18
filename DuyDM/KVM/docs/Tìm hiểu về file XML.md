# Tìm hiểu về file XML trong KVM

### Mục lục

[1. Tổng quan về file XML](#tongquan)

[2. Các thành phần của file XML](#thanhphan)

[3. Tạo máy ảo từ file XML](#vmxml)

## 1, Tổng quan về file XML

- VM trong KVM có hai thành phần chính đó là VM's definition được lưu dưới dạng file XML mặc định ở thư mục /etc/libvirt/qemu và VM's storage lưu dưới dạng file image.

- File domain XML chứa những thông tin về thành phần của máy ảo (số CPU, RAM, các thiết lập của I/O devices...)

- libvirt dùng những thông tin này để tiến hành khởi chạy tiến trình QEMU-KVM tạo máy ảo.

- KVM cũng có các file XML khác để lưu các thông tin liên quan tới network, storage...

- Mục đích chính của XML là đơn giản hóa việc chia sẻ dữ liệu giữa các hệ thống khác nhau, đặc biệt là các hệ thống được kết nối với Internet.

![](../images/filexml/xml1.png)


