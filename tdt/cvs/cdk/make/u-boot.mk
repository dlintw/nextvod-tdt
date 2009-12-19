#
# U-BOOT
#
HOST_U_BOOT	:= host-u-boot
if STM22
U_BOOT_VERSION	:= 1.1.2_stm22_0020-20
U_BOOT_RAWVERSION	:= 1.1.2_stm22_0020
U_BOOT_DIR	:= u-boot/u-boot-1.1.2_stm22_0020
else
U_BOOT_VERSION	:= sh4-1.3.1_stm23_0038-38
U_BOOT_RAWVERSION	:= sh4-1.3.1_stm23_0038-38
U_BOOT_DIR	:= u-boot/u-boot-sh4-1.3.1_stm23_0038
endif

RPMS/noarch/$(STLINUX)-$(HOST_U_BOOT)-source-$(U_BOOT_VERSION).noarch.rpm: \
		Archive/$(STLINUX)-$(HOST_U_BOOT)-source-$(U_BOOT_VERSION).src.rpm
	rpm --rcfile localrc --nosignature -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_U_BOOT).spec

$(DEPDIR)/u-boot.do_prepare:  RPMS/noarch/$(STLINUX)-$(HOST_U_BOOT)-source-$(U_BOOT_VERSION).noarch.rpm
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $< && \
	touch $@

if STM22
$(DEPDIR)/u-boot.do_compile: \
		$(DEPDIR)/u-boot.do_prepare
	cd $(U_BOOT_DIR) && \
		$(MAKE) ARCH=sh4 CROSS_COMPILE=$(target)- mrproper && \
		$(MAKE) $(MAKE_OPTS) stb7100ref_27_config && \
		$(MAKE) ARCH=sh4 CROSS_COMPILE=$(target)-
	cd $(U_BOOT_DIR) && \
		./STM/mkenv stb7100ref_27 setupenv && \
		sed -e "s/set uversion.*/set uversion $(U_BOOT_RAWVERSION)/" \
		-e "s/set kversion.*/set kversion /" \
		-i setupenv && \
		sed -e "s/define uversion.*/define uversion $(U_BOOT_RAWVERSION)/" \
		./STM/kscript > kscript && \
		./tools/mkimage -A sh4 -O u-boot -T script -C none -a 0 -e 0 -d setupenv setupenv.ub
	touch $@

$(DEPDIR)/u-boot-utils.do_compile: bootstrap $(DEPDIR)/u-boot.do_prepare
	cd $(U_BOOT_DIR) && \
		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- clean TARGETS=fw_printenv TARGETDIR=$(targetprefix) && \
		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- all TARGETS=fw_printenv TARGETDIR=$(targetprefix)
	touch $@

$(DEPDIR)/min-u-boot-utils $(DEPDIR)/std-u-boot-utils $(DEPDIR)/max-u-boot-utils \
$(DEPDIR)/u-boot-utils: \
$(DEPDIR)/%u-boot-utils: $(DEPDIR)/u-boot-utils.do_compile
	$(INSTALL) -d $(prefix)/$*cdkroot/{etc,usr/sbin} && \
	cd $(U_BOOT_DIR) && \
		$(INSTALL) -m 755 STM/env/fw_printenv $(prefix)/$*cdkroot/usr/sbin && \
		$(LN_SF) fw_printenv $(prefix)/$*cdkroot/usr/sbin/fw_setenv
	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(prefix)/$*cdkroot/etc/
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
else
### TO be fixed
$(DEPDIR)/u-boot-utils.do_compile: bootstrap $(DEPDIR)/u-boot.do_prepare
#	cd $(U_BOOT_DIR) && \
#		$(MAKE) -C tools/env TOPDIR=$(buildprefix)/$(U_BOOT_DIR) ARCH=sh4 CROSS_COMPILE=$(target)- clean TARGETS=fw_printenv TARGETDIR=$(targetprefix) && \
#		$(MAKE) -C tools/env TOPDIR=$(buildprefix)/$(U_BOOT_DIR) ARCH=sh4 CROSS_COMPILE=$(target)- all TARGETS=fw_printenv TARGETDIR=$(targetprefix)
	touch $@

$(DEPDIR)/min-u-boot-utils $(DEPDIR)/std-u-boot-utils $(DEPDIR)/max-u-boot-utils \
$(DEPDIR)/u-boot-utils: \
$(DEPDIR)/%u-boot-utils: $(DEPDIR)/u-boot-utils.do_compile
#	$(INSTALL) -d $(prefix)/$*cdkroot/{etc,usr/sbin} && \
#	cd $(U_BOOT_DIR) && \
#		$(INSTALL) -m 755 tools/env/fw_printenv $(prefix)/$*cdkroot/usr/sbin && \
#		$(LN_SF) fw_printenv $(prefix)/$*cdkroot/usr/sbin/fw_setenv
#	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(prefix)/$*cdkroot/etc/
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif

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

$(DEPDIR)/u-boot: $(DEPDIR)/u-boot.do_compile
#%install
#%host_setup
#rm -rf %{buildroot}
#cd u-boot
#install -d -m 755 %{buildroot}%{_stm_binary_uboot_dir}
#cp u-boot       %{buildroot}%{_stm_binary_uboot_dir}
#cp u-boot.*     %{buildroot}%{_stm_binary_uboot_dir}
#cp setupenv*    %{buildroot}%{_stm_binary_uboot_dir}
#cp STM/localenv %{buildroot}%{_stm_binary_uboot_dir}
#cp kscript      %{buildroot}%{_stm_binary_uboot_dir}
####cp COPYING      %{buildroot}%{_stm_binary_uboot_dir}/LICENSE
####
####echo -e "ST Linux Distribution "%{_hhl_build_id}" Binary U-boot\n \
####CPU: sh4\n \
####PLATFORM: stb7100ref_27\n \
####U-BOOT VERSION: 1.1.2_st2.0\n" > \
####%{buildroot}%{_stm_binary_uboot_dir}/README.ST


#stlinux20-host-u-boot ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/SRPM_Distribution/sh4-SRPMS-updates/stlinux20-host-u-boot-sh4_stb7100ref_27-2.0-14.src.rpm
HOST_U_BOOT_SH4_STB7100REF_27 := host-u-boot-sh4_stb7100ref_27
RPMS/sh4/stlinux20-$(HOST_U_BOOT_SH4_STB7100REF_27)-2.0-14.sh4.rpm: Archive/stlinux20-$(HOST_U_BOOT_SH4_STB7100REF_27)-2.0-14.src.rpm
	rpm --rcfile localrc --nosignature -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_U_BOOT_SH4_STB7100REF_27).spec
$(HOST_U_BOOT_SH4_STB7100REF_27): RPMS/sh4/stlinux20-$(HOST_U_BOOT_SH4_STB7100REF_27)-2.0-14.sh4.rpm
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_27-1.1.2_stm22_0017-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_30-1.1.2_stm22_0017-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_27-1.1.2_stm22_0020-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_30-1.1.2_stm22_0020-1.src.rpm


#
# HOST-U-BOOT-TOOLS
#
HOST_U_BOOT_TOOLS	:= host-u-boot-tools
if STM22
U_BOOT_TOOLS_VERSION	:= 1.1.2_st2.0-3
else
#stlinux23-host-u-boot-tools-1.3.1_stm23-7.src.rpm
U_BOOT_TOOLS_VERSION	:= 1.3.1_stm23-7
endif

RPMS/sh4/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).src.rpm
	rpm --rcfile localrc --nosignature -Uhv $< && \
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:localrc -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_U_BOOT_TOOLS).spec

if STM22
$(DEPDIR)/$(HOST_U_BOOT_TOOLS): RPMS/sh4/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).sh4.rpm | bootstrap-cross
else
$(DEPDIR)/$(HOST_U_BOOT_TOOLS): u-boot.do_prepare RPMS/sh4/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(U_BOOT_TOOLS_VERSION).sh4.rpm | bootstrap-cross
endif
	@rpm --rcfile /usr/lib/rpm/rpmrc:localrc --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@

