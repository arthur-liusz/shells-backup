#!/bin/sh

here=`pwd`
temp_result_data_file=$here"/temp_result_data_file.txt"
email_result_file=$here"/email_result.txt"

if [ -f "$temp_result_data_file" ]; then
        /bin/rm $temp_result_data_file
fi

if [ -f "$email_result_file" ]; then
        /bin/rm $email_result_file
fi

touch $temp_result_data_file
touch $email_result_file

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/result_data_logger.log >> $temp_result_data_file
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/result_data_logger.log >> $temp_result_data_file
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/result_data_logger.log >> $temp_result_data_file
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/result_data_logger.log >> $temp_result_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r/apache-tomcat-9.0.0.M6/logs/result_data_logger.log $here"/temp.log" && cat $here"/"temp.log >> $temp_result_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/result_data_logger.log $here"/temp.log" && cat $here"/"temp.log >> $temp_result_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/result_data_logger.log $here"/temp.log" && cat $here"/"temp.log >> $temp_result_data_file
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/result_data_logger.log $here"/temp.log" && cat $here"/"temp.log >> $temp_result_data_file


echo "Realtime RTReturnCode Statistics:" >> $email_result_file
echo " " >> $email_result_file

echo "code  count" >> $email_result_file
`cat $temp_result_data_file | grep "output result data in writeResponse method" | awk '{FS="tReturnCode\":"} {print $2}' | awk '{FS="}"} {print $1}' | grep -v ":" | sort | uniq -c | awk '{FS=" "} {print "   "$2"  "$1}' >> $email_result_file`

echo "" >> $email_result_file
echo "annotations:" >> $email_result_file
echo "0 : RT_SUCCESS" >> $email_result_file
echo "1 : RT_STOCK_NONE" >> $email_result_file
echo "2 : RT_ITEM_OFFLINE" >> $email_result_file
echo "3 : RT_CRAWLING_TIMEOUT" >> $email_result_file
echo "4 : RT_URL_NONE" >> $email_result_file
echo "5 : RT_URL_ILLEGAL" >> $email_result_file
echo "6 : RT_WEBSITE_NOT_SUPPORT" >> $email_result_file
echo "7 : RT_INNER_ERROR" >> $email_result_file
echo " " >> $email_result_file
