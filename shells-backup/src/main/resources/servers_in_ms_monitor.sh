#!/bin/sh

here=`pwd`
cd $here

## emailRecipients="liushizhen@55haitao.com"
emailRecipients="liushizhen@55haitao.com,zhoushuo@55haitao.com,denghuan@55haitao.com,xusongsong@55haitao.com,zhangyouping@55haitao.com,jingpeng@55haitao.com,zhaohongliang@55haitao.com,taorui@55haitao.com,gechongyu@55haitao.com"

sendMonitorEmail()
{
	emailTitle=$1
	emailContent=$2
	
	/usr/bin/sendemail -u "$emailTitle" -m "$emailContent" -s smtp.126.com:25 -o tls=auto -f shishihejia@126.com -xu shishihejia -xp "haitao55" -t $emailRecipients
}

checkServer()
{
	serverUrl=$1
	grepTarget=$2
	serverName=$3

	result=`curl -X GET -s --connect-timeout 3 "$serverUrl" | tail -10 | grep "$grepTarget"`
	if [ "$result"x = x ]; then
        	sendMonitorEmail "google vps mainserver::servers monitor alarm!!!" "$3 is not in service, please check in time!"
	fi
}

checkServers()
{
	checkServer "http://104.197.229.122:9090/spider-55haitao-ui/" "登录" "spider-55haitao-ui"
	checkServer "http://104.197.229.122:7777/spider-order-robot-platform/" "登录" "spider-order-robot-platform"
}

checkServers
