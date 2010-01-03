#!/bin/sh
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr


NET_SCRIPTS="net.eth0 net.eth1 netmount samba sshd xinetd xxv vdradmind ntp-client nfs fritzwatch portmap"
NET_CONFIG="/etc/conf.d/net"

if [ "$NET" = "Nein" ] ; then
   logger -s "ADMIN - Netzwerk wird deaktiviert"
   for i in $NET_SCRIPTS ; do
      rc-update del ${i} default >/dev/null 2>&1
   done
elif [ "$NET" = "Ja" ] ; then
   logger -s "ADMIN - Netzwerk wird aktiviert"
   rc-update del net.eth1 >/dev/null 2>&1
   rc-update add net.eth0 default >/dev/null 2>&1
   rc-update add netmount default >/dev/null 2>&1
   rc-update add portmap default >/dev/null 2>&1

   echo "/etc/conf.d/hostname wird angepasst"
   echo "HOSTNAME=$HOSTNAME" > /etc/conf.d/hostname
   hostname $HOSTNAME
   if [ "$(grep "127\.0\.0\.1" /etc/hosts | grep $HOSTNAME)" = "" ] ; then
      sed -i /etc/hosts -e "/127\.0\.0\.1/d" 
      echo "127.0.0.1   localhost" >> /etc/hosts
      echo "127.0.0.1   $HOSTNAME" >> /etc/hosts
   fi        
   sed -i /etc/samba/smb.conf -e "s/netbios name = .*$/netbios name = $HOSTNAME/"

#   mv -f $NET_CONFIG $NET_CONFIG.old
   if [ "$DHCP" = "0" ] ; then
      BROADCAST=`echo $IPADR | cut -f 1 -d "."`
      IPRANGE=`echo $IPADR | cut -f 1 -d "."`
      IPRREST=""
      IPRLEN=32
      for i in `seq 2 4` ; do
         NM=`echo $SUBNET | cut -f ${i} -d "."`
         if [ "$NM" = "0" ] ; then
            NM=255
            IPRREST=$IPRREST.0
            IPRLEN=$(($IPRLEN-8))
         else
            NM=`echo $IPADR | cut -f ${i} -d "."`
            IPRANGE=$IPRANGE.$NM
         fi
         BROADCAST=$BROADCAST.$NM
      done
      sed -i $NET_CONFIG -e "/^config_eth0=/d"
      echo "config_eth0=( \"$IPADR netmask $SUBNET broadcast $BROADCAST\" )" >> $NET_CONFIG
      if [ "$GATEWAY" != "" ] ; then
#         echo "gateway=\"eth0/$GATEWAY\"" >> $NET_CONFIG
         sed -i $NET_CONFIG -e "/^routes_eth0=/d"
	 echo "routes_eth0=(\"default via $GATEWAY\" )" >> $NET_CONFIG
      fi
      rm -f /etc/resolv.conf
      IPA=`ifconfig |grep "inet addr:"|cut -f2 -d":"|cut -f1 -d" "|sed '/127\./d'`
      if [ "$IPA" != "$IPADR" ] ; then
         /etc/init.d/net.eth0 stop >/dev/null 2>&1
         ifconfig eth0 down >/dev/null 2>&1
         /etc/init.d/net.eth0 start >/dev/null 2>&1
      fi
   else
      sed -i $NET_CONFIG -e "/^config_eth0=/d"
      sed -i $NET_CONFIG -e "/^fallback_eth0=/d"
      sed -i $NET_CONFIG -e "/^fallback_route_eth0=/d"
      sed -i $NET_CONFIG -e "/^dhcpcd_eth0=/d"
      
      echo "fallback_eth0=( \"192.168.0.2 netmask 255.255.0.0\" )" >> $NET_CONFIG
      echo "fallback_route_eth0=( \"default via 192.168.0.1\" )" >> $NET_CONFIG
   
      echo "config_eth0=( \"dhcp\" )" >> $NET_CONFIG
      echo "dhcpcd_eth0=\"-t 10 -h $HOSTNAME\"" >> $NET_CONFIG
      /etc/init.d/net.eth0 stop >/dev/null 2>&1
      /etc/init.d/net.eth0 zap >/dev/null 2>&1
#      ifconfig eth0 down
      /etc/init.d/net.eth0 start 2>&1
      logger "$NETSTART"
      IFC=$(ifconfig 2>&1)
      logger "$IFC"
      IPADR=`ifconfig |grep "inet addr:"|cut -f2 -d":"|cut -f1 -d" "|sed '/127\./d'`
      if [ "$IPADR" = "" ] ; then
         IPADR=`ifconfig |grep "inet Adresse:"|cut -f2 -d":"|cut -f1 -d" "|sed '/127\./d'`
      fi
      if [ "$IPADR" != "" ] ; then
         $SETVAL IPADR $IPADR       
         NMS=$(grep -m 1 nameserver /etc/resolv.conf | cut -f 2 -d " ")
	 [ "$NMS" = "" ] && NMS="192.168.0.1"
         $SETVAL NAMESERVER $NMS
      fi
      if [ "$IPADR" = "" ] ; then
         logger -s "ADMIN - Netzwerk wird deaktiviert"
         for i in $NET_SCRIPTS ; do
            rc-update del ${i} default >/dev/null 2>&1
         done
         $SETVAL NET 0
         exit 1
      else
         ping -b -c1 fritz.box > /dev/null 2>&1
         if [ "$?" = "0" ] ; then
            logger -s "FritzBox gefunden"
	    nc6 fritz.box 1012 >/dev/null 2>&1 &
	    sleep 3
	    killall -9 nc6
	    if [ "$?" = "0" ] ; then
               logger -s "FritzBox Anrufmonitor wird aktiviert"
               $SETVAL FRITZWATCH 1
	       FRITZWATCH=1
	    else   
               logger -s "FritzBox Anrufmonitor ist nicht aktiviert"
	    fi   
         else
            $SETVAL FRITZWATCH 0
	    FRITZWATCH=0
         fi              
      fi

      IPRANGE=`echo $IPADR | cut -f 1 -d "."`
      IPRREST=""
      IPRLEN=32
      for i in `seq 2 4` ; do
         NM=`echo $SUBNET | cut -f ${i} -d "."`
         if [ "$NM" = "0" ] ; then
            NM=255
            IPRREST=$IPRREST.0
            IPRLEN=$(($IPRLEN-8))
         else
            NM=`echo $IPADR | cut -f ${i} -d "."`
            IPRANGE=$IPRANGE.$NM
         fi
      done
   fi

   echo "/etc/vdr/svdrphosts.conf wird angepasst"
   sed -i /etc/vdr/svdrphosts.conf \
       -e "/192.168.0.*/d" \
       -e "/9.152.*/d" \
       -e "/# local subnet/d"

   echo "$IPRANGE$IPRREST/$IPRLEN   # local subnet" >> /etc/vdr/svdrphosts.conf

   if [ "$NAMESERVER" != "" ] && [ "$DHCP" = "0" ] ; then
      echo "nameserver $NAMESERVER" >> /etc/resolv.conf
   fi

    

   if [ "$SAMBA" = "0" ] ; then
      rc-update del samba default >/dev/null 2>&1
      /etc/init.d/samba stop
   else
      rc-update add samba default >/dev/null 2>&1
      echo "/etc/samba/smb.conf wird angepasst"
      sed -i /etc/samba/smb.conf -e "s/hosts allow = .*$/hosts allow = $IPRANGE./" -e "s/workgroup = .*/workgroup = $WORKGROUP/"
      /etc/init.d/samba restart
   fi
   logger -s "ADMIN - Samba: $SAMBA"

   if [ "$SSH" = "0" ] ; then
      rc-update del sshd default >/dev/null 2>&1
      /etc/init.d/sshd stop
   else
      rc-update add sshd default >/dev/null 2>&1
      /etc/init.d/sshd restart
   fi
   logger -s "ADMIN - SSH: $SSH"

   if [ "$NFS" = "0" ] ; then
      rc-update del nfs default >/dev/null 2>&1
      /etc/init.d/nfs stop
   else
      if [ "$NFS_RO" = "0" ] ; then
         sed -i /etc/exports -e "s/*(ro,/*(rw,/"
      else
         sed -i /etc/exports -e "s/*(rw,/*(ro,/"      
      fi	 
   
      rc-update add nfs default >/dev/null 2>&1
      /etc/init.d/nfs restart
   fi
   logger -s "ADMIN - NFS: $NFS"

   sed -i /etc/xinetd.conf -e "s/only_from.*$/only_from = 127.0.0.0\/24 $IPRANGE$IPRREST\/$IPRLEN/"
   if [ "$FTP" = "0" ] ; then
      sed -i /etc/xinetd.d/ftp -e "s/disable.*$/disable = yes/"
      rc-update del xinetd default >/dev/null 2>&1
      /etc/init.d/xinetd stop
   else
      rc-update add xinetd default >/dev/null 2>&1
      sed -i /etc/xinetd.d/ftp -e "s/disable.*$/disable = no/"
      /etc/init.d/xinetd restart
   fi
   logger -s "ADMIN - FTP: $FTP"

   if [ "$NTP" = "0" ] ; then
      rc-update del ntp-client default >/dev/null 2>&1
   else
      rc-update add ntp-client default >/dev/null 2>&1
   fi
   logger -s "ADMIN - NTP(Uhrzeit per Internet): $NTP"
   
   if [ "$FRITZWATCH" = "1" ] ; then
      rc-update add fritzwatch default >/dev/null 2>&1
   else
      rc-update del fritzwatch >/dev/null 2>&1
   fi

   if [ "$WAKEONLAN" = "1" ] ; then
      sed -i /etc/conf.d/rc -e "s/RC_DOWN_INTERFACE.*/RC_DOWN_INTERFACE=\"no\"/"
   else
      sed -i /etc/conf.d/rc -e "s/RC_DOWN_INTERFACE.*/RC_DOWN_INTERFACE=\"yes\"/"
   fi
   
   logger -s "ADMIN - WAKEONLAN: $WAKEONLAN"
else
   logger -s "ADMIN - Netzwerk wird manuell konfiguriert"
fi
exit 0
											  