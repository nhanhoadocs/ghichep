yum install bind bind-utils -y 

allow-query     { any; };
listen-on-v6 port 53 { any; };
