# Hướng dẫn cài đặt IPAM trên CentOS 7

### Mục lục

[1, Chuẩn bị](#chuanbi)

[2, Mô hình](#mohinh)

[3, Các bước cài đặt](#setup)

[4, Link tham khảo](#thamkhao)

<a name="chuanbi"></a>
## 1, Chuẩn bị

- Server: Cài đặt OS CentOS 7

- RAM: 4Gb

- CPU: 2 core

- Disk: 100 Gb

- Network: 1 interface

Server ra được internet, disable firewall, selinux, hostaname...


<a name="mohinh"></a>
## 2, Mô hình


<a name="setup"></a>
## 3, Các bước cài đặt

Bước 1: Cài đặt các gói cần thiết

```sh
yum -y install epel-release
yum -y update
yum -y install httpd mariadb-server mariadb
```

Bước 2: Update repo

```sh
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y update
```

![](../images/Screenshot_51.png)

Bước 3: Cài đặt PHP modules

```sh
yum -y install php71w php71w-cli php71w-session php71w-sockets php71w-gmp php71w-mcrypt php71w-simplexml php71w-json php71w-gettext php71w-filter php71w-pcntl php71w-mbstring php71w-gd php71w-common php71w-ldap php71w-pdo php71w-pear php71w-snmp php71w-xml php71w-mysql git
```

![](../images/Screenshot_52.png)


- Kiểm tra version PHP

![](../images/Screenshot_53.png)

Bước 4: Chỉnh sửa time zone trong file php.ini


```sh
vi /etc/php.ini

edit 

Asia/Ho_Chi_Minh

```

![](../images/Screenshot_54.png)

Bước 5: Khởi động service httpd, mariadb

```sh
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb
```

![](../images/Screenshot_55.png)

Bước 6: Cài đặt thông tin về SQL

- Thiết lập thông tin cho mysql

![](../images/Screenshot_56.png)

```sh
mysql -u root -p
CREATE DATABASE phpipam_data;
CREATE USER 'phpipam_user'@'localhost' IDENTIFIED BY 'datpasstuyy';
GRANT ALL PRIVILEGES ON phpipam_data.* TO 'phpipam_user'@'localhost';
FLUSH PRIVILEGES;
```
![](../images/Screenshot_58.png)

Bước 7: Tải các package của IPAM


```sh
cd /var/www
 
git clone https://github.com/phpipam/phpipam.git 

cd phpipam

git checkout 1.3
```

![](../images/Screenshot_59.png)

Bước 7: Set quyền cho IPAM

```sh
chown -R apache:apache /var/www/phpipam
```
![](../images/Screenshot_60.png)

Bước 8: Chỉnh sửa file config ipam

```sh
cd /var/www/phpipam 
cp config.dist.php config.php
```

![](../images/Screenshot_61.png)

![](../images/Screenshot_62.png)

Cài đặt với đúng thông tin database đã thiết lập.


Bước 9: Tạo file config ipam trong `httpd/conf.d`

```sh
vi /etc/httpd/conf.d/phpipam.conf

add nội dung

<VirtualHost *:80>
    ServerAdmin localhost
    DocumentRoot "/var/www/phpipam"
    ServerName localhost
    ServerAlias localhost
    <Directory "/var/www/phpipam">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog "/var/log/httpd/phpipam.yourdomain.com-error_log"
    CustomLog "/var/log/httpd/phpipam.yourdomain.com-access_log" combined
</VirtualHost>

```

- Restart lại service httpd, mariadb

```sh
systemctl restart httpd
systemctl restart mariadb
```

Bước 10: Truy cập giao diện IPAM

http://ip_server_ipam

- Lựa chọn 1 để hệ thống tự detect sqp ipam

![](../images/Screenshot_63.png)

- Thiết lập thông số database: Click "Show advance option" bỏ hết tích

![](../images/Screenshot_64.png)

- Thiết lập config admin cho ipam

![](../images/Screenshot_66.png)

- Login thành công

![](../images/Screenshot_67.png)

![](../images/Screenshot_68.png)

<a name="thamkhao"></a>
## 4, Link tham khảo

https://hostpresto.com/community/tutorials/how-to-install-phpipam-on-centos-7/

https://phpipam.net/phpipam-installation-on-centos-7/

https://phpipam.net/documents/installation/










