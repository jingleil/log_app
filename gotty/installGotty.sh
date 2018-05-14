## Gotty 环境配置及安装
# installGotty.sh
GOPKG="http://172.24.7.32:8017/gotty/go1.7.3.linux-amd64.tar.gz"
GOTTYPKG="http://172.24.7.32:8017/gotty/gotty-master.zip"
INSTALLDIR="/home/supdev/.jingleil"
cmd_exist() {
	type $1 >/dev/null 2>&1 && echo 0 || echo 1
}

get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

test `cmd_exist "unzip"` -eq 0 || sudo yum install -y unzip
test `cmd_exist "tar"` -eq 0 || sudo yum install -y tar

## 创建目录、拷贝文件，安装go语言
mkdir -p $INSTALLDIR/prog
mkdir -p $INSTALLDIR/prog/go_projects/bin
mkdir -p $INSTALLDIR/prog/go_projects/src
mkdir -p $INSTALLDIR/prog/go_projects/pkg

cd $INSTALLDIR/prog

curl -o go1.7.3.linux-amd64.tar.gz $GOPKG
curl -o gotty-master.zip $GOTTYPKG

sudo tar -C /usr/local -xvzf go1.7.3.linux-amd64.tar.gz

## 配置go环境变量
BASHF=/home/supdev/.bash_profile
grep "go\/bin" $BASHF>/dev/null 2>&1 || echo "export PATH=\$PATH:/usr/local/go/bin">>$BASHF
grep "GOROOT" $BASHF>/dev/null 2>&1 || echo "export GOROOT=\"/usr/local/go\"">>$BASHF
grep "GOPATH" $BASHF>/dev/null 2>&1 || echo "export GOPATH=\"\$HOME/.jingleil/prog/go_projects\"">>$BASHF
grep "GOBIN" $BASHF>/dev/null 2>&1 || echo "export GOBIN=\"\$GOPATH/bin\"">>$BASHF

source /home/supdev/.bash_profile
rm -rf go1.7.3.linux-amd64.tar.gz

## 安装gotty
## go get github.com/yudai/gotty
mkdir -p $INSTALLDIR/prog/go_projects/src/github.com/yudai
mv gotty-master.zip $INSTALLDIR/prog/go_projects/src/github.com/yudai
cd $INSTALLDIR/prog/go_projects/src/github.com/yudai
unzip gotty-master.zip
mv gotty-master gotty
rm -rf gotty-master.zip 

go get github.com/yudai/gotty

## 安装管理脚本
RINSFL="http://172.24.7.32:8017/gotty/installGotty.sh"
RSTTFL="http://172.24.7.32:8017/gotty/startGotty.sh"
RSTPFL="http://172.24.7.32:8017/gotty/stopGotty.sh"
RUNSFL="http://172.24.7.32:8017/gotty/uninstallGotty.sh"

GTMGR="$INSTALLDIR/gotty_mgr"
GINSFL="$GTMGR/installGotty.sh"
GSTTFL="$GTMGR/startGotty.sh"
GSTPFL="$GTMGR/stopGotty.sh"
GUNSFL="$GTMGR/uninstallGotty.sh"

mkdir -p $GTMGR
curl -o $GINSFL $RINSFL
curl -o $GSTTFL $RSTTFL
curl -o $GSTPFL $RSTPFL
curl -o $GUNSFL $RUNSFL
chmod +x $GINSFL $GSTTFL $GSTPFL $GUNSFL

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
