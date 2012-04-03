#!/bin/sh

MODDIR=$1

PTI_P179_ARGS=""
PTI_P191_ARGS=""
STMDVB_P179_ARGS=""
STMDVB_P191_ARGS=""

insmod $MODDIR/boxtype.ko

fp_control -c

echo "init AVS"
insmod $MODDIR/avs.ko

insmod $MODDIR/cx24116.ko
insmod $MODDIR/cimax.ko

insmod $MODDIR/simu_button.ko

BOXTYPE=`cat /proc/boxtype`
case "$BOXTYPE" in
0) echo "1W boxtype"
   echo "B" > /dev/ttyAS1
   echo "B" > /dev/ttyAS1;;
1|3) echo "14W boxtype"
   insmod $MODDIR/button.ko
   insmod $MODDIR/led.ko;;
*) echo "unknown boxtype";;
esac
