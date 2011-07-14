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

if [  -e $CURDIR/extras/dev_ufs910.tar.gz ]; then
  sudo tar -xzf $CURDIR/extras/dev_ufs910.tar.gz -C $TMPROOTDIR/dev/
fi



#TODO: We need to strip the ROOT further as there is no chance that this will fit into the flash at the moment !!!
#TODO: Also how to use VAR best ?
