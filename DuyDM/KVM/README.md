## Check list tìm hiểu và LAB về KVM

### A, Lý thuyết

[Tìm hiểu về các công nghệ ảo hóa]
- [x] [Tìm hiểu về các công nghệ ảo hóa](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Create-VM-CLI.md)

- [x] [Tìm hiểu về virtualization-hypervisors](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Virtualization-hypervisors.md)

- [Tìm hiểu về công nghệ ảo hóa KVM](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Tim-hieu-ve-cong-nghe-KVM.md)

	+ [x] Đặc điểm
	+ [x] Kiến trúc và sự hoạt động

- [x] [Phân biệt thick-thin provisioning](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Phan-biet-thin-thick-provisioning.md)

- [File image trong KVM](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Phan-biet-raw-qcow-iso-cua-image.md)
	+ [x] Tìm hiểu chung
	+ [x] Định dạng file image phổ biến (raw, qcow, iso)
	+ [x] Chuyển đổi giữa raw và qcow
	+ [ ] Test performance raw và qcow
	
- Tìm hiểu file xml

	+ [x] [Thành phần trong file domain XML](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/T%C3%ACm%20hi%E1%BB%83u%20v%E1%BB%81%20file%20XML.md)
	+ [x] [Tạo máy ảo bằng file XML](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/T%C3%ACm%20hi%E1%BB%83u%20v%E1%BB%81%20file%20XML.md#vmxml)
	+ [ ] File network XML
	
		[ ] Tạo virtual network từ file xml
		
- [x] Card mạng ảo trong VM (NAT, Public Bridge, Private Bridge)

- Giao tiếp máy ảo Linux Bridge và OpenVSwitch

	+ [ ] Linux Bridge
	+ [ ] OpenVSwitch
	
- Template và Snapshot trong KVM

	+ [ ] Template
	+ [ ] Snapshot
	

	
### B, LAB
	
- [x] [Cài đặt KVM server](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Install-KVM-server.md)

- [Tạo máy ảo bằng CLI (virt-install)](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Create-VM-CLI.md)

	+ [x] Từ image có sẵn
	
	+ [x] Từ file ISO
	
	+ [x] Từ internet

- [Tạo máy ảo bằng GUI (virt-manager)](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Create-VM-GUI.md)

	+ [x] Từ image có sẵn
	
	+ [x] Từ file ISO
	
	+ [ ] Từ internet
	
- [x] [Cài đặt giao diện web KVM - webvirt](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Install-webvirt-KVM.md)

- Tạo máy ảo trên giao diện web KVM

	+ [x] [Từ file xml](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Install-webvirt-KVM.md#vmxml)
	
	+ [x] Từ file ISO

- Thao tác đối với máy ảo (GUI, CLI)

	+ [x] Tạo - xóa - sửa (GUI)
	
	+ [ ] Clone
	
	+ [x] Snapshot (GUI)

- [x] [Tìm hiểu và thao tác một số lệnh Virsh cơ bản trên máy ảo](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Virsh-command-basic.md)

- [x] [Tìm hiểu và sử dụng virt-tools](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Tim-hieu-virt-tools.md)

- [x] [Live Migration](https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Live-migration-KVM.md)




sed -i 's/GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet"/GRUB_CMDLINE_LINUX="crashkernel=auto console=tty0 console=ttyS0,115200n8"/g' /etc/default/grub


virt-sparsify --compress /var/lib/libvirt/images/centOS72nic.qcow2 centOS72nic.img







