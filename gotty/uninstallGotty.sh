## 卸载gotty
BASHF=/home/supdev/.bash_profile
INSTALLDIR=/home/supdev/.jingleil
GTMGR="$INSTALLDIR/gotty_mgr"
GTPROG="$INSTALLDIR/prog/go_projects"


PROC=`ps -ef| grep -i gotty| grep -v grep| awk '{print $2}'`
kill -9 $PROC >/dev/null 2>&1
echo -e "\033[34m[INFO]: Gotty service has been stopt.\033[0m"

sed -i -e '/GOROOT/d' -e '/GOPATH/d' -e '/GOBIN/d' $BASHF
sudo rm -rf $GTPROG $GTMGR
echo -e "\033[34m[INFO]: Gotty application has been un-installed.\033[0m"
