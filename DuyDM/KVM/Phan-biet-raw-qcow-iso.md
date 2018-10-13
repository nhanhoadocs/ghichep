# Định dạng raw - qcown - iso

### Mục lục

[1. Định dạng raw](#formatraw)

[2. ](#)

Công nghệ ảo hóa phần cứng QEMU rất giống với KVM. Cả hai đều được điều khiển thông qua libvirt, cả hai đều hỗ trợ tính năng thiết lập giống nhau, và tất cả các hình ảnh máy ảo tương thích với KVM thì cũng tương thích với QEMU. Điểm khác biệt chính giữa QEMU và KVM là QEMU không hỗ trợ ảo hóa bản địa (native virtualization); do đó, QEMU có hiệu suất kém hơn KVM.

QEMU được sử dụng trong các trường hợp sau:
- Chạy trên các phần cứng cũ không hỗ trợ ảo hóa.
- Chạy các dịch vụ Compute trên một máy ảo cho mục đích phát triển hoặc thử nghiệm.

QEMU hỗ trợ các định dạng hình ảnh máy ảo sau đây:
- Raw
- QEMU Copy-on-write (qcow2)
- VMWare virtual machine disk format (vmdk)

<a name="formatraw"></a>
## 1. Định dạng raw


