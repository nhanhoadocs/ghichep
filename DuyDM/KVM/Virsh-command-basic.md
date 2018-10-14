# Tìm hiểu một số lệnh cơ bản với Virsh

### 1, Bật máy ảo

+ Start 

```sh
virsh start <name_máy_ảo>
```

+ Start và mở console

```sh
virsh start --console
```

### 2, Tắt máy ảo

```sh
virsh shutdown <name_máy_ảo>

or

virsh destroy <name_máy_ảo>
```

### 3, Auto bật máy ảo

```sh
+enable

virsh autostart <name_máy_ảo>

+disable

virsh autostart --disable <name_máy_ảo>
```
### 4, List tất cả máy ảo

```sh
virsh list --all
```
![](images/virshcommand/Screenshot_31.png)

### 5, 	Chuyển chế độ console GuestOS <-> HostOS

Hệ điều hành chủ (host operating system): là hệ điều hành chạy trên máy chủ.

Hệ điều hành khách (guest operating system): là hệ điều hành chạy trên một VM


