#!/bin/bash
#
MODULES="lirc_serial lirc_atiusb"
source /etc/vdr.d/conf/vdr
source /etc/vdr.d/conf/gen2vdr.cfg

ALL_CONF=$(ls /_config/install/lircd.conf.*| cut -f 3 -d ".")
ADMIN_FBS=$(grep ":LIRC:" /etc/vdr/plugins/admin/admin.conf)
CHANGED=0
for i in $ALL_CONF ; do
   if [ "$(echo $ADMIN_FBS | grep "[:,]$i[:,]")" = "" ] ; then
      ADMIN_FBS="$(echo $ADMIN_FBS | sed -e "s/,Other:/,$i,Other:/")"
      CHANGED=1
   fi
done
if [ "$CHANGED" = "1" ] ; then
   sed -i /etc/vdr/plugins/admin/admin.conf -e "s%.*:LIRC:.*%$ADMIN_FBS%"
   $SETVAL LIRC "$LIRC"
fi   

[ "$1" = "-check" ] && exit

/etc/init.d/lircd stop
/etc/init.d/irexec stop
for i in $MODULES ; do
   modprobe -r $i
done
$SETVAL PLG_lircrc 0

if [ "$LIRC" = "Tastatur" ] ; then
   logger -s "ADMIN - Tastaturmodus"
   rc-update del lircd  >/dev/null 2>&1
   rc-update del irexec  >/dev/null 2>&1
elif [ "$LIRC" = "Nexus" ]; then
   logger -s "ADMIN - LIRC: Nexus"
   rc-update del lircd  >/dev/null 2>&1
   rc-update del irexec  >/dev/null 2>&1
   $SETVAL PLG_remote 1
else
   logger -s "ADMIN - LIRC: $LIRC"
   if [ -f /_config/install/lircd.conf.$LIRC ] ; then
      [ ! -f /etc/lircd.conf.save ] && cp /etc/lircd.conf /etc/lircd.conf.save
      
      cp -f /_config/install/lircd.conf.$LIRC /etc/lircd.conf  >/dev/null 2>&1
   else
      if [ "$LIRC" != "Other" -a "$LIRC" != "ActivyFB" -a "$LIRC" != "SMT7020FB" ]  ; then
         echo "Unknown LIRC parameter $1"
         exit 1
      fi
   fi
   rc-update add lircd boot >/dev/null 2>&1
   rc-update add irexec default >/dev/null 2>&1
   sed -i /etc/conf.d/lircd -e "/LIRCD_USESERIAL/d" -e "/LIRCD_USEATIUSBMODULE/d" -e "/LIRCD_USEACTIVY/d"
   LSER=1
   LATI=0
   LACT=0
   LSMT=0
   if [ "$LIRC" = "MedionX10" ] ; then
      if [ "$(grep "options lirc_atiusb" /etc/modprobe.d/lircd)" = "" ] ; then 
         echo "options lirc_atiusb debug=0 mask=0xFFFF repeat=25 emit_updown=1 emit_modekeys=2" >> /etc/modprobe.d/lircd
         update-modules
      fi
      LSER=0
      LATI=1
   elif [ "$LIRC" = "ActivyFB" ] ; then
      LSER=0
      LACT=1
   elif [ "$LIRC" = "SMT7020FB" ] ; then
      cp /_config/install/vdr/remote.conf.smt7020 /etc/vdr/remote.conf
      cp /_config/install/lircrc.conf.smt7020 /etc/lircrc.conf
      LSER=0
      LSMT=1
   fi
   sed -i /etc/conf.d/lircd -e "/LIRCD_USESERIAL=.*/d"                  
   sed -i /etc/conf.d/lircd -e "/LIRCD_USEATIUSBMODULE=.*/d"                  
   sed -i /etc/conf.d/lircd -e "/LIRCD_USEACTIVY=.*/d"                  
   sed -i /etc/conf.d/lircd -e "/LIRCD_USESMT7020=.*/d"                  
   echo "LIRCD_USESERIAL=$LSER"  >> /etc/conf.d/lircd
   echo "LIRCD_USEATIUSBMODULE=$LATI"  >> /etc/conf.d/lircd
   echo "LIRCD_USEACTIVY=$LACT"        >> /etc/conf.d/lircd
   echo "LIRCD_USESMT7020=$LSMT"       >> /etc/conf.d/lircd
   /etc/init.d/lircd start
   /etc/init.d/irexec start
fi
if [ "$(grep "mplayer.ControlMode" $VDR_CONFIG_DIR/setup.conf)" != "" ] ; then
   sed -i $VDR_CONFIG_DIR/setup.conf -e "s/^mplayer\.ControlMode.*/mplayer\.ControlMode = 1/"
else
   echo "mplayer.ControlMode = 1" >> $VDR_CONFIG_DIR/setup.conf
fi   
									
echo 'Done!'
exit 0

