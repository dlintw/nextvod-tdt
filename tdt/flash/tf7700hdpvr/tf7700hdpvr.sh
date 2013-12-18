#!/bin/bash
if [ `id -u` != 0 ]; then
	echo "You are not running this script as root. Try it again as root or with su/sudo command."
	echo "Bye Bye..."
	exit
fi

CURDIR=`pwd`
BASEDIR=$CURDIR/../..

TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk
TFINSTALLERDIR=$CDKDIR/tfinstaller

cd $CDKDIR
make u-boot.do_compile
make -C tfinstaller tfpacker
make tfinstaller/u-boot.ftfd
make tfinstaller

mkdir -p $CURDIR/out
rm -rf $CURDIR/out/*
cp $TFINSTALLERDIR/Enigma_Installer.ini $CURDIR/out/
cp $TFINSTALLERDIR/Enigma_Installer.tfd $CURDIR/out/
cp $TFINSTALLERDIR/uImage $CURDIR/out/

cp $CURDIR/audio.elf $TUFSBOXDIR/release/boot/
cp $CURDIR/video.elf $TUFSBOXDIR/release/boot/

cd $TUFSBOXDIR/release/
tar -cvzf $CURDIR/out/rootfs.tar.gz *
cd -

echo "REMEMBER THAT AUDIO.ELF and VIDEO:ELF have to exist"
echo "ALSO REMEMBER THAT YOU NEED THE PLAYER2 HEADER FILES"
