## 关闭gotty
# stopGotty.sh
PROC=`ps -ef| grep -i "gotty" | grep -v grep| awk '{print $2}'`
kill -9 $PROC >/dev/null 2>&1
echo -e "\033[34m[INFO]: Gotty service has been stopt.\033[0m"
