# Create virtual machine (CLI)

## A, Môi trường thực hiện LAB

	- KVM server
	
## B, Mô hình

	![](images/createvmcli/mohinhkvm.png)

## C, Các bước thực hiện

Bước 1: Tạo một thư mục (pool) để lưu trữ máy ảo
	```sh
	mkdir -p /var/kvm/images
	```
	![](images/createvmcli/Screenshot_22.png)
	
Bước 2: Sử dụng lệnh `virt-install` với các tham số + giá trị truyền vào để tạo máy ảo với thông tin cấu hình mong muốn

	Các tham số đối với `virt-install`
	
	--name: Đặt tên cho máy ảo
	--ram: Set dung lượng RAM cho máy ảo (MB)
	--disk path=xxx ,size=xxx
		+ path: Đường dẫn lưu trữ file img máy ảo .img, size: dung lượng disk mount
	--vcpus: Set giá trị số vCPU
	--os-type: kiểu hệ điều hành (linux, windows)
	--os-variant: Kiểu của GuestOS . Check bằng lệnh
		```sh
		osinfo-query os
		```
	![](images/createvmcli/Screenshot_23.png)	
	--network: Đải network mà máy ảo tạo ra sẽ cắm vào.
	--graphics: Set chế độ đồ họa, đặt là none -> không sử dụng chế độ đồ họa.
	--console: Lựa chọn kiểu console
	--location: Đường dẫn tới file cài đặt
	--extra-args: Set tham số cho kernel
	