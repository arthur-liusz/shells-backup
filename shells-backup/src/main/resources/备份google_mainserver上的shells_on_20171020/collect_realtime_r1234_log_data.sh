#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_log_data.log"

if [ -f "$temp_log_data_file" ]; then
	/bin/rm $temp_log_data_file
fi

touch $temp_log_data_file

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file

scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
