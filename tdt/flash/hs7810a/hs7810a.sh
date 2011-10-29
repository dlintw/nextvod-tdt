CURDIR=`pwd`
BASEDIR=$CURDIR/../..


TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk

SCRIPTDIR=$CURDIR/scripts
TMPDIR=$CURDIR/tmp
TMPROOTDIR=$TMPDIR/ROOT
TMPKERNELDIR=$TMPDIR/KERNEL
TMPFWDIR=$TMPDIR/FW

OUTDIR=$CURDIR/out

if [ $# == "0" ]; then
  if [  -e $TMPDIR ]; then
    sudo rm -rf $TMPDIR/*
  else
    mkdir $TMPDIR
  fi
fi

mkdir $TMPROOTDIR
mkdir $TMPKERNELDIR
mkdir $TMPFWDIR

echo "This script creates flashable images for Fortis HS7910a"
echo "Author: Schischu"
echo "Date: 10-25-2011"
echo "-----------------------------------------------------------------------"
echo "It's expected that a images was already build prior to this execution!"
echo "-----------------------------------------------------------------------"

$BASEDIR/flash/common/common.sh $BASEDIR/flash/common/

echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found targets:"
if [  -e $TUFSBOXDIR/release ]; then
  echo "   1) Prepare Enigma2"
fi
if [  -e $TUFSBOXDIR/release_neutrino ]; then
  echo "   2) Prepare Neutrino"
fi

read -p "Select target (1-2)? "
case "$REPLY" in
	0)  echo "Skipping...";;
	1)  echo "Preparing Enigma2 Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR;;
	2)  echo "Preparing Neutrino Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release_neutrino $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 2;;
esac
echo "Root prepared"
echo "Checking if flashtool fup exists..."
if [ ! -e $CURDIR/fup ]; then
  echo "Flashtool fup is missing, trying to compile it..."
  cd $CURDIR/../common/fup.src
  $CURDIR/../common/fup.src/compile.sh USE_ZLIB
  mv $CURDIR/../common/fup.src/fup $CURDIR/fup
  cd $CURDIR
  if [ ! -e $CURDIR/fup ]; then
    echo "Compiling failed! Exiting..."
    echo "It the error is \"cannot find -lz\" than you need to install the 32bit version of libz"
    exit 3
  else
    echo "Compiling successfull"
  fi
fi

if [ ! -e $CURDIR/dummy.squash.signed.padded ]; then
  cp $CURDIR/../common/fup.src/dummy.squash.signed.padded $CURDIR/dummy.squash.signed.padded
fi

echo "Flashtool fup exists"
echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found flashtarget:"
#echo "   1) KERNEL with ROOT"
echo "   2) KERNEL with ROOT and FW"
echo "   3) KERNEL"
#echo "   4) FW"
read -p "Select flashtarget (1-4)? "
case "$REPLY" in
#	1)  echo "Creating KERNEL with ROOT..."
#		$SCRIPTDIR/flash_part_wo_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPROOTDIR;;
	2)  echo "Creating KERNEL with ROOT and FW..."
		$SCRIPTDIR/flash_part_w_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPFWDIR $TMPROOTDIR;;
	3)  echo "Creating KERNEL..."
		$SCRIPTDIR/flash_part_kernel.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR;;
#	4)  echo "Creating FW..."
#		$SCRIPTDIR/flash_part_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 3;;
esac
clear
echo "-----------------------------------------------------------------------"
AUDIOELFSIZE=`stat -c %s $TMPFWDIR/audio.elf`
VIDEOELFSIZE=`stat -c %s $TMPFWDIR/video.elf`
if [ $AUDIOELFSIZE == "0" ]; then
  echo "!!! WARNING: AUDIOELF SIZE IS ZERO !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo "-----------------------------------------------------------------------"
fi
if [ $VIDEOELFSIZE == "0" ]; then
  echo "!!! WARNING: VIDEOELF SIZE IS ZERO !!!"
  echo "IF YOUR ARE CREATING THE FW PART MAKE SURE THAT YOU USE CORRECT ELFS"
  echo "-----------------------------------------------------------------------"
fi
if [ ! -e $TMPROOTDIR/dev/mtd0 ]; then
  echo "!!! WARNING: DEVS ARE MISSING !!!"
  echo "IF YOUR ARE CREATING THE ROOT PART MAKE SURE THAT YOU USE A CORRECT DEV.TAR"
  echo "-----------------------------------------------------------------------"
fi

echo ""
echo ""
echo ""
echo "-----------------------------------------------------------------------"
echo "Flashimage created:"
echo `ls $OUTDIR`

echo "-----------------------------------------------------------------------"
echo "To flash the created image copy the *.ird file to"
echo "your usb drive"
echo ""

