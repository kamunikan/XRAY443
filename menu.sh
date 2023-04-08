#!/bin/bash
clear

### - start export >----------------->>
## ----------------->> Bash Script By Hatunnel
## ----------------->> Moded & fixed Script By Dotycat
## ----------------->> Visit our website wwww.dotycat.com

export RED='\033[0;31m'
export GRAY="\e[1;30m"
export BLUE="\033[36m"
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BG='\033[44m'
export NC='\033[0m'

export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";


if pgrep nginx >/dev/null 2>&1; then
    nginx="${GREEN}STATUS RUNNING${NC}"
else 
    nginx="${RED}STATUS OFFLINE${NC}"
fi

if pgrep xray >/dev/null 2>&1; then
    xray="${GREEN}STATUS RUNNING${NC}"
else
    xray="${RED}STATUS OFFLINE${NC}"
fi
IPVPS=$(curl -sS ifconfig.me)
domain=$(cat /usr/local/sbin/xray/domain)

function restart(){
clear
echo -e "$BLUE┌──────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG               • MAIN MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└──────────────────────────────────────────┘$NC"
echo -e "$BLUE┌──────────────────────────────────────────┐$NC"
sudo systemctl daemon-reload
echo -e "$BLUE│$NC $INFO Stating";
sleep 2
sudo systemctl restart xray
echo -e "$BLUE│$NC $INFO Restating Xray XTLS";
sleep 2
sudo systemctl restart nginx
echo -e "$BLUE│$NC $INFO Restating Nginx";
sleep 2
sudo systemctl restart vnstat
echo -e "$BLUE│$NC $INFO Restating Vnstat";
sleep 2
echo -e "$BLUE│$NC $INFO Restating Successfully";
echo -e "$BLUE└──────────────────────────────────────────┘$NC"
echo -e "$BLUE•──────────────────────────────────────────•$NC"
echo -e "" 
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}

function rebootvps(){
    clear
    reboot
}

echo -e "$BLUE┌──────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG               • MAIN MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└──────────────────────────────────────────┘$NC"
echo -e "$BLUE┌──────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC • DOMAIN : $domain";
echo -e "$BLUE│$NC • IPVPS  : $IPVPS"
echo -e "$BLUE│$NC • NGINX  : $nginx";
echo -e "$BLUE│$NC • XRAY   : $xray";
echo -e "$BLUE└──────────────────────────────────────────┘$NC"
echo -e "$BLUE┌──────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC • [01] Restart Server";
echo -e "$BLUE│$NC • [02] Reboot Server"; 
echo -e "$BLUE└──────────────────────────────────────────┘$NC"
echo -e "$BLUE•──────────────────────────────────────────•$NC"
echo -e "" 
read -p "  Select Menu : " menu
case $menu in
1 | 01) clear ; restart ;;
2 | 02) clear ; rebootvps ;;
*) clear ; menu ;;
esac

