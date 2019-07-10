Creating dedicated mount point for docker
It’s good to start with a dedicated mount point for docker by creating a logical volume.

```sh
fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate vg_docker /dev/sdb1
lvcreate -n lv_docker -l 100%FREE vg_docker
mkfs.xfs /dev/mapper/vg_docker/lv_docker
mount /dev/mapper/vg_docker/lv_docker /var/lib/docker
```

Extending docker mount point
In case if we need more space under /var/lib/docker, add a new disk and extend the existing vg, lv at last grow the XFS mount point.
```sh
fdisk /dev/sdc
pvcreate /dev/sdc1
vgextend vg_docker /dev/sdc1
lvextend -l +100%FREE /dev/mapper/vg_docker/lv_docker
xfs_growfs /var/lib/docker
```

Enabling Docker Repo, Installing and starting Docker
```sh
cd /etc/yum.repos.d/; 
curl -O https://download.docker.com/linux/centos/docker-ce.repo
yum repolist
yum install yum-utils device-mapper-persistent-data lvm2 -y
yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
```

Granting Normal user to run docker commands
`sudo usermod -aG docker babinlonston`

Verifying Docker Version
```sh
docker -v
docker info
docker system info
```

Searching, Pulling, listing and Removing Docker images.
```sh
docker search nginx
docker pull nginx
docker pull nginx:1.14
docker images
docker rmi nginx
docker rmi nginx:1.14
```

Starting a container, with tag
```sh
docker run nginx
docker run -d nginx:1.14
docker run -d --name web_server nginx
docker run -d --name web_server1 nginx:1.14
```

Launching a container and login into it
```sh
docker run --name web_server2 -it nginx /bin/bash
```
 
Listing all running and stopped containers
```sh
docker ps
docker ps -a
```

Accessing shell of a running Container after launch
```docker exec -it web_server /bin/bash```

Executing command on a running Container
```sh
docker exec web_server cat /etc/hosts
docker exec web_server env
```

Restarting, Stopping and Deleting
```sh
docker restart web_server
docker stop web_server1 nginx
docker stop $(docker ps -aq)
docker rm web_server1
docker rm $(docker ps -aq)
```

Reference: How to manage Docker containers

Stop or kill by sending SIGKILL
```sh
docker kill exec web_server2
docker kill -s SIGKILL exec web_server2
```

Launch and expose the network.
# docker run --name web_server3 -p 8080:80 -d -it nginx
# docker run -d --name web_server4 -p 192.168.107.105:8080:80 nginx
Reference: How to connect Docker containers and expose the network

Running Inspect to Know the IP of a Container
# docker inspect web_server
# docker inspect web_server | grep -i -A 1 'IPAddress|ExposedPorts'
# docker inspect -f '{{ .NetworkSettings.IPAddress }}' web_server
# docker inspect -f '{{ .Config.ExposedPorts }}' web_server

 
Attaching a Volume
# mkdir /mysql_container 
# chown -R 27:27 /mysql_container 
# chcon -t svirt_sandbox_file_t /mysql_container  #temp
                      or
# semanage fcontext -a -t svirt_sandbox_file_t '/mysql_container(/.*)?'  #Persistent

# docker run --name mysql-pro-dbsrv -d -v /mysql_container:/var/lib/mysql/ -e MYSQL_ROOT_USER=root -e MYSQL_ROOT_PASSWORD=password123 mysql
Reference : Managing Docker data persistently by attaching a volume

Docker export, import, load and save
# docker export apache > linuxsysadins.local.tar
# docker import - website < linuxsysadins.local.tar 
# docker save -o website_backup.local.tar website
# docker load < website_backup.local.tar
Creating Docker file and Building image with a Volume
# mkdir /root/linuxsysadmins
# vim /root/linuxsysadmins/Dockerfile
Replace with your required values.

 FROM centos
 MAINTAINER Babin Lonston
 RUN yum update -y && yum install httpd mod_ssl -y
 VOLUME /var/www/html
 ADD linuxsysadmins.local.conf /etc/httpd/conf.d/linuxsysadmins.local.conf
 ADD index.html /var/www/html/index.html
 CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
 EXPOSE 80/tcp
Creating virtualhost configuration

# vim linuxsysadmins.local.conf
<VirtualHost *:80>
    ServerAdmin siteadmin@linuxsysadmins.local
    DocumentRoot /var/www/html
    ServerName linuxsysadmins.local
    ServerAlias nixsysadmins.local
    ErrorLog "/var/log/httpd/linuxsysadmins.local-error_log
    CustomLog "/var/log/httpd/linuxsysadmins.local-access_log common
</VirtualHost>
Create index.html file for Apache

# vim /root/linuxsysadmins/index.html
Append with your content.

<html>
<body>
<h1>This is Test page for linuxsysadmins.local</h1>
</body>
</html>
Build an image using docker file. Make sure to use “.” as shown below to build from the current directory.

# docker build  -t linuxsysadmins.local .
# docker images
Pushing images to Docker Hub
Login to Docker hub using “docker login“, tag the image and push to your repository.

# docker login
# docker tag linuxsysadmins.local babinlonston/linuxsysadmins.local:0.1
# docker images
# docker push babinlonston/linuxsysadmins.local:0.1
Find the changes with an image and running Container
To list out the changed files on a container by comparing with its image

# docker run -d --name webserver nginx
# docker diff webserver

 
[root@docker ~]# docker diff webserver 
 C /var
 C /var/cache
 C /var/cache/nginx
 A /var/cache/nginx/client_temp
 A /var/cache/nginx/fastcgi_temp
 A /var/cache/nginx/proxy_temp
 A /var/cache/nginx/scgi_temp
 A /var/cache/nginx/uwsgi_temp
 C /run
 A /run/nginx.pid
Creating and mounting Volumes
Creating a Volume on Container

# docker run -d -v /var/www/html --name websrv linuxsysadmins.local
Mounting a local directory inside a Container

# docker run -d --name webserver_hosted -v /var/www/html:/var/www/html linuxsysadmins.local
Creating, Inspecting, Removing unused and Deleting a Volume
To create a volume for different applications, inspecting a volume, remove a local unused volume.

# docker volume ls
# docker volume create web_apps
# docker volume inspect web_apps
# docker volume prune
# docker volume rm web_apps1

 
[root@docker ~]# docker volume inspect web_apps
 [
     {
         "CreatedAt": "2019-07-03T00:47:33+05:30",
         "Driver": "local",
         "Labels": {},
         "Mountpoint": "/var/lib/docker/volumes/web_apps/_data",
         "Name": "web_apps",
         "Options": {},
         "Scope": "local"
     }
 ]
Create Docker Network
Creating a network for communicating between container and host, this will be a bridge by default. Use Inspect to know more information about network.

# docker network create --subnet 192.168.109.0/24 --gateway 192.168.109.2 web_apps_net
# docker network inspect web_apps_net
# docker network ls
[root@docker ~]# docker network inspect web_apps_net 
 [
     {
         "Name": "web_apps_net",
         "Id": "f2cca056137040b8e05d6e70cd4287a056356642e49ee9f264ef06b6b637f35e",
         "Created": "2019-07-03T21:54:30.35434543+05:30",
         "Scope": "local",
         "Driver": "bridge",
         "EnableIPv6": false,
         "IPAM": {
             "Driver": "default",
             "Options": {},
             "Config": [
                 {
                     "Subnet": "192.168.109.0/24",
                     "Gateway": "192.168.109.2"
                 }
             ]
         },
         "Internal": false,
         "Attachable": false,
         "Ingress": false,
         "ConfigFrom": {
             "Network": ""
         },
         "ConfigOnly": false,
         "Containers": {},
         "Options": {},
         "Labels": {}
     }
 ]
 [root@docker ~]#
Assigning static IP address to a Container
Start a container from nginx image by assigning a static IP address and verify the same.

# docker run -d --name web_apps_srv1 --network web_apps_net --ip 192.168.109.100 nginx
# docker inspect web_apps_srv1
# docker inspect -f '{{ .NetworkSettings.IPAddress }}' web_apps_srv1
# curl 192.168.109.100

 
Verify using curl by pointing to Nginx server’s static IP.

[root@docker ~]# curl 192.168.109.100
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
[root@docker ~]#
Disconnecting and Reconnecting Network from a Container
To disconnect a network from a container use “disconnect network container“. Once disconnected, we need to specify the IP again while reconnecting the network to the Container. Finally inspect the IP once connected.
```sh
docker network disconnect web_apps_net web_apps_srv1
docker inspect web_apps_srv1
docker network connect web_apps_net web_apps_srv1 --ip 192.168.109.100
docker inspect web_apps_srv1
```
Removing a Network and Prune
To remove a network use “network rm“. To remove all unused network those are not attached to any container will be removed while we run “network prune“.
```sh
docker inspect web_apps_net
docker network rm web_apps_net
docker network ls
docker network prune
```