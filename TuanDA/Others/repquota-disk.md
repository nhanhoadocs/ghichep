# Repquota thường được sử dụng để limit quota tài nguyên disk đối với từng user

1. Hiển thị quota của các user:

```sh
repquota -a
#hoặc
repquota /home
```

2. Khi 1 user đã đạt limit sẽ có dấu + nhỏ cạnh tên user:

```sh
*** Report for user quotas on device /dev/sdb1
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      -- 42326864       0       0         315840     0     0   
kynguyen  +- 1026800 1024000 1126400   none    6735     0     0
```

Block limit của user `kynguyen` đã đạt đến giá trị limit.
- Thực hiện upload vào thư mục home của user này sẽ hiển thị lỗi:

```sh
Mar 22 13:48:57 digi proftpd[27672]: 103.x.x.x (x.x.x.48[x.x.x.48]) - notice: user kynguyen: aborting transfer: Disk quota exceeded
```


3. Chỉnh lại giá trị limit của user:

```sh
edquota -f /dev/sdb1 kynguyen
```
Cụ thể ở đây là phân vùng `/dev/sdb1` với user `kynguyen`

Sau khi thực hiện lệnh sẽ ra trình edit `vi` và có thể thay đổi giá trị:

```sh
Disk quotas for user kynguyen (uid 559):
  Filesystem                   blocks       soft       hard     inodes     soft     hard
  /dev/sdb1                   1026804          0          0       6735        0        0
```

sau khi lưu lại thay đổi, ta sử dụng câu lệnh để kiểm tra lại:
`repquota /home`

```sh
*** Report for user quotas on device /dev/sdb1
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      -- 42326864       0       0         315840     0     0  
kynguyen  -- 1026800       0       0           6735     0     0
```

*** Tham khảo : 
http://www.omnisecu.com/gnu-linux/redhat-certified-engineer-rhce/how-to-manage-linux-disk-quota-using-edquota-and-repquota-commands.php