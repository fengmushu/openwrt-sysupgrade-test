#!/bin/bash

USR_NAME='root'
DEV_ADDR='192.168.10.104'
TIME_TO_WAIT=60

FW="MS1200S.202403101407-v1.0"
SIG="md5sum.txt"
SCRIPTS="post-scp.sh"


[ -z "$1" ] || {
	FW=$1
}

[ -z "$2" ] || {
	DEV_ADDR=$2
}

[ -z "$3" ] || {
	TIME_TO_WAIT=$3
}

do_scp_and_upgrade() {
	# 1. apt-get install sshpass
	#    auto input password
	#
	# 2. modify /etc/ssh/ssh_config, avoid warring:
	#    RSA key fingerprint is 96:a9:23:5c:cc:d1:0a:d4:70:22:93:e9:9e:1e:74:2f.
	#    Are you sure you want to continue connecting (yes/no)? yes
	# StrictHostKeyChecking accept-new

	rm ~/.ssh/known_hosts

	sshpass -p "fitap@network@oawifi" scp -P 12580 $FW $SIG $SCRIPTS $USR_NAME@$DEV_ADDR:/tmp/

	sshpass -p "fitap@network@oawifi" ssh -p 12580 $USR_NAME@$DEV_ADDR "sh -x /tmp/post-scp.sh $FW $SIG"
}

# do_scp_and_upgrade
while :;
do
	ping $DEV_ADDR -i1 -w3 -W1 || continue
	let TIME_TO_WAIT="$RANDOM % 60 + 60"
	logger "acturally wait $TIME_TO_WAIT sec..."
	sleep $TIME_TO_WAIT
	do_scp_and_upgrade
done
