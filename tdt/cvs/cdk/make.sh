#!/bin/bash

if [ "$1" == -h ] || [ "$1" == --help ]; then
 echo "Parameter 1: target system (1-18)"
 echo "Parameter 2: kernel (1-4)"
 echo "Parameter 3: debug (Y/N)"
 echo "Parameter 4: player(1-2)"
 echo "Parameter 5: Multicom(1-2)"
 echo "Parameter 6: Media Framwork(1-2)"
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
echo "20) SPARK7162"
echo "21) IPBOX9900"
echo "22) IPBOX99"
echo "23) IPBOX55"
echo "24) Fortis HS7810A"
echo "25) B4Team ADB 5800S"

case $1 in
	[1-9] | 1[0-9] | 2[0-9]) REPLY=$1
	echo -e "\nSelected target: $REPLY\n"
	;;
	*)
	read -p "Select target (1-25)? ";;
esac

case "$REPLY" in
	 1) TARGET="--enable-ufs910 --with-rootpartitionsize=0x9e0000 --with-datapartitionsize=0x480000";;
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
	17) TARGET="--enable-octagon1008 --with-rootpartitionsize=0xa00000 --with-datapartitionsize=0x13C0000";;
	18) TARGET="--enable-spark";;
	19) TARGET="--enable-atevio7500";;
	20) TARGET="--enable-spark7162";;
	21) TARGET="--enable-ipbox9900";;
	22) TARGET="--enable-ipbox99";;
	23) TARGET="--enable-ipbox55";;
	24) TARGET="--enable-hs7810a --with-rootpartitionsize=0xa00000 --with-datapartitionsize=0x13C0000";;
	25) TARGET="--enable-adb_box";;
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
        *)
esac

##############################################

echo -e "\nKernel:"
echo " Maintained:"
echo "   4) STM 23 P0123"
echo "   6) STM 24 P0205"
echo "   8) STM 24 P0207 (Recommended)"
echo " Experimental:"
echo "   9) HAVANA P0207-5 (experimental)"
echo " Deprecated (Not maintained):"
echo "   1) STM 22 P0041"
echo "   2) STM 23 P0119"
case $2 in
        [1-9]) REPLY=$2
        echo -e "\nSelected kernel: $REPLY\n"
        ;;
        *)
        read -p "Select kernel (1-9)? ";;
esac

case "$REPLY" in
	1) KERNEL="--enable-stm22 --enable-p0041";;
	2) KERNEL="--enable-stm23 --enable-p0119";;
	3) KERNEL="--enable-stm23 --enable-p0119 --enable-havana";;
	4) KERNEL="--enable-stm23 --enable-p0123";;
	5) KERNEL="--enable-stm24 --enable-p0201";STMFB="stm24";;
	6) KERNEL="--enable-stm24 --enable-p0205";STMFB="stm24";;
	7) KERNEL="--enable-stm24 --enable-p0206";STMFB="stm24";;
	8) KERNEL="--enable-stm24 --enable-p0207";STMFB="stm24";;
	9) KERNEL="--enable-stm24 --enable-havana-p0207_5";STMFB="stm24";;
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

cd ../driver/
echo "# Automatically generated config: don't edit" > .config
echo "#" >> .config
echo "export CONFIG_ZD1211REV_B=y" >> .config
echo "export CONFIG_ZD1211=n"		>> .config
cd -

##############################################

echo -e "\nPlayer:"
echo "   1) Player 131 (Deprecated)"
echo "   2) Player 179"
echo "   3) Player 191 (Recommended)"
case $4 in
        [1-3]) REPLY=$4
        echo -e "\nSelected player: $REPLY\n"
        ;;
        *)
        read -p "Select player (1-3)? ";;
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
       echo "export CONFIG_PLAYER_131=y" >> .config
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
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_179 player2
       echo "export CONFIG_PLAYER_179=y" >> .config
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -
    ;;
	3) PLAYER="--enable-player191"
       cd ../driver/include/
       if [ -L player2 ]; then
          rm player2
       fi

       if [ -L stmfb ]; then
          rm stmfb
       fi
       ln -s player2_179 player2
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -

       cd ../driver/
       if [ -L player2 ]; then
          rm player2
       fi
       ln -s player2_191 player2
       echo "export CONFIG_PLAYER_191=y" >> .config
       cd -

       cd ../driver/stgfb
       if [ -L stmfb ]; then
          rm stmfb
       fi
       if [ "$STMFB" == "stm24" ]; then
           ln -s stmfb-3.1_stm24_0102 stmfb
       else
           ln -s stmfb-3.1_stm23_0032 stmfb
       fi
       cd -
    ;;
	*) PLAYER="--enable-player131";;
esac

##############################################

echo -e "\nMulticom:"
echo "   1) Multicom 3.2.2     (Recommended for Player179)"
echo "   2) Multicom 3.2.4 rc3 (Recommended for Player191)"
case $5 in
        [1-2]) REPLY=$5
        echo -e "\nSelected multicom: $REPLY\n"
        ;;
        *)
        read -p "Select multicom (1-2)? ";;
esac

case "$REPLY" in
	1) MULTICOM="--enable-multicom322"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       cd -

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.2 multicom
       echo "export CONFIG_MULTICOM322=y" >> .config
       cd -
    ;;
	2) MULTICOM="--enable-multicom324"
       cd ../driver/include/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s ../multicom-3.2.4_rc3/include multicom
       cd -

       cd ../driver/
       if [ -L multicom ]; then
          rm multicom
       fi

       ln -s multicom-3.2.4_rc3 multicom
       echo "export CONFIG_MULTICOM324=y" >> .config
       cd -
    ;;
	*) MULTICOM="--enable-multicom322";;
esac

##############################################

echo -e "\nMedia Framework:"
echo "   1) eplayer3  (Recommended)"
echo "   2) gstreamer (Only working with enigma2 diff0 at the moment)"
case $5 in
        [1-2]) REPLY=$6
        echo -e "\nSelected media framwork: $REPLY\n"
        ;;
        *)
        read -p "Select media framwork (1-2)? ";;
esac

case "$REPLY" in
	1) MEDIAFW="";;
	2) MEDIAFW="--enable-mediafwgstreamer";;
	*) MEDIAFW="";;
esac

##############################################

CONFIGPARAM="$CONFIGPARAM $PLAYER $MULTICOM $MEDIAFW"

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
echo "make yaud-enigma1-hd"
echo "-----------------------"
