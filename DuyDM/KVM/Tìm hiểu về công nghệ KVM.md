# Tìm hiểu về công nghệ KVM #

## 1, Giới thiệu về công nghệ KVM ##

Kernel-based Virtual Machine (KVM) là một virtualization infrastructure cho Linux kernel được biến thành một hypervisor. Được tích hợp vào kernel Linux chính trong phiên bản kernel 2.6.20, được phát hành vào ngày 5 tháng 2 năm 2007.

KVM (Kernel-based virtual machine) là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V).

+ Intel VT-x:  Intel® Virtualization Technology (VT-x) trên CPU Intel
+ AMD -v: AMD Virtualization (AMD-V) trên CPU AMD.

Thiệt bị phần cứng phải hỗ trợ ảo hóa thì mới áp dụng được công nghệ KVM vào để ảo hóa phần cứng.

