#Trick ALPHA-Version ;)
$(DEPDIR)/min-release_vdrdev2 $(DEPDIR)/std-release_vdrdev2 $(DEPDIR)/max-release_vdrdev2 $(DEPDIR)/release_vdrdev2: \
$(DEPDIR)/%release_vdrdev2:
	rm -rf $(prefix)/release_vdrdev2 || true
	$(INSTALL_DIR) $(prefix)/release_vdrdev2 && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/bin && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/sbin && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/boot && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/dev && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/hdd && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/lib && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/ram && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/var && \
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/var/etc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_vdrdev2 && \
	touch $(prefix)/release_vdrdev2/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_vdrdev2/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_vdrdev2/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/release_vdrdev2/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_vdrdev2/etc/init.d/ && \
cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(ATEVIO7500),_dual_tuner)$(if $(ADB_BOX),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI) $(prefix)/release_vdrdev2/sbin/MAKEDEV && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_vdrdev2/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release_vdrdev2/bin/ && \
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_vdrdev2/boot/video.elf && \
	$(if $(TF7700),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(UFS912),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(UFS922),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI_FTA),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_250HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_2000HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(CUBEREVO_9500HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(FORTIS_HDBOX),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(ATEVIO7500),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	$(if $(ADB_BOX),cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_vdrdev2/boot/video.elf &&) \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_vdrdev2/boot/audio.elf && \
	$(if $(UFS912),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_vdrdev2/boot/audio.elf &&) \
	cp -a $(targetprefix)/dev/* $(prefix)/release_vdrdev2/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_vdrdev2/etc/ && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_vdrdev2/etc/ &&) \
##	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_vdrdev2/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_vdrdev2/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_vdrdev2/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_vdrdev2/etc/init.d/ && \
	echo "576i50" > $(prefix)/release_vdrdev2/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_vdrdev2$(if $(TF7700),_$(TF7700))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS922),_$(UFS922))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(ADB_BOX),_$(ADB_BOX))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_vdrdev2/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rcS && \
	mkdir -p $(prefix)/release_vdrdev2/usr/local/share/vdr && \
	mkdir -p $(prefix)/release_vdrdev2/usr/local/share/vdr/plugins && \
	mkdir -p $(prefix)/release_vdrdev2/usr/local/share/vdr/themes && \
	mkdir -p $(prefix)/release_vdrdev2/usr/local/bin && \
	mkdir -p $(prefix)/release_vdrdev2/usr/lib/locale && \
	cp $(buildprefix)/root/var/vdr/plugins_vdrdev2.load $(prefix)/release_vdrdev2/usr/local/share/vdr/plugins.load && \
	cp $(buildprefix)/root/var/vdr/channels.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/diseqc.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/keymacros.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/remote.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/setup.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/sources.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/ && \
	cp $(buildprefix)/root/var/vdr/plugins/mplayersources.conf $(prefix)/release_vdrdev2/usr/local/share/vdr/plugins && \
	cp $(buildprefix)/root/usr/local/bin/mplayer.sh $(prefix)/release_vdrdev2/usr/local/bin/ && \
        chmod 755 $(prefix)/release_vdrdev2/usr/local/bin/mplayer.sh && \
	cp -rd $(buildprefix)/root/var/vdr/themes/* $(prefix)/release_vdrdev2/usr/local/share/vdr/themes/ && \
	cp $(buildprefix)/root/usr/local/bin/runvdrdev2 $(prefix)/release_vdrdev2/usr/local/bin/runvdr && \
	chmod 755 $(prefix)/release_vdrdev2/usr/local/bin/runvdr && \
	cp $(buildprefix)/root/usr/local/bin/vdrshutdown $(prefix)/release_vdrdev2/usr/local/bin/ && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_vdrdev2/etc/init.d/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_vdrdev2/bin/ && \
	cp -rd $(buildprefix)/root/usr/lib/locale/* $(prefix)/release_vdrdev2/usr/lib/locale/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_vdrdev2/lib/ && \
	rm -f $(prefix)/release_vdrdev2/lib/*.a && \
	rm -f $(prefix)/release_vdrdev2/lib/*.o && \
	rm -f $(prefix)/release_vdrdev2/lib/*.la && \
	find $(prefix)/release_vdrdev2/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_vdrdev2/lib/modules/
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_vdrdev2/lib/modules/)

if ENABLE_TF7700

	echo "tf7700" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_vdrdev2/etc/fstab

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_vdrdev2/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_vdrdev2/etc/

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/gotosleep
else
if ENABLE_UFS922

	echo "ufs922" > $(prefix)/release_vdrdev2/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/gotosleep
else
if ENABLE_UFS912

	echo "ufs912" > $(prefix)/release_vdrdev2/etc/hostname
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_vdrdev2/lib/modules/
##	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_vdrdev2/boot/video.elf
##	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_vdrdev2/boot/audio.elf
#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_vdrdev2/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_vdrdev2/etc/

	mv $(prefix)/release_vdrdev2/lib/firmware/component_7111_mb618.fw $(prefix)/release_vdrdev2/lib/firmware/component.fw
	rm $(prefix)/release_vdrdev2/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/gotosleep

else
if ENABLE_CUBEREVO
	echo "cuberevo" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI
	echo "cuberevo-mini" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI2
	echo "cuberevo-mini2" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI_FTA
	echo "cuberevo-mini-fta" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_250HD
	echo "cuberevo-250hd" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_2000HD
	echo "cuberevo-2000hd" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_CUBEREVO_9500HD
	echo "cuberevo-9500hd" > $(prefix)/release_vdrdev2/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_vdrdev2/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdrdev2/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdrdev2/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_vdrdev2/etc/init.d/halt
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/rc
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdrdev2/etc/init.d/halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdrdev2/etc/rc.d
	ln -fs halt $(prefix)/release_vdrdev2/sbin/reboot
	ln -fs halt $(prefix)/release_vdrdev2/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdrdev2/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdrdev2/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdrdev2/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/modules/simu_button.ko
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/tffpctl
	rm -f $(prefix)/release_vdrdev2/bin/vfdctl
	rm -f $(prefix)/release_vdrdev2/bin/evremote
	rm -f $(prefix)/release_vdrdev2/bin/tfd2mtd
else
if ENABLE_FORTIS_HDBOX

	echo "fortis" > $(prefix)/release_vdrdev2/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_vdrdev2/lib/modules/

if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_vdrdev2/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_vdrdev2/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_vdrdev2/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_vdrdev2/lib/modules
endif

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/evremote
else
if ENABLE_ATEVIO7500

	echo "fortis" > $(prefix)/release_vdrdev2/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdrdev2/bin/evremote
else
if ENABLE_ADB_BOX

	echo "Adb_Box" > $(prefix)/release_vdr/etc/hostname
	rm -f $(prefix)/release_vdr/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_vdr/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_vdr/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_vdr/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_vdr/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_vdr/etc/init.d/
	cp $(buildprefix)/root/release/halt_adb_box $(prefix)/release_vdr/etc/init.d/halt
	chmod 755 $(prefix)/release_vdr/etc/init.d/umountfs
	chmod 755 $(prefix)/release_vdr/etc/init.d/rc
	chmod 755 $(prefix)/release_vdr/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_vdr/etc/init.d/halt
	mkdir -p $(prefix)/release_vdr/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_vdr/etc/rc.d
	ln -fs halt $(prefix)/release_vdr/sbin/reboot
	ln -fs halt $(prefix)/release_vdr/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_vdr/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdr/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_vdr/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_vdr/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_vdr/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_vdr/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_vdr/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release_vdr/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release_vdr/lib/modules/
	cp $(buildprefix)/root/firmware/as102_data1_st.hex $(prefix)/release/lib/firmware/
	cp $(buildprefix)/root/firmware/as102_data2_st.hex $(prefix)/release/lib/firmware/
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release_vdr/etc/fstab

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_vdr/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_vdr/etc/
	echo 'sda    -fstype=auto,noatime,nodiratime          :/dev/sda' >> $(prefix)/release_vdr/etc/auto.usb
	echo 'sda1   -fstype=auto,noatime,nodiratime          :/dev/sda1' >> $(prefix)/release_vdr/etc/auto.usb
	echo 'sda2   -fstype=auto,noatime,nodiratime          :/dev/sda2' >> $(prefix)/release_vdr/etc/auto.usb
	echo 'sda3   -fstype=auto,noatime,nodiratime          :/dev/sda3' >> $(prefix)/release_vdr/etc/auto.usb

	rm -f $(prefix)/release/bin/vdstandby

	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_vdr/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_vdr/bin/evremote

	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_vdrdev2/lib/modules/

	rm -f $(prefix)/release_vdrdev2/lib/firmware/dvb-fe-cx21143.fw
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
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_vdrdev2/lib/modules/
if !ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_vdrdev2/lib/modules/
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_vdrdev2/lib/modules/
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_compress.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/lzo-kmod/lzo1x_decompress.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_vdrdev2/lib/modules/
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_vdrdev2/lib/modules/
endif
endif
if ENABLE_PLAYER131
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_vdrdev2/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_vdrdev2/lib/modules/
	find $(prefix)/release_vdrdev2/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_vdrdev2/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
			echo "`basename $$mod` not found" ; \
		fi;\
	done
endif

if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_vdrdev2/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_vdrdev2/lib/modules/
	find $(prefix)/release_vdrdev2/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_vdrdev2/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_vdrdev2/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_vdrdev2/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_vdrdev2/lib/modules/
	find $(prefix)/release_vdrdev2/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
		if [ -e player2/linux/drivers/$$mod ] ; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_vdrdev2/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_vdrdev2/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if STM22
	rm $(prefix)/release_vdrdev2/lib/modules/p2div64.ko
endif
	rm -rf $(prefix)/release_vdrdev2/lib/autofs
	rm -rf $(prefix)/release_vdrdev2/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/media
	ln -s /hdd $(prefix)/release_vdrdev2/media/hdd
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/media/dvd

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/mnt
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/root

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/proc
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/sys
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/tmp

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr
	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/bin
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_vdrdev2/usr/bin/
if ENABLE_TF7700
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_vdrdev2/usr/bin/
endif

if ENABLE_UFS910
#	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_vdrdev2/usr/bin/
	touch $(prefix)/release_vdrdev2/usr/bin/lircd
endif

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_vdrdev2/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_vdrdev2/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/tuxtxt


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/share

#######################################################################################


#######################################################################################

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_vdrdev2/usr/share/zoneinfo/

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_vdrdev2/usr/share/udhcpc/


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/local

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/local/bin
	cp -rd $(targetprefix)/usr/local/bin/vdr $(prefix)/release_vdrdev2/usr/local/bin/
	find $(prefix)/release_vdrdev2/usr/local/bin/ -name  vdr -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################

#	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/local/share
#	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_vdrdev2/usr/local/share/
#	TODO: Channellist ....
#	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/local/share/config
#	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_vdrdev2/usr/local/share/config/
#	cp -aR $(targetprefix)/usr/local/share/vdr $(prefix)/release_vdrdev2/usr/local/share/
#	TODO: HACK
#	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/vdr/* $(prefix)/release_vdrdev2/usr/local/share/vdr
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/release_vdrdev2/usr/local/share/
#	ln -s /usr/local/share/fonts/micron.ttf $(prefix)/release_vdrdev2/usr/local/share/fonts/vdr.ttf
	mkdir -p $(prefix)/release_vdrdev2/usr/share/fonts
	mkdir -p $(prefix)/release_vdrdev2/etc/fonts
	cp -d $(buildprefix)/root/usr/share/fonts/seg.ttf $(prefix)/release_vdrdev2/usr/share/fonts/vdr.ttf
	cp -d $(targetprefix)/etc/fonts/fonts.conf $(prefix)/release_vdrdev2/etc/fonts/


#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_vdrdev2/etc/imageinfo
	git describe >> $(prefix)/release_vdrdev2/etc/imageinfo
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/lib

	mkdir -p $(prefix)/release_vdrdev2/usr/local/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_vdrdev2/usr/lib/
#	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_vdrdev2/usr/lib/
	cp -rd $(targetprefix)/usr/lib/libfontconfi* $(prefix)/release_vdrdev2/usr/lib/
	mkdir -p $(prefix)/release_vdrdev2/usr/lib/vdr/

	cp -rd $(targetprefix)/usr/lib/vdr/lib*.1.7.22 $(prefix)/release_vdrdev2/usr/lib/vdr/
	cp -rd $(targetprefix)/usr/lib/vdr/lib*.1.7.22 $(prefix)/release_vdrdev2/usr/lib/vdr/

	rm -rf $(prefix)/release_vdrdev2/usr/lib/alsa-lib
	rm -rf $(prefix)/release_vdrdev2/usr/lib/alsaplayer
	rm -rf $(prefix)/release_vdrdev2/usr/lib/engines
	rm -rf $(prefix)/release_vdrdev2/usr/lib/enigma2

	rm -rf $(prefix)/release_vdrdev2/usr/lib/gconv/*
	cp -rd $(targetprefix)/usr/lib/gconv/gconv-modules $(prefix)/release_vdrdev2/usr/lib/gconv/
#cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-1.so $(prefix)/release_vdrdev2/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-9.so $(prefix)/release_vdrdev2/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/ISO8859-15.so $(prefix)/release_vdrdev2/usr/lib/gconv/
	cp -rd $(targetprefix)/usr/lib/gconv/UTF-32.so $(prefix)/release_vdrdev2/usr/lib/gconv/

	rm -rf $(prefix)/release_vdrdev2/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_vdrdev2/usr/lib/pkgconfig
	rm -rf $(prefix)/release_vdrdev2/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_vdrdev2/usr/lib/X11
	rm -f $(prefix)/release_vdrdev2/usr/lib/*.a
	rm -f $(prefix)/release_vdrdev2/usr/lib/*.o
	rm -f $(prefix)/release_vdrdev2/usr/lib/*.la
	find $(prefix)/release_vdrdev2/usr/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/vdr #############
	cp -RP $(buildprefix)/own_build/vdr/* $(prefix)/release_vdrdev2/
	ln -sf /usr/share/zoneinfo/CET $(prefix)/release_vdrdev2/etc/localtime
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/include/boost

#	mkdir -p $(prefix)/release_vdrdev2/usr/include/boost/
#	cp -rd $(targetprefix)/usr/include/boost/shared_container_iterator.hpp $(prefix)/release_vdrdev2/usr/include/boost/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/share/locale

#	mkdir -p $(prefix)/release_vdrdev2/usr/share/locale/
	cp -rd $(targetprefix)/usr/share/locale/* $(prefix)/release_vdrdev2/usr/share/locale

	mkdir -p $(prefix)/release_vdrdev2/usr/local/share/locale
#	cp -rd $(targetprefix)/usr/local/share/locale/* $(prefix)/release_vdrdev2/usr/local/share/locale
	cp -rd $(targetprefix)/usr/local/share/locale/de_DE $(prefix)/release_vdrdev2/usr/local/share/locale/

#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_vdrdev2/usr/share/locale

	mkdir -p $(prefix)/release_vdrdev2/var/vdr
#	cp -rd $(targetprefix)/var/vdr/remote.conf $(prefix)/release_vdrdev2/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/sources.conf $(prefix)/release_vdrdev2/var/vdr/
#	cp -rd $(targetprefix)/var/vdr/channels.conf $(prefix)/release_vdrdev2/var/vdr/
#	cp -rd $(targetprefix)/var/vdr $(prefix)/release_vdrdev2/var/vdr/

#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release_vdrdev2/boot/
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release_vdrdev2/boot/
endif

if STM24
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_vdrdev2/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_vdrdev2/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_vdrdev2/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_vdrdev2/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_vdrdev2/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_vdrdev2/lib/modules || true
endif

	touch $@
