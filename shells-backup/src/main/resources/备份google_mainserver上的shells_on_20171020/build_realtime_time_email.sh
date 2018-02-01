#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_data.log"
stat_result_file=$here"/result_stat.csv"
bad_urls_file=$here"/result_stat_bad_urls.csv"
email_content_file=$here"/email_content.txt"

if [ -f "$temp_log_data_file" ]; then
	/bin/rm $temp_log_data_file
fi

if [ -f "$stat_result_file" ]; then
	/bin/rm $stat_result_file
fi

if [ -f "$bad_urls_file" ]; then
        /bin/rm $bad_urls_file
fi

if [ -f "$email_content_file" ]; then
        /bin/rm $email_content_file
fi

touch $temp_log_data_file
touch $stat_result_file
touch $bad_urls_file
touch $email_content_file

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log $here"/temp.log" && cat $here"/"temp.log >> $temp_log_data_file

`cat $temp_log_data_file | grep "realtime_time_consuming" | grep -v "realtime_time_consuming_total" | grep -v "crawler" | grep -v "redis" | grep -v "mongo" | awk -F' INFO  |realtime_time_consuming : | from | url :' '{print $3" "$5" "$1" "$4}' | sort -n > $stat_result_file`
`cat $stat_result_file | awk '{FS=" "} {if($1 > 10) print $0}' > $bad_urls_file`

totalCount=`wc -l $stat_result_file | awk '{FS=" "} {print $1}'`

## print the result in some format by using the printf command
printf "%-20s%-20s%-20s\n" "Time-Section" "Count" "Percentage" >> $email_content_file
time_point_list="0 1 2 3 4 5 6 7 8 9"
for time_point in $time_point_list
do
        currentTimePointCount=`cat $stat_result_file | awk '{FS=" "} {if($1 == "'"$time_point"'") print $0}' | wc -l`
        currentTimePoint=$(( $time_point + 1 ))
        ratio=`awk 'BEGIN{printf "%.2f", ("'"$currentTimePointCount"'"/"'"$totalCount"'")*100}'`

	printf "%-20s%-20s%-20s\n" "within ${currentTimePoint} secs" "${currentTimePointCount}" "${ratio}%" >> $email_content_file
done
currentTimePointCount=`cat $stat_result_file | awk '{FS=" "} {if($1 > 10) print $0}' | wc -l`
ratio=`awk 'BEGIN{printf "%.2f", ("'"$currentTimePointCount"'"/"'"$totalCount"'")*100}'`
printf "%-20s%-20s%-20s\n" "without 10 secs" "${currentTimePointCount}" "${ratio}%" >> $email_content_file
printf "%-20s%-20s%-20s\n" "total" "${totalCount}" "100%" >> $email_content_file



