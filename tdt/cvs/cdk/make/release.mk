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


release_cuberevo_9500hd: release_common_utils release_cube_common
	echo "cuberevo-9500hd" > $(prefix)/release/etc/hostname


release_cuberevo_2000hd: release_common_utils release_cube_common
	echo "cuberevo-2000hd" > $(prefix)/release/etc/hostname


release_cuberevo_250hd: release_common_utils release_cube_common cube_skin_extra
	echo "cuberevo-250hd" > $(prefix)/release/etc/hostname


cube_skin_extra:
	cp $(targetprefix)/usr/local/share/enigma2/skin_default/rc_small.png $(prefix)/release/usr/local/share/enigma2/skin_default/rc.png
	cp $(targetprefix)/usr/local/share/enigma2/skin_default/rcold_small.png $(prefix)/release/usr/local/share/enigma2/skin_default/rcold.png
	cp $(targetprefix)/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rc_small.png $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rc.png
	cp $(targetprefix)/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rcold_small.png $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rcold.png
	cp $(targetprefix)/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/gfx/remotecontrol_static_small.jpg $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/gfx/remotecontrol_static.jpg
	cp $(targetprefix)/usr/local/share/enigma2/rcpositions_small.xml $(prefix)/release/usr/local/share/enigma2/rcpositions.xml
	cp $(targetprefix)/usr/local/share/enigma2/keymap_small.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml


release_cuberevo_mini_fta: release_common_utils release_cube_common cube_skin_extra
	echo "cuberevo-mini-fta" > $(prefix)/release/etc/hostname


release_cuberevo_mini2: release_common_utils release_cube_common
	echo "cuberevo-mini2" > $(prefix)/release/etc/hostname
#	obviously the following two links are not desired
	rm -f $(prefix)/release/sbin/reboot
	rm -f $(prefix)/release/sbin/poweroff


release_cuberevo_mini: release_common_utils release_cube_common
	echo "cuberevo-mini" > $(prefix)/release/etc/hostname


release_cuberevo: release_common_utils release_cube_common
	echo "cuberevo" > $(prefix)/release/etc/hostname


release_cube_common:
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf

	rm -f $(prefix)/release/lib/modules/simu_button.ko
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/tffpctl
	rm -f $(prefix)/release/bin/vfdctl
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/tfd2mtd

	rm -f $(prefix)/release/usr/local/share/enigma2/skin_default/rc_dream.png
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rc_dream.png
	rm -f $(prefix)/release/usr/local/share/enigma2/skin_default/rcold_dream.png
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rcold_dream.png
	rm -f $(prefix)/release/usr/local/share/enigma2/skin_default/rc_small.png
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rc_small.png
	rm -f $(prefix)/release/usr/local/share/enigma2/skin_default/rcold_small.png
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/img/rcold_small.png
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/gfx/remotecontrol_static_small.jpg
	rm -f $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/WebInterface/web-data/gfx/remotecontrol_static_dream.jpg
	rm -f $(prefix)/release/usr/local/share/enigma2/rcpositions_dream.xml
	rm -f $(prefix)/release/usr/local/share/enigma2/rcpositions_small.xml
	rm -f $(prefix)/release/usr/local/share/enigma2/keymap_small.xml


release_ufs922:
	echo "ufs922" > $(prefix)/release/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/micom/micom.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/bin/evremote
	rm -f $(prefix)/release/bin/gotosleep


release_fortis_hdbox:
	echo "fortis" > $(prefix)/release/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/evremote


release_ufs910:
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/vfd/vfd.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release/boot/video.elf

	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release/usr/bin/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw


release_tf7700: release_common_utils
	echo "tf7700" > $(prefix)/release/etc/hostname 
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release/sbin/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/tffp/tffp.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release/boot/video.elf
	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_tf7700.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml	


#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release/etc/

	rm -f $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release/bin/gotosleep
	rm -f $(prefix)/release/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(prefix)/release/usr/local/share/enigma2/settings


#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/min-release $(DEPDIR)/std-release $(DEPDIR)/max-release $(DEPDIR)/ipk-release $(DEPDIR)/release: \
$(DEPDIR)/%release: release_base release_$(TF7700)$(UFS910)$(UFS922)$(FORTIS_HDBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)
	touch $@

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
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI) $(prefix)/release/sbin/MAKEDEV && \
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
	cp $(buildprefix)/root/release/rcS$(if $(TF7700),_$(TF7700))$(if $(UFS922),_$(UFS922))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/etc/init.d/rcS && \
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
	find $(prefix)/release/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;
if !STM22
	cp $(buildprefix)/root/release/rcS_stm23$(if $(TF7700),_$(TF7700))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release/etc/init.d/rcS && \
	rm -f $(prefix)/release/bin/{stslave,ustslave}
else
	rm -f $(prefix)/release/bin/ustslave_stm23
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release/lib/modules/

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/sound/pseudocard/pseudocard.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/sound/silencegen/silencegen.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/stm/mmelog/mmelog.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/stm/monitor/stm_monitor.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/video/stm/stm_v4l2.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/dvb/stm/dvb/stmdvb.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/sound/ksound/ksound.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/dvb/stm/backend/player2.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/dvb/stm/h264_preprocessor/sth264pp.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/media/dvb/stm/allocator/stmalloc.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/stm/platform/platform.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release/lib/modules/
if !STM22
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/player2/linux/drivers/stm/platform/p2div64.ko $(prefix)/release/lib/modules/
endif
	find $(prefix)/release/lib/modules/ -name  *.ko -exec sh4-linux-strip --strip-unneeded {} \;
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
	cp -p $(targetprefix)/usr/bin/tuxtxt $(prefix)/release/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release/usr/tuxtxt
	cp -p $(targetprefix)/usr/tuxtxt/tuxtxt2.conf $(prefix)/release/usr/tuxtxt/

	$(INSTALL_DIR) $(prefix)/release/usr/share

	ln -s /usr/local/share/enigma2 $(prefix)/release/usr/share/enigma2
	$(INSTALL_DIR) $(prefix)/release/usr/share/alsa
	cp -a $(targetprefix)/usr/share/alsa/* $(prefix)/release/usr/share/alsa


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

	$(INSTALL_DIR) $(prefix)/release/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release/usr/share/zoneinfo/

	$(INSTALL_DIR) $(prefix)/release/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release/usr/share/udhcpc/

	ln -s /usr/local/share/keymaps $(prefix)/release/usr/share/keymaps

	$(INSTALL_DIR) $(prefix)/release/usr/local
	$(INSTALL_DIR) $(prefix)/release/usr/local/bin
	cp $(targetprefix)/usr/local/bin/enigma2 $(prefix)/release/usr/local/bin/
	find $(prefix)/release/usr/local/bin/ -name  enigma2 -exec sh4-linux-strip --strip-unneeded {} \;

	ln -s /etc $(prefix)/release/usr/local/etc

	$(INSTALL_DIR) $(prefix)/release/usr/local/share
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/keymaps
	$(INSTALL_DIR) $(prefix)/release/usr/local/share/enigma2
	cp -a $(targetprefix)/usr/local/share/enigma2/* $(prefix)/release/usr/local/share/enigma2
	cp -a $(targetprefix)/etc/enigma2/* $(prefix)/release/etc/enigma2

	cp -f $(buildprefix)/root/usr/local/share/enigma2/keymap_ufs910.xml $(prefix)/release/usr/local/share/enigma2/keymap.xml	

	$(INSTALL_DIR) $(prefix)/release/usr/lib
	cp -R $(targetprefix)/usr/lib/* $(prefix)/release/usr/lib/
	rm -rf $(prefix)/release/usr/lib/alsa-lib
	rm -rf $(prefix)/release/usr/lib/alsaplayer
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
	find $(prefix)/release/usr/lib/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

	$(INSTALL_DIR) $(prefix)/release/usr/lib/enigma2
	cp -a $(targetprefix)/usr/lib/enigma2/* $(prefix)/release/usr/lib/enigma2/
	if test -d $(targetprefix)/usr/local/lib/enigma2; then \
		cp -a $(targetprefix)/usr/local/lib/enigma2/* $(prefix)/release/usr/lib/enigma2/; fi
	find $(prefix)/release/usr/lib/enigma2/ -name *.a -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name *.o -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name *.la -exec rm -f {} \;
	find $(prefix)/release/usr/lib/enigma2/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

#Delete unnecessary plugins 
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/DemoPlugins 
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/SystemPlugins/FrontprocessorUpgrade 
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/SystemPlugins/NFIFlash 
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/FileManager 
	rm -rf $(prefix)/release/usr/lib/enigma2/python/Plugins/Extensions/TuxboxPlugins 

	$(INSTALL_DIR) $(prefix)/release/usr/lib/python2.6
	cp -a $(targetprefix)/usr/lib/python2.6/* $(prefix)/release/usr/lib/python2.6/

	rm -rf $(prefix)/release/usr/lib/python2.6/test

	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml

	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/lxml-2.0.5-py2.5.egg.info

	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxml2mod.so
	rm -f $(prefix)/release/usr/lib/python2.6/site-packages/libxsltmod.so

	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/OpenSSL/test

	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/setuptools

	rm -rf $(prefix)/release/usr/lib/python2.6/site-packages/setuptools-0.6c8-py2.5.egg-info

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

	rm -rf $(prefix)/release/usr/lib/python2.6/bsddb

	rm -rf $(prefix)/release/usr/lib/python2.6/compiler

	rm -rf $(prefix)/release/usr/lib/python2.6/config

	rm -rf $(prefix)/release/usr/lib/python2.6/ctypes

	rm -rf $(prefix)/release/usr/lib/python2.6/curses

	rm -rf $(prefix)/release/usr/lib/python2.6/distutils

	rm -rf $(prefix)/release/usr/lib/python2.6/email

	find $(prefix)/release/usr/lib/python2.6/ -name *.a -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name *.o -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name *.la -exec rm -f {} \;
	find $(prefix)/release/usr/lib/python2.6/ -name  *.so* -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2 #############
	cp -RP $(buildprefix)/own_build/enigma2/* $(prefix)/release/

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release/boot/
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release/boot/
endif

