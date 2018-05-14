## 停止LoggerApp应用
# stopLoggerApp.sh
PROC=`ps -ef| grep -i "logger_app/run.py" | grep -v grep| awk '{print $2}'`;
sudo kill -9 $PROC >/dev/null 2>&1
echo -e "\033[34m[INFO]: LoggerApp server has been stopt.\033[0m"
