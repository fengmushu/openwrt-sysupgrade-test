#!/bin/bash

USR_NAME='root'
DEV_ADDR='192.168.10.104'
DEV_PASS='fitap@network@oawifi'
TIME_TO_WAIT=60

FW="MS1200S.202403101407-v1.0"
SIG="md5sum.txt"
SCRIPTS="post-scp.sh"

usage() {
	echo "sysupgrade-stable-test.sh <fw name> <device ipaddr> <password> <base wait sec>"
	echo "	$FW $SIG $SCRIPTS must self-checked"
	exit 0
}

[ -z "$1" ] || {
	FW=$1
}

[ -z "$2" ] || {
	DEV_ADDR=$2
}

[ -z "$3" ] || {
	DEV_PASS=$3
}

[ -z "$4" ] || {
	TIME_TO_WAIT=$4
}

[ x"--help" = x"$1" ] && {
	usage
}

[ -f "$FW" ] && [ -f "$SIG" ] && [ -f "$SCRIPTS" ] || {
	usage
}

SSH_URL="$USR_NAME@$DEV_ADDR"

do_scp_and_upgrade() {
	# 1. apt-get install sshpass
	#    auto input password
	#
	# 2. modify /etc/ssh/ssh_config, avoid warring:
	#    RSA key fingerprint is 96:a9:23:5c:cc:d1:0a:d4:70:22:93:e9:9e:1e:74:2f.
	#    Are you sure you want to continue connecting (yes/no)? yes
	# StrictHostKeyChecking accept-new

	rm ~/.ssh/known_hosts

	sshpass -p "$DEV_PASS" scp -P 12580 $FW $SIG $SCRIPTS $SSH_URL:/tmp/

	sshpass -p "$DEV_PASS" ssh -p 12580 $SSH_URL "sh -x /tmp/post-scp.sh $FW $SIG"
}

# do_scp_and_upgrade
while :;
do
	ping $DEV_ADDR -i1 -w1 -W1 || {
		sleep 3
		continue
	}
	let TIME_TO_WAIT="$RANDOM % 60 + $TIME_TO_WAIT"
	echo "acturally wait $TIME_TO_WAIT sec..."
	sleep $TIME_TO_WAIT
	do_scp_and_upgrade
done
