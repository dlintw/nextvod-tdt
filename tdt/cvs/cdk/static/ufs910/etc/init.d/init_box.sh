#!/bin/sh

MODDIR=$1

insmod $MODDIR/boxtype.ko

fp_control -c

echo "init AVS"
insmod $MODDIR/avs.ko

insmod $MODDIR/cx24116.ko
insmod $MODDIR/cimax.ko

insmod $MODDIR/simu_button.ko

var=`cat /proc/boxtype`
case "$var" in
0) echo "1W boxtype"
   echo "B" > /dev/ttyAS1
   echo "B" > /dev/ttyAS1;;
1|3) echo "14W boxtype"
   insmod $MODDIR/button.ko
   insmod $MODDIR/led.ko;;
*) echo "unknown boxtype";;
esac
