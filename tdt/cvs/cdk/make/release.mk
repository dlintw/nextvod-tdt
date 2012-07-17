# auxiliary targets for model-specific builds
release_common_utils:
#       remove the slink to busybox
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

release_cube_common:
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release/etc/init.d/reboot
	chmod 777 $(prefix)/release/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/bin/eeprom $(prefix)/release/bin
if !STM22
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox/micom.ko $(prefix)/release/lib/modules/
else
	cp $(kernelprefix)/linux/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/usb/serial/cp2101.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/cifs/cifs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/nfsd/nfsd.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/exportfs/exportfs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/nfs_common/nfs_acl.ko $(prefix)/release/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox/micom.ko $(prefix)/release/lib/modules/
endif
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/bin/tffpctl
	rm -f $(prefix)/release/bin/vfdctl
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/tfd2mtd


release_cuberevo_9500hd: release_common_utils release_cube_common
	echo "cuberevo-9500hd" > $(prefix)/release/etc/hostname

release_cuberevo_2000hd: release_common_utils release_cube_common
	echo "cuberevo-2000hd" > $(prefix)/release/etc/hostname

release_cuberevo_250hd: release_common_utils release_cube_common
	echo "cuberevo-250hd" > $(prefix)/release/etc/hostname

release_cuberevo_mini_fta: release_common_utils release_cube_common
	echo "cuberevo-mini-fta" > $(prefix)/release/etc/hostname

release_cuberevo_mini2: release_common_utils release_cube_common
	echo "cuberevo-mini2" > $(prefix)/release/etc/hostname

release_cuberevo_mini: release_common_utils release_cube_common
	echo "cuberevo-mini" > $(prefix)/release/etc/hostname

release_cuberevo: release_common_utils release_cube_common
	echo "cuberevo" > $(prefix)/release/etc/hostname

release_ufs922:
	echo "ufs922" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
if STM22
	cp $(kernelprefix)/linux/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
else
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/release/lib/modules || true
endif
	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

release_ufs912:
	echo "ufs912" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf

	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs912.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml



	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7105_pdk7105.fw

release_ufs913:
	echo "ufs913" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf

	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs912.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7111_mb618.fw

release_spark:
	echo "spark" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_spark.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release/sbin

	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/share/fonts/

if !ENABLE_P0209
	cp $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko $(prefix)/release/lib/modules/encrypt.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/bin/vdstandby

release_spark7162:
	echo "spark7162" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_spark.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/release/tuner.ko$(KERNELSTMLABEL)_spark7162 $(prefix)/release/lib/modules/spark7162.ko
	cp -f $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/i2c_spi/i2s.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/sbin/flashcp $(prefix)/release/sbin
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release/sbin

	cp -dp $(buildprefix)/root/etc/lircd_spark7162.conf $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/share/fonts/

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/bin/vdstandby

release_fortis_hdbox:
	echo "fortis" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
else
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release/lib/modules || true
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

release_atevio7500:
	echo "atevio7500" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf

	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/

	mv $(prefix)/release/lib/firmware/component_7105_pdk7105.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7111_mb618.fw

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

release_octagon1008:
	echo "octagon1008" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

release_hs7810a:
	echo "hs7810a" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_hs7810a $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7105_pdk7105.fw

release_hs7110:
	echo "hs7110" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_hs7110 $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7105_pdk7105.fw

release_whitebox:
	echo "whitebox" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_whitebox $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7105_pdk7105.fw

release_ufs910:
	echo "ufs910" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release/etc/init.d/halt
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs910.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	mv $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw

	rm -f $(prefix)/release/bin/vdstandby

release_hl101:
	echo "hl101" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_hl101 $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_hl101.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	rm -f $(prefix)/release/bin/vdstandby

release_adb_box:
	echo "Adb_Box" > $(prefix)/release/etc/hostname
	rm -f $(prefix)/release/sbin/halt
	cp $(buildprefix)/root/release/halt_adb_box $(prefix)/release/etc/init.d/halt
	chmod 777 $(prefix)/release/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release/etc/init.d/ 
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release/etc/init.d/
	chmod 755 $(prefix)/release/etc/init.d/umountfs
	chmod 755 $(prefix)/release/etc/init.d/rc
	chmod 755 $(prefix)/release/etc/init.d/sendsigs
	chmod 755 $(prefix)/release/etc/init.d/halt
	mkdir -p $(prefix)/release/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release/etc/rc.d
	ln -fs halt $(prefix)/release/sbin/reboot
	ln -fs halt $(prefix)/release/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/smartcard.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/vfd.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/stmcore-display-stx7100.ko
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/cooler.ko

	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release/lib/firmware/
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_adb_box.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_adb_box.conf $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/lircd
	mkdir -p $(prefix)/release/var/run/lirc
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/release/etc/boxtype

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

	rm -f $(prefix)/release/bin/vdstandby

release_vip1_v2: release_common_utils
	echo "Edision-v2" > $(prefix)/release/etc/hostname
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/halt_vip2 $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_vip2 $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/bin/stslave $(prefix)/release/bin
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_vip2.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
if STM23
	cp -f $(buildprefix)/root/release/vfd_vip2_stm23_0123.ko $(prefix)/release/lib/modules/vfd.ko
endif
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/local/share/fonts/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw

	rm -f $(prefix)/release/bin/vdstandby

release_vip2_v1: release_vip1_v2
	echo "Edision-v1" > $(prefix)/release/etc/hostname

release_hs5101:
	echo "hs5101" > $(prefix)/release/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button_hs5101/button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs5101/vfd.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs910.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/
	mkdir -p $(prefix)/release/var/run/lirc

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw

	rm -f $(prefix)/release/bin/vdstandby

release_tf7700: release_common_utils
	echo "tf7700" > $(prefix)/release/etc/hostname
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_tf7700.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif

	rm -f $(prefix)/release/bin/vdstandby

release_ipbox9900: release_common_utils
	echo "ipbox9900" > $(prefix)/release/etc/hostname
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/rmu/rmu.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ipbox.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd
	mkdir -p $(prefix)/release/var/run/lirc
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif

	rm -f $(prefix)/release/lib/firmware/*
	rm -f $(prefix)/release/lib/modules/boxtype.ko
	rm -f $(prefix)/release/lib/modules/bpamem.ko
	rm -f $(prefix)/release/lib/modules/lzo*.ko
	rm -f $(prefix)/release/lib/modules/ramzswap.ko
	rm -f $(prefix)/release/lib/modules/simu_button.ko
	rm -f $(prefix)/release/lib/modules/stmvbi.ko
	rm -f $(prefix)/release/lib/modules/stmvout.ko
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings

release_ipbox99: release_common_utils
	echo "ipbox99" > $(prefix)/release/etc/hostname
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ipbox.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd
	mkdir -p $(prefix)/release/var/run/lirc
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif

	rm -f $(prefix)/release/lib/firmware/*
	rm -f $(prefix)/release/lib/modules/boxtype.ko
	rm -f $(prefix)/release/lib/modules/bpamem.ko
	rm -f $(prefix)/release/lib/modules/lzo*.ko
	rm -f $(prefix)/release/lib/modules/ramzswap.ko
	rm -f $(prefix)/release/lib/modules/simu_button.ko
	rm -f $(prefix)/release/lib/modules/stmvbi.ko
	rm -f $(prefix)/release/lib/modules/stmvout.ko
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings

release_ipbox55: release_common_utils
	echo "ipbox55" > $(prefix)/release/etc/hostname
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox55/front.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ipbox.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd
	mkdir -p $(prefix)/release/var/run/lirc
	cp -p $(buildprefix)/root/release/tvmode_ipbox55 $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif

	rm -f $(prefix)/release/lib/firmware/*
	rm -f $(prefix)/release/lib/modules/boxtype.ko
	rm -f $(prefix)/release/lib/modules/bpamem.ko
	rm -f $(prefix)/release/lib/modules/lzo*.ko
	rm -f $(prefix)/release/lib/modules/ramzswap.ko
	rm -f $(prefix)/release/lib/modules/simu_button.ko
	rm -f $(prefix)/release/lib/modules/stmvbi.ko
	rm -f $(prefix)/release/lib/modules/stmvout.ko
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/etc/enigma2/settings


#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/min-release $(DEPDIR)/std-release $(DEPDIR)/max-release $(DEPDIR)/release: \
$(DEPDIR)/%release: release_base release_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)
	touch $@


release-clean:
	rm -f $(DEPDIR)/release
	rm -f $(DEPDIR)/release_base
	rm -f $(DEPDIR)/release_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)$(ADB_BOX)
	rm -f $(DEPDIR)/release_common_utils 
	rm -f $(DEPDIR)/release_cube_common


# the following target creates the common file base
release_base:
	rm -rf $(prefix)/release || true
	$(INSTALL_DIR) $(prefix)/release && \
	$(INSTALL_DIR) $(prefix)/release/bin && \
	$(INSTALL_DIR) $(prefix)/release/sbin && \
	$(INSTALL_DIR) $(prefix)/release/boot && \
	$(INSTALL_DIR) $(prefix)/release/dev && \
	$(INSTALL_DIR) $(prefix)/release/dev.static && \
	$(INSTALL_DIR) $(prefix)/release/etc && \
	$(INSTALL_DIR) $(prefix)/release/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release/etc/enigma2 && \
	ln -s /media/hdd $(prefix)/release/hdd && \
	$(INSTALL_DIR) $(prefix)/release/lib && \
	$(INSTALL_DIR) $(prefix)/release/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release/ram && \
	$(INSTALL_DIR) $(prefix)/release/var && \
	$(INSTALL_DIR) $(prefix)/release/var/etc && \
	$(INSTALL_DIR) $(prefix)/release/var/opkg && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release && \
	touch $(prefix)/release/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release/bin/ && \
	ln -s /bin/showiframe $(prefix)/release/usr/bin/showiframe && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release/bin/ && \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release/boot/audio.elf && \
	cp -a $(targetprefix)/dev/* $(prefix)/release/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/inetd.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/inetd.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/image-version $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release/etc/init.d/ && \
	cp $(targetprefix)/etc/tuxbox/satellites.xml $(prefix)/release/etc/tuxbox/ && \
	cp $(targetprefix)/etc/tuxbox/cables.xml $(prefix)/release/etc/tuxbox/ && \
	cp $(targetprefix)/etc/tuxbox/terrestrial.xml $(prefix)/release/etc/tuxbox/ && \
	ln -sf /etc/timezone.xml $(prefix)/release/etc/tuxbox/timezone.xml && \
	echo "576i50" > $(prefix)/release/etc/videomode && \
	cp -R $(targetprefix)/etc/fonts/* $(prefix)/release/etc/fonts/ && \
	cp $(buildprefix)/root/release/rcS$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(HOMECAST5101),_$(HOMECAST5101))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/release/etc/init.d/rcS && \
	chmod 755 $(prefix)/release/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/network $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release/boot/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release/bin/ && \
	cp $(buildprefix)/root/bin/vdstandby $(prefix)/release/bin/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release/lib/ && \
	rm -f $(prefix)/release/lib/*.a && \
	rm -f $(prefix)/release/lib/*.o && \
	rm -f $(prefix)/release/lib/*.la && \
	find $(prefix)/release/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

	if [ -e $(targetprefix)/usr/bin/hotplug_e2_helper ]; then \
		cp -dp $(targetprefix)/usr/bin/hotplug_e2_helper $(prefix)/release/sbin/hotplug; \
		cp -dp $(targetprefix)/usr/bin/bdpoll $(prefix)/release/sbin/; \
		rm -f $(prefix)/release/bin/hotplug; \
	else \
		cp -dp $(targetprefix)/bin/hotplug $(prefix)/release/sbin/; \
	fi;

if STM24
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release/sbin/
endif

if !STM22
	cp $(buildprefix)/root/release/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/release/etc/init.d/rcS
endif
if ENABLE_PLAYER131
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/video/stm/stm_v4l2.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/release/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";
endif
if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release/lib/modules/
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/release/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";
endif
if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release/lib/modules/
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		sound/kreplay/kreplay.ko \
		sound/kreplay/kreplay-fdma.ko \
		sound/ksound/ktone.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/release/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";
endif

if STM22
	rm $(prefix)/release/lib/modules/p2div64.ko
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release/lib/modules/

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release/lib/modules/
if ENABLE_CUBEREVO
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_MINI2
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_MINI
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_250HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_MINI_FTA
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_2000HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
endif
if ENABLE_CUBEREVO_9500HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
endif
if ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
endif
if !ENABLE_SPARK7162
if !ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release/lib/modules/
endif
endif

if !ENABLE_VIP2_V1
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release/lib/modules/
endif
endif
endif
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release/lib/modules || true
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release/lib/modules/
	find $(prefix)/release/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;

	rm -rf $(prefix)/release/lib/autofs
	rm -rf $(prefix)/release/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release/media
	$(INSTALL_DIR) $(prefix)/release/media/dvd
	$(INSTALL_DIR) $(prefix)/release/media/hdd
	$(INSTALL_DIR) $(prefix)/release/media/net

	$(INSTALL_DIR) $(prefix)/release/mnt
	$(INSTALL_DIR) $(prefix)/release/mnt/usb
	$(INSTALL_DIR) $(prefix)/release/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release/root

	$(INSTALL_DIR) $(prefix)/release/proc
	$(INSTALL_DIR) $(prefix)/release/sys
	$(INSTALL_DIR) $(prefix)/release/tmp

	$(INSTALL_DIR) $(prefix)/release/usr
	$(INSTALL_DIR) $(prefix)/release/usr/bin
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release/usr/bin/
	cp -p $(targetprefix)/usr/bin/python $(prefix)/release/usr/bin/

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release/usr/bin/
	cp -p $(targetprefix)/usr/bin/opkg-cl $(prefix)/release/usr/bin/opkg
	cp -p $(targetprefix)/usr/bin/ffmpeg $(prefix)/release/sbin/
	if [ -e $(targetprefix)/usr/bin/tuxtxt ]; then \
		cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/release/usr/bin/; \
	fi
	
	$(INSTALL_DIR) $(prefix)/release/usr/tuxtxt
	cp -p $(targetprefix)/etc/tuxbox/tuxtxt2.conf $(prefix)/release/usr/tuxtxt/
	
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release/usr/share

	ln -s /usr/local/share/enigma2 $(prefix)/release/usr/share/enigma2

	$(INSTALL_DIR) $(prefix)/release/usr/share/fonts
	cp $(targetprefix)/usr/share/fonts/ae_AlMateen.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/lcd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/md_khmurabi_10.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/nmsbd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/tuxtxt.ttf $(prefix)/release/usr/share/fonts/
	if [ -e $(targetprefix)/usr/share/fonts/tuxtxt.otb ]; then \
		cp $(targetprefix)/usr/share/fonts/tuxtxt.otb $(prefix)/release/usr/share/fonts/; \
	fi
	cp $(targetprefix)/usr/share/fonts/goodtime.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/valis_enigma.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/valis_lcd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/seg.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/seg_internat.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/Symbols.ttf $(prefix)/release/usr/share/fonts/
	if [ -e $(targetprefix)/usr/local/share/fonts/andale.ttf ]; then \
		cp $(targetprefix)/usr/local/share/fonts/andale.ttf $(prefix)/release/usr/share/fonts/; \
	fi
	
#       Font libass
	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/release/usr/share/fonts/

	$(INSTALL_DIR) $(prefix)/release/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release/usr/share/zoneinfo/

	$(INSTALL_DIR) $(prefix)/release/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release/usr/share/udhcpc/

	if [ -e $(targetprefix)/usr/share/alsa ]; then \
		mkdir $(prefix)/release/usr/share/alsa/; \
		mkdir $(prefix)/release/usr/share/alsa/cards/; \
		mkdir $(prefix)/release/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/alsa.conf          $(prefix)/release/usr/share/alsa/alsa.conf; \
		cp $(targetprefix)/usr/share/alsa/cards/aliases.conf $(prefix)/release/usr/share/alsa/cards/; \
		cp $(targetprefix)/usr/share/alsa/pcm/default.conf   $(prefix)/release/usr/share/alsa/pcm/; \
		cp $(targetprefix)/usr/share/alsa/pcm/dmix.conf      $(prefix)/release/usr/share/alsa/pcm/; fi

	ln -s /usr/local/share/keymaps $(prefix)/release/usr/share/keymaps

	$(INSTALL_DIR) $(prefix)/release/usr/local
	$(INSTALL_DIR) $(prefix)/release/usr/local/bin
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/bin/enigma2 $(prefix)/release/usr/local/bin/enigma2;fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		cp -f $(targetprefix)/usr/local/bin/enigma2 $(prefix)/release/usr/local/bin/enigma2;fi
	find $(prefix)/release/usr/local/bin/ -name  enigma2 -exec sh4-linux-strip --strip-unneeded {} \;

	ln -s /etc $(prefix)/release/usr/local/etc

	$(INSTALL_DIR) $(prefix)/release/usr/local/share
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/keymaps
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/enigma2
	cp -a $(targetprefix)/usr/local/share/enigma2/* $(prefix)/release/usr/local/share/enigma2
	cp -a $(targetprefix)/etc/enigma2/* $(prefix)/release/etc/enigma2

	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs910.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

	ln -s /usr/share/fonts $(prefix)/release/usr/local/share/fonts

	$(INSTALL_DIR) $(prefix)/release/usr/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/release/usr/lib/
	rm -rf $(prefix)/release/usr/lib/engines
	rm -rf $(prefix)/release/usr/lib/enigma2
	rm -rf $(prefix)/release/usr/lib/gconv
	rm -rf $(prefix)/release/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release/usr/lib/pkgconfig
	rm -rf $(prefix)/release/usr/lib/python2.6
	rm -rf $(prefix)/release/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release/usr/lib/X11
	rm -f $(prefix)/release/usr/lib/*.a
	rm -f $(prefix)/release/usr/lib/*.o
	rm -f $(prefix)/release/usr/lib/*.la
	find $(prefix)/release/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

	$(INSTALL_DIR) $(prefix)/release/usr/lib/enigma2
	cp -a $(targetprefix)/usr/lib/enigma2/* $(prefix)/release/usr/lib/enigma2/
	if test -d $(targetprefix)/usr/local/lib/enigma2; then \
		cp -a $(targetprefix)/usr/local/lib/enigma2/* $(prefix)/release/usr/lib/enigma2/; fi

#	Dont remove pyo files, remove pyc instead
	find $(prefix)/release/usr/lib/enigma2/ -name '*.pyc' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

#	Delete unnecessary plugins
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/DemoPlugins
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/SystemPlugins/FrontprocessorUpgrade
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/SystemPlugins/NFIFlash
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/FileManager
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/TuxboxPlugins

	$(INSTALL_DIR) $(prefix)/release/usr/lib/python2.6
	cp -a $(targetprefix)/usr/lib/python2.6/* $(prefix)/release/usr/lib/python2.6/
	rm -rf $(prefix)/release/usr/lib/python2.6/test
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/Cheetah-2.4.4-py2.6.egg-info
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml-2.0.5-py2.6.egg-info
	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxml2mod.so
	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxsltmod.so
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/OpenSSL/test
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/python_wiffi-0.5.0-py2.6.egg-info
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/setuptools
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/setuptools-0.6c8-py2.6.egg-info
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/zope.interface-3.3.0-py2.6.egg-info
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/test
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/conch
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/mail
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/manhole
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/names
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/news
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/trial
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/words
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/application
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/enterprise
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/flow
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/lore
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/pair
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/runner
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/scripts
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/tap
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/twisted/topfiles
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/Twisted-8.2.0-py2.6.egg-info
	rm -rf $(prefix)/release/usr/lib/python2.6/bsddb
	rm -rf $(prefix)/release/usr/lib/python2.6/compiler
	rm -rf $(prefix)/release/usr/lib/python2.6/config
	rm -rf $(prefix)/release/usr/lib/python2.6/ctypes
	rm -rf $(prefix)/release/usr/lib/python2.6/curses
	rm -rf $(prefix)/release/usr/lib/python2.6/distutils
	rm -rf $(prefix)/release/usr/lib/python2.6/email

#	Dont remove pyo files, remove pyc instead
	find $(prefix)/release/usr/lib/python2.6/ -name '*.pyc' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name '*.a' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name '*.o' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name '*.la' -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2 #############
	cp -RP $(buildprefix)/own_build/enigma2/* $(prefix)/release/

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release/boot/
	cp $(kernelprefix)/linux/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release/boot/

if ENABLE_UFS912
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_UFS913
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_HS7810A
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_HS7110
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_WHITEBOX
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_UFS922
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
endif

	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/release/lib/modules || true

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/release/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/release/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/release/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/release/lib/modules || true
endif

if STM23
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu_hs7110/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu_hs7110/8192cu.ko $(prefix)/release/lib/modules || true
else
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/release/lib/modules || true
endif

#
# AUTOFS
#
	if [ -d $(prefix)/release/usr/lib/autofs ]; then \
		cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/; \
		ln -s /usr/lib/autofs/mount_ext2.so $(prefix)/release/usr/lib/autofs/mount_ext3.so; \
		if [ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko ]; then \
			cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules; \
		fi; \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release/etc/init.d/; \
	fi

#
# GSTREAMER
#
	if [ -d $(prefix)/release/usr/lib/gstreamer-0.10 ]; then \
		rm -rf $(prefix)/release/usr/lib/libav*; \
		rm -rf $(prefix)/release/usr/lib/libgstfft*; \
		rm -rf $(prefix)/release/usr/lib/gstreamer-0.10/*; \
		cp -a $(targetprefix)/usr/bin/gst-launch* $(prefix)/release/usr/bin/; \
		sh4-linux-strip --strip-unneeded $(prefix)/release/usr/bin/gst-launch*; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstalsa.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstapp.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstasf.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstassrender.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioconvert.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioparsers.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstaudioresample.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstautodetect.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstavi.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcdxaparse.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreelements.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstcoreindexers.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdecodebin2.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbaudiosink.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvbvideosink.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstdvdsub.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflac.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstflv.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstfragmented.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsticydemux.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstid3demux.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstisomp4.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmad.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmatroska.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegaudioparse.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegdemux.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstmpegstream.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstogg.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstplaybin.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtmp.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtp.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtpmanager.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstrtsp.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsouphttpsrc.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubparse.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgsttypefindfunctions.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstudp.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstvcdsrc.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstwavparse.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		if [ -e $(prefix)/release/usr/lib/gstreamer-0.10/libgstffmpeg.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpeg.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstffmpegscale.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstpostproc.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		fi; \
		if [ -e $(prefix)/release/usr/lib/gstreamer-0.10/libgstsubsink.so ]; then \
			cp -a $(targetprefix)/usr/lib/gstreamer-0.10/libgstsubsink.so $(prefix)/release/usr/lib/gstreamer-0.10/; \
		fi; \
		sh4-linux-strip --strip-unneeded $(prefix)/release/usr/lib/gstreamer-0.10/*; \
	fi

#
# DIRECTFB
#
	if [ -d $(prefix)/release/usr/lib/directfb-1.4-5 ]; then \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/gfxdrivers/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/gfxdrivers/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/gfxdrivers/*.o; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/inputdrivers/*; \
		cp -a $(targetprefix)/usr/lib/directfb-1.4-5/inputdrivers/libdirectfb_enigma2remote.so $(prefix)/release/usr/lib/directfb-1.4-5/inputdrivers/; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/systems/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/systems/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/systems/*.o; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/systems/libdirectfb_dummy.so; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/systems/libdirectfb_fbdev.so; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/wm/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/wm/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/wm/*.o; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBFont/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBFont/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBFont/*.o; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBImageProvider/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBImageProvider/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBImageProvider/*.o; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBVideoProvider/*.a; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBVideoProvider/*.la; \
		rm -rf $(prefix)/release/usr/lib/directfb-1.4-5/interfaces/IDirectFBVideoProvider/*.o; \
	fi
	if [ -d $(prefix)/release/usr/lib/icu ]; then \
		rm -rf $(prefix)/release/usr/lib/icu; \
	fi
	if [ -d $(prefix)/release/usr/lib/glib-2.0 ]; then \
		rm -rf $(prefix)/release/usr/lib/glib-2.0; \
	fi
	if [ -d $(prefix)/release/usr/lib/gio ]; then \
		rm -rf $(prefix)/release/usr/lib/gio; \
	fi
	if [ -d $(prefix)/release/usr/lib/enchant ]; then \
		rm -rf $(prefix)/release/usr/lib/enchant; \
	fi

#
# GRAPHLCD
#
	if [ -e $(prefix)/release/usr/lib/libglcddrivers.so ]; then \
		cp -f $(targetprefix)/etc/graphlcd.conf $(prefix)/release/etc/graphlcd.conf; \
	fi

