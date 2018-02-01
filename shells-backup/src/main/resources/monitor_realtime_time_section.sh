#!/bin/sh

here=`pwd`
temp_log_data_file=$here"/temp_data_time_section.log"
temp_result_file=$here"/temp_result_time_section.csv"
return_content_file=$here"/return_content_time_section.csv"

if [ -f "$temp_log_data_file" ]; then
	/bin/rm $temp_log_data_file
fi

if [ -f "$temp_result_file" ]; then
	/bin/rm $temp_result_file
fi

if [ -f "$return_content_file" ]; then
        /bin/rm $return_content_file
fi

touch $temp_log_data_file
touch $temp_result_file
touch $return_content_file

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/realtime_time_consuming.log >> $temp_log_data_file

`cat $temp_log_data_file | grep "realtime_time_consuming" | grep -v "realtime_time_consuming_total" | grep -v "crawler" | grep -v "redis" | awk -F' INFO  |realtime_time_consuming : | from | url :' '{print $3" "$5" "$1" "$4}' | sort -n > $temp_result_file`

time_point_list="0 1 2 3 4 5 6 7 8 9"
for time_point in $time_point_list
do
	currentTimePoint=$(( $time_point + 1 ))
	currentTimePointCount=`cat $temp_result_file | awk '{FS=" "} {if($1 == "'"$time_point"'") print $0}' | wc -l`

	echo "${currentTimePoint} ${currentTimePointCount}" >> $return_content_file
done

currentTimePoint=999
currentTimePointCount=`cat $temp_result_file | awk '{FS=" "} {if($1 > 10) print $0}' | wc -l`
echo "${currentTimePoint} ${currentTimePointCount}" >> $return_content_file

##  return_content=`cat $return_content_file`

return_content=""
while read line
do
	return_content=${return_content}"\n"$line
done < $return_content_file

echo $return_content  ## Return value of this shell script file
