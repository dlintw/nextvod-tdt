#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-14)"
 echo "Parameter 2: kernel (1-4)"
 echo "Parameter 3: debug (Y/N)"
 exit
fi

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
echo " 1) Kathrein UFS-910"
echo " 2) Kathrein UFS-910-FLASH"
echo " 3) Kathrein UFS-912"
echo " 4) Kathrein UFS-922"
echo " 5) Topfield 7700 HDPVR"
echo " 6) Fortis based (HDBOX)"
echo " 7) SpiderBox HL-101"
echo " 8) Edision argus VIP2"
echo " 9) Cuberevo (IPBOX 9000)"
echo "10) Cuberevo mini (IPBOX 900)"
echo "11) Cuberevo mini2 (IPBOX 910)"
echo "12) Cuberevo 250 (IPBOX 91)"
echo "13) Homecast 5101"
echo "14) Octagon 1008"
case $1 in
	[1-9] | 1[0-4]) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-14)? ";;
esac

case "$REPLY" in
	 1) TARGET="--enable-ufs910";;
	 2) TARGET="--enable-flash_ufs910 --with-rootpartitionsize=0x8e0000 --with-datapartitionsize=0x580000";;
	 3) TARGET="--enable-ufs912";;
	 4) TARGET="--enable-ufs922";;
	 5) TARGET="--enable-tf7700";;
	 6) TARGET="--enable-fortis_hdbox --with-rootpartitionsize=0xa00000 --with-datapartitionsize=0x13C0000";;
	 7) TARGET="--enable-hl101";;
	 8) TARGET="--enable-vip2";;
	 9) TARGET="--enable-cuberevo";;
	10) TARGET="--enable-cuberevo_mini";;
	11) TARGET="--enable-cuberevo_mini2";;
	12) TARGET="--enable-cuberevo_250hd";;
	13) TARGET="--enable-homecast5101";;
	14) TARGET="--enable-octagon1008";;
	 *) TARGET="--enable-ufs910";;
esac
CONFIGPARAM="$CONFIGPARAM $TARGET"

##############################################

echo "Kernel:"
echo " 1) STM 22 P0041"
echo " 2) STM 23 P0119 (instable)"
echo " 3) STM 23 P0119 with Havana (instable)"
echo " 4) STM 23 P0123 (instable)"
#echo " 5) STM 24 P0201 (not working)"
case $2 in
        [1-5]) REPLY=$2
        echo -e "\nSelected kernel: $REPLY\n"
        ;;
        *)
        read -p "Select kernel (1-5)? ";;
esac

case "$REPLY" in
	1) KERNEL="--enable-stm22 --enable-p0041";;
	2) KERNEL="--enable-stm23 --enable-p0119";;
	3) KERNEL="--enable-stm23 --enable-p0119 --enable-havana";;
	4) KERNEL="--enable-stm23 --enable-p0123";;
	5) KERNEL="--enable-stm24 --enable-p0201";;
	*) KERNEL="--enable-stm22 --enable-p0041";;
esac
CONFIGPARAM="$CONFIGPARAM $KERNEL"

##############################################
if [ "$3" ]; then 
 REPLY="$3"
 echo "Activate debug (y/N)? "
 echo -e "\nSelected option: $REPLY\n"
else
 REPLY=N
 read -p "Activate debug (y/N)? "
fi
[ "$REPLY" == "y" -o "$REPLY" == "Y" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"

##############################################

# Enable this option if you want to use the latest version of every package.
# The latest version might have solved some bugs, but might also have
# introduced new ones
# CONFIGPARAM="$CONFIGPARAM --enable-bleeding-edge"

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

#Dagobert: I find it sometimes useful to know
#what I have build last in this directory ;)
echo $CONFIGPARAM >lastChoice

echo "-----------------------"
echo "Your build enivroment is ready :-)"
echo "Your next step could be:"
echo "make yaud-enigma2"
echo "make yaud-enigma2-nightly"
echo "make yaud-neutrino"
echo "make yaud-vdr"
echo "-----------------------"
