# Create virtual machine (GUI)

## A, Môi trường thực hiện LAB

- KVM server

- Cài đặt XMing

- File .iso hệ điều hành
	
## B, Mô hình

![](images/createvmcli/Screenshot_24.png)

## C, Các bước thực hiện

Bước 1: Chạy lệnh `virt-manager` để khởi tạo GUI

```sh
virt-manager
```

![](images/createvmcli/Screenshot_21.png)

Bước 2: Tạo máy ảo

File -> Virtual Machine

![](images/createvmcli/Screenshot_22.png)

- Lựa chọn cách thức cài đặt

	+ Local install media: Cài đặt từ file ISO
	
	+ Network install: Cài đặt qua giao thức HTTP, FTP, NFS
	
	+ Network boot (PXE): Cài đặt qua cobbler
	
	+ Import existing disk image: Cài đặt từ một file img có sẵn.
	
![](images/createvmcli/Screenshot_23.png)

Ở đây cài đặt từ file ISO chọn `Local install media`

- Tìm và lựa chọn file ISO

![](images/createvmcli/Screenshot_24.png)

- Set thông số RAM, vCPU

![](images/createvmcli/Screenshot_26.png)

- Set dung lượng disk của VM

![](images/createvmcli/Screenshot_27.png)

- Đặt tên cho máy ảo và lựa chọn card mạng của máy ảo.

![](images/createvmcli/Screenshot_28.png)

- Click `Finish` quá trình cafid đặt OS bắt đầu.

![](images/createvmcli/Screenshot_29.png)

- Tiến hành cài đặt OS bình thường.


