#!/bin/bash
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

LILO_CONF="/etc/lilo.conf"
VESA="video=uvesafb:.*"
VESA_OFF="video=uvesafb:off\""
VESA_ON="video=uvesafb:800x600-16@60\""
VESA_ON_SPLASH="video=uvesafb:800x600-16@60 splash=silent,theme:vdr quiet CONSOLE=/dev/tty1\""

#read-only
#initrd = /boot/fbsplash-vdr-800x600

logger -s "ADMIN - Framebuffer: $VESAFB"

if [ "$VESAFB" = "1" ] ; then
   if [ "$BOOTSPLASH" = "1" ] ; then
      sed -i $LILO_CONF -e "s/$VESA.*/$VESA_ON_SPLASH/" \
                        -e "s%^#initrd = /boot/fb%initrd = /boot/fb%"
   else
      sed -i $LILO_CONF -e "s/$VESA.*/$VESA_ON/" \
                        -e "s%^initrd = /boot/fb%#initrd = /boot/fb%"
   fi
   logger -s "ADMIN - BootSplash: $VESAFB"
else
   sed -i $LILO_CONF -e "s/$VESA.*/$VESA_OFF/" \
                     -e "s%^initrd = /boot%#initrd = /boot/fb%"
fi
lilo
echo 'Done!'
exit 0

