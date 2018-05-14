BASHF=/home/supdev/.bash_profile
source $BASHF

removeDup()
{
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

BSPORT=8030

applist=`echo -e "$(ls /home/wy/www;ls /export/Domains/)" | grep -vE 'zip|tar|grep'`
for app in `removeDup "$applist"`;do
        if [[ $app != "default.wangyin.com" && $app != "tmh.jd.com" ]];then
				if [ -f /export/log/$app/${app}_detail.log ];then
					BSLOG="/export/log/$app/${app}_detail.log"
				elif [ -f /home/wy/www/$app/logs/catalina.out ];then
					BSLOG="/home/wy/www/$app/logs/catalina.out"
				elif [ -f /export/Domains/$app/server1/logs/catalina.out ];then
					BSLOG="/export/Domains/$app/server1/logs/catalina.out"
				else
					BSLOG=""
				fi
				
				if [ x"$BSLOG" != x ];then
					nohup $GOPATH/bin/gotty -p $BSPORT tail -200f $BSLOG &
					BSPORT=$((BSPORT+1))
				fi
        fi
done

echo -e "\033[34m[INFO]: Application process have started.\033[0m"
