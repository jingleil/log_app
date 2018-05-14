usage() {
	echo "[INFO]: Usage: `basename $0` + APP_NAME"
}

get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

[ $# -lt 1 ] && usage && exit -1

APPNAME=$1
LOGPORT=`ps -ef| grep -i ".*gotty.*tail.*${APPNAME}.*" | grep -v grep| awk -F'-p' '{ print $2 }' | awk '{print $1}'`
if [ "X${LOGPORT}" != "X" ];then
	LOGURL="http://$(get_ip):$LOGPORT"
	echo $LOGURL
fi
