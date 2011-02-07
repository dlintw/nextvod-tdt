#!/bin/sh

MODDIR=$1

echo "init TUNER"
insmod $MODDIR/stv090x.ko

echo "init CAM"
insmod $MODDIR/ufs912_cic.ko

echo "init REMOTECONTROL"
insmod $MODDIR/simu_button.ko

EVREMOTE2_PERIOD="10"
EVREMOTE2_DELAY="120"
/bin/evremote2 $EVREMOTE2_PERIOD $EVREMOTE2_DELAY &
