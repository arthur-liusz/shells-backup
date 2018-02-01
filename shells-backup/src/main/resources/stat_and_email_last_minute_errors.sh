#!/bin/sh

here="/data/shell_tasks/realtime_statistics_last_minute_error_count"
remoteHere="/data/shell_tasks/realtime_statistics_last_minute_error_count"
threshold="\"5.00%\""

emailTitle="Realtime timeout ratio too high Warning!!!"
emailRecipients="liushizhen@55haitao.com,zhoushuo@55haitao.com,denghuan@55haitao.com,xusongsong@55haitao.com,zhaoxinluo@55haitao.com,zhangyouping@55haitao.com,jingpeng@55haitao.com,zhaohongliang@55haitao.com,gechongyu@55haitao.com"

return_content=`ssh -t -p 22 -q gphonebbs@ms "cd $remoteHere; $remoteHere/realtime_statistics_last_minute_error_count.sh"`
errorRatio=`echo $return_content | jq .currentMinuteErrorRatio`

if [ "$errorRatio" \> "$threshold" ]; then
	emailBody="The spider-55haitao-realtime timeout ratio is too high, please to check on google vps mainserver! The statistics information is:\r\n $return_content"
	/usr/bin/sendemail -u "$emailTitle" -m "$emailBody" -s smtp.126.com:25 -o tls=auto -f shishihejia@126.com -xu shishihejia -xp "haitao55" -t $emailRecipients
fi
