Mục đích sử dụng xác thực 2 lớp để đăng nhập / thao tác trên Linux - ở đây cụ thể là Ubuntu 18 và Google’s PAM module (Pluggable Authentication Module )

Bước 1 : Cài đặt Google PAM module:

```sh
sudo apt-get update
sudo apt-get install libpam-google-authenticator
```

Bước 2 : Cài đặt `Google Authenticator`:

Vào APPSTORE tìm kiếm và cài đặt `Google Authenticator`. 

<div style="width:50%">
![](/images/2fa-ubuntu-3.PNG)
</div>

<p align="center">
<img width="400" height="800" src="/images/2fa-ubuntu-3.PNG">
</p>

Bước 3 : Cấu hình 

```sh
google-authenticator
```


```sh
Do you want authentication tokens to be time-based (y/n) y
```

- `QR code`: Sử dụng ứng dụng `Google Authenticator` để scan, và từ đó sẽ tạo ra mã , thay đổi 30s / lần. Có thể scan trực tiếp hoặc paste đường link vào trình duyệt (ví dụ: https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/root@ctrtest%3Fsecret%3DSZKDXYCAG7TBFNJ7UH75JNQ4DY%26issuer%3Dctrtest)

- Sử dụng ứng dụng Google Authen đã cài đặt vào điện thoại và scan Barcode:

<div style="width:50%">

![](/images/2fa-ubuntu-1.PNG)

![](/images/2fa-ubuntu-2.PNG)

</div>

- `Your new secret key`: phương thức dự phòng để nhập vào authentication app, nếu không support QR code

- `Your verification code`: verification code đầu tiên.

- `Your emergency scratch codes`: Code sử dụng vào trường hợp mất authentication device, cần backup lại

```sh
Do you want me to update your "/root/.google_authenticator" file? (y/n) y
```

Có cho phép nhiều user sử dụng cùng 1 authentication token không:
```sh
Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y
```

Có cho phép phương án dự phòng khi việc đồng bộ thời gian có vấn dề không:
```sh
By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) n
```

Có bật phương thức để chống brute-force không:
```sh
If the computer that you are logging into isnt hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```

Bước 3 : Activating 2FA

- 2FA khi SSH:

Thêm vào  `/etc/pam.d/sshd`:
```sh
auth required pam_google_authenticator.so
```

Thay đổi `ChallengeResponseAuthentication`  trong file `/etc/ssh/sshd_config`: từ `no` sang `yes`
```sh
ChallengeResponseAuthentication yes
```

Restart service :
```sh
service ssh restart
```

SSH vào kiểm tra bảo mật 2 lớp:
```sh
ssh root@103.101.x.x
Password: 
Verification code:
```


- 2FA khi login và sử dụng sudo:

Thêm vào `/etc/pam.d/common-auth`

`auth required pam_google_authenticator.so nullok`

- 2FA chỉ khi login:
Thêm vào `/etc/pam.d/common-session`

`auth required pam_google_authenticator.so nullok`