$(DEPDIR)/min-release_neutrino_static $(DEPDIR)/std-release_neutrino_static $(DEPDIR)/max-release_neutrino_static $(DEPDIR)/release_neutrino_static: \
$(DEPDIR)/%release_neutrino_static:
	$(INSTALL_DIR) $(prefix)/release_neutrino_static && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/bin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/sbin && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/boot && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/dev && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/fonts && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/init.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/network && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/network/if-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/network/if-post-down.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/network/if-pre-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/etc/network/if-up.d && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/hdd && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/lib && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/ram && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/var && \
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/var/etc && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_neutrino_static && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_neutrino_static/bin/ && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext2 $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs.ext3 $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext2 $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.ext3 $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino_static/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_neutrino_static/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/bin/grep $(prefix)/release_neutrino_static/bin/ && \
	cp -dp $(targetprefix)/usr/bin/egrep $(prefix)/release_neutrino_static/bin/ && \
	cp -dp $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_neutrino_static/sbin/ && \
	cp -R $(buildprefix)/static/common/* $(prefix)/release_neutrino_static/ && \
	cp -R $(buildprefix)/static/$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(SPARK)$(SPARK7162)$(UFS922)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(ATEMIO520)$(ATEMIO530)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(HOMECAST5101)$(ADB_BOX)/* $(prefix)/release_neutrino_static/ && \
	cp -R $(buildprefix)/static/neutrino/* $(prefix)/release_neutrino_static/ && \
	cp -rd $(targetprefix)/lib/* $(prefix)/release_neutrino_static/lib/ && \
	rm -f $(prefix)/release_neutrino_static/lib/*.a && \
	rm -f $(prefix)/release_neutrino_static/lib/*.o && \
	rm -f $(prefix)/release_neutrino_static/lib/*.la && \
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_neutrino_static/lib/modules/

if ENABLE_TF7700
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_UFS922
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_UFS912
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_SPARK
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_HL101
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_ADB_BOX
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_VIP1_V2
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_VIP2_V1
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_MINI
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_MINI2
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_MINI_FTA
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_250HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_2000HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_CUBEREVO_9500HD
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cubefp/fp.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_FORTIS_HDBOX
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_ATEVIO7500
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino_static/lib/modules/
else
if ENABLE_HS7810A
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino_static/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_neutrino_static/lib/modules
endif
else
if ENABLE_HS7110
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino_static/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_neutrino_static/lib/modules
endif
else
if ENABLE_ATEMIO520
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino_static/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_neutrino_static/lib/modules
endif
else
if ENABLE_ATEMIO530
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino_static/lib/modules/
if STM23
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino_static/lib/modules/ftdi.ko
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino_static/lib/modules
	cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_neutrino_static/lib/modules
endif
else
if ENABLE_OCTAGON1008
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino_static/boot/video.elf
else
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino_static/lib/modules/
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

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_neutrino_static/lib/modules/
if !ENABLE_OCTAGON1008
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino_static/lib/modules/
endif
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_neutrino_static/lib/modules/
endif
endif
#	PLAYER

	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_neutrino_static/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino_static/lib/modules/

	find $(prefix)/release_neutrino_static/lib/modules/ -name '*.ko' -exec sh4-linux-strip --strip-unneeded {} \;
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
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino_static/lib/modules/; \
		else \
			touch $(prefix)/release_neutrino_static/lib/modules/`basename $$mod`; \
		fi;\
	done


if STM22
	rm $(prefix)/release_neutrino_static/lib/modules/p2div64.ko
endif

	$(INSTALL_DIR) $(prefix)/release_neutrino_static/mnt

	$(INSTALL_DIR) $(prefix)/release_neutrino_static/root

	$(INSTALL_DIR) $(prefix)/release_neutrino_static/proc
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/sys
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/tmp

	$(INSTALL_DIR) $(prefix)/release_neutrino_static/usr
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/usr/bin
	$(INSTALL_DIR) $(prefix)/release_neutrino_static/usr/lib
	cp -p $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_neutrino_static/usr/bin/
	cp -dp $(buildprefix)/root/etc/lircd.conf $(prefix)/release_neutrino_static/etc/
	cp -dp $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino_static/usr/bin/
	cp -dp $(targetprefix)/usr/lib/liblirc* $(prefix)/release_neutrino_static/usr/lib/


#######################################################################################


	$(INSTALL_DIR) $(prefix)/release_neutrino_static/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino_static/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino_static/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino_static/usr/local/bin/
	find $(prefix)/release_neutrino_static/usr/local/bin/ -name  neutrino -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino_static/usr/local/bin/ -name  pzapit -exec sh4-linux-strip --strip-unneeded {} \;
	find $(prefix)/release_neutrino_static/usr/local/bin/ -name  sectionsdcontrol -exec sh4-linux-strip --strip-unneeded {} \;

#######################################################################################
	echo "duckbox-rev#: " > $(prefix)/release_neutrino_static/etc/imageinfo
	git describe >> $(prefix)/release_neutrino_static/etc/imageinfo
#######################################################################################

	$(INSTALL_DIR) $(prefix)/release_neutrino_static/usr/lib

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_neutrino_static/usr/lib/
	cp -R $(targetprefix)/usr/local/lib/* $(prefix)/release_neutrino_static/usr/lib/
	rm -rf $(prefix)/release_neutrino_static/usr/lib/alsa-lib
	rm -rf $(prefix)/release_neutrino_static/usr/lib/alsaplayer
	rm -rf $(prefix)/release_neutrino_static/usr/lib/engines
	rm -rf $(prefix)/release_neutrino_static/usr/lib/enigma2
	rm -rf $(prefix)/release_neutrino_static/usr/lib/gconv
	rm -rf $(prefix)/release_neutrino_static/usr/lib/libxslt-plugins
	rm -rf $(prefix)/release_neutrino_static/usr/lib/pkgconfig
	rm -rf $(prefix)/release_neutrino_static/usr/lib/sigc++-1.2
	rm -rf $(prefix)/release_neutrino_static/usr/lib/X11
	rm -f $(prefix)/release_neutrino_static/usr/lib/*.a
	rm -f $(prefix)/release_neutrino_static/usr/lib/*.o
	rm -f $(prefix)/release_neutrino_static/usr/lib/*.la
	find $(prefix)/release_neutrino_static/usr/lib/ -name '*.so*' -exec sh4-linux-strip --strip-unneeded {} \;

######## FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino #############
	cp -RP $(buildprefix)/own_build/neutrino/* $(prefix)/release_neutrino_static/

if STM22
	cp $(kernelprefix)/linux/arch/sh/boot/uImage $(prefix)/release_neutrino_static/boot/
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino_static/usr/bin/
else
	cp $(kernelprefix)/linux-sh4/arch/sh/boot/uImage $(prefix)/release_neutrino_static/boot/
endif

	touch $@
