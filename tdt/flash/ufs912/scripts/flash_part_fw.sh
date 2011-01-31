#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPFWDIR=$4

echo "CURDIR     = $CURDIR"
echo "TUFSBOXDIR = $TUFSBOXDIR"
echo "OUTDIR     = $OUTDIR"
echo "TMPFWDIR   = $TMPFWDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
MUP=$CURDIR/mup

OUTFILE=$OUTDIR/update_fw.img

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
fi

# Create a jffs2 partition for fw's
# Size 8mb = -p0x800000
# Folder which contains fw's is -r fw
# e.g.
# .
# ./fw
# ./fw/audio.elf
# ./fw/video.elf
$MKFSJFFS2 -qUnfv -r $TMPFWDIR -s0x800 -p0x800000 -e0x20000 -o $CURDIR/mtd_fw.bin

# Create a kathrein update file for fw's 
# Offset on NAND Disk = 0x00400000
$MUP c $OUTFILE << EOF
2
0x00400000, 1, mtd_fw.bin
;
EOF

rm -f $CURDIR/mtd_fw.bin

zip $OUTFILE.zip $OUTFILE
