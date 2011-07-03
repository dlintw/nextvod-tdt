#
# U-BOOT
#
HOST_U_BOOT := host-u-boot
if STM22
HOST_U_BOOT_VERSION := 1.1.2_stm22_0020-20
HOST_U_BOOT_RAWVERSION := $(firstword $(subst -, ,$(HOST_U_BOOT_VERSION)))
HOST_U_BOOT_DIR := u-boot/u-boot-$(HOST_U_BOOT_RAWVERSION)
HOST_U_BOOT_SPEC := stm-$(HOST_U_BOOT).spec
HOST_U_BOOT_SPEC_PATCH :=
HOST_U_BOOT_PATCHES :=
else !STM22
if STM23
HOST_U_BOOT_VERSION := $(if $(STABLE),sh4-1.3.1_stm23_0038-38,sh4-1.3.1_stm23_0047-47)
HOST_U_BOOT_RAWVERSION := $(HOST_U_BOOT_VERSION)
HOST_U_BOOT_DIR := u-boot/u-boot-sh4-$(word 2, $(subst -, ,$(HOST_U_BOOT_VERSION)))
HOST_U_BOOT_SPEC := stm-$(HOST_U_BOOT).spec
HOST_U_BOOT_SPEC_PATCH :=
HOST_U_BOOT_PATCHES :=
else !STM23
# if STM24
HOST_U_BOOT_VERSION := sh4-1.3.1_stm24_0048-48
HOST_U_BOOT_RAWVERSION := $(HOST_U_BOOT_VERSION)
HOST_U_BOOT_DIR := u-boot/u-boot-sh4-$(word 2, $(subst -, ,$(HOST_U_BOOT_VERSION)))
HOST_U_BOOT_SPEC := stm-$(HOST_U_BOOT).spec
HOST_U_BOOT_SPEC_PATCH := uboot-1.3.1_spec_stm24.patch
HOST_U_BOOT_PATCHES := uboot-1.3.1_lzma_stm24.patch
# endif STM24
endif !STM23
endif !STM22
HOST_U_BOOT_RPM := RPMS/noarch/$(STLINUX)-$(HOST_U_BOOT)-source-$(HOST_U_BOOT_VERSION).noarch.rpm

$(HOST_U_BOOT_RPM): \
		$(if $(HOST_U_BOOT_SPEC_PATCH),Patches/$(HOST_U_BOOT_SPEC_PATCH)) \
		$(if $(HOST_U_BOOT_PATCHES),$(HOST_U_BOOT_PATCHES:%=Patches/%)) \
 		Archive/$(STLINUX)-$(HOST_U_BOOT)-source-$(HOST_U_BOOT_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_U_BOOT_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_U_BOOT_SPEC) < ../Patches/$(HOST_U_BOOT_SPEC_PATCH) ) &&) \
	$(if $(HOST_U_BOOT_PATCHES),cp $(HOST_U_BOOT_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_U_BOOT_SPEC)

$(DEPDIR)/u-boot.do_prepare: $(HOST_U_BOOT_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch $@

if STM22
$(DEPDIR)/u-boot.do_compile: \
		$(DEPDIR)/u-boot.do_prepare
	cd $(HOST_U_BOOT_DIR) && \
		$(MAKE) ARCH=sh4 CROSS_COMPILE=$(target)- mrproper && \
		$(MAKE) $(MAKE_OPTS) stb7100ref_27_config && \
		$(MAKE) ARCH=sh4 CROSS_COMPILE=$(target)-
	cd $(HOST_U_BOOT_DIR) && \
		./STM/mkenv stb7100ref_27 setupenv && \
		sed -e "s/set uversion.*/set uversion $(HOST_U_BOOT_RAWVERSION)/" \
		-e "s/set kversion.*/set kversion /" \
		-i setupenv && \
		sed -e "s/define uversion.*/define uversion $(HOST_U_BOOT_RAWVERSION)/" \
		./STM/kscript > kscript && \
		./tools/mkimage -A sh4 -O u-boot -T script -C none -a 0 -e 0 -d setupenv setupenv.ub
	touch $@

$(DEPDIR)/u-boot-utils.do_compile: bootstrap $(DEPDIR)/u-boot.do_prepare
	cd $(HOST_U_BOOT_DIR) && \
		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- clean TARGETS=fw_printenv TARGETDIR=$(targetprefix) && \
		$(MAKE) -C STM/env ARCH=sh4 CROSS_COMPILE=$(target)- all TARGETS=fw_printenv TARGETDIR=$(targetprefix)
	touch $@

$(DEPDIR)/min-u-boot-utils $(DEPDIR)/std-u-boot-utils $(DEPDIR)/max-u-boot-utils \
$(DEPDIR)/u-boot-utils: \
$(DEPDIR)/%u-boot-utils: $(DEPDIR)/u-boot-utils.do_compile
	$(INSTALL) -d $(prefix)/$*cdkroot/{etc,usr/sbin} && \
	cd $(HOST_U_BOOT_DIR) && \
		$(INSTALL) -m 755 STM/env/fw_printenv $(prefix)/$*cdkroot/usr/sbin && \
		$(LN_SF) fw_printenv $(prefix)/$*cdkroot/usr/sbin/fw_setenv
	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(prefix)/$*cdkroot/etc/
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
else !STM22
### TO be fixed
$(DEPDIR)/u-boot-utils.do_compile: bootstrap $(DEPDIR)/u-boot.do_prepare
#	cd $(HOST_U_BOOT_DIR) && \
#		$(MAKE) -C tools/env TOPDIR=$(buildprefix)/$(HOST_U_BOOT_DIR) ARCH=sh4 CROSS_COMPILE=$(target)- clean TARGETS=fw_printenv TARGETDIR=$(targetprefix) && \
#		$(MAKE) -C tools/env TOPDIR=$(buildprefix)/$(HOST_U_BOOT_DIR) ARCH=sh4 CROSS_COMPILE=$(target)- all TARGETS=fw_printenv TARGETDIR=$(targetprefix)
	touch $@

$(DEPDIR)/min-u-boot-utils $(DEPDIR)/std-u-boot-utils $(DEPDIR)/max-u-boot-utils \
$(DEPDIR)/u-boot-utils: \
$(DEPDIR)/%u-boot-utils: $(DEPDIR)/u-boot-utils.do_compile
#	$(INSTALL) -d $(prefix)/$*cdkroot/{etc,usr/sbin} && \
#	cd $(HOST_U_BOOT_DIR) && \
#		$(INSTALL) -m 755 tools/env/fw_printenv $(prefix)/$*cdkroot/usr/sbin && \
#		$(LN_SF) fw_printenv $(prefix)/$*cdkroot/usr/sbin/fw_setenv
#	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(prefix)/$*cdkroot/etc/
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
endif !STM22

if TARGETRULESET_FLASH
flash-u-boot-utils: $(flashprefix)/root/usr/sbin/fw_printenv

$(flashprefix)/root/usr/sbin/fw_printenv: $(DEPDIR)/u-boot-utils.do_compile
	$(INSTALL) -d $(flashprefix)/root/{etc,usr/sbin} && \
	cd $(HOST_U_BOOT_DIR) && \
		$(INSTALL) -m 755 STM/env/fw_printenv $@ && \
		$(LN_SF) fw_printenv $(flashprefix)/root/usr/sbin/fw_setenv
	$(INSTALL) -m 644 $(buildprefix)/root/etc/fw_env.config $(flashprefix)/root/etc/
	@FLASHROOTDIR_MODIFIED@
endif TARGETRULESET_FLASH

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
	rpm $(DRPM) --nosignature -Uhv $< && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-$(HOST_U_BOOT_SH4_STB7100REF_27).spec
$(HOST_U_BOOT_SH4_STB7100REF_27): RPMS/sh4/stlinux20-$(HOST_U_BOOT_SH4_STB7100REF_27)-2.0-14.sh4.rpm
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $< && \
	touch .deps/$(notdir $@)
#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_27-1.1.2_stm22_0017-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_30-1.1.2_stm22_0017-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_27-1.1.2_stm22_0020-1.src.rpm
#ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS/stlinux22-target-u-boot-sh4_stb7100ref_30-1.1.2_stm22_0020-1.src.rpm


#
# HOST-U-BOOT-TOOLS
#
HOST_U_BOOT_TOOLS := host-u-boot-tools
if STM22
HOST_U_BOOT_TOOLS_VERSION := 1.1.2_st2.0-3
HOST_U_BOOT_TOOLS_SPEC := stm-$(HOST_U_BOOT_TOOLS).spec
HOST_U_BOOT_TOOLS_SPEC_PATCH :=
HOST_U_BOOT_TOOLS_PATCHES :=
else !STM22
if STM23
HOST_U_BOOT_TOOLS_VERSION := 1.3.1_stm23-7
HOST_U_BOOT_TOOLS_SPEC := stm-$(HOST_U_BOOT_TOOLS).spec
HOST_U_BOOT_TOOLS_SPEC_PATCH :=
HOST_U_BOOT_TOOLS_PATCHES :=
else !STM23
# if STM24
HOST_U_BOOT_TOOLS_VERSION := 1.3.1_stm24-8
HOST_U_BOOT_TOOLS_SPEC := stm-$(HOST_U_BOOT_TOOLS).spec
HOST_U_BOOT_TOOLS_SPEC_PATCH :=
HOST_U_BOOT_TOOLS_PATCHES :=
# endif STM24
endif !STM23
endif !STM22
HOST_U_BOOT_TOOLS_RPM := RPMS/sh4/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(HOST_U_BOOT_TOOLS_VERSION).sh4.rpm

$(HOST_U_BOOT_TOOLS_RPM): \
		$(if $(HOST_U_BOOT_TOOLS_SPEC_PATCH),Patches/$(HOST_U_BOOT_TOOLS_SPEC_PATCH)) \
		$(if $(HOST_U_BOOT_TOOLS_PATCHES),$(HOST_U_BOOT_TOOLS_PATCHES:%=Patches/%)) \
		Archive/$(STLINUX)-$(HOST_U_BOOT_TOOLS)-$(HOST_U_BOOT_TOOLS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(HOST_U_BOOT_TOOLS_SPEC_PATCH),( cd SPECS && patch -p1 $(HOST_U_BOOT_TOOLS_SPEC) < ../Patches/$(HOST_U_BOOT_TOOLS_SPEC_PATCH) ) &&) \
	$(if $(HOST_U_BOOT_TOOLS_PATCHES),cp $(HOST_U_BOOT_TOOLS_PATCHES:%=Patches/%) SOURCES/ &&) \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(HOST_U_BOOT_TOOLS_SPEC)

if STM22
$(DEPDIR)/$(HOST_U_BOOT_TOOLS): $(HOST_U_BOOT_TOOLS_RPM) | bootstrap-cross
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@
else !STM22
$(DEPDIR)/$(HOST_U_BOOT_TOOLS): u-boot.do_prepare $(HOST_U_BOOT_TOOLS_RPM) | bootstrap-cross
	@rpm $(DRPM) --ignorearch --nodeps -Uhv $(lastword $^) && \
	touch $@
endif !STM22

