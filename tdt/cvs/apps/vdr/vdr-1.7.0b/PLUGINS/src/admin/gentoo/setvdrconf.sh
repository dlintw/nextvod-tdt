#!/bin/sh
source /etc/vdr.d/conf/gen2vdr.cfg
VDR_CONF="/etc/vdr.d/conf/vdr"

[ "$1" != "" ] && [ -f $1 ] && ADMIN_CFG_FILE=$1
[ "$2" != "" ] && [ -f $2 ] && VDR_CONF=$2

cp $VDR_CONF $VDR_CONF.old

grep "^/" $ADMIN_CFG_FILE | grep -v ":PLG_" | sed -e "s/\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\):/# \7 \(\6\)\n\2=\"\3\"\n/" >$VDR_CONF
PLGS=$(grep ":PLG_" $ADMIN_CFG_FILE | grep -v ":0:I:0" |cut -f 2,3 -d ":" |sort -n -t: -k2| sed -e "s/PLG_//" -e "s/:.*//" | tr "\n" " " | sed -e "s/[ ]*$//")
echo "PLUGINS=\"$PLGS\"" >> $VDR_CONF

Newline=$'\n'
IFS="${Newline}"

for i in $(diff ${VDR_CONF}.old $VDR_CONF | grep "^>" | cut -f 2- -d " " ) ; do
   logger -s "Changed <$i> in $VDR_CONF"
done
