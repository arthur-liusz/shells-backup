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

`cat $temp_log_data_file | grep "realtime_time_consuming" | grep -v "crawler" | grep -v "redis" | awk -F' INFO  |realtime_time_consuming : | from | url :' '{print $3" "$5" "$1" "$4}' | sort -n > $stat_result_file`
`cat $stat_result_file | awk '{FS=" "} {if($1 > 10) print $0}' > $bad_urls_file`

totalCount=`wc -l $stat_result_file | awk '{FS=" "} {print $1}'`

echo "时段	次数	占比" >> $email_content_file
time_point_list="0 1 2 3 4 5 6 7 8 9"
for time_point in $time_point_list
do
	currentTimePointCount=`cat $stat_result_file | awk '{FS=" "} {if($1 == "'"$time_point"'") print $0}' | wc -l`
	currentTimePoint=$(( $time_point + 1 ))
	ratio=`awk 'BEGIN{printf "%.2f%", ("'"$currentTimePointCount"'"/"'"$totalCount"'")*100}'`
	echo "${currentTimePoint}秒内	${currentTimePointCount}次	${ratio}" >> $email_content_file
done
currentTimePointCount=`cat $stat_result_file | awk '{FS=" "} {if($1 > 10) print $0}' | wc -l`
ratio=`awk 'BEGIN{printf "%.2f%", ("'"$currentTimePointCount"'"/"'"$totalCount"'")*100}'`
echo "10秒外	${currentTimePointCount}次	${ratio}" >> $email_content_file
echo "总计	${totalCount}次	100%" >> $email_content_file





