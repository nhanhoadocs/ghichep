# Join OSD vào node CEPH production đang chạy

Bổ sung 8 ổ vào 8 node CEPH

# Thực hiện

## Bước 1

+ Test disk
+ Cắm disk vào server

=> check lệnh lsblk sẽ nhận device mới (Ổ này không được tự động join và cụm CEPH do đã config `osd crush update on start = false` trong file `ceph.conf`)

## Bước 2: Join các OSD vào cụm (chưa đổ data vào)

Đứng trên node ceph-deploy (.51)

```
su cephuser
cd
cd ceph-deploy
```

```
ceph-deploy disk zap nhcephssd01 /dev/sdi
ceph-deploy osd create --data /dev/sdi nhcephssd01
```

Thực hiện `zap` và `create` lần lượt các ổ mới trên các node `nhcephssd01` -> `nhcephssd08`

=> Thực hiện lệnh `ceph osd tree` kết quả disk đã được join vào node ceph tương ứng trong cụm có OSD id và sẵn sàng đổ data vào.

Move ổ Ceph vào bucket:
Ví dụ
```
sudo ceph osd crush move osd.59 host=nhcephssd04
```

## Bước 3: Đổ data vào OSD mới

```
sudo ceph osd reweight osd.{osd-id} {weight1} 
sudo ceph osd crush reweight osd.{osd-id} {weight2}
```

`{weight1}`: Recommend là % sử dụng của cụm tương ứng với %use mà chúng ta muốn đẩy vào ổ mới

`{weight2}`: Là dung lượng thực tế của ổ tính theo TiB, Ceph sẽ dựa trên tham số này để định lượng data đẩy vào OSD sau này

Ví dụ thực hiện lệnh:

```
sudo ceph osd reweight osd.66 0.8 
sudo ceph osd crush reweight osd.66 0.87328
```
