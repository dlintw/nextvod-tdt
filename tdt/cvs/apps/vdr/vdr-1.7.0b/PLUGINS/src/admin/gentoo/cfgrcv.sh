#!/bin/bash
#
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

sed -i /etc/vdr/setup.conf -e "s/SetSystemTime.*/SetSystemTime = 1/"
if [ "$RCV" = "SAT" ] ; then
   logger -s "ADMIN - Senderliste fuer SAT setzen"
   if [ "$(echo $FCHAN | grep -c \":S19\.2E:\")" = "0" ] ; then
      cp -f /etc/vdr/channels.conf.sat /etc/vdr/channels.conf
   fi
else
   if [ "$RCV" = "Kabel" ]  ; then
      logger -s "ADMIN - Senderliste fuer Kabel setzen"
      if [ "$(echo $FCHAN | grep -c \":C:\")" = "0" ] ; then
         cp -f /etc/vdr/channels.conf.cable /etc/vdr/channels.conf
      fi
   else
      if [ "$RCV" = "DVB-T" ]  ; then
         logger -s "ADMIN - Senderliste fuer DVB-T setzen"
         if [ "$(echo $FCHAN | grep -c \":T:\")" = "0" ] ; then
            cp -f /etc/vdr/channels.conf.terr /etc/vdr/channels.conf
         fi
      else
         echo "Unknown parameter RCV $1"
         exit 1
      fi
   fi
fi
FCHAN=$(sed -e "/^:.*/d" /etc/vdr/channels.conf | head -n 1)
TS=$(echo $FCHAN | cut -f 4 -d ":")
TT=$(echo $FCHAN | cut -f 2 -d ":")
sed -i /etc/vdr/setup.conf -e "s/TimeTransponder.*/TimeTransponder = 1$TT/"
sed -i /etc/vdr/setup.conf -e "s/TimeSource.*/TimeSource = $TS/"

echo 'Done!'
exit 0
