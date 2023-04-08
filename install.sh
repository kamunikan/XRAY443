clear
NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
secs_to_human() {
echo -e "${WB}Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds${NC}"
}
start=$(date +%s)
#Hallo

#Update & Upgrade
apt update -y
apt full-upgrade -y
apt dist-upgrade -y
apt install build-essential gcc make libsqlite3-dev
apt install socat curl screen cron screenfetch netfilter-persistent vnstat lsof fail2ban -y
systemctl start vnstat
mkdir /usr/local/sbin/xray
clear

vnstat -i eth1 --remove --force
clear

wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
sudo unzip Xray-linux-64.zip -d //usr/local/sbin/xray/
sudo chmod +x /usr/local/sbin/xray/xray 

sudo wget -O /etc/systemd/system/xray.service https://raw.githubusercontent.com/kamunikan/XRAY443/main/xray.service

sudo mkdir -p /var/log/xray
sudo chown root:root /var/log/xray
sudo touch /var/log/xray/access.log
sudo touch /var/log/xray/error.log


clear
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
clear
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
apt install nginx -y
rm /var/www/html/*.html
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
systemctl restart nginx
clear
touch /usr/local/sbin/xray/domain
echo -e "${YB}Input Domain${NC} "
echo " "
read -rp "Input your domain : " -e dns
if [ -z $dns ]; then
echo -e "Nothing input for domain!"
else
echo "$dns" > /usr/local/sbin/xray/domain
fi
clear
systemctl stop nginx
domain=$(cat /usr/local/sbin/xray/domain)
curl https://get.acme.sh | sh
source ~/.bashrc
cd .acme.sh
bash acme.sh --issue -d $domain --server letsencrypt --keylength ec-256 --fullchain-file /usr/local/sbin/xray/fullchain.crt --key-file /usr/local/sbin/xray/private.key --standalone --force
clear
echo -e "${GB}[ INFO ]${NC} ${YB}Setup Nginx & Xray Conf${NC}"
echo "UQ3w2q98BItd3DPgyctdoJw4cqQFmY59ppiDQdqMKbw=" > /usr/local/sbin/xray/serverpsk
sudo wget -q -O /usr/local/sbin/xray/config.json https://raw.githubusercontent.com/kamunikan/XRAY443/main/config.json
sudo wget -q -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/kamunikan/XRAY443/main/nginx.conf
sudo wget -q -O /etc/nginx/conf.d/xray.conf https://raw.githubusercontent.com/kamunikan/XRAY443/main/xray.conf
wget -q -O /usr/local/sbin/menu "https://raw.githubusercontent.com/kamunikan/XRAY443/main/menu.sh" && chmod +x /usr/local/sbin/menu

wget -q -O /usr/local/sbin/add-vl "https://raw.githubusercontent.com/kamunikan/XRAY443/main/add-vl.sh" && chmod +x /usr/local/sbin/add-vl
wget -q -O /usr/local/sbin/add-vm "https://raw.githubusercontent.com/kamunikan/XRAY443/main/add-vm.sh" && chmod +x /usr/local/sbin/add-vm
wget -q -O /usr/local/sbin/add-tr "https://raw.githubusercontent.com/kamunikan/XRAY443/main/add-tr.sh" && chmod +x /usr/local/sbin/add-tr

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
systemctl restart nginx

systemctl daemon-reload
systemctl enable xray
systemctl start xray
systemctl enable nginx
systemctl start nginx

echo -e "${GB}[ INFO ]${NC} ${YB}Setup Done${NC}"
sleep 2
clear
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sed -i '/fs.file-max/d' /etc/sysctl.conf
sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
echo "fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "0 0 * * * root xp" >> /etc/crontab
echo "*/5 * * * * root clear-log" >> /etc/crontab
systemctl restart cron
cat > /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile
clear
rm -f install.sh
secs_to_human "$(($(date +%s) - ${start}))"
echo -e "${YB}[ WARNING ] reboot now ? (Y/N)${NC} "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
