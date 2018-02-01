#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_data_time_section.log"
temp_result_file=$here"/temp_result_time_section.csv"
realtime_monitor_time_section_server="http://172.16.7.206:8888/spider-55haitao-monitt/realtimeTimesPerMinites.action"

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

`cat $temp_log_data_file | grep "realtime_time_consuming" | grep -v "realtime_time_consuming_total" | grep -v "crawler" | grep -v "redis" | awk -F' INFO  |realtime_time_consuming : | from | url :' '{print $3" "$5" "$1" "$4}' | sort -n > $temp_result_file`

result_json_content="{"

time_point_list="0 1 2 3 4 5 6 7 8 9"
for time_point in $time_point_list
do
	currentTimePoint=$(( $time_point + 1 ))
	currentTimePointCount=`cat $temp_result_file | awk '{FS=" "} {if($1 == "'"$time_point"'") print $0}' | wc -l`
	if [ "$result_json_content" = "{" ]; then
		result_json_content=$result_json_content"\"${currentTimePoint}\":${currentTimePointCount}"
	else
		result_json_content=$result_json_content", \"${currentTimePoint}\":${currentTimePointCount}"
	fi
done

badTimePointCount=`cat $temp_result_file | awk '{FS=" "} {if($1 > 10) print $0}' | wc -l`
result_json_content=$result_json_content", \"999\":${badTimePointCount}}"

echo $result_json_content
curl -X POST --connect-timeout 10 -m 20 --data "content=$result_json_content" "$realtime_monitor_time_section_server"
