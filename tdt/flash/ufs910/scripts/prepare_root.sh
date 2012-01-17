#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPVARDIR=$4
TMPKERNELDIR=$5

cp -a $RELEASEDIR/* $TMPROOTDIR

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

# --- VAR ---
mv $TMPROOTDIR/var/* $TMPVARDIR

# --- ROOT ---
echo "/dev/mtdblock3	/var	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab

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
cd -



#TODO: We need to strip the ROOT further as there is no chance that this will fit into the flash at the moment !!!
#TODO: Also how to use VAR best ?
