#!/bin/sh

here="/data/shell_tasks/realtime_statistics_rtReturnCode"
remoteHere="/data/shell_tasks/realtime_statistics_rtReturnCode"


emailTitle="Realtime RTReturnCode Statistics"
emailRecipients="liushizhen@55haitao.com,zhangyouping@55haitao.com"

emailAttachFileName="realtime_rtReturnCode_statistics.txt"

if [ -f "$emailAttachFileName" ]; then
        /bin/rm $emailAttachFileName
fi

ssh -t -p 22 gphonebbs@ms "cd $remoteHere; $remoteHere/realtime_statistics_rtReturnCode.sh"
scp gphonebbs@ms:$remoteHere"/email_result.txt" $here"/"$emailAttachFileName

emailBody=`cat $here"/"$emailAttachFileName`

/usr/bin/sendemail -u "$emailTitle" -m "$emailBody" -a $here"/"$emailAttachFileName -s smtp.126.com:25 -o tls=auto -f shishihejia@126.com -xu shishihejia -xp "haitao55" -t $emailRecipients
