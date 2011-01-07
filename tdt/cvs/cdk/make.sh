#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-18)"
 echo "Parameter 2: kernel (1-4)"
 echo "Parameter 3: debug (Y/N)"
 echo "Parameter 4: player(1-2)"
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
echo " 8) Edision Argus vip"
echo " 9) Cuberevo (IPBOX 9000)"
echo "10) Cuberevo mini (IPBOX 900)"
echo "11) Cuberevo mini2 (IPBOX 910)"
echo "12) Cuberevo 250 (IPBOX 91)"
echo "13) Cuberevo 9500HD (7000HD)"
echo "14) Cuberevo 2000HD"
echo "15) Cuberevo mini_fta (200HD)"
echo "16) Homecast 5101"
echo "17) Octagon 1008"
echo "18) SPARK"
echo "19) Atevio7500"
case $1 in
	[1-9] | 1[0-9]) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-19)? ";;
esac

case "$REPLY" in
	 1) TARGET="--enable-ufs910";;
	 2) TARGET="--enable-flash_ufs910 --with-rootpartitionsize=0x9e0000 --with-datapartitionsize=0x480000";;
	 3) TARGET="--enable-ufs912";;
	 4) TARGET="--enable-ufs922";;
	 5) TARGET="--enable-tf7700";;
	 6) TARGET="--enable-fortis_hdbox --with-rootpartitionsize=0xa00000 --with-datapartitionsize=0x13C0000";;
	 7) TARGET="--enable-hl101";;
	 8) TARGET="--enable-vip";;
	 9) TARGET="--enable-cuberevo";;
	10) TARGET="--enable-cuberevo_mini";;
	11) TARGET="--enable-cuberevo_mini2";;
	12) TARGET="--enable-cuberevo_250hd";;
	13) TARGET="--enable-cuberevo_9500hd";;
	14) TARGET="--enable-cuberevo_2000hd";;
	15) TARGET="--enable-cuberevo_mini_fta";;
	16) TARGET="--enable-homecast5101";;
	17) TARGET="--enable-octagon1008";;
	18) TARGET="--enable-spark";;
	19) TARGET="--enable-atevio7500";;
	 *) TARGET="--enable-ufs910";;
esac
CONFIGPARAM="$CONFIGPARAM $TARGET"

case "$REPLY" in
        8) REPLY=$3
			echo -e "\nModels:"
			echo " 1) VIP1 v1 [ single tuner + 2 CI + 2 USB ]"
			echo " 2) VIP1 v2 [ single tuner + 2 CI + 1 USB + plug & play tuner (dvb-s2/t/c) ]"
			echo " 3) VIP2 v1 [ twin tuner ]"
			
        	read -p "Select Model (1-3)? "
        		
			case "$REPLY" in
				1) MODEL="--enable-hl101";;
				2) MODEL="--enable-vip1_v2";;
				3) MODEL="--enable-vip2_v1";;
				*) MODEL="--enable-vip2_v1";;
			esac
			CONFIGPARAM="$CONFIGPARAM $MODEL"
        	;;
        18) REPLY=$3
			echo -e "\nRemotes:"
			echo " 1) spark(rcu-05:HOF-54M15)"
			echo " 2) rc08(rcu-08:HOF-55C)"

        	read -p "Select Remote (1-2)? "

			case "$REPLY" in
				1) REMOTE="--enable-remote-spark";;
				2) REMOTE="--enable-remote-rc08";;
				*) REMOTE="--enable-remote-spark";;
			esac
			CONFIGPARAM="$CONFIGPARAM $REMOTE"
        	;;
        *)
esac

##############################################

echo -e "\nKernel:"
echo " Maintained:"
echo "   1) STM 22 P0041"
echo "   2) STM 23 P0119"
echo " Experimental:"
echo "   3) STM 23 P0119 with Havana"
echo "   4) STM 23 P0123"
#echo "   5) STM 24 P0201 (not working)"
#echo "   6) STM 24 P0205 (experimental)"
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
	6) KERNEL="--enable-stm24 --enable-p0205";;
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

echo -e "\nPlayer:"
echo "   1) Player 131"
echo "   2) Player 179"
case $4 in
        [1-2]) REPLY=$4
        echo -e "\nSelected player: $REPLY\n"
        ;;
        *)
        read -p "Select player (1-2)? ";;
esac

case "$REPLY" in
	1) PLAYER="--enable-player131"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi
       
       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_131 player2
       ln -s stmfb_player131 stmfb
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_131 player2
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s stmfb_player131 stmfb
       cd -
    ;;
	2) PLAYER="--enable-player179"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi
       
       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_179 player2
       ln -s stmfb-3.1_stm23_0032 stmfb
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_179 player2
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s stmfb-3.1_stm23_0032 stmfb
       cd -
    ;;
	*) PLAYER="--enable-player131";;
esac
CONFIGPARAM="$CONFIGPARAM $PLAYER"

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
if [ ! -e $KATIDIR/cvs/driver/include/player2/acc_defines.h ]; then
 echo "WARNING: Player2 Header files not found!"
 echo "         Player2 will not be build!"
 echo "         Please install the Player2 Header files and rerun this script"
 sed -i 's/^obj-y	+= player2\/$/#obj-y	+= player2\//g' $KATIDIR/cvs/driver/Makefile
else
 sed -i 's/^#obj-y	+= player2\//obj-y	+= player2\//g' $KATIDIR/cvs/driver/Makefile
fi

echo "-----------------------"
echo "Your build enivroment is ready :-)"
echo "Your next step could be:"
echo "make yaud-enigma2"
echo "make yaud-enigma2-nightly"
echo "make yaud-neutrino"
echo "make yaud-vdr"
echo "-----------------------"
