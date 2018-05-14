usage() {
	echo "[INFO]: Usage: `basename $0`"
}

get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

LOGPORT=`ps -ef| grep -i ".*gotty.*-p.*bash" | grep -v grep| awk -F'-p' '{ print $2 }' | awk '{print $1}'`
if [ "X${LOGPORT}" != "X" ];then
	LOGURL="http://$(get_ip):$LOGPORT"
	echo $LOGURL
fi
