1. cài đặt vzstorage
2. các câu lệnh cơ bản
3. connect Client vào iscsi
4. add / remove CS
5. add / remove Cache
6. Register / Unregister target
7. Troubleshoot các lỗi thường gặp







storage role: chunk service or CS
• metadata role: metadata service or MDS
• network roles:
• iSCSI access point service (iSCSI)
• S3 gateway (access point) service (GW)
• S3 name service (NS)
• S3 object service (OS)
• Web CP
2
Chapter 1. Preparing for Installation
• SSH
• supplementary roles:
• management,
• SSD cache,
• system
Any server in the cluster can be assigned a combination of storage, metadata, and network roles. For
example, a single server can be an S3 access point, an iSCSI access point, and a storage node at once.

Each cluster also requires that a web-based management panel be installed on one (and only one) of the
nodes. The panel enables administrators to manage the cluster.


Metadata+Cache: One or more recommended
enterprise-grade SSDs with power loss protection;
100GB or more capacity; and 75 MB/s sequential
write performance per serviced HDD. For example,
a node with 10 HDDs will need an SSD with at least
750 MB/s sequential write speed (on the first five
nodes in the cluster)

Storage: Four or more HDDs or SSDs; 1 DWPD
endurance minimum, 10 DWPD recommended

### Terabytes Written (TBW)

Terabytes Written (TBW) directly measures how much you can write cumulatively into the drive over its lifetime. Essentially, it just includes the multiplication we did above in the measurement itself. 
For example, if your drive is rated for 365 TBW, that means you can write 365 TB into it before you may need to replace it. 
If its warranty period is 5 years, that works out to 365 TB ÷ (5 years × 365 days/year) = 200 GB of writes per day. If your drive was 200 GB in size, that’s equivalent to 1 DWPD. Correspondingly, if your drive was rated for 3.65 PBW = 3,650 TBW, that works out to 2 TB of writes per day, or 10 DWPD. 
As you can see, if you know the drive’s size and warranty period, you can always get from DWPD to TBW or vice-versa with some simple multiplications or divisions. The two measurements are really very similar. 

What’s the difference?



The only real difference is that DWPD depends on the drive’s size whereas TBW does not. 
For example, consider an SSD which can take 1,000 TB of writes over its 5-year lifetime. 
Suppose the SSD is 200 GB: 

1,000 TB ÷ (5 years × 365 days/year × 200 GB) = 2.74 DWPD 

Now suppose the SSD is 400 GB: 
1,000 TB ÷ (5 years × 365 days/year × 400 GB) = 1.37 DWPD 
The resulting DWPD is different! What does that mean? 
On the one hand, the larger 400 GB drive can do the exact same cumulative writes over its lifetime as the smaller 200 GB drive. Looking at TBW, this is very clear – both drives are rated for 1,000 TBW. But looking at DWPD, the larger drive appears to have just half the endurance! You might argue that because under the same workload, it would perform “the same”, using TBW is better. 



On the other hand, you might argue that the 400 GB drive can provide storage for more workload because it is larger, and therefore its 1,000 TBW spreads more thinly, and it really does have just half the endurance! By this reasoning, using DWPD is better. 

# Tiers
Trong Virtuozzo Storage, tier bao gồm các nhóm các disk được đăng ký để tách biệt tài nguyên. Ví dụ, với các nhóm ổ cứng có đặc điểm khác biệt: giữa SSD tốc độ cao để chạy dịch vụ hoặc giữa nhóm ổ HDD với dung lượng lớn để backup.
Khi tạo lưu ý : 
- Các disk tốc độ cao nên nhóm vào các Tier cao hơn.
- Dung lượng ưu tiên sử dụng cho các tier cao hơn, ví dụ khi tier 2 hết dung lượng, sẽ sử dụng dung lượng ổ cứng của Tier 1,..

vstorage -c vsto top 


Đây là những cờ quan trọng xác định các CS đang ở trạng thái nào. Chi tiết có thể xem tại đây.
J : cờ J thông báo là CS hiện tại đang sử dụng tính năng write journal.
C: cờ này dùng để checksum data có bị chỉnh sửa bởi 1 phần mềm bên ngoài nào đó không ( bảo đảm tính toàn vẹn của data )
D: cờ này thể hiện CS đang sử dụng tốc độ I/O thật của nó. Không dùng write journal.
c: cờ này thể hiện dung lượng hiện tại của journal hiện đang trống. Không có hoạt động nào tác động write journal nào từ SSD đến HDD nơi CS được đặt