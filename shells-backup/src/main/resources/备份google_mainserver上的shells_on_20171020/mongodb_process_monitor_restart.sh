#!/bin/sh

## monitor the mongodb process and, restart it if the process is dead
## add by arthur.liu on 2017-09-06

here="/data/shell_tasks/mongodb_process_monitor_restart"
cd $here

runLogFile=$here"/run.log"
echo "" >> $runLogFile
echo "" >> $runLogFile

nowStartTime=`date "+%Y-%m-%d %H:%M:%S"`
echo "execute start time: $nowStartTime" >> $runLogFile

mongodbPath="/home/gphonebbs/soft/mongodb-linux-x86_64-ubuntu1604-3.2.10"
mongodbProcessCount=`ps aux | grep "$mongodbPath" | grep -v "grep" | wc -l`
echo "mongodbProcessCount: $mongodbProcessCount" >> $runLogFile

if [ $mongodbProcessCount -ne 0 ]
then
	echo "mongodb process is alive:)" >> $runLogFile
else
	echo "mongodb process is dead, I will restart it!:" >> $runLogFile

	## start mongodb process
	nohup /home/gphonebbs/soft/mongodb-linux-x86_64-ubuntu1604-3.2.10/bin/mongod --dbpath /home/gphonebbs/soft/mongodb-linux-x86_64-ubuntu1604-3.2.10/data --logpath /home/gphonebbs/soft/mongodb-linux-x86_64-ubuntu1604-3.2.10/logs/mongo.log --fork &

        echo "restart successfully!" >> $runLogFile
fi

nowEndTime=`date "+%Y-%m-%d %H:%M:%S"`
echo "execute end time: $nowEndTime" >> $runLogFile
