#!/bin/bash
export TERM=xterm
export domain=$(cat /etc/xray/domain)
export tls="443"
export none="80"
MYIP=$(wget -qO- icanhazip.com);
clear
read -rp "User: " -e user
read -p "Expired (days): " masaaktif
read -p "Uuid: " uuid
exp=$(date -d "$masaaktif days" +"%Y-%m-%d")
sed -i '/#vmess$/a\#@ '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/sbin/xray/config.json
systemctl restart xray
systemctl restart nginx
service cron restart
clear
echo "### ${user} ${exp} ${uuid}" >>/usr/local/sbin/xray/vmess.txt



