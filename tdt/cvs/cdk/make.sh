#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
export PATH=/usr/sbin:/sbin:$PATH

CONFIGPARAM=" \
 --host=sh4-linux \
 --enable-maintainer-mode \
 --prefix=$KATIDIR/tufsbox \
 --with-cvsdir=$KATIDIR/cvs \
 --with-customizationsdir=$KATIDIR/custom \
 --with-logosdir=$KATIDIR/logos \
 --enable-ccache \
 --enable-flashrules \
 --with-stockdir=$KATIDIR/stock"

##############################################

echo "
  _______                     _____              _     _         _          
 |__   __|                   |  __ \            | |   | |       | |         
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___ 
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/
                                                                                  
"

##############################################

echo "Targets:"
echo "1) Kathrein UFS-910"
echo "2) Kathrein UFS-910-FLASH"
echo "3) Kathrein UFS-912"
echo "4) Kathrein UFS-922"
echo "5) Topfield 7700 HDPVR"
echo "6) Fortis based (HDBOX)"
read -p "Select target (1-5)? "

[ "$REPLY" == "1" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs910"
[ "$REPLY" == "2" ] && CONFIGPARAM="$CONFIGPARAM --enable-flash_ufs910"
[ "$REPLY" == "3" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs912"
[ "$REPLY" == "4" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs922"
[ "$REPLY" == "5" ] && CONFIGPARAM="$CONFIGPARAM --enable-tf7700"
[ "$REPLY" == "6" ] && CONFIGPARAM="$CONFIGPARAM --enable-fortis_hdbox"
[ "$REPLY" == "1" -o "$REPLY" == "2" -o "$REPLY" == "3" -o "$REPLY" == "4" -o "$REPLY" == "5" -o "$REPLY" == "6" ] || CONFIGPARAM="$CONFIGPARAM --enable-ufs910"

##############################################

read -p "Building for stm23(instable) instead of stm22(stable) (y/N/h)? "
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-stm23"
[ "$REPLY" == "h" -o "$REPLY" == "H" ] && CONFIGPARAM="$CONFIGPARAM --enable-stm23 --enable-havana"
[ "$REPLY" == "y" -o "$REPLY" == "Y" -o "$REPLY" == "h"  -o "$REPLY" == "H"  ] || CONFIGPARAM="$CONFIGPARAM --enable-stm22 --enable-p0041"

##############################################

read -p "Activate debug (y/N)? "
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"

##############################################

echo && \
echo "Performing autogen.sh..." && \
echo "------------------------" && \
./autogen.sh && \
echo && \
echo "Performing configure..." && \
echo "-----------------------" && \
echo && \
./configure $CONFIGPARAM
./touch.sh
