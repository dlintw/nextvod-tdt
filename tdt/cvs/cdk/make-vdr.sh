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
CONFIGPARAM="$CONFIGPARAM --enable-ufs910"

##############################################

CONFIGPARAM="$CONFIGPARAM --enable-stm22 --enable-p0041"
#CONFIGPARAM="$CONFIGPARAM --enable-vdr1711"
 echo "$CONFIGPARAM"
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
