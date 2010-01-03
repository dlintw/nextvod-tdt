#!/bin/bash
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

#read-only
#initrd = /boot/fbsplash-vdr-800x600
logger -s "ADMIN - AUTOMOUNT: $AUTOMOUNT"

if [ "$AUTOMOUNT" = "1" ] ; then
   rc-update add ivman default
   /etc/init.d/ivman start
else
   rc-update del ivman
   /etc/init.d/ivman stop 
fi
echo 'Done!'
exit 0

