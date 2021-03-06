#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_data_last_minute_count.log"
temp_result_file=$here"/temp_result_last_minute_count.csv"
realtime_monitor_last_minute_server="http://118.178.57.197:8080/spider-55haitao-monitor-chart/realtimeTotalPerMinites.action"

if [ -f "$temp_log_data_file" ]; then
	/bin/rm $temp_log_data_file
fi

if [ -f "$temp_result_file" ]; then
	/bin/rm $temp_result_file
fi

touch $temp_log_data_file
touch $temp_result_file

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file

`cat $temp_log_data_file | grep "realtime_time_consuming" | grep -v "crawler" | grep -v "redis" | grep -v "mongo" | grep " from se url" > $temp_result_file`

currentMinute=`date -d "now -1 minute" +"%Y-%m-%d %H:%M"`
currentMinuteCount=`cat $temp_result_file | grep "$currentMinute" | wc -l`

result_json_content="{\"currentMinute\":\"${currentMinute}\", \"currentMinuteCount\":\"${currentMinuteCount}\"}"
curl -X POST --connect-timeout 10 -m 20 --data "content=$result_json_content" "$realtime_monitor_last_minute_server"
