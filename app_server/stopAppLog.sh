BASHF=/home/supdev/.bash_profile
source $BASHF

PSLIST=`ps -ef| grep -i ".*gotty.*tail" | grep -v grep| awk '{ print $2 }'`
echo -e "\033[34m[INFO]: Application log process list: $PSLIST\033[0m"
for proc in ${PSLIST[*]};do
	echo $proc;
	sudo pstree $proc -p|awk -F"[()]" '{print $2}'| xargs kill -9 2>/dev/null
done
for tproc in `ps -ef| grep 'tail -200f '| grep -v grep | awk '{print $2}'`; do
	sudo kill -9 $tproc 2>/dev/null
done
echo -e "\033[34m[INFO]: Application log process has been stopt.\033[0m"
