#!/bin/sh

here=`pwd`
data_log=$here"/realtime_time_temp_data.log"
stat_result_file=$here"/realtime_time_stat_result.csv"

echo $here
echo $data_log
echo $stat_result_file

if [ -f "$data_log" ]; then
	/bin/rm $data_log
fi

if [ -f "$stat_result_file" ]; then
	/bin/rm $stat_result_file
fi

touch $data_log
cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $data_log
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $data_log
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $data_log
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $data_log

`cat $data_log | grep "realtime_time_consuming" | awk -F' INFO  |realtime_time_consuming : | from | url :' '{print $3" "$5" "$1" "$4}' | sort -n > $stat_result_file`



