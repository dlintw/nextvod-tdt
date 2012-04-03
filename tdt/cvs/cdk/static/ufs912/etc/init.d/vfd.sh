#!/bin/sh

echoVFD()
{
   echo "$1" > /dev/vfd
}

initVFD()
{
   insmod $1/micom.ko paramDebug=0
   #clear
   /bin/fp_control -c

   #green led on
   /bin/fp_control -l 2 1
   #led brightness
   /bin/fp_control -led 80
}

