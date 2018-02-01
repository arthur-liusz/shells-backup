#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_data_last_minute_error_count.log"
temp_result_file=$here"/temp_result_last_minute_error_count.log"
timeout_threshold=29

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

currentMinute=`date -d "now -1 minute" +"%Y-%m-%d %H:%M"`
currentMinuteCount=`cat $temp_result_file | grep "$currentMinute" | wc -l`
currentMinuteErrorCount=`cat $temp_result_file | grep "$currentMinute" | awk '{FS=" "} {if($1 > '"$timeout_threshold"') print $0}' | wc -l`
currentMinuteErrorRatio=`echo "scale=4; ($currentMinuteErrorCount / $currentMinuteCount) * 100" | bc | awk '{printf "%.2f%", $0}'`

result_json_content="{\"currentMinute\":\"$currentMinute\", \"currentMinuteCount\":\"$currentMinuteCount\", \"currentMinuteErrorCount\":\"$currentMinuteErrorCount\", \"currentMinuteErrorRatio\":\"$currentMinuteErrorRatio\"}"
echo $result_json_content  ## return content
