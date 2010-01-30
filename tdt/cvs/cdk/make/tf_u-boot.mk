#
# U-BOOT for the TF7700
#
HOST_U_BOOT	:= host-u-boot
U_BOOT_RAWVERSION	:= 1.3.1_stm23_0043
U_BOOT_VERSION	:= $(U_BOOT_RAWVERSION)-43
U_BOOT_DIR	:= u-boot/u-boot-sh4-$(U_BOOT_RAWVERSION)
U_BOOT_PREFIX	:= stlinux23-$(HOST_U_BOOT)-source-sh4
TFINSTALLER_DIR := tfinstaller

RPMS/noarch/$(U_BOOT_PREFIX)-$(U_BOOT_VERSION).noarch.rpm: \
		Archive/$(U_BOOT_PREFIX)-$(U_BOOT_VERSION).src.rpm
	rpm --rcfile localrc --nosignature -Uhv $< && \
	mv SPECS/stm-$(HOST_U_BOOT).spec SPECS/stm-$(HOST_U_BOOT).spec_ && \
	sed -e "s/if_target_cpu sh/if 1/g" SPECS/stm-$(HOST_U_BOOT).spec_ > SPECS/stm-$(HOST_U_BOOT).spec && \
	rm SPECS/stm-$(HOST_U_BOOT).spec_ && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -bb -v --clean --define "_stm_short_build_id 23" --define "_stm_target_name sh4" --define "_stm_pkg_prefix stlinux23" --target=sh --define "_stm_uboot_dir $(BUILDPREFIX)/u-boot" SPECS/stm-$(HOST_U_BOOT).spec

$(DEPDIR)/u-boot.do_prepare:  RPMS/noarch/$(U_BOOT_PREFIX)-$(U_BOOT_VERSION).noarch.rpm $(BUILDPREFIX)/Patches/u-boot-1.3.1_stm23_0043_tf7700.patch
# FIXME: "rpm -e" does not remove files
	rm -fr $(U_BOOT_DIR)
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $< && \
	(cd $(U_BOOT_DIR) && \
		patch -p1 < $(lastword $^) && \
		$(MAKE) tf7700_config )
	touch $@

$(DEPDIR)/u-boot.do_compile: $(DEPDIR)/u-boot.do_prepare
	cd $(U_BOOT_DIR) && \
		$(MAKE)

$(DEPDIR)/u-boot-utils.do_compile: bootstrap $(DEPDIR)/u-boot.do_prepare
#	cd $(U_BOOT_DIR) && \
#		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- clean TARGETS=fw_printenv TARGETDIR=$(targetprefix) && \
#		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- all TARGETS=fw_printenv TARGETDIR=$(targetprefix)
	touch $@

$(DEPDIR)/min-u-boot-utils $(DEPDIR)/std-u-boot-utils $(DEPDIR)/max-u-boot-utils \
$(DEPDIR)/u-boot-utils: \
$(DEPDIR)/%u-boot-utils: $(DEPDIR)/u-boot-utils.do_compile
#	$(INSTALL) -d $(prefix)/$*cdkroot/{etc,usr/sbin} && \
#	cd $(U_BOOT_DIR) && \
#		$(INSTALL) -m 755 STM/env/fw_printenv $(prefix)/$*cdkroot/usr/sbin && \
#		$(LN_SF) fw_printenv $(prefix)/$*cdkroot/usr/sbin/fw_setenv
#	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(prefix)/$*cdkroot/etc/
#	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-u-boot-utils: $(flashprefix)/root/usr/sbin/fw_printenv

$(flashprefix)/root/usr/sbin/fw_printenv: $(DEPDIR)/u-boot-utils.do_compile
	$(INSTALL) -d $(flashprefix)/root/{etc,usr/sbin} && \
	cd $(U_BOOT_DIR) && \
		$(INSTALL) -m 755 STM/env/fw_printenv $@ && \
		$(LN_SF) fw_printenv $(flashprefix)/root/usr/sbin/fw_setenv
	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(flashprefix)/root/etc/
	@FLASHROOTDIR_MODIFIED@
endif

$(TFINSTALLER_DIR)/u-boot.ftfd: $(U_BOOT_DIR)/u-boot.bin $(TFINSTALLER_DIR)/tfpacker
	$(TFINSTALLER_DIR)/tfpacker $< $@
	$(TFINSTALLER_DIR)/tfpacker -t $< $(@D)/Enigma_Installer.tfd

$(TFINSTALLER_DIR)/tfpacker:
	$(MAKE) -C $(TFINSTALLER_DIR) tfpacker

$(DEPDIR)/u-boot: $(DEPDIR)/u-boot.do_compile $(TFINSTALLER_DIR)/u-boot.ftfd

#
# HOST-U-BOOT-TOOLS
#
HOST_U_BOOT_TOOLS	:= host-u-boot-tools
U_BOOT_TOOLS_VERSION	:= 1.3.1_stm23-7

RPMS/sh4/stlinux23-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).sh4.rpm: \
		Archive/stlinux23-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).src.rpm
	rpm --rcfile localrc --nosignature -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -bb -v --clean --target=sh4-linux --define "_stm_short_build_id 23" --define "_stm_pkg_prefix stlinux23" --define "_stm_uboot_dir $(BUILDPREFIX)/u-boot" SPECS/stm-$(HOST_U_BOOT_TOOLS).spec

$(DEPDIR)/$(HOST_U_BOOT_TOOLS): u-boot.do_prepare RPMS/sh4/stlinux23-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).sh4.rpm | bootstrap-cross
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@
