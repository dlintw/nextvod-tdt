#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}
export PATH=/usr/sbin:/sbin:$PATH

CONFIGPARAM=" \
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

# config.guess generates different answers for some packages 
# Ensure that all packages use the same host by explicitly specifying it. 

# First obtain the triplet 
AM_VER=`automake --version | awk '{print $NF}' | grep -oEm1 "^[0-9]+.[0-9]+"` 
host_alias=`/usr/share/automake-${AM_VER}/config.guess` 

# Then undo Suse specific modifications, no harm to other distribution 
case `echo ${host_alias} | cut -d '-' -f 1` in 
  i?86) VENDOR=pc ;; 
  *   ) VENDOR=unknown ;; 
esac 
host_alias=`echo ${host_alias} | sed -e "s/suse/${VENDOR}/"`

# And add it to the config parameters. 
CONFIGPARAM="${CONFIGPARAM} --host=${host_alias} --build=${host_alias}" 

############################################## 

echo "Targets:"
echo "1) Kathrein UFS-910"
echo "2) Kathrein UFS-910-FLASH"
echo "3) Kathrein UFS-912"
echo "4) Kathrein UFS-922"
echo "5) Topfield 7700 HDPVR"
echo "6) Fortis based (HDBOX)"
echo "7) Cuberevo (IPBOX)"
echo "8) SpiderBox HL-101"
case $1 in
	1|2|3|4|5|6|7|8) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-8)? ";;
esac

[ "$REPLY" == "1" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs910"
[ "$REPLY" == "2" ] && CONFIGPARAM="$CONFIGPARAM --enable-flash_ufs910"
[ "$REPLY" == "3" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs912"
[ "$REPLY" == "4" ] && CONFIGPARAM="$CONFIGPARAM --enable-ufs922"
[ "$REPLY" == "5" ] && CONFIGPARAM="$CONFIGPARAM --enable-tf7700"
[ "$REPLY" == "6" ] && CONFIGPARAM="$CONFIGPARAM --enable-fortis_hdbox"
[ "$REPLY" == "7" ] && CONFIGPARAM="$CONFIGPARAM --enable-cuberevo"
[ "$REPLY" == "8" ] && CONFIGPARAM="$CONFIGPARAM --enable-hl101"
[ "$REPLY" == "1" -o "$REPLY" == "2" -o "$REPLY" == "3" -o "$REPLY" == "4" -o "$REPLY" == "5" -o "$REPLY" == "6" -o "$REPLY" == "7" -o "$REPLY" == "8" ] || CONFIGPARAM="$CONFIGPARAM --enable-ufs910"

##############################################
REPLY=N
read -p "Building for stm23(instable) instead of stm22(stable) (y/N/h)? " -t 5
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-stm23"
[ "$REPLY" == "h" -o "$REPLY" == "H" ] && CONFIGPARAM="$CONFIGPARAM --enable-stm23 --enable-havana"
[ "$REPLY" == "y" -o "$REPLY" == "Y" -o "$REPLY" == "h"  -o "$REPLY" == "H"  ] || CONFIGPARAM="$CONFIGPARAM --enable-stm22 --enable-p0041"
echo -e "\nSelected option: $REPLY\n"
##############################################
REPLY=N
read -p "Activate debug (y/N)? " -t 5
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"
echo -e "\nSelected option: $REPLY\n"

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
