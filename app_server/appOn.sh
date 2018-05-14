## 操作脚本
# appOn.sh
##
usage() {
	echo "[INFO]: Usage: `basename $0` install|stop|start|restart|uninstall"
        echo "        please execute under [/home/supdev] with [supdev] user."
}

[ $# -lt 1 ] || [ `whoami` != "supdev" ] || [ `pwd` != '/home/supdev' ] && usage && exit -1


RGOONFL="http://172.24.7.32:8017/gotty/goOn.sh"
RLOGGERONFL="http://172.24.7.32:8017/logger_app/loggerOn.sh"
RSTTLOGFL="http://172.24.7.32:8017/app_server/startAppLog.sh"
RSTPLOGFL="http://172.24.7.32:8017/app_server/stopAppLog.sh"

HOMEDIR="/home/supdev"
INSTALLDIR="/home/supdev/.jingleil"
APPMGR="$INSTALLDIR/app_server_mgr"

GOONFL="$HOMEDIR/goOn.sh"
LOGGERONFL="$HOMEDIR/loggerOn.sh"
STTLOGFL="$APPMGR/startAppLog.sh"
STPLOGFL="$APPMGR/stopAppLog.sh"

do_install() {
	#ps -ef | grep -i "logger_app" >/dev/null 2>&1 && echo "[ERROR] LoggerApp already installed." && exit -1
	#test -e $LOGGERAPP && echo "[ERROR] LoggerApp already installed." && exit -1
	echo -e "\033[34m[INFO]: Start to install log_app application\033[0m"
	test -f $GOONFL || curl -o $GOONFL $RGOONFL
	test -f $LOGGERONFL || curl -o $LOGGERONFL $RLOGGERONFL 
	sh $GOONFL install
	mkdir -p $APPMGR
	curl -o $STTLOGFL $RSTTLOGFL && chmod +x $STTLOGFL
	curl -o $STPLOGFL $RSTPLOGFL && chmod +x $STPLOGFL
	$STTLOGFL 
	sh $LOGGERONFL install
}

do_start() {
	test -f $GOONFL || curl -o $GOONFL $RGOONFL
	test -f $LOGGERONFL || curl -o $LOGGERONFL $RLOGGERONFL
	test -f $STTLOGFL || curl -o $STTLOGFL $RSTTLOGFL && chmod +x $STTLOGFL
	sh $GOONFL start
	$STTLOGFL
	sh $LOGGERONFL start
}

do_stop() {
	test -f $GOONFL || curl -o $GOONFL $RGOONFL
	test -f $LOGGERONFL || curl -o $LOGGERONFL $RLOGGERONFL
	test -f $STPLOGFL || curl -o $STPLOGFL $RSTPLOGFL && chmod +x $STPLOGFL
	sh $GOONFL stop
	$STPLOGFL
	sh $LOGGERONFL stop
}

do_uninstall() {
	test -f $GOONFL || curl -o $GOONFL $RGOONFL
	test -f $LOGGERONFL || curl -o $LOGGERONFL $RLOGGERONFL
	test -f $STPLOGFL || curl -o $STPLOGFL $RSTPLOGFL && chmod +x $STPLOGFL
	sh $LOGGERONFL uninstall
	$STPLOGFL
	sh $GOONFL uninstall
	rm -rf $APPMGR
	rm -rf $LOGGERONFL $GOONFL $0
}

## 优化预留
do_action() {
	test -f $1 || curl -o $1 $2 && chmod +x $1
	$1
}

##########
# main
##########
ARG=$1
case $ARG in
	install)
			do_install
			;;
	stop)
			do_stop
			;;
	start)
			do_start
			;;
	restart)
			do_stop
			do_start
			;;
	uninstall)
			#do_stop
			do_uninstall
			;;
	*)
			usage
			exit -1
			;;
esac

