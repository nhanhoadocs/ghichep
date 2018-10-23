# 1. Tìm hiểu về SSH key

Về bản chất ssh key trong Linux sử dụng mã hóa khóa công khai sử dụng cặp khóa private và public key trong xác thực và phân quyền.

SSH key sinh ra một cặp key được dùng để mã hóa bất đối xứng, gồm có public key và private key. SSH key không dùng để mã hóa nội dung nào cả, mà chỉ dùng để xác minh quyền truy cập (cụ thể ở trong ngữ cảnh tìm hiểu là SSH vào server)


- Việc sử dụng password mỗi khi login vào server tiềm tàng một số nguy cơ:

+ Người sử dụng phải nhớ password

+ Dễ bị tấn công từ điển, vét cạn mật khẩu.

+ Một sô nguy cơ bị lộ mật khẩu

## 2. Sử dụng key trong SSH

Mô hình

![](../images/ssh1.png)

Bước 1: Tạo key 

```sh
ssh-keygen -t rsa
```

![](../images/Screenshot_105.png)







