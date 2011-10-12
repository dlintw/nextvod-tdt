#
#
#
release_dir="release_neutrino_nightly"

#
# max ALPHA-Version ;)
#
$(DEPDIR)/min-release_neutrino_nightly $(DEPDIR)/std-release_neutrino_nightly $(DEPDIR)/max-release_neutrino_nightly $(DEPDIR)/ipk-release_neutrino_nightly $(DEPDIR)/release_neutrino_nightly: \
$(DEPDIR)/%release_neutrino_nightly:

# the following target creates the common file base
	rm -rf $(prefix)/$(release_dir) || true
	$(INSTALL_DIR) $(prefix)/$(release_dir) && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/bin && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/boot && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/dev && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/dev.static && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/network && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/hdd && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/hdd/music && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/lib && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/lib/modules && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/media && \
	ln -s /hdd $(prefix)/$(release_dir)/media/hdd && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/media/dvd && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/mnt && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/mnt/usb && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/mnt/hdd && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/mnt/nfs && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/ram && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/sbin && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/var && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/var/etc && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/root && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/proc && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/sys && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/tmp && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/bin && \
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/lib && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/$(release_dir) && \
	touch $(prefix)/$(release_dir)/var/etc/.firstboot && \
	cp -dp $(buildprefix)/root/var/etc/.version $(prefix)/$(release_dir)/var/etc/ && \
	ln -sf /var/etc/.version $(prefix)/$(release_dir)/.version && \
	cp -a $(targetprefix)/bin/* $(prefix)/$(release_dir)/bin/ && \
	ln -s /bin/showiframe $(prefix)/$(release_dir)/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/$(release_dir)/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/$(release_dir)/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/$(release_dir)/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/$(release_dir)/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/$(release_dir)/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/$(release_dir)/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/$(release_dir)/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/$(release_dir)/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/$(release_dir)/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/$(release_dir)/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/$(release_dir)/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/$(release_dir)/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/$(release_dir)/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/$(release_dir)/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/$(release_dir)/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/$(release_dir)/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(ATEVIO7500),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI) $(prefix)/$(release_dir)/sbin/MAKEDEV && \
	cp -dp $(targetprefix)/usr/sbin/vsftpd $(prefix)/$(release_dir)/usr/bin/ && \
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/$(release_dir)/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/$(release_dir)/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/$(release_dir)/bin/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/$(release_dir)/sbin/ && \
	cp $(targetprefix)/boot/uImage $(prefix)/$(release_dir)/boot/ && \
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/$(release_dir)/boot/video.elf && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/$(release_dir)/etc/ &&) \
	$(if $(ADB_BOX),cp $(targetprefix)/boot/video_7100.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(TF7700),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(HL101),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(VIP1_V2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(VIP2_V1),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(UFS912),cp $(targetprefix)/boot/video_7111.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/video_7111.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(SPARK7162),cp $(targetprefix)/boot/video_7105.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(UFS922),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI_FTA),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_250HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_2000HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(CUBEREVO_9500HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(FORTIS_HDBOX),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(ATEVIO7500),cp $(targetprefix)/boot/video_7105.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	$(if $(OCTAGON1008),cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf &&) \
	cp $(targetprefix)/boot/audio.elf $(prefix)/$(release_dir)/boot/audio.elf && \
	$(if $(UFS912),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/$(release_dir)/boot/audio.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/$(release_dir)/boot/audio.elf &&) \
	$(if $(SPARK7162),cp $(targetprefix)/boot/audio_7105.elf $(prefix)/$(release_dir)/boot/audio.elf &&) \
	cp -a $(targetprefix)/dev/* $(prefix)/$(release_dir)/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/$(release_dir)/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/$(release_dir)/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/$(release_dir)/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/$(release_dir)/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/$(release_dir)/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/$(release_dir)/etc/init.d/ && \
	echo "576i50" > $(prefix)/$(release_dir)/etc/videomode && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/release/getfb.awk $(prefix)/$(release_dir)/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/$(release_dir)/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/$(release_dir)/lib/
#
#
#
if !STM22
	cp $(buildprefix)/root/release/rcS_stm23_neutrino$(if $(TF7700),_$(TF7700))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/$(release_dir)/etc/init.d/rcS
else
	cp $(buildprefix)/root/release/rcS_neutrino$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(ADB_BOX),_$(ADB_BOX)) $(prefix)/$(release_dir)/etc/init.d/rcS
endif
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rcS
#
#
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/$(release_dir)/lib/modules
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/$(release_dir)/lib/modules/)

if ENABLE_TF7700
	echo "tf7700" > $(prefix)/$(release_dir)/etc/hostname
#   remove the slink to busybox
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/$(release_dir)/etc/fstab

	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_UFS922
	echo "ufs922" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/

	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/ftdi_sio.ko $(prefix)/$(release_dir)/lib/modules/ftdi.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/pl2303.ko $(prefix)/$(release_dir)/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/usbserial.ko $(prefix)/$(release_dir)/lib/modules

else
if ENABLE_UFS912
	echo "ufs912" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/$(release_dir)/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/$(release_dir)/boot/audio.elf
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/$(release_dir)/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/$(release_dir)/etc/
	mv $(prefix)/$(release_dir)/lib/firmware/component_7111_mb618.fw $(prefix)/$(release_dir)/lib/firmware/component.fw
	rm $(prefix)/$(release_dir)/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_SPARK
	echo "spark" > $(prefix)/$(release_dir)/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/$(release_dir)/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/$(release_dir)/boot/audio.elf
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_SPARK7162
	echo "spark7162" > $(prefix)/$(release_dir)/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/$(release_dir)/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/$(release_dir)/boot/audio.elf
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_HL101
	echo "hl101" > $(prefix)/$(release_dir)/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_ADB_BOX
	echo "Adb_Box" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp $(buildprefix)/root/release/halt_adb_box $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 777 $(prefix)/$(release_dir)/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/$(release_dir)/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/$(release_dir)/etc/fstab
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/$(release_dir)/boot/video.elf
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/$(release_dir)/lib/modules/

	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/$(release_dir)/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/$(release_dir)/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/$(release_dir)/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/$(release_dir)/lib/modules

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/$(release_dir)/usr/sbin/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/autofs4/autofs4.ko $(prefix)/$(release_dir)/lib/modules
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/$(release_dir)/etc/
	echo 'sda    -fstype=auto,noatime,nodiratime          :/dev/sda' >> $(prefix)/$(release_dir)/etc/auto.usb
	echo 'sda1   -fstype=auto,noatime,nodiratime          :/dev/sda1' >> $(prefix)/$(release_dir)/etc/auto.usb
	echo 'sda2   -fstype=auto,noatime,nodiratime          :/dev/sda2' >> $(prefix)/$(release_dir)/etc/auto.usb
	echo 'sda3   -fstype=auto,noatime,nodiratime          :/dev/sda3' >> $(prefix)/$(release_dir)/etc/auto.usb
else
if ENABLE_VIP1_V2
	echo "Edision" > $(prefix)/$(release_dir)/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_VIP2_V1
	echo "Edision" > $(prefix)/$(release_dir)/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
	rm -f $(prefix)/$(release_dir)/bin/gotosleep
else
if ENABLE_FORTIS_HDBOX
	echo "fortis" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 777 $(prefix)/$(release_dir)/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
if STM23
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/ftdi_sio.ko $(prefix)/$(release_dir)/lib/modules/ftdi.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/pl2303.ko $(prefix)/$(release_dir)/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/usb/serial/usbserial.ko $(prefix)/$(release_dir)/lib/modules
endif
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
else
if ENABLE_ATEVIO7500
	echo "atevio7500" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 777 $(prefix)/$(release_dir)/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/$(release_dir)/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/$(release_dir)/boot/audio.elf
	mv $(prefix)/$(release_dir)/lib/firmware/component_7105_pdk7105.fw $(prefix)/$(release_dir)/lib/firmware/component.fw
	rm $(prefix)/$(release_dir)/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
else
if ENABLE_OCTAGON1008
	echo "octagon1008" > $(prefix)/$(release_dir)/etc/hostname
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 777 $(prefix)/$(release_dir)/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/$(release_dir)/boot/video.elf
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/$(release_dir)/bin/evremote
else
	rm -f $(prefix)/$(release_dir)/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/$(release_dir)/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/$(release_dir)/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/$(release_dir)/etc/init.d/halt
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/umountfs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/rc
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/sendsigs
	chmod 755 $(prefix)/$(release_dir)/etc/init.d/halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/$(release_dir)/etc/rc.d
	ln -fs halt $(prefix)/$(release_dir)/sbin/reboot
	ln -fs halt $(prefix)/$(release_dir)/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/$(release_dir)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/$(release_dir)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/$(release_dir)/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/$(release_dir)/lib/modules/
	rm -f $(prefix)/$(release_dir)/lib/firmware/dvb-fe-cx21143.fw
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/$(release_dir)/lib/modules/
if !ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/$(release_dir)/lib/modules/
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/$(release_dir)/lib/modules/
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/$(release_dir)/lib/modules/
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/$(release_dir)/lib/modules/
endif
endif
if ENABLE_PLAYER131
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/$(release_dir)/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/$(release_dir)/lib/modules/
	find $(prefix)/$(release_dir)/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/$(release_dir)/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/$(release_dir)/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/$(release_dir)/lib/modules/
	find $(prefix)/$(release_dir)/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/$(release_dir)/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/$(release_dir)/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/$(release_dir)/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/$(release_dir)/lib/modules/
	find $(prefix)/$(release_dir)/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/$(release_dir)/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/$(release_dir)/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_TF7700
#	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
endif

if ENABLE_UFS910
	cp -dp $(buildprefix)/root/etc/lircd.conf $(prefix)/$(release_dir)/etc/
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/$(release_dir)/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
endif

if ENABLE_HL101
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/$(release_dir)/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/$(release_dir)/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
endif
if ENABLE_ADB_BOX
	cp -dp $(buildprefix)/root/etc/lircd_adb_box.conf $(prefix)/$(release_dir)/etc/lircd.conf
	cp -dp $(buildprefix)/root/usr/bin/lircd_adb $(prefix)/$(release_dir)/usr/bin/lircd
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/$(release_dir)/etc/boxtype
endif
if ENABLE_VIP1_V2
	cp -dp $(buildprefix)/root/etc/lircd_vip1_v2.conf $(prefix)/$(release_dir)/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/$(release_dir)/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
endif
if ENABLE_VIP2_V1
	cp -dp $(buildprefix)/root/etc/lircd_vip2_v1.conf $(prefix)/$(release_dir)/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/$(release_dir)/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/$(release_dir)/usr/bin/
endif

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/$(release_dir)/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/$(release_dir)/usr/sbin/

########################################################################
#	mkdir -p $(prefix)/$(release_dir)/var/plugins
#	mkdir -p $(prefix)/$(release_dir)/lib/tuxbox
#	mkdir -p $(prefix)/$(release_dir)/var/tuxbox/config
#	mkdir -p $(prefix)/$(release_dir)/share/tuxbox
#	mkdir -p $(prefix)/$(release_dir)/var/share/icons
#	mkdir -p $(prefix)/$(release_dir)/var/usr/local/share/config
#	( cd $(prefix)/$(release_dir)/share/tuxbox && ln -s /usr/local/share/neutrino )
#	( cd $(prefix)/$(release_dir)/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
#	( cd $(prefix)/$(release_dir)/ && ln -s /usr/local/share/neutrino/icons/logo logos )
#	( cd $(prefix)/$(release_dir)/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
#	( cd $(prefix)/$(release_dir)/lib/tuxbox && ln -s /var/plugins )
#	( cd $(prefix)/$(release_dir)/var/tuxbox && ln -s /var/plugins )
#	( cd $(prefix)/$(release_dir)/usr/lib/tuxbox && ln -s /var/plugins )
#	mkdir -p $(prefix)/$(release_dir)/usr/local/share/config/tuxtxt/
#	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/$(release_dir)/usr/local/share/config/tuxtxt/
########################################################################
#
#
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/$(release_dir)/usr/share/udhcpc/
#
#
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/$(release_dir)/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/$(release_dir)/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/$(release_dir)/usr/local/bin/

#
# zapit
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/var/tuxbox/config/zapit

#
# channellist
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/var/tuxbox/config
	cp -aR $(targetprefix)/var/tuxbox/config/* $(prefix)/$(release_dir)/var/tuxbox/config
#
# zoneinfo
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/$(release_dir)/usr/share/zoneinfo/
#
# fonts
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/share/fonts
	cp -aR $(targetprefix)/share/fonts $(prefix)/$(release_dir)/share/
#
# iso-codes
#
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/$(release_dir)/share/
#
# httpd/icons/locale/themes
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/share/tuxbox/neutrino
	cp -aR $(targetprefix)/share/tuxbox/neutrino/* $(prefix)/$(release_dir)/share/tuxbox/neutrino/

#
# /usr/lib
#
	$(INSTALL_DIR) $(prefix)/$(release_dir)/usr/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/$(release_dir)/usr/lib/

#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino
#
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/$(release_dir)/

#
# del/strip
#
if STM22
	rm $(prefix)/$(release_dir)/lib/modules/p2div64.ko
endif
	rm -rf $(prefix)/$(release_dir)/lib/modules/$(KERNELVERSION)
	rm -rf $(prefix)/$(release_dir)/usr/lib/alsa-lib
	rm -rf $(prefix)/$(release_dir)/usr/lib/alsaplayer
	rm -rf $(prefix)/$(release_dir)/usr/lib/engines
	rm -rf $(prefix)/$(release_dir)/usr/lib/enigma2
	rm -rf $(prefix)/$(release_dir)/usr/lib/gconv
	rm -rf $(prefix)/$(release_dir)/usr/lib/libxslt-plugins
	rm -rf $(prefix)/$(release_dir)/usr/lib/pkgconfig
	rm -rf $(prefix)/$(release_dir)/usr/lib/sigc++-1.2
	rm -rf $(prefix)/$(release_dir)/usr/lib/X11
	rm -f $(prefix)/$(release_dir)/lib/*.a
	rm -f $(prefix)/$(release_dir)/lib/*.o
	rm -f $(prefix)/$(release_dir)/lib/*.la
	find $(prefix)/$(release_dir)/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
	rm -f $(prefix)/$(release_dir)/usr/lib/*.a
	rm -f $(prefix)/$(release_dir)/usr/lib/*.o
	rm -f $(prefix)/$(release_dir)/usr/lib/*.la
	find $(prefix)/$(release_dir)/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
#
# release_neutrino_nightly end
#
	touch $@
