usage() {
	echo "[INFO]: Usage: `basename $0` + start|stop|restart"
}

[ $# -lt 2 ] && usage && exit -1

APPNAME=$1
APPCMD=$2
WYAPPDIR="/home/wy/www/$APPNAME"
JRAPPDIR="/export/Domains/$APPNAME"

## 启动、停止或重启网银应用
# $1: 应用名称
# $2: 操作类型
wyadmin() {
	cmddir="/home/wy/tools/bin"
	case $2 in
		start)
			sudo $cmddir/start_tomcat.sh $1
			;;
		stop)
			sudo $cmddir/stop_tomcat.sh $1
			;;
		restart)
			sudo $cmddir/restart_tomcat.sh $1
			;;
	esac
}

## 启动、停止或重启金融应用
# $1: 应用名称
# $2: 操作类型
jradmin() {
	set -x
	cmddir="/export/Domains/$1/server1/bin"
	case $2 in
		start)
			sudo $cmddir/start.sh $1
			echo "starting $1"
			;;
		stop)
			sudo $cmddir/stop.sh $1
			echo "stoping $1"

			;;
		restart)
			sudo $cmddir/stop.sh $1
			echo "stoping $1"
			sudo $cmddir/start.sh $1
			echo "starting $1"
			;;
	esac
}


if test -e $WYAPPDIR;then
	wyadmin "$APPNAME/" $APPCMD
elif test -e $JRAPPDIR;then
	jradmin "$APPNAME" $APPCMD
else
	echo "$APPNAME is neither WangYIN or JinRong applicaiton, operation not supported."
fi
