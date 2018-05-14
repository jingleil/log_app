## 卸载
PROC=`ps -ef| grep -i "logger_app/run.py" | grep -v grep| awk '{print $2}'`
sudo kill -9 $PROC >/dev/null 2>&1

APPDIR="/export/App"
LOGGERAPP="$APPDIR/logger_app"
PYTHNDIR="/export/python27"
DOWNLOADS="/home/supdev/.jingleil/downloads/*"
GTMGR="/home/supdev/.jingleil/logger_mgr"

sudo rm -rf $LOGGERAPP $PYTHNDIR $DOWNLOADS $GTMGR 

echo -e "\033[34m[INFO]: LoggerApp has been uninstalled.\033[0m"
