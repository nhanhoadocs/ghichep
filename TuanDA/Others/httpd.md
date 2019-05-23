
# PREPAIR

```sh
yum install gcc gcc-c++ -y
```

# APR 
```sh
cd srclib/

wget http://mirror.downloadvn.com/apache//apr/apr-1.6.5.tar.gz
tar xvzf apr-1.6.5.tar.gz
mv apr-1.6.5 apr

wget http://mirror.downloadvn.com/apache//apr/apr-util-1.6.1.tar.gz
tar xvzf apr-util-1.6.1.tar.gz
mv apr-util-1.6.1 apr-util
```

# PCRE

```sh
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
tar xvzf pcre-8.43.tar.gz 
cd pcre-8.43
./configure 
make && make install
```

# EXPAT

```sh
wget http://downloads.sourceforge.net/expat/expat-2.0.1.tar.gz
tar xvzf expat-2.0.1.tar.gz 
cd expat-2.0.1
./configure --prefix=/usr &&
 make install && install -v -m755 -d /usr/share/doc/expat-2.0.1 && install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.0.1
 ```

# APACHE
```sh
wget http://mirror.downloadvn.com/apache//httpd/httpd-2.4.38.tar.gz

gzip -d httpd-2.4.38.tar.g
tar xvf httpd-2.4.38.tar
cd httpd-2.4.38
./configure --with-included-apr
make && make install
```
Sử dụng option `--prefix=PREFIX` để chỉ định thư mục cài đặt, nếu không, mặc định là `/usr/local/apache2`.

Customize

$ vi PREFIX/conf/httpd.conf

Test	

$ PREFIX/bin/apachectl -k start

Thư mục mặc định upload source code PREFIX/htdocs/

https://geekflare.com/apache-installation-troubleshooting/
https://www.rootusers.com/installing-apache-2-4-and-php-5-4-from-source/