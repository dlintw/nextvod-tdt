#!/bin/sh
CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
version=`git describe`
cat $KATIDIR/cvs/cdk/root/var/etc/.version | head -n 6 > $KATIDIR/cvs/cdk/root/var/etc/.version.new
echo "version=$version" >> $KATIDIR/cvs/cdk/root/var/etc/.version.new
mv $KATIDIR/cvs/cdk/root/var/etc/.version.new $KATIDIR/cvs/cdk/root/var/etc/.version
exit
