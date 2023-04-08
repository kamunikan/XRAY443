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
sed -i '/#trojan$/a\#& '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /usr/local/sbin/xray/config.json
TLS="trojan://${uuid}@${domain}:443?path=/trojan&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
NTLS="trojan://${uuid}@${domain}:80?path=/trojan&security=none&host=${domain}&type=ws#${user}"
systemctl restart xray
systemctl restart nginx
service cron restart
clear
echo "### ${user} ${exp} ${uuid}" >>/usr/local/sbin/xray/trojan.txt

