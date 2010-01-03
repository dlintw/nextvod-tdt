#!/bin/bash
#
source /etc/vdr.d/conf/gen2vdr.cfg
source /etc/vdr.d/conf/vdr

LILOCONF="/etc/lilo.conf"
logger -s "ADMIN - ACPI: $ACPI"

case "$ACPI" in
   1|An|Activy)
      BP="2.6"
      $SETVAL "ACPI" 1
      ;;
   
   0|Aus|MP_QDI|MP_AVT|EPIA_M)
      BP="2.6-AN"
      $SETVAL "ACPI" 0
      ;;
      
   *)      
      echo "Unknown ACPI parameter $ACPI"
      BP="2.6-AN"
      $SETVAL "ACPI" 0
      ;;
esac

sed -i $LILOCONF -e "s/^default = .*/default = $BP/"
lilo
echo 'Done!'
exit 0
