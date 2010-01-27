COMMONPATCHES_41 = \
		Patches/nosquashfs3.1.patch \
		Patches/squashfs3.0.patch \
		Patches/squashfs3.0_lzma.patch \
		Patches/linux-sh4-2.6.17.14_stm22_0037.mini_fo.diff \
		Patches/do-printk.patch \
		Patches/ufs922_ktime_p0041.patch \
		Patches/ufs922_hrtimer_p0041.patch \
		Patches/ufs922_linuxdvb_p0041.patch \
		Patches/ufs922_sound_p0041.patch \
		Patches/ufs922_copo_p0041.patch \
		Patches/ufs922_stm-dma_p0041.patch \
		Patches/sched_p0041.patch \
		Patches/timer_stm22.patch \
		Patches/p0041_cmdline_printk.patch \
		Patches/p0041_strcpy.patch

FORTISPATCHES_41 = $(COMMONPATCHES_41) \
		Patches/fortis_hdbox_setup_p0041.diff \
		Patches/fortis_hdbox_dvb.diff \
		Patches/fortis_hdbox_sound.patch

UFS922PATCHES_41 = $(COMMONPATCHES_41) \
		Patches/ufs922_stasc_p0041.patch \
		Patches/ufs922_stmmac_p0041.patch \
		Patches/ufs922_setup_p0041.patch \
		Patches/fat.patch \
		Patches/fuse.patch \
		Patches/net.patch \
		Patches/tune.patch \
		Patches/usbwait123.patch \
		Patches/jffs2-lzma.patch \
		Patches/sumversion_ubuntu.patch \
		Patches/ufs922_stboards_p0041.patch

TF7700PATCHES_41 = $(COMMONPATCHES_41) \
		Patches/ufs922_stasc_p0041.patch \
		Patches/tf7700_setup_p0041.patch

UFS910PATCHES_41 = $(COMMONPATCHES_41) \
		Patches/ufs910_smsc_p0041.patch \
		Patches/ufs910_i2c_p0041.patch \
		Patches/ufs910_setup_p0041.patch \
		Patches/ufs910_stboards_p0041.patch \
		Patches/ufs910_nits_net.patch

FLASHUFS910PATCHES_41 = $(COMMONPATCHES_41) \
		Patches/ufs910_smsc_p0041.patch \
		Patches/ufs910_i2c_p0041.patch \
		Patches/ufs910_setup_p0041.patch \
		Patches/ufs910_stboards_p0041_flash.patch

# IMPORTANT: it is expected that only one define is set
CUBEMOD=$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)
CUBEPATCHES_041 = $(COMMONPATCHES_41) \
		Patches/cuberevo_patches_p0041.patch \
		Patches/cuberevo_fdma_p0041.patch \
		Patches/cuberevo_i2c_p0041.patch \
		Patches/cuberevo_rtl8201_p0041.patch \
		Patches/$(CUBEMOD)_setup_p0041.patch

KERNELPATCHES_41 =	$(if $(TF7700),$(TF7700PATCHES_41)) \
			$(if $(UFS922),$(UFS922PATCHES_41)) \
			$(if $(CUBEMOD),$(CUBEPATCHES_041)) \
			$(if $(UFS910),$(UFS910PATCHES_41)) \
			$(if $(FLASH_UFS910),$(FLASHUFS910PATCHES_41)) \
			$(if $(FORTIS_HDBOX),$(FORTISPATCHES_41))

# IMPORTANT: it is expected that only one define is set
MODNAME = $(UFS910)$(UFS922)$(TF7700)$(CUBEMOD)$(FORTIS_HDBOX)$(FLASH_UFS910)

if STM22
##################################################################################
if P0041
RPMS/noarch/stlinux22-host-kernel-source-2.6.17.14_stm22_0041-41.noarch.rpm: \
		Archive/stlinux22-host-kernel-source-2.6.17.14_stm22_0041-41.src.rpm
	rpm --rcfile localrc --nosignature --nodeps -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -ba -v --clean --target=sh4-linux SPECS/stm-host-kernel.spec

if DEBUG
DEBUG_STR=.debug
else
DEBUG_STR=
endif

echo DEBUG_STR=$DEBUG_STR

$(DEPDIR)/linux-kernel.do_prepare: RPMS/noarch/stlinux22-host-kernel-source-2.6.17.14_stm22_0041-41.noarch.rpm $(KERNELPATCHES_41)
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc -ev stlinux22-host-kernel-source-2.6.17.14_stm22_0041-41 || true
	rm -rf $(KERNEL_DIR)
	@echo "Preparing kernel for $(MODNAME)"
#	@echo "Patches: $(filter ../Patches/%, $(^:Patches/%=../Patches/%))"
	rm -rf linux
	rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $<
	cd $(KERNEL_DIR) && cat $(filter ../Patches/%, $(^:Patches/%=../Patches/%)) | patch -p1
	$(INSTALL) -m644 Patches/linux-$(subst _stm22_,-,$(KERNELVERSION))_$(MODNAME).config${DEBUG_STR} $(KERNEL_DIR)/.config
	-rm $(KERNEL_DIR)/localversion*
	echo "$(KERNELSTMLABEL)" > $(KERNEL_DIR)/localversion-stm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh oldconfig
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/asm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/linux/version.h
	rm $(KERNEL_DIR)/.config
	touch $@


#dagobert: without stboard ->not sure if we need this
$(DEPDIR)/linux-kernel.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/linux-$(subst _stm22_,-,$(KERNELVERSION))_$(MODNAME).config${DEBUG_STR} \
		config.status \
		| $(HOST_U_BOOT_TOOLS)
	-rm $(DEPDIR)/linux-kernel*.do_compile
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ ../$(word 3,$^)	> .config && \
		$(MAKE) $(if $(TF7700),TF7700=y) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

else
$(DEPDIR)/linux-kernel.do_prepare: $(KERNEL_DEPENDS)
	$(KERNEL_PREPARE)
	touch $@

#endof P0041
endif

#endof STM22
else

##################################################################################
#stlinux23

RPMS/noarch/stlinux23-host-kernel-source-sh4-2.6.23.17_stm23_0119-119.noarch.rpm: \
		Archive/stlinux23-host-kernel-source-sh4-2.6.23.17_stm23_0119-119.src.rpm
	rpm --rcfile localrc --nosignature --nodeps -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -ba -v --clean --target=sh4-linux SPECS/stm-host-kernel-sh4.spec

if DEBUG
DEBUG_STR=.debug
else
DEBUG_STR=
endif

$(DEPDIR)/linux-kernel.do_prepare: RPMS/noarch/stlinux23-host-kernel-source-sh4-2.6.23.17_stm23_0119-119.noarch.rpm \
		Patches/cpp_stm23.patch \
		Patches/linuxdvb_stm23.patch \
		Patches/time_stlinux23.diff \
		Patches/fdma_stm23.patch \
		Patches/sound_stm23.diff \
		$(if $(UFS922),Patches/ufs922_stmmac_stlinux23.patch) \
		$(if $(UFS922),Patches/ufs922_setup_stlinux23.patch) \
		$(if $(UFS910),Patches/ufs910_setup_stlinux23.patch) \
		$(if $(UFS910),Patches/ufs910_pcmplayer_stlinux23.patch) \
		$(if $(UFS910),Patches/ufs910_reboot_stlinux23.patch) \
		$(if $(CUBEREVO),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO),Patches/$(CUBEREVO)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_MINI),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_MINI),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_MINI),Patches/$(CUBEREVO_MINI)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_MINI2),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_MINI2),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_MINI2),Patches/$(CUBEREVO_MINI2)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_MINI_FTA),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_MINI_FTA),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_MINI_FTA),Patches/$(CUBEREVO_MINI_FTA)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_250HD),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_250HD),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_250HD),Patches/$(CUBEREVO_250HD)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_2000HD),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_2000HD),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_2000HD),Patches/$(CUBEREVO_2000HD)_setup_stlinux23.patch) \
		$(if $(CUBEREVO_9500HD),Patches/cuberevo_patches_stlinux23.patch) \
		$(if $(CUBEREVO_9500HD),Patches/cuberevo_rtl8201_stlinux23.patch) \
		$(if $(CUBEREVO_9500HD),Patches/$(CUBEREVO_9500HD)_setup_stlinux23.patch)
#		Patches/nosquashfs3.1_stm23.patch \
#		Patches/squashfs3.0_stm23.patch \
#		Patches/squashfs3.0_lzma_stm23.patch \
#		Patches/linux-sh4-2.6.17.14_stm22_0037.mini_fo.diff \
#		Patches/do-printk.patch \
#		$(if $(TF7700),Patches/ufs922_stasc_stm23.patch) \
#		$(if $(TF7700),Patches/tf7700_setup_stm23.patch) \
#		$(if $(UFS910),Patches/ufs910_smsc_stm23.patch) \
#		$(if $(UFS910),Patches/ufs910_i2c_stm23.patch) \
#		$(if $(UFS910),Patches/ufs910_setup_stm23.patch) \
#		$(if $(UFS910),Patches/ufs910_stboards_stm23.patch) \
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc -ev stlinux23-host-kernel-source-sh4-2.6.23.17_stm23_0119-119 || true
	rm -rf $(KERNEL_DIR)
	rm -rf linux-sh4
	rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $<
	cd $(KERNEL_DIR) && patch -p1 <../$(word 2,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 3,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 4,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 5,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 6,$^)
if ENABLE_UFS922
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(UFS922).config${DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_UFS910
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 9,$^)
	$(INSTALL) -m644 Patches/linux-$(subst _stm23_,-,sh4-$(KERNELVERSION))_$(UFS910).config${DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_FLASH_UFS910
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(FLASH_UFS910).config${DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_TF7700
#	cd $(KERNEL_DIR) && patch -p1 <../$(word 13,$^)
#	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-$(subst _stm23_,-,$(KERNELVERSION))_$(TF7700).config${DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_MINI
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_MINI).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_MINI2
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_MINI2).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_MINI_FTA
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_MINI_FTA).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_250HD
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_250HD).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_2000HD
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_2000HD).config{DEBUG_STR} $(KERNEL_DIR)/.config
else
if ENABLE_CUBEREVO_9500HD
	cd $(KERNEL_DIR) && patch -p1 <../$(word 7,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(word 8,$^)
	cd $(KERNEL_DIR) && patch -p1 <../$(lastword $^)
	$(INSTALL) -m644 Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))_$(CUBEREVO_9500HD).config{DEBUG_STR} $(KERNEL_DIR)/.config
else

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
	-rm $(KERNEL_DIR)/localversion*
	echo "$(KERNELSTMLABEL)" > $(KERNEL_DIR)/localversion-stm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh oldconfig
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/asm
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh include/linux/version.h
	rm $(KERNEL_DIR)/.config
	touch $@

#dagobert: without stboard ->not sure if we need this
$(DEPDIR)/linux-kernel.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/linux-sh4-$(subst _stm23_,-,$(KERNELVERSION))$(if $(TF7700),_$(TF7700))$(if $(UFS910),_$(UFS910))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(FLASH_UFS910),_$(FLASH_UFS910)).config \
		config.status \
		| $(HOST_U_BOOT_TOOLS)
	-rm $(DEPDIR)/linux-kernel*.do_compile
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ ../$(word 3,$^)	> .config && \
		$(MAKE) $(if $(TF7700),TF7700=y) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

#endof STM23
endif 

NFS_FLASH_SED_CONF=$(foreach param,XCONFIG_NFS_FS XCONFIG_LOCKD XCONFIG_SUNRPC,-e s"/^.*$(param)[= ].*/$(param)=m/")

if ENABLE_XFS
XFS_SED_CONF=$(foreach param,CONFIG_XFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
XFS_SED_CONF=-e ""
endif

if ENABLE_NFSSERVER
#NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD CONFIG_NFSD_V3 CONFIG_NFSD_TCP,-e s"/^.*$(param)[= ].*/$(param)=y/")
NFSSERVER_SED_CONF=$(foreach param,CONFIG_NFSD,-e s"/^.*$(param)[= ].*/$(param)=y\nCONFIG_NFSD_V3=y\n\# CONFIG_NFSD_V3_ACL is not set\n\# CONFIG_NFSD_V4 is not set\nCONFIG_NFSD_TCP=y/")
else
NFSSERVER_SED_CONF=-e ""
endif

if ENABLE_NTFS
NTFS_SED_CONF=$(foreach param,CONFIG_NTFS_FS,-e s"/^.*$(param)[= ].*/$(param)=m/")
else
NTFS_SED_CONF=-e ""
endif

$(DEPDIR)/linux-kernel.cramfs.do_compile $(DEPDIR)/linux-kernel.squashfs.do_compile \
$(DEPDIR)/linux-kernel.jffs2.do_compile $(DEPDIR)/linux-kernel.usb.do_compile \
$(DEPDIR)/linux-kernel.focramfs.do_compile $(DEPDIR)/linux-kernel.fosquashfs.do_compile:
$(DEPDIR)/linux-kernel.%.do_compile: \
		bootstrap-cross \
		linux-kernel.do_prepare \
		Patches/linux-sh4-$(KERNELVERSION).stboards.c.m4 \
		Patches/linux-$(subst _stm22_,-,$(KERNELVERSION))$(if $(TF7700),_$(TF7700))$(if $(UFS922),_$(UFS922))$(if $(FLASH_UFS910),_$(FLASH_UFS910))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD)).config \
		config.status \
		| $(DEPDIR)/$(HOST_U_BOOT_TOOLS)
	-rm $(DEPDIR)/linux-kernel*.do_compile
	cd $(KERNEL_DIR) && \
		export PATH=$(hostprefix)/bin:$(PATH) && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- mrproper && \
		@M4@ -Drootfs=$* --define=rootsize=$(ROOT_PARTITION_SIZE) --define=datasize=$(DATA_PARTITION_SIZE) ../$(word 3,$^) \
					> drivers/mtd/maps/stboards.c && \
		@M4@ --define=btldrdef=$* ../$(word 4,$^) \
					> .config && \
		sed $(NFS_FLASH_SED_CONF) -i .config && \
		sed $(XFS_SED_CONF) $(NFSSERVER_SED_CONF) $(NTFS_SED_CONF) -i .config && \
		$(MAKE) ARCH=sh CROSS_COMPILE=$(target)- uImage modules
	touch $@

$(DEPDIR)/min-linux-kernel $(DEPDIR)/std-linux-kernel $(DEPDIR)/max-linux-kernel \
$(DEPDIR)/linux-kernel: \
$(DEPDIR)/%linux-kernel: bootstrap $(DEPDIR)/linux-kernel.do_compile
	@$(INSTALL) -d $(prefix)/$*cdkroot/boot && \
	$(INSTALL) -d $(prefix)/$*$(notdir $(bootprefix)) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $(prefix)/$*$(notdir $(bootprefix))/vmlinux.ub && \
	$(INSTALL) -m644 $(KERNEL_DIR)/vmlinux $(prefix)/$*cdkroot/boot/vmlinux-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/System.map $(prefix)/$*cdkroot/boot/System.map-sh4-$(KERNELVERSION) && \
	$(INSTALL) -m644 $(KERNEL_DIR)/COPYING $(prefix)/$*cdkroot/boot/LICENSE
	cp $(KERNEL_DIR)/arch/sh/boot/uImage $(prefix)/$*cdkroot/boot/
if STM22
	echo -e "ST Linux Distribution - Binary Kernel\n \
	CPU: sh4\n \
	$(if $(FORTIS_HDBOX),PLATFORM: stb7109ref\n) \
	$(if $(UFS922),PLATFORM: stb7109ref\n) \
	$(if $(TF7700),PLATFORM: stb7109ref\n) \
	$(if $(UFS910),PLATFORM: stb7100ref\n) \
	$(if $(FLASH_UFS910),PLATFORM: stb7100ref\n) \
	$(if $(CUBEREVO),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_MINI),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_MINI2),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_MINI_FTA),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_250HD),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_2000HD),PLATFORM: stb7109ref\n) \
	$(if $(CUBEREVO_9500HD),PLATFORM: stb7109ref\n) \
	KERNEL VERSION: $(KERNELVERSION)\n" > $(prefix)/$*cdkroot/README.ST && \
	$(MAKE) -C $(KERNEL_DIR) INSTALL_MOD_PATH=$(prefix)/$*cdkroot modules_install && \
	rm $(prefix)/$*cdkroot/lib/modules/$(KERNELVERSION)/build || true && \
	rm $(prefix)/$*cdkroot/lib/modules/$(KERNELVERSION)/source || true 
else
endif
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/driver: $(driverdir)/Makefile linux-kernel.do_compile
#	$(MAKE) -C $(KERNEL_DIR) $(MAKE_OPTS) modules_prepare
	cp $(driverdir)/stgfb/stmfb/Linux/video/stmfb.h $(targetprefix)/usr/include/linux
	$(MAKE) -C $(driverdir) \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		$(if $(FORTIS_HDBOX),FORTIS_HDBOX=$(FORTIS_HDBOX)) \
		$(if $(TF7700),TF7700=$(TF7700)) \
		$(if $(UFS922),UFS922=$(UFS922)) \
		$(if $(CUBEREVO),CUBEREVO=$(CUBEREVO)) \
		$(if $(CUBEREVO_MINI),CUBEREVO_MINI=$(CUBEREVO_MINI)) \
		$(if $(CUBEREVO_MINI2),CUBEREVO_MINI2=$(CUBEREVO_MINI2)) \
		$(if $(CUBEREVO_MINI_FTA),CUBEREVO_MINI_FTA=$(CUBEREVO_MINI_FTA)) \
		$(if $(CUBEREVO_250HD),CUBEREVO_250HD=$(CUBEREVO_250HD)) \
		$(if $(CUBEREVO_2000HD),CUBEREVO_2000HD=$(CUBEREVO_2000HD)) \
		$(if $(CUBEREVO_9500HD),CUBEREVO_9500HD=$(CUBEREVO_9500HD)) \
		CROSS_COMPILE=$(target)-
	$(MAKE) -C $(driverdir) \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		BIN_DEST=$(targetprefix)/bin \
		INSTALL_MOD_PATH=$(targetprefix) \
		$(if $(FORTIS_HDBOX),FORTIS_HDBOX=$(FORTIS_HDBOX)) \
		$(if $(TF7700),TF7700=$(TF7700)) \
		$(if $(UFS922),UFS922=$(UFS922)) \
		$(if $(CUBEREVO),CUBEREVO=$(CUBEREVO)) \
		$(if $(CUBEREVO_MINI),CUBEREVO_MINI=$(CUBEREVO_MINI)) \
		$(if $(CUBEREVO_MINI2),CUBEREVO_MINI2=$(CUBEREVO_MINI2)) \
		$(if $(CUBEREVO_MINI_FTA),CUBEREVO_MINI_FTA=$(CUBEREVO_MINI_FTA)) \
		$(if $(CUBEREVO_250HD),CUBEREVO_250HD=$(CUBEREVO_250HD)) \
		$(if $(CUBEREVO_2000HD),CUBEREVO_2000HD=$(CUBEREVO_2000HD)) \
		$(if $(CUBEREVO_9500HD),CUBEREVO_9500HD=$(CUBEREVO_9500HD)) \
		install
	$(DEPMOD) -ae -b $(targetprefix) -r $(KERNELVERSION)
	touch $@
	@TUXBOX_YAUD_CUSTOMIZE@

driver-clean:
	rm -f $(DEPDIR)/driver
	$(MAKE) -C $(driverdir) \
		KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) \
		distclean

#------------------- Helper

linux-kernel.menuconfig linux-kernel.xconfig: \
linux-kernel.%:
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=sh4-linux- $*
	@echo
	@echo "You have to edit m a n u a l l y Patches/linux-$(KERNELVERSION).config to make changes permanent !!!"
	@echo ""
	diff linux/.config.old linux/.config

#-------------------

$(flashprefix)/root-cramfs/lib \
$(flashprefix)/root-squashfs/lib \
$(flashprefix)/root-jffs2/lib \
$(flashprefix)/root-usb/lib \
$(flashprefix)/root-focramfs/lib \
$(flashprefix)/root-fosquashfs/lib: \
$(flashprefix)/root-%/lib: \
		$(DEPDIR)/linux-kernel.%.do_compile
	-rm -rf $(flashprefix)/root-$*
	$(MAKE) -C $(KERNEL_DIR) INSTALL_MOD_PATH=$(flashprefix)/root-$* modules_install
	-rm $(flashprefix)/root-$*/lib/modules/$(KERNELVERSION)/build
	-rm $(flashprefix)/root-$*/lib/modules/$(KERNELVERSION)/source
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/root-disk/lib: \
$(flashprefix)/root-%/lib: \
		$(DEPDIR)/linux-kernel.do_compile
#		$(DEPDIR)/linux-kernel.%.do_compile
	-rm -rf $(flashprefix)/root-$*
	$(INSTALL_DIR) $(dir $@)/{boot,lib/firmware} && \
	$(INSTALL_FILE) $(KERNEL_DIR)/arch/sh/boot/uImage $(dir $@)/boot/vmlinux.ub && \
	$(CP_D) root/boot/ACF_*x.elf $(dir $@)/boot/ && \
	$(CP_D) root/boot/vid_*.elf $(dir $@)/boot/ && \
	$(CP_D) root/firmware/dvb-fe-cx24116.fw $(dir $@)/lib/firmware/ && \
	$(CP_D) root/firmware/dvb-fe-cx21143.fw $(dir $@)/lib/firmware/ && \
	$(MAKE) -C $(KERNEL_DIR) INSTALL_MOD_PATH=$(flashprefix)/root-$* modules_install
	$(MAKE) -C $(driverdir) KERNEL_LOCATION=$(buildprefix)/$(KERNEL_DIR) INSTALL_MOD_PATH=$(flashprefix)/root-$* install
	-rm $(flashprefix)/root-$*/lib/modules/$(KERNELVERSION)/build
	-rm $(flashprefix)/root-$*/lib/modules/$(KERNELVERSION)/source
	@TUXBOX_CUSTOMIZE@

