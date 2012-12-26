CURDIR=`pwd`
BASEDIR=$CURDIR/../..


TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk

EXTRADIR=$CURDIR/extra
SCRIPTDIR=$CURDIR/scripts
TMPDIR=$CURDIR/tmp
TMPROOTDIR=$TMPDIR/ROOT
TMPKERNELDIR=$TMPDIR/KERNEL
TMPFWDIR=$TMPDIR/FW
TMPTINYROOTDIR=$TMPDIR/TINYROOT
TMPTINYKERNELDIR=$TMPDIR/TINYKERNEL

OUTDIR=$CURDIR/out

if [  -e $TMPDIR ]; then
  rm -rf $TMPDIR/*
fi

mkdir $TMPDIR
mkdir $TMPROOTDIR
mkdir $TMPKERNELDIR
mkdir $TMPFWDIR

echo "This script creates flashable images for Kathrein UFS913"
echo "Author: Schischu"
echo "Date: 07-17-2012"
echo "-----------------------------------------------------------------------"
echo "It's expected that an image was already build prior to this execution!"
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
	1)  echo "Preparing Enigma2 Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR;;
	2)  echo "Preparing Neutrino Root..."
		$SCRIPTDIR/prepare_root.sh $CURDIR $TUFSBOXDIR/release_neutrino $TMPROOTDIR $TMPKERNELDIR $TMPFWDIR;;
	*)  "Invalid Input! Exiting..."
		exit 2;;
esac
echo "Root prepared"
echo "Checking if flashtool mup exists..."
if [ ! -e $CURDIR/mup ]; then
  echo "Flashtool mup is missing, trying to compile it..."
  cd $CURDIR/../common/mup.src
  $CURDIR/../common/mup.src/compile.sh
  mv $CURDIR/../common/mup.src/mup $CURDIR/mup
  cd $CURDIR
  if [ ! -e $CURDIR/mup ]; then
    echo "Compiling failed! Exiting..."
    exit 3
  else
    echo "Compiling successfull"
  fi
fi
echo "Flashtool mup exists"
echo "-----------------------------------------------------------------------"
echo "Creating tiny image..."
$SCRIPTDIR/prepare_tiny.sh $CURDIR $EXTRADIR $TMPTINYROOTDIR $TMPTINYKERNELDIR
$SCRIPTDIR/flash_tiny.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPTINYKERNELDIR $TMPTINYROOTDIR

echo "-----------------------------------------------------------------------"
echo "Checking targets..."
echo "Found flashtarget:"
echo "   1) KERNEL with ROOT and FW"
read -p "Select flashtarget (1-1)? "
case "$REPLY" in
	1)  echo "Creating KERNEL with ROOT and FW..."
		$SCRIPTDIR/flash_part_w_fw.sh $CURDIR $TUFSBOXDIR $OUTDIR $TMPKERNELDIR $TMPFWDIR $TMPROOTDIR;;
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
echo "To flash the created image copy the *.img file to"
echo "your usb drive in the subfolder /kathrein/ufs913/"
echo ""
echo "Remember, if this is the first time you flash Enigma2 or Neutrino,"
echo "you will need to flash the updatescript.sh first."
echo "The script can be found in the extras folder, copy it to /kathrein/ufs913/ on your usb drive."
