# Lab limit Bandwidth IO trên VM

Khi phát hiện 1 VPS có hiện tượng Bandwidth IO cao được phát hiện qua một số cách nhứ:

+ Có cảnh báo qua telegram về đường bond3 (CEPH-COM) traffic cao

![](../images/img-qos-bandwidth-io/Screenshot_332.png)

+ Kiểm tra các traffic qua biểu đổ

Traffic Port CEPH-COM to Compute 

![](../images/img-qos-bandwidth-io/Screenshot_333.png)

CEPH I/O Bandwidth 

![](../images/img-qos-bandwidth-io/Screenshot_334.png)

=> Xác định được VM ở COM nào đang gây ra hiện tượng I/O Bandwidth cao.

+ Xác định chính xác VM nào.

ssh vào COM đó sử dụng lệnh `virt-top`

![](../images/img-qos-bandwidth-io/Screenshot_766.png)

Trích xuất thông tin instance-xxx

dump file xml để lấy thông tin ID

```
virsh dumpxml instance-xxx
```

## Test QoS Bandwidth IO

+ Chuẩn bị 1 VPS 

Lấy ID VM trên KVM

![](../images/img-qos-bandwidth-io/Screenshot_335.png)

+ Thực hiện trên node COM chứa VM đó.

Xem VM đó đã được áp policy QoS nào chứa.

```
virsh domblklist instance-0000001c

virsh blkdeviotune instance-0000001c vda
```

![](../images/img-qos-bandwidth-io/Screenshot_336.png)

Như trên hình là chưa có policy được áp dụng đối với VM này trên KVM.

+ Test thử VM đó.

```
Read rand 4k
sync; echo 3 > /proc/sys/vm/drop_caches && name=read-rand; fio --randrepeat=1 --rw=randread --ioengine=libaio --size=4G --filename=testfile --name=read-rand --direct=1 --gtod_reduce=1 --bs=4k --iodepth=64 --runtime=600 --time_based && rm -rf testfile
```


