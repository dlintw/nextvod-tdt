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
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_cube.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release/bin/vdstandby
	chmod 777 $(prefix)/release/bin/vdstandby
if !STM22
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release/bin/cubefpctl
	chmod 777 $(prefix)/release/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/lib/modules/tuner.ko
else
	cp $(kernelprefix)/linux/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/drivers/usb/serial/cp2101.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/cifs/cifs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/nfsd/nfsd.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/exportfs/exportfs.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux/fs/nfs_common/nfs_acl.ko $(prefix)/release/lib/modules
	cp -f $(buildprefix)/root/bin/cubefpctl_stm22 $(prefix)/release/bin/cubefpctl
	chmod 777 $(prefix)/release/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm22_041$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm22_041$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/lib/modules/tuner.ko
endif
	rm -f $(prefix)/release/lib/modules/simu_button.ko
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
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_cube_small.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

release_cuberevo_mini_fta: release_common_utils release_cube_common
	echo "cuberevo-mini-fta" > $(prefix)/release/etc/hostname
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_cube_small.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

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

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/
	echo 'sda    -fstype=auto,noatime,nodiratime          :/dev/sda' >> $(prefix)/release/etc/auto.usb
	echo 'sda1   -fstype=auto,noatime,nodiratime          :/dev/sda1' >> $(prefix)/release/etc/auto.usb
	echo 'sda2   -fstype=auto,noatime,nodiratime          :/dev/sda2' >> $(prefix)/release/etc/auto.usb
	echo 'sda3   -fstype=auto,noatime,nodiratime          :/dev/sda3' >> $(prefix)/release/etc/auto.usb

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

	mv $(prefix)/release/lib/firmware/component_7111_mb618.fw $(prefix)/release/lib/firmware/component.fw
	rm $(prefix)/release/lib/firmware/component_7105_pdk7105.fw

release_spark:
	echo "spark" > $(prefix)/release/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_spark.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/release/vfd_spark$(KERNELSTMLABEL).ko $(prefix)/release/lib/modules/vfd.ko
	cp -f $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko $(prefix)/release/lib/modules/encrypt.ko

	cp -dp $(buildprefix)/root/etc/$(LIRCD_CONF) $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/local/share/fonts/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

release_spark7162:
	echo "spark7162" > $(prefix)/release/etc/hostname

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release/boot/audio.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_spark.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -f $(buildprefix)/root/release/vfd_spark7162$(KERNELSTMLABEL).ko $(prefix)/release/lib/modules/vfd.ko
	cp -f $(buildprefix)/root/release/tuner.ko$(KERNELSTMLABEL)_spark7162 $(prefix)/release/lib/modules/spark7162.ko

	cp -dp $(buildprefix)/root/etc/$(LIRCD_CONF) $(prefix)/release/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/local/share/fonts/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep

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

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/
	echo 'sda    -fstype=auto,noatime,nodiratime          :/dev/sda' >> $(prefix)/release/etc/auto.usb
	echo 'sda1   -fstype=auto,noatime,nodiratime          :/dev/sda1' >> $(prefix)/release/etc/auto.usb
	echo 'sda2   -fstype=auto,noatime,nodiratime          :/dev/sda2' >> $(prefix)/release/etc/auto.usb
	echo 'sda3   -fstype=auto,noatime,nodiratime          :/dev/sda3' >> $(prefix)/release/etc/auto.usb

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

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release/boot/audio.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/
	echo 'sda    -fstype=auto,noatime,nodiratime          :/dev/sda' >> $(prefix)/release/etc/auto.usb
	echo 'sda1   -fstype=auto,noatime,nodiratime          :/dev/sda1' >> $(prefix)/release/etc/auto.usb
	echo 'sda2   -fstype=auto,noatime,nodiratime          :/dev/sda2' >> $(prefix)/release/etc/auto.usb
	echo 'sda3   -fstype=auto,noatime,nodiratime          :/dev/sda3' >> $(prefix)/release/etc/auto.usb

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

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	mv $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw

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

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote

release_vip1_v2: release_common_utils
	echo "Edision" > $(prefix)/release/etc/hostname
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

	$(INSTALL_DIR) $(prefix)/release/usr/local/share/fonts
	cp $(targetprefix)/usr/local/share/fonts/* $(prefix)/release/usr/local/share/fonts/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw

release_vip2_v1: release_vip1_v2

release_hs5101:
	echo "hs5101" > $(prefix)/release/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button_hs5101/button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs5101/vfd.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs910.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml

	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw

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

release_ipbox9900: release_common_utils
	echo "ipbox" > $(prefix)/release/etc/hostname
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
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif


#	install autofs
#	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/

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
	echo "ipbox" > $(prefix)/release/etc/hostname
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ipbox.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif


#	install autofs
#	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/

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
	echo "ipbox" > $(prefix)/release/etc/hostname
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox55/front.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ipbox.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release/usr/bin/lircd
	cp -p $(buildprefix)/root/release/tvmode_ipbox55 $(prefix)/release/usr/bin/tvmode

if STM22
	cp $(kernelprefix)/linux/drivers/net/tun.ko $(prefix)/release/lib/modules
else
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
endif


#	install autofs
#	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/

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
$(DEPDIR)/min-release $(DEPDIR)/std-release $(DEPDIR)/max-release $(DEPDIR)/ipk-release $(DEPDIR)/release: \
$(DEPDIR)/%release: release_base release_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)
	touch $@


release-clean:
	rm -f $(DEPDIR)/release
	rm -f $(DEPDIR)/release_base
	rm -f $(DEPDIR)/release_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(IPBOX9900)$(IPBOX99)$(IPBOX55)
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
	$(INSTALL_DIR) $(prefix)/release/hdd && \
	$(INSTALL_DIR) $(prefix)/release/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release/hdd/picture && \
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
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release/sbin/ && \
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
	cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(ATEVIO7500),_dual_tuner)$(if $(VIP2_V1),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI)$(if $(IPBOX9900),_dual_tuner)$(if $(IPBOX99),_no_CI)$(if $(IPBOX55),_no_CI) $(prefix)/release/sbin/MAKEDEV && \
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
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/inetd.conf $(prefix)/release/etc/ && \
	cp -dp $(targetprefix)/etc/image-version $(prefix)/release/etc/ && \
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
	cp $(targetprefix)/etc/tuxbox/tuxtxt2.conf $(prefix)/release/etc/tuxbox/ && \
	echo "576i50" > $(prefix)/release/etc/videomode && \
	cp -R $(targetprefix)/etc/fonts/* $(prefix)/release/etc/fonts/ && \
	cp $(buildprefix)/root/release/rcS$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(HOMECAST5101),_$(HOMECAST5101))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55)) $(prefix)/release/etc/init.d/rcS && \
	chmod 755 $(prefix)/release/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release/lib/ && \
	rm -f $(prefix)/release/lib/*.a && \
	rm -f $(prefix)/release/lib/*.o && \
	rm -f $(prefix)/release/lib/*.la && \
	find $(prefix)/release/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

if STM24
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release/sbin/
endif

if !STM22
	cp $(buildprefix)/root/release/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55)) $(prefix)/release/etc/init.d/rcS
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
if !ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release/lib/modules/
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release/lib/modules/
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
	ln -s /hdd $(prefix)/release/media/hdd
	$(INSTALL_DIR) $(prefix)/release/media/dvd

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
	cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/release/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release/usr/tuxtxt
	cp -p $(targetprefix)/usr/tuxtxt/tuxtxt2.conf $(prefix)/release/usr/tuxtxt/

	$(INSTALL_DIR) $(prefix)/release/usr/share

	ln -s /usr/local/share/enigma2 $(prefix)/release/usr/share/enigma2

	$(INSTALL_DIR) $(prefix)/release/usr/share/fonts
	cp $(targetprefix)/usr/share/fonts/ae_AlMateen.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/lcd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/md_khmurabi_10.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/nmsbd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/tuxtxt.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/goodtime.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/valis_enigma.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/valis_lcd.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/seg.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/seg_internat.ttf $(prefix)/release/usr/share/fonts/
	cp $(targetprefix)/usr/share/fonts/Symbols.ttf $(prefix)/release/usr/share/fonts/

#       Font libass
	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/release/usr/share/fonts/

	$(INSTALL_DIR) $(prefix)/release/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release/usr/share/zoneinfo/

	$(INSTALL_DIR) $(prefix)/release/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release/usr/share/udhcpc/

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
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml-2.0.5-py2.6.egg-info
	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxml2mod.so
	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxsltmod.so
	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/OpenSSL/test
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
else
if ENABLE_HS7810A
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
endif
if ENABLE_UFS922
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules
endif
endif
endif

if STM24
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release/lib/modules || true
endif
