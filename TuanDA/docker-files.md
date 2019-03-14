# 1. Dockerfile là gì ?
Dockerfile là một file dạng text không có extension, và tên bắt buộc phải là Dockerfile

Dockerfile là một file kịch bản sử dụng để tạo mới một image


Cacs truowng co ban cua docker file

- FROM 
Base tu iamge nao
`FROM centos:centos7`

- LABEL
`LABEL "image-type"="test"
LABEL "image-type1"="test1"
LABEL "image-type2"="test2"`

LABEL: Chỉ định label metadata của image. Để xem được các label này sử dụng câu lệnh `docker inspect <IMAGE ID>`

- MAINTAINER
`
MAINTAINER tuanda`

MAINTERNER là author (tác giả) build image đó.

- RUN 
run 1 cau lenh tren linux
`RUN yum update -y`

- COPY
`COPY start.sh /start.sh`
COPY Copy một file từ Dockerhost vào image trong quá trình build image

- ENV
`ENV source /var/www/html/
COPY index.html ${source}`
ENV là biến môi trường sử dụng trong quá trình build image.

ENV chỉ có thể được sử dụng trong các command sau:

ADD
COPY
ENV
EXPOSE
FROM
LABEL
STOPSIGNAL
USER
VOLUME
WORKDIR
CMD
CMD ["./start.sh"]
CMD dùng để truyền một Linux command khi khởi tạo container từ image

- VOLUME
`VOLUME ["/etc/http"]`
VOLUME Tạo một volume nằm trong folder /var/lib/docker/volumes của docker host và mount với folder chẳng hạn /etc/http khi khởi chạy container

- EXPOSE
`EXPOSE 80 443`
EXPOSE Chỉ định các port sẽ Listen trong container khi khởi chạy container từ image

#Tạo images httpd với Dockerfile

- 1. Tao thu muc de lam viec voi dockerfile:
```sh
cd ~
mkdir build_image && cd build_image
```

- 2. Tao dockerfile:
```sh
vi Dockerfile
```
Lưu ý: Filename phải là `Dockerfile` và không có phần mở rộng

```sh
FROM centos

LABEL "image-type"="tuanda"
MAINTAINER tuan

RUN yum update -y
RUN yum install httpd -y


```

docker build -f /root/build_image/Dockerfile  -t tuanda/centos7-httpd .

