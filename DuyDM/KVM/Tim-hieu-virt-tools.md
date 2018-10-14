# Tìm hiểu một số lệnh cơ bản với virt-tools quản lý máy ảo

## 1, Cài đặt virt-tool

```sh
yum -y install libguestfs-tools virt-top
```
### 2, Một sô lệnh cơ bản

- Hiển thị cấu trúc một thư mục nào đó trong một vm

```sh
virt-ls -l -d <name_máy_ảo> /root 
```

![](images/virttool/Screenshot_32.png)

- Cat nội dung file trong vm

```sh
virt-cat -d <name_máy_ảo> /etc/passwd 
```

![](images/virttool/Screenshot_33.png)

- Edit file trong vm

```sh
virt-edit -d <name_máy_ảo> /etc/fstab
```

- Hiển thị dung lượng disk vm

```sh
virt-df -d <name_máy_ảo>
```
![](images/virttool/Screenshot_34.png)

- Hiển thị status một vm

```sh
virt-top
```
![](images/virttool/Screenshot_35.png)




