#!/bin/sh

MODDIR=$1

echoVFD()
{
   echo "$1" > /dev/vfd
}

initVFD()
{
   insmod $MODDIR/vfd.ko
   # clear
   /bin/fp_control -c
}
