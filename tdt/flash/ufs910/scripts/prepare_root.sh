#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4

cp -a $RELEASEDIR/* $TMPROOTDIR

mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

mv $TMPROOTDIR/boot/bootlogo.mvi $TMPROOTDIR/etc/bootlogo.mvi
sed -i "s/\/boot\/bootlogo.mvi/\/etc\/bootlogo.mvi/g" $TMPROOTDIR/etc/init.d/rcS

rm -f $TMPROOTDIR/boot/*

echo "/dev/mtdblock3	/var	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab

if [  -e $CURDIR/extras/dev_ufs910.tar.gz ]; then
  sudo tar -xzf $CURDIR/extras/dev_ufs910.tar.gz -C $TMPROOTDIR/dev/
fi

#TODO: We need to strip the root further as there is no chance that this will fit into the flash at the moment !!!
