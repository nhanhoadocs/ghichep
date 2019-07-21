# 1. Container
Docker là một ứng dụng dựa vào và cải tiến lại các tính năng có sẵn của Linux kernel, trong đó bao gồm Linux container (LXC), cgroup, namespaces…

Có thể tham khảo thêm github của LXC ở https://github.com/lxc/lxc

# 2. Docker
Docker là một ứng dụng mã nguồn mở cho phép đóng gói các ứng dụng, các phần mềm phụ thuộc lẫn nhau vào trong cùng một container. Container này sau đó có thể mang đi triển khai trên bất kỳ một hệ thống Linux phổ biến nào. Các container này hoàn toàn độc lập với các container khác.

# 3. Các khái niệm quan trọng trong Docker
### Image
Image là một template được đóng gói sẵn và không đổi trong toàn bộ quá trình chạy container (trừ khi build lại image). Liên tưởng đến lập trình hướng đối tượng, Image là class và container là object của class đó.

Các bạn có thể tự build image cho riêng mình, hoặc download các image có sẵn của cộng đồng từ Docker Hub.

### Container
Container được khởi chạy từ các Image, bên trong sẽ có đầy đủ các ứng dụng cần thiết mà bạn định nghĩa từ Image

### Docker Registry
Là một kho chứa các image. Bạn có thể dựng riêng một con Docker Registry cho riêng mình. Hoặc up lên Docker Hub để đóng góp ngược lại cho cộng đồng.

```sh
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io

[root@testdock ~]# sudo systemctl start docker
docker -v[root@testdock ~]# docker -v
Docker version 18.09.3, build 774a1f4

```

sudo docker run hello-world
Bản chất của câu lệnh trên, Docker sẽ pull một image là hello-world trên Docker hub về server và chạy container với image đó.


B1. Docker client (CLI) dùng lệnh sau để chạy một container centos trắng:

docker run -itd centos

docker ps

lis image
docker images

- tim kiem image

`
docker search images
`
- down image ve

`
docker pull centos
`
- chay container

`
docker run -itd centos`
- chay bash trong CT

`docker exec -it 5ae53dede04d bash
cat /etc/centos-release`

docker stop my_container
docker restart my_container

Như vậy là mình đã thực hiện chạy một container với image được pull về (nằm trên Docker host rồi). Trong trường hợp các bạn biết tên image cần chạy thì chỉ cần chạy container luôn và ngay thôi.

Ví dụ: docker run -itd ubuntu. Khi này Docker sẽ tự pull image về host cho bạn rồi sau đó nó mới chạy container


2. Cài đặt Docker sử dụng yum và repository#
Cài đặt các gói cần thiết

`sudo yum install -y yum-utils device-mapper-persistent-data lvm2`

Thêm Docker repo

`sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

Cài đặt bản lastest của Docker CE

`sudo yum install -y docker-ce docker-ce-cli containerd.io`

Kiểm tra lại cài đặt

`sudo systemctl start docker
docker -v`

Docker version 18.09.1, build 4c52b90

Chạy container đầu tiên với Docker

`sudo docker run hello-world`





Nguồn:
https://blog.cloud365.vn/container/tim-hieu-docker-phan-1/