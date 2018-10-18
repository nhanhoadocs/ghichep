# Tìm hiểu về file XML trong KVM

### Mục lục

[1. Tổng quan về file XML](#tongquan)

[2. Các thành phần của file XML](#thanhphan)

[3. Tạo máy ảo từ file XML](#vmxml)

<a name="tongquan"></a>

## 1, Tổng quan về file XML

- VM trong KVM có hai thành phần chính đó là VM's definition được lưu dưới dạng file XML mặc định ở thư mục /etc/libvirt/qemu và VM's storage lưu dưới dạng file image.

- File domain XML chứa những thông tin về thành phần của máy ảo (số CPU, RAM, các thiết lập của I/O devices...)

- libvirt dùng những thông tin này để tiến hành khởi chạy tiến trình QEMU-KVM tạo máy ảo.

- KVM cũng có các file XML khác để lưu các thông tin liên quan tới network, storage...

- Mục đích chính của XML là đơn giản hóa việc chia sẻ dữ liệu giữa các hệ thống khác nhau, đặc biệt là các hệ thống được kết nối với Internet.

![](../images/filexml/xml1.png)


<a name="thanhphan"></a>
## 2, Các thành phần của file XML

File xml nhìn cơ bản có thể thấy tổ chức theo khối lệnh, có nhiều khối lệnh cùng trong 1 khối lệnh tổng quan, cú pháp giống HTML có thẻ đóng, thẻ mở.

![](../images/filexml/Screenshot_50.png)

Thẻ quan trọng không thể thiếu trong file domain xml là `domain`

+ Tham số `type` cho biết hypervisor đang sử dụng của VM.

- Các tham số bên trong có ý nghĩa như sau:

`name` thông tin về tên VM

```sh
<name>centos7</name>
```

- `uuid` : Mã nhận dạng quốc tế duy nhất cho máy ảo. Format theo RFC 4122. Nếu thiếu trường uuid khi khởi tạo, mã này sẽ được tự động generate.

```sh
<uuid>0b343e4f-fac7-4944-85cc-eee71389a297</uuid>
```
- Một số type khác có thêm thông tin về các tham số như

+ `title` : Tiêu đề của máy ảo.
+ `description` : Đoạn mô tả của máy ảo, nó sẽ không được libvirt sửa dụng.
+ `metadata` : Chứa những thông tin về file xml.

- `memory`: Dung lượng RAM của máy ảo được cấp khi khởi tạo máy.

`unit` : đơn vị, mặc định là KiB (kibibytes = 1024 bytes), có thể sử dụng b (bytes), KB (Kilobytes = 1000 bytes), MB (Megabytes = 1000000 bytes), M hoặc MiB (Mebibytes = 1,048,576 bytes), GB (gigabytes = 1,000,000,000 bytes), G hoặc GiB (gibibytes = 1,073,741,824 bytes), TB (terabytes = 1,000,000,000,000 bytes), T hoặc TiB (tebibytes = 1,099,511,627,776 bytes)

```sh
<memory unit='KiB'>2097152</memory>
```

- `currentMemory`: Dung lượng RAM đang được sử dụng tại thởi điểm trích xuất file XML

```sh
<currentMemory unit='KiB'>2097152</currentMemory>
```

- `maxMemory` : Dung lượng RAM tối đa có thể sử dụng

- `vcpu`: Tổng số vcpu máy ảo được cấp khi khởi tạo.

```sh
<vcpu placement='static'>1</vcpu>
```
vcpu có một số tham số:

+ `cpuset`: danh sách các cpu vật lí mà máy ảo sử dụng

+ `current` : chỉ định cho phéo kích hoặt nhiều hơn số cpu đang sử dụng

+ `placement` : vị trí của cpu, giá trị bao gồm static và dynamic, trong đó static là giá trị mặc định.

- Block OS: Chứa các thông tin về hệ điều hành của máy ảo

```sh
<os>
    <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
    <boot dev='hd'/>
</os>
```

`arch`: Hệ điều hành thuộc kiến trúc 32 hay 64 bit

`machine`: Thông tin về kernel của HDH

`loader` : readonly có giá trị yes hoặc no chỉ ra file image writable hay readonly. type có giá trị rom hoặc pflash chỉ ra nơi guest memory được kết nối.

`kernel` : đường dẫn tới kernel image trên hệ điều hành máy chủ

`initrd` : đường dẫn tới ramdisk image trên hệ điều hành máy chủ

`cmdline` : xác định giao diện điều khiển thay thế

- Hành động xảy ra đối với một số sự kiện của OS

```sh
<on_poweroff>destroy</on_poweroff>
<on_reboot>restart</on_reboot>
<on_crash>destroy</on_crash>
```

`on_poweroff` : Hành động được thực hiện khi người dùng yêu cầu tắt máy

`on_reboot` : Hành động được thực hiện khi người dùng yêu cầu reset máy

`on_crash` : Hành động được thực hiện khi có sự cố.

Những hành động được phép thực thi:

+ destroy : Chấm dứt và giải phóng tài nguyên

+ restart : Chấm dứt rồi khởi động lại giữ nguyên cấu hình

+ preserve : Chấm dứt nhưng dữ liệu vẫn được lưu lại

+ rename-restart : Khởi động lại với tên mới

+ destroy và restart được hỗ trợ trong cả on_poweroff và on_reboot. preserve dùng trong on_reboot, rename-restart dùng trong on_poweroff

- on_crash hỗ trợ 2 hành động:

+ coredump-destroy: domain bị lỗi sẽ được dump trước khi bị chấm dứt và giải phóng tài nguyên

+ coredump-restart: domain bị lỗi sẽ được dump trước khi được khởi động lại với cấu hình cũ

- CPU : Khuyến cáo đối với CPU model, các tính năng và cấu trúc liên kết của nó có thể được xác định bằng cách sử dụng tập hợp các phần tử sau

```sh
...
<cpu match='exact'>
  <model fallback='allow'>core2duo</model>
  <vendor>Intel</vendor>
  <topology sockets='1' cores='2' threads='1'/>
  <cache level='3' mode='emulate'/>
  <feature policy='disable' name='lahf_lm'/>
</cpu>
...
```

```sh
<cpu mode='host-model'>
  <model fallback='forbid'/>
  <topology sockets='1' cores='2' threads='1'/>
</cpu>
```

```sh
<cpu mode='host-passthrough'>
  <cache mode='passthrough'/>
  <feature policy='disable' name='lahf_lm'/>
...
```

cpu là chứa mô tả các yêu cầu của guest CPU. Thuộc tính `match` của nó xác định mức độ lên kết của CPU ảo được cung cấp cho quest phù hợp với các yêu cầu này. Từ phiên bản 0.7.6 thuộc tính match có thể được bỏ qua nếu topo là phần tử duy nhất trong cpu. 

Một số giá trị có thể có cho thuộc tính `match` là:

+ minimum: 

+ exact: 

+ strict:

- clock: Thiết lập về thời gian

```sh
<clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
</clock>
```

`offset` : giá trị utc, localtime, timezone, variable






Link

https://libvirt.org/formatdomain.html#elementsDevices


