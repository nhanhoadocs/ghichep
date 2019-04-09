# Cấu hình IPv6 trên OS Windows Server 2008

1. Chọn `Open Network and Sharing Center`:

2. Tick chọn `TCP/IPv6` trong phần `Network Properties`:

![](../images/win2008_1.png)

3. Sau đó vào phần `Properties` của `IPv6`, thực hiện điển IPv6 đã được cấp, bao gồm cả prefix và gateway:

![](../images/win2008_2.png)

4. Chạy lệnh `ipconfig` để kiểm tra lại cấu hình:

![](../images/win2008_3.png)

- Thực hiện ping Google DNS:

![](../images/win2008_4.png)

- Kiểm tra: truy cập vào trang : `http://ipv6-test.com/`