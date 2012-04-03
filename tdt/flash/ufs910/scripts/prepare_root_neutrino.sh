#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPSTORAGEDIR=$4
TMPKERNELDIR=$5

find $RELEASEDIR -mindepth 1 -maxdepth 1 -exec cp -at$TMPROOTDIR -- {} +
mkdir $TMPROOTDIR/root_rw
mkdir $TMPROOTDIR/storage
cp ../common/init_mini_fo $TMPROOTDIR/sbin/
chmod 777 $TMPROOTDIR/sbin/init_mini_fo

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

# --- STORAGE FOR MINI_FO ---
mkdir $TMPSTORAGEDIR/root_ro

cd $TMPROOTDIR/dev/
MAKEDEV="sudo $TMPROOTDIR/sbin/MAKEDEV -p $TMPROOTDIR/etc/passwd -g $TMPROOTDIR/etc/group"
${MAKEDEV} std
${MAKEDEV} fd
${MAKEDEV} hda hdb
${MAKEDEV} sda sdb sdc sdd
${MAKEDEV} scd0 scd1
${MAKEDEV} st0 st1
${MAKEDEV} sg
${MAKEDEV} ptyp ptyq
${MAKEDEV} console
${MAKEDEV} ttyAS0 ttyAS1 ttyAS2 ttyAS3
${MAKEDEV} lp par audio video fb rtc lirc st200 alsasnd mme bpamem
${MAKEDEV} ppp busmice
${MAKEDEV} input i2c mtd
${MAKEDEV} dvb
${MAKEDEV} vfd
cd -


