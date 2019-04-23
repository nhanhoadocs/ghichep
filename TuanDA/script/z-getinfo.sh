#kill s.sh
for pid in $(ps -ef | grep "s.sh" | awk '{print $2}'); do kill -9 $pid; done
#kill l.sh
for pid in $(ps -ef | grep "l.sh" | awk '{print $2}'); do kill -9 $pid; done
#kill zmcat
for pid in $(ps -ef | grep "zmcat" | awk '{print $2}'); do kill -9 $pid; done

find / -name "zmcat" -exec echo {} \; >> /root/listfile
find / -name "l.sh" -exec echo {} \; >> /root/listfile
find / -name "s.sh" -exec echo {} \; >> /root/listfile