## Check list tìm hiểu và LAB về KVM

### A, Lý thuyết

[Tìm hiểu về các công nghệ ảo hóa](#https://github.com/domanhduy/ghichep/blob/master/DuyDM/KVM/docs/Create-VM-CLI.md)
- [x] Tìm hiểu về các công nghệ ảo hóa

- [x] Tìm hiểu về virtualization-hypervisors

- Tìm hiểu về công nghệ ảo óa KVM

	+ [x] Đặc điểm
	+ [x] Kiến trúc và sự hoạt động

- [x] Phân biệt thick-thin provisioning

- File image trong KVM
	+ [x] Tìm hiểu chung
	+ [x] Định dạng file image phổ biến (raw, qcow, iso)
	+ [x] Chuyển đổi giữa raw và qcow
	+ [ ] Test performance raw và qcow
	
- Tìm hiểu file xml

	+ [ ] Thành phần trong file domain XML
	+ [ ] Tạo máy ảo bằng file XML
	+ [ ] File network XML
	
		[ ] Tạo virtual network từ file xml
		
- [ ] Card mạng ảo trong VM (NAT, Public Bridge, Private Bridge)

- Giao tiếp máy ảo Linux Bridge và OpenVSwitch

	+ [ ] Linux Bridge
	+ [ ] OpenVSwitch
	
- Template và Snapshot trong KVM

	+ [ ] Template
	+ [ ] Snapshot
	

	
### B, LAB
	
- [x] Cài đặt KVM server

- Tạo máy ảo bằng CLI (virt-install)

	+ [x] Từ image có sẵn
	
	+ [x] Từ file ISO
	
	+ [x] Từ internet

- Tạo máy ảo bằng GUI (virt-manager)

	+ [ ] Từ image có sẵn
	
	+ [x] Từ file ISO
	
	+ [ ] Từ internet
	
- [ ] Cài đặt giao diện web KVM (webvirt)

- Tạo máy ảo trên giao diện web KVM

	+ [ ] Từ image có sẵn
	
	+ [ ] Từ file ISO
	
	+ [ ] Từ internet

- Thao tác đối với máy ảo (GUI, CLI)

	+ [x] Tạo - xóa - sửa (GUI)
	
	+ [ ] Clone
	
	+ [x] Snapshot (GUI)

- [x] Tìm hiểu và thao tác một số lệnh Virsh cơ bản trên máy ảo

- [x] Tìm hiểu và sử dụng virt-tools

- [ ] Live Migration









