#!/bin/sh

# default installation device
HDD=/dev/sda

# Check if the correct MTD setup has been used
if [ -z "`cat /proc/mtd | grep mtd3 | grep 'TF Kernel'`" ]
then
        echo 'ERR MTD' > /dev/fplarge
        echo 'ERR MTD'
        exit 1
fi


# Give the system a chance to recognize the USB stick
echo "Mounting USB stick"
echo '   9'     > /dev/fpsmall
echo 'USB STCK' > /dev/fplarge
sleep 5
mkdir /instsrc
mount -t vfat /dev/sdb1 /instsrc
if [ $? -ne 0 ]; then
 mount -t vfat /dev/sdb /instsrc
  if [ $? -ne 0 ]; then
    echo "USB" > /dev/fpsmall
    echo "FAILED" > /dev/fplarge
    exit
  fi
fi


# If the file topfield.tfd is located on the stick, flash it
if [ -f /instsrc/topfield.tfd ]; then

  echo
  echo Please stand by. This will take about 1.5 minutes...
  echo After the reboot of the box, it may take another 2 or
  echo 3 minutes until the picture comes back
  echo

  cat /instsrc/topfield.tfd | tfd2mtd > /dev/mtdblock5
  mv /instsrc/topfield.tfd /instsrc/topfield.tfd_
  dd if=/dev/zero of=/dev/sda bs=512 count=64
  umount /instsrc

  echo Shutting down
  reboot
  exit
fi
mkdir /instdest

export KEEPSETTINGS=`grep -i 'keepsettings' /instsrc/Enigma_Installer.ini 2>/dev/null`
export NOFORMAT=`grep -i 'noformat' /instsrc/Enigma_Installer.ini 2>/dev/null`
export NOPARTITION=`grep -i 'nopartition' /instsrc/Enigma_Installer.ini 2>/dev/null`
export NOUPDATE=`grep -i 'noupdate' /instsrc/Enigma_Installer.ini 2>/dev/null`
export USBHDD=`grep -i 'usbhdd' /instsrc/Enigma_Installer.ini 2>/dev/null`

if [ "$USBHDD" != "" ]; then
  HDD=/dev/sdb
fi

ROOTFS=$HDD"1"
SWAPFS=$HDD"2"
DATAFS=$HDD"3"

# If the keyword 'keepsettings' has been specified, save some config files to the disk
if [ $KEEPSETTINGS ]; then
  if [ ! -d /instsrc/e2settings ]; then
    echo Saving settings
    mkdir /instsrc/e2settings
    mount $ROOTFS /instdest
    cp /instdest/usr/local/share/enigma2/timers.xml /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/settings /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/profile /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/lamedb /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/bouquets.* /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/keymap.xml /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/module.list /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/satellites.xml /instsrc/e2settings
    cp /instdest/usr/local/share/enigma2/skin.xml /instsrc/e2settings
    cp /instdest/etc/network/interfaces /instsrc/e2settings
    cp /instdest/etc/tffpctl.conf /instsrc/e2settings
    umount /instdest
  else
    echo Settings are already on the stick
  fi
fi

if [ "$USBHDD" != "" ]; then
  # the following is only executed when usbhdd is selected
  echo "Preparing installation to USB HDD"
  mkdir /instsrc1
  if [ -d /initsrc/settings ]; then
    cp -r /instsrc/settings /instsrc1
  fi
  cp /instsrc/rootfs.tar.gz /instsrc1
  if [ $? != 0 ]; then
    echo "error copying files to RAM disk"
    echo 'FAIL'     > /dev/fpsmall
    echo 'RAMDISK'  > /dev/fplarge
    exit
  fi

  # remount the RAM disk
  umount /instsrc
  mv /instsrc /instsrc_
  mv /instsrc1 /instsrc

  echo "waiting for USB stick to be detached"
  echo 'STCK'     > /dev/fpsmall
  echo ' DETACH'  > /dev/fplarge

  while (true) do
    if [ "`grep sdb /proc/diskstats`" == "" ]; then
      break
    fi
    sleep 1
  done

  echo "USB detached"
  echo ' HDD'     > /dev/fpsmall
  echo ' ATTACH'  > /dev/fplarge

  while (true) do
    if [ "`grep sdb /proc/diskstats`" != "" ]; then
      break
    fi
    sleep 1
  done

  echo "USB attached"
fi

# Skip formatting if the keyword 'noformat' is specified in the control file
if [ $NOFORMAT ]; then
  echo Checking hdd
  echo '   8'     > /dev/fpsmall
  echo 'HDD CHK'  > /dev/fplarge

  fsck.ext3 -y $ROOTFS
  fsck.ext2 -y $DATAFS
else
  if [ -z $NOPARTITION ]; then
    # Erase the disk and create 3 partitions
    #  1:   2GB Linux
    #  2: 512MB Swap
    #  3: remaining space as Linux
    echo "Partitioning HDD"
    echo '   8'     > /dev/fpsmall
    echo 'HDD PART' > /dev/fplarge
    dd if=/dev/zero of=$HDD bs=512 count=64
    sfdisk --re-read $HDD
    sfdisk $HDD -uM << EOF
,2048,L
,256,S
,,L
;
EOF
  else
    echo Skipping partitioning of the disk
  fi


  # Format both Linux partitions
  echo "Formatting HDD"
  echo '   7'     > /dev/fpsmall
  echo 'HDD FMT'  > /dev/fplarge
  ln -s /proc/mounts /etc/mtab
  mkfs.ext3 $ROOTFS

  if [ -z $NOPARTITION ]; then
    echo '   6'     > /dev/fpsmall
    mkfs.ext2 $DATAFS
  fi


  # Initialise the swap partition
  echo '   5'     > /dev/fpsmall
  echo 'HDD SWAP' > /dev/fplarge
  mkswap $SWAPFS
fi


# Skip rootfs installation if the keyword 'noupdate' is specified in the control file
if [ -z $NOUPDATE ]; then
  echo "Installing root file system"
  echo '   4'     > /dev/fpsmall
  echo 'ROOT FS'  > /dev/fplarge
  mount $ROOTFS /instdest
  cd /instdest
  gunzip -c /instsrc/rootfs.tar.gz | tar -xv
  if [ $USBHDD ]; then
    sed -e "s#sda#sdb#g" etc/fstab > fstab1
    mv fstab1 etc/fstab
    sed -e "s#sda#sdb#g" etc/init.d/rcS > rcS1
    mv rcS1 etc/init.d/rcS
    chmod 744 etc/init.d/rcS
  fi
  cd ..
  umount /instdest
else
  echo Skipping root file system
fi


# Restore the settings
if [ $KEEPSETTINGS ]; then
  echo Restoring settings
  mount $ROOTFS /instdest
  cp /instsrc/e2settings/timers.xml     /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/settings       /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/profile        /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/lamedb         /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/bouquets.*     /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/keymap.xml     /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/module.list    /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/satellites.xml /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/skin.xml       /instdest/usr/local/share/enigma2
  cp /instsrc/e2settings/interfaces     /instdest/etc/network
  cp /instsrc/e2settings/tffpctl.conf	/instdest/etc
  umount /instdest
fi

# Make sure that the data partition contains subdirectories
mkdir -p /mnt
mount $DATAFS /mnt
mkdir -p /mnt/movie
mkdir -p /mnt/music
mkdir -p /mnt/picture
umount /mnt

# Write U-Boot settings into the flash
echo "Flashing U-Boot settings"
echo '   3'     > /dev/fpsmall
echo 'LOADER'   > /dev/fplarge
dd if=/deploy/u-boot.mtd1 of=/dev/mtdblock1  
if [ $? -ne 0 ]; then  
  echo "FAIL" > /dev/fpsmall  
  exit  
fi  
if [ "$USBHDD" != "" ]; then
  dd if=/deploy/U-Boot_Settings_usb.mtd2 of=/dev/mtdblock2
else
  dd if=/deploy/U-Boot_Settings_hdd.mtd2 of=/dev/mtdblock2
fi
if [ $? -ne 0 ]; then
  echo "FAIL" > /dev/fpsmall
  exit
fi


# write the kernel to flash
echo "Flashing kernel"
echo '   2'     > /dev/fpsmall
echo 'KERNEL'   > /dev/fplarge
mount $ROOTFS /instdest
dd if=/instdest/boot/uImage of=/dev/mtdblock3
if [ $? -ne 0 ]; then
  echo "FAIL" > /dev/fpsmall
  exit
fi


# unmount and check the file system
echo '   1'     > /dev/fpsmall
echo 'FSCK'     > /dev/fplarge
umount /instdest
rmdir /instdest
fsck.ext3 -y $ROOTFS


# rename uImage to avoid infinite installation loop
if [ "$USBHDD" == "" ]; then
  mv -f /instsrc/uImage /instsrc/uImage_
  umount /instsrc
fi


# Reboot
echo '   0'     > /dev/fpsmall
echo 'REBOOT'   > /dev/fplarge
sleep 2
reboot
