#!/bin/sh

here=`pwd`
remoteHere="/data/shell_tasks/realtime_statistics"

emailTitle="实时核价时间统计"
emailRecipients="liushizhen@55haitao.com,zhoushuo@55haitao.com,denghuan@55haitao.com,xusongsong@55haitao.com,zhaoxinluo@55haitao.com,zhangyouping@55haitao.com,jingpeng@55haitao.com,zhaohongliang@55haitao.com,gechongyu@55haitao.com"
emailAttachFileName="realtime_time_statistics.txt"

ssh -t -p 22 gphonebbs@ms "cd $remoteHere; $remoteHere/build_realtime_time_email.sh"
scp gphonebbs@ms:$remoteHere"/email_content.txt" $here"/"$emailAttachFileName

emailBody=`cat $here"/"$emailAttachFileName`

/usr/bin/sendemail -u "$emailTitle" -m "$emailBody" -a $here"/"$emailAttachFileName -s smtp.126.com:25 -o tls=auto -f shishihejia@126.com -xu shishihejia -xp "haitao55" -t $emailRecipients
