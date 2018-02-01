#!/bin/sh

. /etc/profile

here=`pwd`
cd $here

log_file="/data/apps/spider-55haitao-crawler/logs/monitor.log"
server_addr=http://118.178.57.197:8080/spider-55haitao-ui/monitor-collector/collect-monitor.action

ip=`/sbin/ifconfig | grep -A 1 "ens4" | grep "inet addr" | awk -F' ' '{print $2}' | awk -F':' '{print $2}'`
module="crawler"
content=`tail -1 $log_file`
comefrom="google"

/usr/bin/curl -X POST --connect-timeout 20 -m 20 -s --data "ip=$ip&module=$module&content=$content&comefrom=$comefrom" "$server_addr"

today=`date "+%Y-%m-%d"`
execute_time=`date "+%Y-%m-%d %H:%M:%S"`
echo "Execute successfully at:$execute_time" >> $here"/crawler_task_monitor_collector_${today}.log"
