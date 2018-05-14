## 启动logger_app应用
LOGGERAPP="/export/App/logger_app"
PYTHNBIN="/export/python27/bin"

get_ip() {
	ifconfig -a| awk -F':' '{ if(NR==2){ print $2 } }'| cut -d' ' -f1
}

cd $LOGGERAPP
sudo nohup $PYTHNBIN/python $LOGGERAPP/run.py &
cd ~

URL="http://$(get_ip):8028"
echo -e "\033[34m[INFO]: LoggerApp has been started.\033[0m"
echo -e "\033[34m[INFO]: LoggerApp access URL: \033[4m$URL\033[0m\033[0m"
