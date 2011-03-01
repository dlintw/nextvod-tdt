#Trick ALPHA-Version ;)
$(DEPDIR)/min-release_neutrino $(DEPDIR)/std-release_neutrino $(DEPDIR)/max-release_neutrino $(DEPDIR)/ipk-release_neutrino $(DEPDIR)/release_neutrino: \
$(DEPDIR)/%release_neutrino:
	rm -rf $(prefix)/release_neutrino || true
	$(INSTALL_DIR) $(prefix)/release_neutrino && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/bin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/sbin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/boot && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/dev && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/dev.static && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/tuxbox && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/movie && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/music && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/picture && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/lib && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/ram && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/etc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_neutrino && \
	touch $(prefix)/release_neutrino/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_neutrino/bin/ && \
	ln -s /bin/showiframe $(prefix)/release_neutrino/usr/bin/showiframe && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(buildprefix)/root/var/etc/.version $(prefix)/release_neutrino/var/etc/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV$(if $(TF7700),_dual_tuner)$(if $(FORTIS_HDBOX),_dual_tuner)$(if $(ATEVIO7500),_dual_tuner)$(if $(CUBEREVO),_dual_tuner)$(if $(CUBEREVO_9500HD),_dual_tuner)$(if $(UFS922),_dual_tuner)$(if $(CUBEREVO_MINI_FTA),_no_CI)$(if $(CUBEREVO_250HD),_no_CI)$(if $(CUBEREVO_2000HD),_no_CI) $(prefix)/release_neutrino/sbin/MAKEDEV && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_neutrino/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release_neutrino/bin/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_neutrino/sbin/ && \
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_neutrino/boot/video.elf && \
	$(if $(TF7700),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(HL101),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(VIP1_V2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(VIP2_V1),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(UFS912),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(UFS922),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI2),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_MINI_FTA),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_250HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_2000HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(CUBEREVO_9500HD),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(FORTIS_HDBOX),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(ATEVIO7500),cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	$(if $(OCTAGON1008),cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf &&) \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_neutrino/boot/audio.elf && \
	$(if $(UFS912),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf &&) \
	$(if $(SPARK),cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf &&) \
	cp -a $(targetprefix)/dev/* $(prefix)/release_neutrino/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_neutrino/etc/ && \
	$(if $(UFS910),cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_neutrino/etc/ &&) \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/halt $(prefix)/release_neutrino/etc/init.d/ && \
	mkdir -p $(prefix)/release_neutrino/usr/local/share/config/tuxtxt/ && \
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_neutrino/usr/local/share/config/tuxtxt/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_neutrino/etc/init.d/ && \
	echo "576i50" > $(prefix)/release_neutrino/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_neutrino$(if $(TF7700),_$(TF7700))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS922),_$(UFS922))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)) $(prefix)/release_neutrino/etc/init.d/rcS && \
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/getfb.awk $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_neutrino/boot/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_neutrino/lib/ && \
	rm -f $(prefix)/release_neutrino/lib/*.a && \
	rm -f $(prefix)/release_neutrino/lib/*.o && \
	rm -f $(prefix)/release_neutrino/lib/*.la && \
	find $(prefix)/release_neutrino/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
if !STM22
	cp $(buildprefix)/root/release/rcS_stm23_neutrino$(if $(TF7700),_$(TF7700))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(UFS912),_$(UFS912))$(if $(SPARK),_$(SPARK)) $(prefix)/release_neutrino/etc/init.d/rcS
endif
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_neutrino/lib/modules/
	$(if $(UFS922),cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_neutrino/lib/modules/)

if ENABLE_TF7700

	echo "tf7700" > $(prefix)/release_neutrino/etc/hostname 
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_neutrino/etc/fstab

#	install autofs
	cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_neutrino/usr/sbin/
	cp -f $(buildprefix)/root/release/auto.usb $(prefix)/release_neutrino/etc/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else
if ENABLE_UFS922

	echo "ufs922" > $(prefix)/release_neutrino/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot	
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else
if ENABLE_UFS912

	echo "ufs912" > $(prefix)/release_neutrino/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot	
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf 
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf

	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

else
if ENABLE_SPARK

	echo "spark" > $(prefix)/release_neutrino/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf 
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

else
if ENABLE_HL101

	echo "hl101" > $(prefix)/release_neutrino/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else
if ENABLE_VIP1_V2

	echo "Edision" > $(prefix)/release_neutrino/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else
if ENABLE_VIP2_V1

	echo "Edision" > $(prefix)/release_neutrino/etc/hostname 
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
else
if ENABLE_CUBEREVO
	echo "cuberevo" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI
	echo "cuberevo-mini" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI2
	echo "cuberevo-mini2" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_MINI_FTA
	echo "cuberevo-mini-fta" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_250HD
	echo "cuberevo-250hd" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_2000HD
	echo "cuberevo-2000hd" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_CUBEREVO_9500HD
	echo "cuberevo-9500hd" > $(prefix)/release_neutrino/etc/hostname
#       remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-avl2108.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-stv6306.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd
else
if ENABLE_FORTIS_HDBOX

	echo "fortis" > $(prefix)/release_neutrino/etc/hostname 
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 777 $(prefix)/release_neutrino/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
else
if ENABLE_ATEVIO7500

	echo "atevio7500" > $(prefix)/release_neutrino/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 777 $(prefix)/release_neutrino/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_neutrino/lib/modules/		
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf 
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_neutrino/boot/audio.elf

	mv $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
else
if ENABLE_OCTAGON1008

	echo "octagon1008" > $(prefix)/release_neutrino/etc/hostname
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 777 $(prefix)/release_neutrino/etc/init.d/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot	
# disable driver copy
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/avl2108.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
else
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino/lib/modules/

	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw
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
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_neutrino/lib/modules/
if !ENABLE_OCTAGON1008
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
endif
if !ENABLE_SPARK
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_neutrino/lib/modules/
endif
if ENABLE_PLAYER131
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_neutrino/lib/modules/
	find $(prefix)/release_neutrino/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		fi;\
	done
endif

if ENABLE_PLAYER179
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino/lib/modules/
#	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_neutrino/lib/modules/
	find $(prefix)/release_neutrino/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		fi;\
	done
endif    
    
    
if STM22
	rm $(prefix)/release_neutrino/lib/modules/p2div64.ko
endif
	rm -rf $(prefix)/release_neutrino/lib/autofs
	rm -rf $(prefix)/release_neutrino/lib/modules/$(KERNELVERSION)

	$(INSTALL_DIR) $(prefix)/release_neutrino/media
	ln -s /hdd $(prefix)/release_neutrino/media/hdd
	$(INSTALL_DIR) $(prefix)/release_neutrino/media/dvd

	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/usb
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/hdd
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/nfs

	$(INSTALL_DIR) $(prefix)/release_neutrino/root

	$(INSTALL_DIR) $(prefix)/release_neutrino/proc
	$(INSTALL_DIR) $(prefix)/release_neutrino/sys
	$(INSTALL_DIR) $(prefix)/release_neutrino/tmp

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/bin
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/lib
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_neutrino/usr/bin/
if ENABLE_TF7700
#	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/ 
	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif

if ENABLE_UFS910
	cp -dp $(buildprefix)/root/etc/lircd.conf $(prefix)/release_neutrino/etc/
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino/usr/lib/ 
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif

if ENABLE_HL101
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino/usr/lib/ 
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif
if ENABLE_VIP1_V2
	cp -dp $(buildprefix)/root/etc/lircd_vip1_v2.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino/usr/lib/ 
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif
if ENABLE_VIP2_V1
	cp -dp $(buildprefix)/root/etc/lircd_vip2_v1.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino/usr/lib/ 
#	cp -p $(buildprefix)/root/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
endif

	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_neutrino/usr/bin/
	cp -p $(targetprefix)/usr/sbin/ethtool $(prefix)/release_neutrino/usr/sbin/

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/tuxtxt


#######################################################################################
	mkdir -p $(prefix)/release_neutrino/tuxbox/config
	mkdir -p $(prefix)/release_neutrino/var/plugins
	mkdir -p $(prefix)/release_neutrino/lib/tuxbox
	mkdir -p $(prefix)/release_neutrino/usr/lib/tuxbox
	mkdir -p $(prefix)/release_neutrino/var/tuxbox/config
	mkdir -p $(prefix)/release_neutrino/share/tuxbox
	mkdir -p $(prefix)/release_neutrino/var/share/icons
	mkdir -p $(prefix)/release_neutrino/var/usr/local/share/config
	( cd $(prefix)/release_neutrino/share/tuxbox && ln -s /usr/local/share/neutrino )
	( cd $(prefix)/release_neutrino/var/share/icons/ && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_neutrino/ && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/release_neutrino/lib && ln -s libcrypto.so.0.9.7 libcrypto.so.0.9.8 )
	( cd $(prefix)/release_neutrino/lib/tuxbox && ln -s /var/plugins )
	( cd $(prefix)/release_neutrino/var/tuxbox && ln -s /var/plugins )
	( cd $(prefix)/release_neutrino/usr/lib/tuxbox && ln -s /var/plugins )

#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share

#######################################################################################


#######################################################################################

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/zoneinfo
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_neutrino/usr/share/zoneinfo/

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/udhcpc
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_neutrino/usr/share/udhcpc/


#######################################################################################
#######################################################################################
#######################################################################################
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	find $(prefix)/release_neutrino/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino/usr/local/bin/ -name  pzapit -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino/usr/local/bin/ -name  sectionsdcontrol -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/share
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_neutrino/usr/local/share/
#	TODO: Channellist ....
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/local/share/config
	cp -aR $(buildprefix)/root/usr/local/share/config/* $(prefix)/release_neutrino/usr/local/share/config/
	cp -aR $(targetprefix)/usr/local/share/neutrino $(prefix)/release_neutrino/usr/local/share/
#	TODO: HACK
	cp -aR $(targetprefix)/$(targetprefix)/usr/local/share/neutrino/* $(prefix)/release_neutrino/usr/local/share/neutrino
#######################################################################################
#	cp -aR $(targetprefix)/usr/local/share/fonts $(prefix)/release_neutrino/usr/local/share/
	mkdir -p $(prefix)/release_neutrino/usr/local/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/tuxtxt.ttf $(prefix)/release_neutrino/usr/local/share/fonts/

#       Font libass
	mkdir -p $(prefix)/release_neutrino/usr/share/fonts
	cp $(buildprefix)/root/usr/share/fonts/FreeSans.ttf $(prefix)/release_neutrino/usr/share/fonts/

	cp -aR $(targetprefix)/usr/local/share/fonts/micron.ttf $(prefix)/release_neutrino/usr/local/share/fonts/neutrino.ttf
	cp $(appsdir)/neutrino/src/nhttpd/web/{Y_Baselib.js,Y_VLC.js} $(prefix)/release_neutrino/usr/local/share/neutrino/httpd-y/
	rm $(prefix)/release_neutrino/usr/local/share/neutrino/httpd-y/{Y_Baselib.js.gz,Y_VLC.js.gz}
#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_neutrino/etc/imageinfo
	git describe >> $(prefix)/release_neutrino/etc/imageinfo
	$(buildprefix)/root/release/neutrino_version.sh
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/lib

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_neutrino/usr/lib/
	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_neutrino/usr/lib/
	rm -rf $(prefix)/release_neutrino/usr/lib/alsa-lib
	rm -rf $(prefix)/release_neutrino/usr/lib/alsaplayer
	rm -rf $(prefix)/release_neutrino/usr/lib/engines
	rm -rf $(prefix)/release_neutrino/usr/lib/enigma2
	rm -rf $(prefix)/release_neutrino/usr/lib/gconv
	rm -rf $(prefix)/release_neutrino/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_neutrino/usr/lib/pkgconfig
	rm -rf $(prefix)/release_neutrino/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_neutrino/usr/lib/X11
	rm -f $(prefix)/release_neutrino/usr/lib/*.a
	rm -f $(prefix)/release_neutrino/usr/lib/*.o
	rm -f $(prefix)/release_neutrino/usr/lib/*.la
	mkdir -p $(prefix)/release_neutrino/usr/local/share/neutrino/icons/logo
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino/httpd-y && ln -s /usr/local/share/neutrino/icons/logo )
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino/httpd-y && ln -s /usr/local/share/neutrino/icons/logo logos )
	( cd $(prefix)/release_neutrino/usr/local/share/neutrino && ln -s /usr/local/share/neutrino/httpd-y httpd )
	( cd $(prefix)/release_neutrino/var && ln -s /usr/local/share/neutrino/httpd-y httpd )
	find $(prefix)/release_neutrino/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;
#
######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino #############
#	rm $(prefix)/release_neutrino/bin/mount
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/release_neutrino/

#if ENABLE_FLASH_UFS910
######### FOR FLASHBUILDING UFS-910 with mount -o bind /var/etc /etc #################
#	rm $(prefix)/release_neutrino/boot/bootlogo.mvi
#	cp -RP $(prefix)/release_neutrino/etc $(prefix)/release_neutrino/var/
#	rm -rf $(prefix)/release_neutrino/etc
#	mkdir -p $(prefix)/release_neutrino/etc/init.d
#	cp -RP $(prefix)/release_neutrino/var/etc/init.d/{rcS,mountvirtfs} $(prefix)/release_neutrino/etc/init.d
#	rm -rf $(prefix)/release_neutrino/var/etc/init.d/{rcS,mountvirtfs}
#	mv $(prefix)/release_neutrino/var/etc/inittab $(prefix)/release_neutrino/etc/
#	mkdir -p $(prefix)/release_neutrino/var/usr/local/share
#	mv $(prefix)/release_neutrino/usr/local/share/config $(prefix)/release_neutrino/var/usr/local/share/
#	mv $(prefix)/release_neutrino/usr/local/share/neutrino $(prefix)/release_neutrino/var/usr/local/share/
#	( cd $(prefix)/release_neutrino/usr/local/share && ln -s /var/usr/local/share/config && ln -s /var/usr/local/share/neutrino && ln -s /var/usr/local/share/operations )
#	rm -rf $(prefix)/release_neutrino/tuxbox
#	( cd $(prefix)/release_neutrino/ && ln -s /var/tuxbox )
#	rm -rf $(prefix)/release_neutrino/lib/tuxbox
#	( cd $(prefix)/release_neutrino/lib && ln -s /var/tuxbox )
#	rm -rf $(prefix)/release_neutrino/share/tuxbox
#	( cd $(prefix)/release_neutrino/share && ln -s /var/tuxbox )
#	mv $(prefix)/release_neutrino/media $(prefix)/release_neutrino/var/
#	mv $(prefix)/release_neutrino/hdd $(prefix)/release_neutrino/var/
#	mv $(prefix)/release_neutrino/mnt $(prefix)/release_neutrino/var/
#	( cd $(prefix)/release_neutrino/ && ln -s /var/media && ln -s /var/mnt && ln -s /var/hdd )
#	( cd $(prefix)/release_neutrino/dev && sudo tar -xzvf dev_neutrino.tar.gz && sudo chmod 777 -R $(prefix)/release_neutrino/dev )
#	rm $(prefix)/release_neutrino/dev/dev_neutrino.tar.gz
#	rm $(prefix)/release_neutrino/var/etc/.firstboot
#	rm $(prefix)/release_neutrino/sbin/{fsck.nfs,fsck.ext2,fsck.ext3,killall5,sfdisk}
#	rm $(prefix)/release_neutrino/bin/{showiframe,stslave,tfd2mtd,tffpctl}
#	rm $(prefix)/release_neutrino/usr/bin/showiframe
#	( cd $(prefix)/release_neutrino/sbin && ln -sf mke2fs mkfs.ext2 && ln -sf mke2fs mkfs.ext3 )
#	( cd $(prefix)/release_neutrino/bin && ln -sf busybox pidof )
#endif

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release_neutrino/boot/
#	cp $(buildprefix)/own_build/neutrino/boot/uImage $(prefix)/release_neutrino/boot/
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino/usr/bin/
	cp -dp $(targetprefix)/usr/bin/rdate $(prefix)/release_neutrino/usr/bin/
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release_neutrino/boot/
endif

	touch $@
