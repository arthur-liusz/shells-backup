#!/bin/sh

here=`pwd`
output=$here"/realtime_output.txt"

inputDir=$1
if [ -z "$inputDir" ]
then
	echo "input dir is required!!!"
	exit
fi

printf "%-10s\n" "" >> $output
printf "%-100s\n" "$inputDir" >> $output
printf "%-46s%-20s%-20s%-20s%-20s\n" "LogFile" "SuccessCount" "FailureCount" "Totalcount" "SuccessRation" >> $output
inputFiles=`ls -t $inputDir| grep  "realtime_time_consuming" | head -10`
for inputFile in $inputFiles
do
	successCount=`cat $inputDir"/"$inputFile | grep "realtime_time_consuming : " | awk '{FS="realtime_time_consuming : | from | url :"} { if($2 <= 7) print $2}' | wc -l`
	failureCount=`cat $inputDir"/"$inputFile | grep "realtime_time_consuming : " | awk '{FS="realtime_time_consuming : | from | url :"} { if($2 > 7) print $2}' | wc -l`
	totalCount=`expr $successCount + $failureCount`
	successRatio=`echo "scale=2;$successCount * 100 / $totalCount" | bc`

	printf "%-46s%-20s%-20s%-20s%-20s\n" "$inputFile" "$successCount" "$failureCount" "$totalCount" "$successRatio" >> $output
done

