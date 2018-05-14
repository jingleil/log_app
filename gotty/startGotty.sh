## 启动gotty
# startGotty.sh
BASHF=/home/supdev/.bash_profile
source $BASHF
cd /home/supdev/
nohup $GOPATH/bin/gotty -p "8018" -w bash &
echo "[INFO]: Gotty service has been started."

get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

URL="http://$(get_ip):8018"
echo -e "\033[34m[INFO]: Gotty access URL: $URL\033[0m"
