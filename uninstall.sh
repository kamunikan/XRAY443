#!/bin/bash

# Stop Xray and Nginx
systemctl stop xray
systemctl stop nginx

# Remove Xray and Nginx configuration files
rm -f /etc/systemd/system/xray.service
rm -f /usr/local/sbin/xray/config.json
rm -f /usr/local/sbin/xray/serverpsk
rm -f /usr/local/sbin/xray/fullchain.crt
rm -f /usr/local/sbin/xray/private.key
rm -f /etc/nginx/nginx.conf
rm -f /etc/nginx/conf.d/xray.conf

# Remove Xray and Nginx binaries
rm -rf /usr/local/sbin/xray
apt-get remove nginx -y

# Remove packages installed by the script
apt-get remove build-essential gcc make libsqlite3-dev socat curl screen cron screenfetch netfilter-persistent vnstat lsof fail2ban lolcat speedtest -y

# Remove firewall rules
iptables -D FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -D FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -D FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -D FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -D FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -D FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -D FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -D FORWARD -m string --algo bm --string "announce" -j DROP
iptables -D FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Remove added system configuration settings
sed -i '/net.core.default_qdisc=fq/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control=bbr/d' /etc/sysctl.conf

# Restart networking
systemctl restart networking

# Print completion message
echo "Uninstallation complete"
