# 1. Repo

## 1.1 Ba trạng thái của một repo:
Như hình trên bạn có thể thấy có 3 điểm cần lưu ý:

![](git_1.png)

Working dir: đây là nơi bạn thực hiện các thao tác chỉnh sửa với file mã nguồn của mình, nó có thể là eclipse, netbean, notepad++,...

Stagging area: những sự thay đổi của bạn với file mã nguồn được lưu lại, giống như bạn ấn Save trong một file notepad.

Git directory: nơi lưu trữ mã nguồn của bạn (ở đây là github)

Tương ứng với 3 vị trí này ta có các hành động:

`Add`: lưu file thay đổi (mang tính cục bộ) - tương ứng với câu lệnh `git add`

`Commit`: Ghi lại trạng thái thay đổi tại máy local (ví dụ như bạn có thể ấn Save nhiều lần với file README.md nhưng chỉ khi commit thì trạng thái của lần ấn Save cuối cùng trước đó mới được lưu lại) - tương ứng với câu lệnh `git commit`

`Push`: Đẩy những thay đổi từ máy trạm lên server - tương đương lệnh `git push`

`Pull`: đồng bộ trạng thái từ server về máy trạm - tương đương lệnh `git pull`

# 2. Cài đặt:
## 1.1. Linux
Với OS là Ubuntu:
`apt-get install git`

Với OS là Fedora, Centos
`yum instal git`

Các thiết lập ban đầu:

Bạn cần thiết lập tên và email của mình để mỗi khi commit lên server sẽ nhận biết được ai commit lên vì một repo có thể có nhiều người tham gia.

`git config --global user.name "TuanDA"`

`git config --global user.email anhtuanit204@gmail.com`

Lựa chọn trình soạn thảo mặc định, có thể là vi, vim, nano,...
`git config --global core.editor vi`

Liệt kê các thiết lập:

`git config --list`

Liên kết với tài khoản github bằng SSH

```sh
ssh-keygen -t rsa

Enter file in which to save the key (/root/.ssh/id_rsa): [Press enter]
Enter passphrase (empty for no passphrase): [Press enter]
Enter same passphrase again: [Press enter]
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
```
Nếu bạn nhập passphrase thì hãy nhớ pass này!

Kết quả:

```sh
ls ~/.ssh/

id_rsa       id_rsa.pub   known_hosts
ssh-agent -s

ssh-add ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub
```

copy đoạn mã này

Truy cập đường dẫn sau https://github.com/settings/ssh (đảm bảo bạn đã đăng nhập vào github), chọn Add SSH key, đặt tên cho key này tại Title và paste nội dung vừa copy vào ô Key

Lúc này bạn đã có thể commit lên github tại máy local mà không cần nhập username và password.

## 1.2. Windows
Download tại địa chỉ: https://windows.github.com/

Cài đặt bình thường, yêu cầu phải có .NET 4.5

Hoặc có thể download git bash về


* Tham khảo: 
https://github.com/hocchudong/git-github-for-sysadmin/blob/master/README.md