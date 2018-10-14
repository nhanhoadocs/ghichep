# Create virtual machine (GUI)

## A, Môi trường thực hiện LAB

- KVM server

- Cài đặt XMing

- File .iso hệ điều hành
	
## B, Mô hình

![](images/createvmgui/Screenshot_24.png)

## C, Các bước thực hiện

Bước 1: Chạy lệnh `virt-manager` để khởi tạo GUI

```sh
virt-manager
```

![](images/createvmgui/Screenshot_21.png)

Bước 2: Tạo máy ảo

File -> Virtual Machine

![](images/createvmgui/Screenshot_22.png)

- Lựa chọn cách thức cài đặt

	+ Local install media: Cài đặt từ file ISO
	
	+ Network install: Cài đặt qua giao thức HTTP, FTP, NFS
	
	+ Network boot (PXE): Cài đặt qua cobbler
	
	+ Import existing disk image: Cài đặt từ một file img có sẵn.
	
![](images/createvmgui/Screenshot_23.png)

Ở đây cài đặt từ file ISO chọn `Local install media`

- Tìm và lựa chọn file ISO

![](images/createvmgui/Screenshot_25.png)

- Set thông số RAM, vCPU

![](images/createvmgui/Screenshot_26.png)

- Set dung lượng disk của VM

![](images/createvmgui/Screenshot_27.png)

- Đặt tên cho máy ảo và lựa chọn card mạng của máy ảo.

![](images/createvmgui/Screenshot_28.png)

- Click `Finish` quá trình cafid đặt OS bắt đầu.

![](images/createvmgui/Screenshot_29.png)

- Tiến hành cài đặt OS bình thường.


