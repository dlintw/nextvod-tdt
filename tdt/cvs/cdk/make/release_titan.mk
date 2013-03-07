kernelpath=linux-sh4

#Trick ALPHA-Version ;)
$(DEPDIR)/release_titan: \
$(DEPDIR)/%release_titan:
	rm -rf $(prefix)/release_titan || true
	$(INSTALL_DIR) $(prefix)/release_titan && \
	$(INSTALL_DIR) $(prefix)/release_titan/bin && \
	$(INSTALL_DIR) $(prefix)/release_titan/sbin && \
	$(INSTALL_DIR) $(prefix)/release_titan/swap && \
	$(INSTALL_DIR) $(prefix)/release_titan/boot && \
	$(INSTALL_DIR) $(prefix)/release_titan/dev && \
	$(INSTALL_DIR) $(prefix)/release_titan/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_titan/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_titan/hdd && \
	$(INSTALL_DIR) $(prefix)/release_titan/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_titan/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_titan/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_titan/lib && \
	$(INSTALL_DIR) $(prefix)/release_titan/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_titan/ram && \
	$(INSTALL_DIR) $(prefix)/release_titan/var && \
	$(INSTALL_DIR) $(prefix)/release_titan/var/etc && \
	$(INSTALL_DIR) $(prefix)/release_titan/var/boot && \
	$(INSTALL_DIR) $(prefix)/release_titan/var/lib-misc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_titan && \
	touch $(prefix)/release_titan/var/etc/.firstboot && \
	mkdir -p $(prefix)/release_titan/var/plugins && \
	mkdir -p $(prefix)/release_titan/var/tuxbox/config && \
	mkdir -p $(prefix)/release_titan/usr/local/share && \
	ln -sf /var/tuxbox/config $(prefix)/release_titan/usr/local/share/config && \
	mkdir -p $(prefix)/release_titan/var/share/icons && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_titan/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_titan/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release_titan/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release_titan/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release_titan/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release_titan/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release_titan/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_titan/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_titan/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_titan/etc/init.d/ && \
	make $(targetprefix)/var/etc/.version && \
	mv $(targetprefix)/var/etc/.version $(prefix)/release_titan/ && \
	ln -sf /.version $(prefix)/release_titan/var/etc/.version && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_titan/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release_titan/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_titan/sbin/ && \
\
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_titan/boot/video.elf && \
	$(if $(ADB_BOX),cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(TF7700),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(HL101),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(VIP1_V2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(VIP2_V1),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(UFS912),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(UFS913),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(SPARK7162),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(UFS922),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI_FTA),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_250HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_2000HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(CUBEREVO_9500HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(FORTIS_HDBOX),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(ATEVIO7500),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(OCTAGON1008),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(HS7810A),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(HS7110),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(WHITEBOX),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(IPBOX9900),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(IPBOX99),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
	$(if $(IPBOX55),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_titan/boot/video.elf &&) \
\
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/boot/audio.elf && \
	$(if $(ADB_BOX), cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(TF7700), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(HL101), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(VIP1_V2), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(VIP2_V1), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(UFS912), cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(UFS913), cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(SPARK), cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(SPARK7162), cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(HS7110), cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(UFS922), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_MINI), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_MINI2), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_MINI_FTA), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_250HD), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_2000HD), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(CUBEREVO_9500HD), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(FORTIS_HDBOX), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(ATEVIO7500), cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(OCTAGON1008), cp $(targetprefix)/boot/audio_7109.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(HS7810A), cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(WHITEBOX),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(IPBOX9900),cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(IPBOX99),cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/boot/audio.elf &&) \
	$(if $(IPBOX55),cp $(targetprefix)/boot/audio.elf $(prefix)/release_titan/boot/audio.elf &&) \
\
	cp -a $(targetprefix)/dev/* $(prefix)/release_titan/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_titan/etc/ && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_titan/etc/ &&) \
	mkdir -p $(prefix)/release_titan/var/run/lirc
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_titan/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_titan/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_titan/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_titan/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_titan/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_titan/etc/init.d/ && \
	mkdir -p $(prefix)/release_titan/var/tuxbox/config/tuxtxt/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_titan/var/tuxbox/config/tuxtxt/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_titan/bin/ && \
	echo "576i50" > $(prefix)/release_titan/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_stm23_neutrino$(if $(TF7700),_$(TF7700))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(ADB_BOX),_$(ADB_BOX))$(if $(UFS913),_$(UFS913))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162))$(if $(IPBOX9900),_$(IPBOX9900))$(if $(IPBOX99),_$(IPBOX99))$(if $(IPBOX55),_$(IPBOX55)) $(prefix)/release_titan/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_titan/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/release/getfb.awk $(prefix)/release_titan/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_titan/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_titan/lib/ && \
	rm -f $(prefix)/release_titan/lib/*.a && \
	rm -f $(prefix)/release_titan/lib/*.o && \
	rm -f $(prefix)/release_titan/lib/*.la && \
	find $(prefix)/release_titan/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
	[ -e $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/autofs4/autofs4.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/pl2303.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/$(kernelpath)/drivers/usb/serial/usbserial.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/cifs/cifs.ko $(prefix)/release_titan/lib/modules || true
	[ -e $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/$(kernelpath)/fs/ntfs/ntfs.ko $(prefix)/release_titan/lib/modules || true

if STM24
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release_titan/sbin/
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_titan/lib/modules/
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_titan/lib/modules/)

if ENABLE_TF7700

	echo "tf7700" > $(prefix)/release_titan/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_titan/etc/fstab

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/gotosleep
else
if ENABLE_UFS922

	echo "ufs922" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

else
if ENABLE_UFS912

	echo "ufs912" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_UFS913

	echo "ufs913" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs913 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

else
if ENABLE_HS7810A

	echo "hs7810a" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_hs7810a $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

else
if ENABLE_HS7110

	echo "hs7110" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_hs7110 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

else
if ENABLE_WHITEBOX

	echo "whitebox" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_whitebox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

else
if ENABLE_SPARK
	echo "spark" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_titan/lib/modules/

	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	mv $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep

	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd

	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
else
if ENABLE_SPARK7162

	echo "spark7162" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_spark7162 $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	cp -dp $(buildprefix)/root/release/encrypt_$(MODNAME)$(KERNELSTMLABEL).ko $(prefix)/release_titan/lib/modules/encrypt.ko

	cp -f $(buildprefix)/root/release/fstab_spark7162 $(prefix)/release_titan/etc/fstab
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	mv $(prefix)/release_titan/lib/firmware/fdvo0_7105.fw $(prefix)/release_titan/lib/firmware/fdvo0.fw
	rm -f $(prefix)/release_titan/boot/bootlogo.mvi
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/fdvo0_7106.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep
	cp -dp $(buildprefix)/root/etc/lircd_spark7162.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	mkdir -p $(prefix)/release_titan/usr/lib
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_titan/lib/modules/
else
if ENABLE_HL101

	echo "hl101" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep
else
if ENABLE_ADB_BOX

	echo "Adb_Box" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release_titan/etc/fstab
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release_titan/lib/modules
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release_titan/lib/modules/
	cp $(buildprefix)/root/firmware/as102_data1_st.hex $(prefix)/release_titan/lib/firmware/
	cp $(buildprefix)/root/firmware/as102_data2_st.hex $(prefix)/release_titan/lib/firmware/
#       install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_titan/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_titan/etc/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep
else
if ENABLE_VIP1_V2

	echo "Edision-v2" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep
else
if ENABLE_VIP2_V1

	echo "Edision-v1" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/gotosleep
else
if ENABLE_IPBOX9900
	echo "IPBOX9900" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/rmu/rmu.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_titan/usr/bin/tvmode

	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ipbox99xx_fan/ipbox_fan.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release_titan/etc/fstab
	rm -f $(prefix)/release_titan/lib/firmware/*
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/lib/modules/lzo*.ko
	rm -f $(prefix)/release_titan/lib/modules/ramzswap.ko
	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvbi.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvout.ko
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/etc/network/interfaces
else
if ENABLE_IPBOX99
	echo "IPBOX99" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_titan/usr/bin/tvmode

	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ipbox99xx_fan/ipbox_fan.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release_titan/etc/fstab
	rm -f $(prefix)/release_titan/lib/firmware/*
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/lib/modules/lzo*.ko
	rm -f $(prefix)/release_titan/lib/modules/ramzswap.ko
	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvbi.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvout.ko
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/etc/network/interfaces
else
if ENABLE_IPBOX55
	echo "IPBOX55" > $(prefix)/release_titan/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox55/front.ko $(prefix)/release_titan/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox55 $(prefix)/release_titan/usr/bin/tvmode

	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release_titan/etc/fstab
	rm -f $(prefix)/release_titan/lib/firmware/*
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko
	rm -f $(prefix)/release_titan/lib/modules/lzo*.ko
	rm -f $(prefix)/release_titan/lib/modules/ramzswap.ko
	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvbi.ko
	rm -f $(prefix)/release_titan/lib/modules/stmvout.ko
	rm -f $(prefix)/release_titan/bin/gotosleep
	rm -f $(prefix)/release_titan/etc/network/interfaces
else
if ENABLE_CUBEREVO
	echo "cuberevo" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI
	echo "cuberevo-mini" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI2
	echo "cuberevo-mini2" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI_FTA
	echo "cuberevo-mini-fta" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_250HD
	echo "cuberevo-250hd" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_2000HD
	echo "cuberevo-2000hd" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_CUBEREVO_9500HD
	echo "cuberevo-9500hd" > $(prefix)/release_titan/etc/hostname
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 777 $(prefix)/release_titan/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp -f $(buildprefix)/root/bin/vdstandby $(prefix)/release_titan/bin/vdstandby
	chmod 777 $(prefix)/release_titan/bin/vdstandby

	cp -f $(buildprefix)/root/bin/cubefpctl_stm23 $(prefix)/release_titan/bin/cubefpctl
	chmod 777 $(prefix)/release_titan/bin/cubefpctl
	cp -f $(buildprefix)/root/release/fp.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/fp.ko
	cp -f $(buildprefix)/root/release/tuner.ko_stm23_0123$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_titan/lib/modules/tuner.ko

	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_titan/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/reboot
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/modules/simu_button.ko
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/vfdctl
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_FORTIS_HDBOX

	echo "fortis" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_titan/etc/init.d/halt
	chmod 777 $(prefix)/release_titan/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/bin/evremote

	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_ATEVIO7500

	echo "atevio7500" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_titan/etc/init.d/halt
	chmod 777 $(prefix)/release_titan/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_titan/lib/modules/

	mv $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_titan/lib/firmware/component.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/bin/evremote
	rm -f $(prefix)/release_titan/lib/modules/boxtype.ko

	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
if ENABLE_OCTAGON1008

	echo "octagon1008" > $(prefix)/release_titan/etc/hostname
	rm -f $(prefix)/release_titan/sbin/halt
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/release_titan/etc/init.d/halt
	chmod 777 $(prefix)/release_titan/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/bin/evremote

	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
else
	rm -f $(prefix)/release_titan/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_titan/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_titan/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_titan/etc/init.d/halt
	chmod 755 $(prefix)/release_titan/etc/init.d/umountfs
	chmod 755 $(prefix)/release_titan/etc/init.d/rc
	chmod 755 $(prefix)/release_titan/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_titan/etc/init.d/halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_titan/etc/rc.d
	ln -fs halt $(prefix)/release_titan/sbin/reboot
	ln -fs halt $(prefix)/release_titan/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_titan/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_titan/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_titan/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_titan/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_titan/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_titan/lib/modules/

	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-cx21143.fw
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
endif
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_titan/lib/modules/
if !ENABLE_ATEVIO7500
if !ENABLE_UFS913
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_titan/lib/modules/
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_titan/lib/modules/
endif
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_titan/lib/modules/
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_titan/lib/modules/
endif
endif

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_titan/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_titan/lib/modules/

	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_titan/lib/modules/ || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_titan/lib/modules/ || true

	find $(prefix)/release_titan/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_titan/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_titan/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_titan/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

	rm -rf $(prefix)/release_titan/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_titan/media
	ln -s /hdd $(prefix)/release_titan/media/hdd
	$(INSTALL_DIR) $(prefix)/release_titan/media/dvd

	$(INSTALL_DIR) $(prefix)/release_titan/mnt
	$(INSTALL_DIR) $(prefix)/release_titan/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_titan/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_titan/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_titan/root

	$(INSTALL_DIR) $(prefix)/release_titan/proc
	$(INSTALL_DIR) $(prefix)/release_titan/sys
	$(INSTALL_DIR) $(prefix)/release_titan/tmp

	$(INSTALL_DIR) $(prefix)/release_titan/usr
	$(INSTALL_DIR) $(prefix)/release_titan/usr/bin
	$(INSTALL_DIR) $(prefix)/release_titan/usr/lib
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_titan/usr/bin/
if ENABLE_TF7700
#	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_titan/usr/bin/
endif

if ENABLE_UFS910
	cp -dp $(buildprefix)/root/etc/lircd.conf $(prefix)/release_titan/etc/
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko $(prefix)/release_titan/lib/modules || true
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_titan/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_titan/bin/tffpctl
	rm -f $(prefix)/release_titan/bin/tfd2mtd
endif

if ENABLE_HL101
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_titan/usr/bin/
endif
if ENABLE_ADB_BOX
	cp -dp $(buildprefix)/root/etc/lircd_adb_box.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/release_titan/etc/boxtype
endif
if ENABLE_IPBOX9900
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release_titan/usr/bin/lircd
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/release_titan/etc/boxtype
endif
if ENABLE_IPBOX99
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release_titan/usr/bin/lircd
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/release_titan/etc/boxtype
endif
if ENABLE_IPBOX55
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release_titan/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release_titan/usr/bin/lircd
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
	cp -dp $(buildprefix)/root/etc/boxtype $(prefix)/release_titan/etc/boxtype
endif
if ENABLE_VIP1_V2
	cp -dp $(buildprefix)/root/etc/lircd_vip1_v2.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_titan/usr/bin/
endif
if ENABLE_VIP2_V1
	cp -dp $(buildprefix)/root/etc/lircd_vip2_v1.conf $(prefix)/release_titan/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_titan/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_titan/usr/lib/
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_titan/usr/bin/
endif

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_titan/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_titan/usr/sbin/
	$(INSTALL_DIR) $(prefix)/release_titan/usr/tuxtxt

if !ENABLE_UFS913
	rm -f $(prefix)/release_titan/lib/firmware/dvb-fe-avl6222.fw
endif

#######################################################################################

	( cd $(prefix)/release_titan/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_titan/ && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/release_titan/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
	( cd $(prefix)/release_titan/var/tuxbox && ln -s /var/plugins )

	$(INSTALL_DIR) $(prefix)/release_titan/usr/share
	$(INSTALL_DIR) $(prefix)/release_titan/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_titan/usr/share/zoneinfo/

	$(INSTALL_DIR) $(prefix)/release_titan/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_titan/usr/share/udhcpc/

	$(INSTALL_DIR) $(prefix)/release_titan/usr/local
	$(INSTALL_DIR) $(prefix)/release_titan/usr/local/bin
	cp $(targetprefix)/usr/local/bin/titan $(prefix)/release_titan/usr/local/bin/
	find $(prefix)/release_titan/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;

	$(INSTALL_DIR) $(prefix)/release_titan/usr/local/share
#	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_titan/usr/local/share/
#	TODO: Channellist ....
#	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_titan/var/tuxbox/config/
if ENABLE_SPARK7162
	rm -f $(prefix)/release_titan/var/tuxbox/config/neutrino.conf
endif
#	cp -aR $(targetprefix)/usr/local/share/neutrino $(prefix)/release_titan/usr/local/share/
#	TODO: HACK (without *.locale are missing!) --- should be not longer needed since path fix
#	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/neutrino/* $(prefix)/release_titan/usr/local/share/neutrino
#######################################################################################
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/release_titan/usr/local/share/
#	mkdir -p $(prefix)/release_titan/usr/local/share/fonts
#	cp $(buildprefix)/root/usr/share/fonts/tuxtxt.ttf $(prefix)/release_titan/usr/local/share/fonts/

# Font libass
#	mkdir -p $(prefix)/release_titan/usr/share/fonts
#	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/release_titan/usr/share/fonts/
#	cp -aR $(targetprefix)/usr/local/share/fonts/micron.ttf $(prefix)/release_titan/usr/local/share/fonts/neutrino.ttf

#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_titan/etc/imageinfo
	git describe >> $(prefix)/release_titan/etc/imageinfo
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_titan/usr/lib

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_titan/usr/lib/
#	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_titan/usr/lib/
	rm -rf $(prefix)/release_titan/usr/lib/alsa-lib
	rm -rf $(prefix)/release_titan/usr/lib/alsaplayer
	rm -rf $(prefix)/release_titan/usr/lib/engines
	rm -rf $(prefix)/release_titan/usr/lib/enigma2
	rm -rf $(prefix)/release_titan/usr/lib/gconv
	rm -rf $(prefix)/release_titan/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_titan/usr/lib/pkgconfig
	rm -rf $(prefix)/release_titan/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_titan/usr/lib/X11
	rm -f $(prefix)/release_titan/usr/lib/*.a
	rm -f $(prefix)/release_titan/usr/lib/*.o
	rm -f $(prefix)/release_titan/usr/lib/*.la

#	mkdir -p $(prefix)/release_titan/usr/local/share/neutrino/icons/logo
#	( cd $(prefix)/release_titan/usr/local/share/neutrino && ln -s /usr/local/share/neutrino/httpd httpd-y )
#	( cd $(prefix)/release_titan/var && ln -s /usr/local/share/neutrino/httpd httpd )
#	cp $(appsdir)/neutrino/src/nhttpd/web/{Y_Baselib.js,Y_VLC.js} $(prefix)/release_titan/usr/local/share/neutrino/httpd/
#	( cd $(prefix)/release_titan/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo )
#	( cd $(prefix)/release_titan/usr/local/share/neutrino/httpd && ln -s /usr/local/share/neutrino/icons/logo logos )

#######################################################################################

	find $(prefix)/release_titan/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino #############
#	rm $(prefix)/release_titan/bin/mount
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/release_titan/

######################################################################################

	cp $(kernelprefix)/$(kernelpath)/arch/sh/boot/uImage $(prefix)/release_titan/boot/
	touch $@
