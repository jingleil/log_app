## 操作脚本
# goOn.sh
##
usage() {
	echo "[INFO]: Usage: `basename $0` install|stop|start|restart|uninstall"
        echo "        Command should be executed with [supdev] user."
}

[ $# -lt 1 ] || [ `whoami` != "supdev" ] && usage && exit -1


RINSFL="http://172.24.7.32:8017/gotty/installGotty.sh"
RSTTFL="http://172.24.7.32:8017/gotty/startGotty.sh"
RSTPFL="http://172.24.7.32:8017/gotty/stopGotty.sh"
RUNSFL="http://172.24.7.32:8017/gotty/uninstallGotty.sh"

INSTALLDIR="/home/supdev/.jingleil"
GTMGR="$INSTALLDIR/gotty_mgr"

GINSFL="$GTMGR/installGotty.sh"
GSTTFL="$GTMGR/startGotty.sh"
GSTPFL="$GTMGR/stopGotty.sh"
GUNSFL="$GTMGR/uninstallGotty.sh"


do_install() {
	#ps -ef | grep -i "gotty" >/dev/null 2>&1 && echo "[ERROR] Gotty already installed." && exit -1
	test -f "$INSTALLDIR/prog/go_projects/bin/gotty" && echo "[ERROR] Gotty already installed." && exit -1
	mkdir -p $GTMGR
	curl -o $GINSFL $RINSFL
	sh $GINSFL
}

do_start() {
	test -f $GSTTFL || curl -o $GSTTFL $RSTTFL && chmod +x $GSTTFL
	$GSTTFL
}

do_stop() {
	test -f $GSTPFL || curl -o $GSTPFL $RSTPFL && chmod +x $GSTPFL
	$GSTPFL
}

do_uninstall() {
	test -f $GUNSFL || curl -o $GUNSFL $RUNSFL && chmod +x $GUNSFL 
	$GUNSFL
	rm -rf $0
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


