# backup_mysql
backup mysql with python 3

# Requirement 
- Ubuntu / CentOS
- python 3
- git 
- crontab

# Feature 

- Backup mysql database.
- Gửi thông báo backup đến slack + telegram.
- Tự động sync đến FTP server.
- Xóa các folder backup cũ trong vòng **x** ngày

# Ví dụ (Thực hiện trên CentOS 7)

#### 1. Cài đặt các gói cần thiết

```
yum groupinstall "Development Tools" -y
yum install git -y
```

#### 2. Cài đặt python 3.6

```
yum install https://centos7.iuscommunity.org/ius-release.rpm -y
yum install python-devel -y
yum install python36-devel -y
yum install python36 -y
yum install python36u-mod_wsgi -y

yum install python-pip -y
yum install python36u-pip -y
pip3.6 install virtualenv
```

#### 3. Clone repo

```
cd /opt/
git clone https://github.com/huytm/backup_mysql.git
```

#### 4. Tạo virtual environmet và cài đặt thư viện cần thiết

```
cd /opt/backup_mysql
virtualenv env
source env/bin/activate
pip install -r requirement.txt
```

#### 5. Sửa file setting

Sửa file setting tại  `/opt/backup_mysql/settings/settings.json`

**backup_type** - setting của các loại backup_type (kiểu backup) gồm:

- all
- database
- table

**Tính năng mở rộng** - setting của các tính năng mở rộng gồm:

- "sync": true / false 

Có hoặc không sync dữ liệu. Nếu chọn *true*, 2 server phải được cài đặt rsync và phải SSH less không cần password với nhau

- "send_notify": true / false 

Có hoặc không gửi thông báo Slack hoặc Telegram

- "delete_old_file": true / false

Có hoặc không gửi xóa các file backup cũ trên server chạy script. Nếu có xóa trong vòng "remove_days" ngày


```json
{
    "mysql": {
        "user": "MYSQL_USER",
        "password": "MYSQL_PASSWORD",
        "backup_type": "table", 
        "database": "MYSQL_DATABASES",
        "tables": "table1, table2, table3"
    },
    "backup": {
        "backup_folder": "/your/backup/folder",
        "backup_file_name": "your_back_up_file_name"
    },
    "delete_old_file": {
        "delete_old_file": true,
        "remove_days": 10
    },
    "sync": {
        "sync": false,
        "ftp_server": "10.10.10.10",
        "remote_sync_path": "/backup/folder/in/ftp/server"
    },
    "telegram": {
        "send_notify": true,
        "token": "your_telegram_token",
        "chat_id": "your_telegram_chat_id"
    },
    "slack": {
        "send_notify": true,
        "token": "your_slack_token",
        "channel": "your_slack_channel"
    }
}
```

- Ví dụ Backup **tất cả** database và **xóa** các file trong vòng 10 ngày: 

```
...
    "mysql": {
        "user": "MYSQL_USER",
        "password": "MYSQL_PASSWORD",
        "backup_type": "all", 
    ...

    "delete_old_file": {
        "delete_old_file": true,
        "remove_days": 10
    },
```

- Ví dụ Backup **một database** và gửi thông báo đến slack:

```
...
    "mysql": {
        "user": "MYSQL_USER",
        "password": "MYSQL_PASSWORD",
        "backup_type": "database",
        "database": "my_database",
    ...
    
    "slack": {
        "send_notify": true,
        "token": "your_slack_token",
        "channel": "your_slack_channel"
    }
```

- Ví dụ Backup **3 table**, **sync** sang ftp server, **gửi thông báo đến telegram**

```
...
    "mysql": {
        "user": "MYSQL_USER",
        "password": "MYSQL_PASSWORD",
        "backup_type": "table",
        "database": "my_database",
        "tables": "table1, table2, table3"
    ...

    "sync": {
        "sync": true,
        "ftp_server": "10.10.10.10",
        "remote_sync_path": "/backup/folder/in/ftp/server"
    },

    ...
    "telegram": {
        "send_notify": true,
        "token": "your_telegram_token",
        "chat_id": "your_telegram_chat_id"
    },
```

#### 6. Thêm script vào crontab

```
crontab -e
```

Add the following line. Interval backup in 2 hours

```
0 */2 * * * source /opt/backup_mysql/env/bin/activate && python /opt/backup_mysql/run_backup.py
```

