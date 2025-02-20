#!/bin/sh

if [ `id -u` = 0 ]; then
	echo "*** You cannot run this script ($0) as root!"
	exit 1
fi

_UID=`id -u`
_GID=`id -g`
_USER=`whoami`
_USER=${_USER:-upclass}
_PASS=${1:-password}
_SSHPORT=22222

_SCRIPTDIR=`dirname $0`
_DIR=`(cd "$_SCRIPTDIR"; pwd)`

echo "** Detected user: $_USER ($_UID:$_GID); password = $_PASS"
mkdir -p ./home
docker run -d --name up-runtime --restart unless-stopped \
	--cap-add SYS_ADMIN --cap-add NET_ADMIN --cap-add DAC_READ_SEARCH \
	-v "$_DIR/home:/home" -p "127.0.0.1:$_SSHPORT:22/tcp" \
	upclass/runtime /entrypoint.sh "$_USER" "$_PASS" "$_UID" "$_GID"
