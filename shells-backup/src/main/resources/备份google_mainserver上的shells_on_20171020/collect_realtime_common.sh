#!/bin/sh

here=`pwd`

if [ $# -ne 1 ]; then
        echo "there should be one parameter!"
	exit
fi

targetFileName=$1
targetFile=$here"/$targetFileName"

if [ -f "$targetFile" ]; then
	/bin/rm $targetFile
fi

touch $targetFile

cat /data/tomcat9/realtime/r1/apache-tomcat-9.0.0.M6/logs/$targetFileName >> $targetFile
cat /data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/$targetFileName >> $targetFile
cat /data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/$targetFileName >> $targetFile
cat /data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/$targetFileName >> $targetFile

scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r/apache-tomcat-9.0.0.M6/logs/$targetFileName $here"/temp.log" && cat $here"/"temp.log >> $targetFile
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r2/apache-tomcat-9.0.0.M6/logs/$targetFileName $here"/temp.log" && cat $here"/"temp.log >> $targetFile
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r3/apache-tomcat-9.0.0.M6/logs/$targetFileName $here"/temp.log" && cat $here"/"temp.log >> $targetFile
scp -q gphonebbs@10.142.0.5:/data/tomcat9/realtime/r4/apache-tomcat-9.0.0.M6/logs/$targetFileName $here"/temp.log" && cat $here"/"temp.log >> $targetFile

/bin/rm $here"/temp.log"
