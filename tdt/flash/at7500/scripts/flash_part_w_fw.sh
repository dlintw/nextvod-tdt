#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPKERNELDIR=$4
TMPFWDIR=$5
TMPROOTDIR=$6

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "TMPFWDIR     = $TMPFWDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
FUP=$CURDIR/fup

OUTFILE=$OUTDIR/update_w_fw.ird

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
fi

cp $TMPKERNELDIR/uImage $CURDIR/uImage

# Create a jffs2 partition for fw's
# Size 6.875  MB = -p0x6E0000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./fw
# ./fw/audio.elf
# ./fw/video.elf
$MKFSJFFS2 -qUfv -p0x6E0000 -e0x20000 -r $TMPFWDIR -o $CURDIR/mtd_fw.bin

# Create a jffs2 partition for root
# Size 30     MB = -p0x1E00000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./release
# ./release/etc
# ./release/usr
$MKFSJFFS2 -qUfv -p0x1E00000 -e0x20000 -r $TMPROOTDIR -o $CURDIR/mtd_root.bin

# Create a fortis signed update file for fw's 
# Note: -g is a workaround which will be removed as soon as the missing conf partition is found
# Note: -e could be used as a extension partition but at the moment we dont use it
$FUP -ce $OUTFILE -k $CURDIR/uImage -f $CURDIR/mtd_fw.bin -g $CURDIR/dummy.squash.signed.padded -e $CURDIR/dummy.squash.signed.padded -r $CURDIR/mtd_root.bin

rm -f $CURDIR/uImage
#rm -f $CURDIR/mtd_fw.bin
#rm -f $CURDIR/mtd_root.bin

zip $OUTFILE.zip $OUTFILE
