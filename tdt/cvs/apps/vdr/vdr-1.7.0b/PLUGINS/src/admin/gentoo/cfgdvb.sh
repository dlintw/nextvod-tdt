#!/bin/bash
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

DVB_MOD="/etc/modprobe.d/dvb"

logger -s "ADMIN - DVB Out: $VIDEO_OUT"

if [ "$VIDEO_OUT" = "SVIDEO" ] ; then
   sed -i $DVB_MOD -e "s/vidmode=./vidmode=2/"
else
   sed -i $DVB_MOD -e "s/vidmode=./vidmode=1/"
fi
update-modules
echo 'Done!'
exit 0

