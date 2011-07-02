#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPKERNELDIR=$4
TMPROOTDIR=$5

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
MKSQUASHFS=$CURDIR/../common/mksquashfs4.0
SUMTOOL=$TUFSBOXDIR/host/bin/sumtool
PAD=$CURDIR/../common/pad

OUTFILE=$OUTDIR/update_w_fw.img

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
fi

# --- KERNEL ---
# Size 1,375MB !
cp $TMPKERNELDIR/uImage $CURDIR/uImage
$PAD 0x160000 $CURDIR/uImage $CURDIR/mtd_kernel.pad.bin

# --- ROOT ---
# Create a squashfs partition for root
# Size 9,875MB ! 0x9e0000
echo "MKSQUASHFS $TMPROOTDIR $CURDIR/mtd_root.bin- comp lzma -all-root"
$MKSQUASHFS $TMPROOTDIR $CURDIR/mtd_root.bin- comp lzma -all-root > /dev/null
echo "PAD 0x9e0000 $CURDIR/mtd_root.bin $CURDIR/mtd_root.pad.bin"
$PAD 0x9e0000 $CURDIR/mtd_root.bin $CURDIR/mtd_root.pad.bin

# --- VAR ---
# Size 4,5
$MKFSJFFS2 -qUfv -p0x480000 -e0x20000 -r $TMPROOTDIR -o $CURDIR/mtd_var.bin
$SUMTOOL -v -p -e 0x20000 -i $CURDIR/mtd_var.bin -o $CURDIR/mtd_var.sum.bin
$PAD 0x480000 $CURDIR/mtd_var.sum.bin $CURDIR/mtd_var.sum.pad.bin

# --- update.img ---
#Merge all 3 together
cat $CURDIR/mtd_kernel.pad.bin >> $OUTFILE
cat $CURDIR/mtd_root.pad.bin >> $OUTFILE
cat $CURDIR/mtd_var.sum.pad.bin >> $OUTFILE

rm -f $CURDIR/uImage
rm -f $CURDIR/mtd_kernel.pad.bin
rm -f $CURDIR/mtd_root.bin
rm -f $CURDIR/mtd_root.pad.bin
rm -f $CURDIR/mtd_var.bin
rm -f $CURDIR/mtd_var.sum.bin
rm -f $CURDIR/mtd_var.sum.pad.bin

zip $OUTFILE.zip $OUTFILE
