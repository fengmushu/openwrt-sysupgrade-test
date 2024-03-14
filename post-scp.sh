#!/bin/sh

logger "auto sysupgrade at `date`"

[ -z "$1" ] || [ -z "$2" ] && {
	logger "FW, or md5sum.txt not found"
	exit 1
}

cd /tmp
M5SUM=`md5sum "$1" | awk '{print $1}'`
M5SIG=`cat "$2" | awk '{print $1}'`

[ x"$M5SIG" = x"$M5SUM" ] || {
	logger "checksum failed, fw not correct..."
	exit 1
}

sysupgrade $1
# jffs2reset -y -r

exit 0