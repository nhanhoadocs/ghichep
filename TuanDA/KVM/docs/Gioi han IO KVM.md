1. Xác định máy ảo bị đang có IOPS lớn bất thường.
openstack server list / openstack server show -> de lay id KVM

2. Chuyển qua node COMPUTE chứa máy ảo để thực hiện limit QOS
Thực hiện lệnh để kiểm tra tên disk của máy ảo
`virsh domblklist instance-00000875`
```sh
[root@compute04 ~]# virsh domblklist instance-00000875
Target     Source
------------------------------------------------
vda        volumes/volume-8d949e2c-d5ec-4842-b049-65b6d0db7cfe
```
Xem policy đã áp cho máy ảo
`virsh blkdeviotune instance-00000875 vda`
```sh
[root@compute04 ~]# virsh blkdeviotune instance-00000875 vda
total_bytes_sec: 0
read_bytes_sec : 0
write_bytes_sec: 0
total_iops_sec : 0
read_iops_sec  : 0
write_iops_sec : 0
total_bytes_sec_max: 0
read_bytes_sec_max: 0
write_bytes_sec_max: 0
total_iops_sec_max: 0
read_iops_sec_max: 0
write_iops_sec_max: 0
size_iops_sec  : 0
group_name     : 
total_bytes_sec_max_length: 0
read_bytes_sec_max_length: 0
write_bytes_sec_max_length: 0
total_iops_sec_max_length: 0
read_iops_sec_max_length: 0
write_iops_sec_max_length: 0
```
Thực hiện thiết lập QoS với thông số Read là 2500 và Write 2500:
```sh
virsh blkdeviotune instance-00000875 vda --read-iops-sec 2500 --write-iops-sec 2500 --live
```
Hoặc theo byte /s (Trong ví dụ là 200MB/s)
```sh
virsh blkdeviotune instance-00000875 vda --write_bytes_sec $(expr 1024 \* 1024 \* 200) 
virsh blkdeviotune instance-00000875 vda --read_bytes_sec $(expr 1024 \* 1024 \* 200) 
```
- Các option có thể đọc thêm tại: https://rentry.co/qtoyh
3. Check lại policy đã áp cho máy ảo:
```sh
[root@compute04 ~]# virsh blkdeviotune instance-00000875 vda
total_bytes_sec: 0
read_bytes_sec : 209715200
write_bytes_sec: 0
total_iops_sec : 0
read_iops_sec  : 2500
write_iops_sec : 2500
total_bytes_sec_max: 0
read_bytes_sec_max: 0
write_bytes_sec_max: 0
total_iops_sec_max: 0
read_iops_sec_max: 0
write_iops_sec_max: 0
size_iops_sec  : 0
group_name     : drive-virtio-disk0
total_bytes_sec_max_length: 0
read_bytes_sec_max_length: 0
write_bytes_sec_max_length: 0
total_iops_sec_max_length: 0
read_iops_sec_max_length: 0
write_iops_sec_max_length: 0
```
4. Thực hiện benchmark để kiểm chứng lại.



*Tài liệu tham khảo:<br/>
https://fedoraproject.org/wiki/QA:Testcase_Virtualization_IO_Throttling <br/>
https://rentry.co/qtoyh