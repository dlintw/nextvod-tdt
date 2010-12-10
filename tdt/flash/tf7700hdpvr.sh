CURDIR=`pwd`
BASEDIR=$CURDIR/..

TUFSBOXDIR=$BASEDIR/tufsbox
CDKDIR=$BASEDIR/cvs/cdk
TFINSTALLERDIR=$CDKDIR/tfinstaller

cd $CDKDIR
make u-boot.do_compile
make -C tfinstaller tfpacker
make tfinstaller/u-boot.ftfd
make tfinstaller

mkdir -p $TUFSBOXDIR/tf7700
rm -rf $TUFSBOXDIR/tf7700/*
cp $TFINSTALLERDIR/Enigma_Installer.ini $TUFSBOXDIR/tf7700/
cp $TFINSTALLERDIR/Enigma_Installer.tfd $TUFSBOXDIR/tf7700/
cp $TFINSTALLERDIR/uImage $TUFSBOXDIR/tf7700/

cp $CURDIR/audio.elf $TUFSBOXDIR/release/boot/
cp $CURDIR/video.elf $TUFSBOXDIR/release/boot/

cd $TUFSBOXDIR/release/
tar -cvzf $TUFSBOXDIR/tf7700/rootfs.tar.gz *
cd -

echo "REMEMBER THAT AUDIO.ELF and VIDEO:ELF have to exist"
echo "ALSO REMEMBER THAT YOU NEED THE PLAYER2 HEADER FILES"
