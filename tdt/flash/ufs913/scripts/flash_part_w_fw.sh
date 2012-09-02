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
SUMTOOL=$TUFSBOXDIR/host/bin/sumtool
MUP=$CURDIR/mup

OUTFILE=$OUTDIR/ufs913.software.V1.00.B00.data

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

cp $TMPKERNELDIR/uImage $CURDIR/uImage

# Create a jffs2 partition for fw's
# Size 8mb = -p0x800000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./fw
# ./fw/audio.elf
# ./fw/video.elf
$MKFSJFFS2 -qnUfv -p0x800000 -e0x20000 -r $TMPFWDIR -o $CURDIR/mtd_fw.bin
$SUMTOOL -v -p -e 0x20000 -i $CURDIR/mtd_fw.bin -o $CURDIR/mtd_fw.sum.bin
# Create a jffs2 partition for root
# Size 64mb = -p0x4000000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./release
# ./release/etc
# ./release/usr
$MKFSJFFS2 -qnUfv -p0x4000000 -e0x20000 -r $TMPROOTDIR -o $CURDIR/mtd_root.bin
$SUMTOOL -v -p -e 0x20000 -i $CURDIR/mtd_root.bin -o $CURDIR/mtd_root.sum.bin

# Create a kathrein update file for fw's 
# To get the partitions erased we first need to fake an yaffs2 update
#$MUP c $OUTFILE << EOF
#3
#0x00000000, 0x00800000, 3, foo
#0x00800000, 0x04000000, 3, foo
#0x00400000, 0x0, 0, uImage
#0x00000000, 0x0, 1, mtd_fw.sum.bin
#0x00800000, 0x0, 1, mtd_root.sum.bin
#;
#EOF

cp $CURDIR/uImage $OUTDIR/uImage.bin
cp $CURDIR/mtd_fw.sum.bin $OUTDIR/
cp $CURDIR/mtd_root.sum.bin $OUTDIR/

rm -f $CURDIR/uImage
rm -f $CURDIR/mtd_fw.bin
rm -f $CURDIR/mtd_root.bin
rm -f $CURDIR/mtd_fw.sum.bin
rm -f $CURDIR/mtd_root.sum.bin

zip $OUTFILE.zip $OUTDIR/*
