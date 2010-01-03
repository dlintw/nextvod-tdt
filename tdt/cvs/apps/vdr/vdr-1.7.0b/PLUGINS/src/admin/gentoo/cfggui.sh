#!/bin/bash
#
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

FRV_SKINS=$(ls /usr/share/freevo/skins/main/*.fxd | sed -e "s:.*/::" -e "s:\.fxd::")
ADMIN_FSK=$(grep ":FREEVO_SKIN:" /etc/vdr/plugins/admin/admin.conf)
CHANGED=0
#set -x
for i in $FRV_SKINS ; do
   if [ "$(echo "$ADMIN_FSK" | grep "[:,]$i[:,]")" = "" ] ; then
      ADMIN_FSK="$(echo $ADMIN_FSK | sed -e "s/:FreeVo/,$i:FreeVo/")"
      CHANGED=1
   fi
done
if [ "$CHANGED" = "1" ] ; then
   sed -i /etc/vdr/plugins/admin/admin.conf -e "s%.*:FREEVO_SKIN:.*%$ADMIN_FSK%"
   $SETVAL FREEVO_SKIN "$FREEVO_SKIN"
fi

[ "$1" = "-check" ] && exit
			
logger -s "ADMIN - GUI: $GUI"

BOARD="$(/_config/bin/query_mb.sh)"

if [ "$GUI" = "FreeVo" ] ; then
   sed -i /etc/vdr.d/plugins/swcon -e "s/-t .*/-t FreeVo\"/"
#   logger -s "Untersuche Audio und Videoverzeichnis - kann lange dauern !"
#   freevo cache
elif [ "$GUI" = "XFCE" ] ; then
   sed -i /etc/rc.conf -e "s/^XSESSION=.*/XSESSION=\"Xfce4\"/"
elif [ "$GUI" = "KDE" ] ; then
   sed -i /etc/rc.conf -e "s/^XSESSION=.*/XSESSION=\"kde-3.5\"/"
elif [ "$GUI" != "Aus" ] ; then
   echo "Unknown GUI parameter $1"
   exit 1
fi


if [ "$BOARD" = "ACTIVY" ] ; then
   if [ "$SCREEN_RESOLUTION" = "1024x768" ] ; then
      cp /etc/X11/xorg.conf.activy.1024 /etc/X11/xorg.conf
   else
      cp /etc/X11/xorg.conf.activy.720 /etc/X11/xorg.conf
   fi      
   if [ "$GUI" = "XFCE" ] ; then
      sed -i /etc/X11/xorg.conf -e "s/DefaultDepth 24/DefaultDepth 16/"
   else
      sed -i /etc/X11/xorg.conf -e "s/DefaultDepth 16/DefaultDepth 24/"
   fi      
fi      

sh /_config/bin/set_xorgres.sh   

depscan.sh
exit 0
