#!/bin/bash
#
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

ALSACTL="/usr/sbin/alsactl"
ASOUNDCFG="/etc/asound.state"

logger -s "ADMIN - ALSA: $ALSA"
/etc/init.d/alsasound stop
rm /etc/asound.state >/dev/null 2>&1
if [ "$ALSA" = "0" ] ; then
   rc-update del alsasound
else
   rc-update add alsasound boot >/dev/null 2>&1
fi
echo 'Done!'
exit 0

