
RPYTHNPKG="http://172.24.7.32:8017/logger_app/python27.zip"
RLOGERPKG="http://172.24.7.32:8017/logger_app/logger_app.zip"

PYTHNPKG="python27.zip"
LOGERPKG="logger_app.zip"

BASEDIR="/home/supdev/.jingleil"
DOWNLOADDIR="$BASEDIR/downloads"
BASHFL="/home/supdev/.bash_profile"

PYTHNDIR="/export/python27"
PYTHNBIN="$PYTHNDIR/bin"

APPDIR="/export/App" 
LOGGERAPP="$APPDIR/logger_app"

mkdir -p $DOWNLOADDIR
cd $DOWNLOADDIR

curl -o $PYTHNPKG $RPYTHNPKG
curl -o $LOGERPKG $RLOGERPKG

cmd_exist() {
	type $1 >/dev/null 2>&1 && echo 0 || echo 1 
}
get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

removeDup() {
    local ustr=""
    local orgstr=$1
    local tmpstr=$1
    for str in $orgstr; do
        tmpstr=${tmpstr#*$str}
        isuniq=yes
        for lstr in $tmpstr; do
            if [ "$lstr" = "$str" ]; then
                isuniq=no
                break
            fi
        done
        if [ "$isuniq" = "yes" ]; then
            if [ -z "$ustr" ]; then
                ustr=$str
            else
                ustr="$ustr $str"
            fi
        fi
    done
    echo $ustr
}

cmd_exist "unzip" || sudo yum install -y unzip

## 安装python
sudo unzip -d /export $PYTHNPKG
sudo chmod -R a+x $PYTHNBIN/*

#grep "python27" $BASHFL >/dev/null 2>&1 || echo "export PATH=\$PATH:/export/python27/bin">>$BASHFL && echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/export/python27/lib">>$BASHFL
#source $BASHFL

## 安装logger_app
sudo unzip -d $APPDIR $LOGERPKG


## 修改显示文件
# --添加select option
# --修改 <title>质量管理部</title> <h1 id="head">台账日志</h1>

TMPTFL="$LOGGERAPP/templates/index.html"
TMPTFL1="$LOGGERAPP/templates/appIndex.html"
TITLESTR="质量管理部：`get_ip`"
HEADSTR="应用日志: `get_ip`"

sudo sed -i "/<option.*<\/option>/d" $TMPTFL
sudo sed -i "s#<title>.*</title>#<title>${TITLESTR}</title>#" $TMPTFL
sudo sed -i "s#<h1 id=\"head\">.*</h1>#<h1 id=\"head\">${HEADSTR}</h1>#" $TMPTFL

# 过滤掉：tmh.jd.com, default.wangyin.com, *.zip, *.tar
applist=`echo -e "$(ls /home/wy/www;ls /export/Domains/)" | grep -vE 'zip|tar|grep'`
for app in `removeDup "$applist"`;do
        if [[ $app != "default.wangyin.com" && $app != "tmh.jd.com" ]];then
                #sudo sed -i "/<\/select>/i<option value=\"$app\">$app<\/option>" $TMPTFL
		sudo sed -i "/<\/select>/i<option value=\"$app\" {% if appName==\"$app\" %} selected {% endif %}>$app<\/option>" $TMPTFL
        fi
done

sudo sed -i "/<option.*<\/option>/d" $TMPTFL1
sudo sed -i "s#<title>.*</title>#<title>${TITLESTR}</title>#" $TMPTFL1
sudo sed -i "s#<h1 id=\"head\">.*</h1>#<h1 id=\"head\">${HEADSTR}</h1>#" $TMPTFL1

# 修改accesstty URL
# -onclick="accesstty('http://172.24.7.32:8018')"/>
TTYURL="http://`get_ip`:8018"
sudo sed -i "s#onclick=\"accesstty\(.*\)\"/>#onclick=\"accesstty\('${TTYURL}'\)\"/>#" $TMPTFL
sudo sed -i "s#onclick=\"accesstty\(.*\)\"/>#onclick=\"accesstty\('${TTYURL}'\)\"/>#" $TMPTFL1

## 删除安装包 
rm -rf $DOWNLOADDIR/*

## 安装管理脚本
RINSFL="http://172.24.7.32:8017/logger_app/installLoggerApp.sh"
RSTTFL="http://172.24.7.32:8017/logger_app/startLoggerApp.sh"
RSTPFL="http://172.24.7.32:8017/logger_app/stopLoggerApp.sh"
RUNSFL="http://172.24.7.32:8017/logger_app/uninstallLoggerApp.sh"

GTMGR="$BASEDIR/logger_mgr"
GINSFL="$GTMGR/installLoggerApp.sh"
GSTTFL="$GTMGR/startLoggerApp.sh"
GSTPFL="$GTMGR/stopLoggerApp.sh"
GUNSFL="$GTMGR/uninstallLoggerApp.sh"

mkdir -p $GTMGR
curl -o $GINSFL $RINSFL
curl -o $GSTTFL $RSTTFL
curl -o $GSTPFL $RSTPFL
curl -o $GUNSFL $RUNSFL
chmod +x $GINSFL $GSTTFL $GSTPFL $GUNSFL

## 启动logger_app应用
cd $LOGGERAPP
sudo nohup $PYTHNBIN/python $LOGGERAPP/run.py &
cd ~
URL="http://$(get_ip):8028"
echo -e "\033[34m[INFO]: LoggerApp access URL: \033[4m$URL\033[0m\033[0m"

