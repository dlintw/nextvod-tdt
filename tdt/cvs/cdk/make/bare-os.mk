#
# FILESYSTEM
#
#$(prefix)/min-cdkroot $(prefix)/std-cdkroot $(prefix)/max-cdkroot \
#$(targetprefix): \
#$(prefix)/%:
#	$(INSTALL) -d $@

$(DEPDIR)/min-filesystem $(DEPDIR)/std-filesystem $(DEPDIR)/max-filesystem \
$(DEPDIR)/filesystem: \
$(DEPDIR)/%filesystem: bootstrap-cross
	$(INSTALL) -d $(targetprefix)/{bin,boot,dev,dev.static,etc,home,lib,mnt,opt,proc,root,sbin,sys,tmp,usr,var}
	$(INSTALL) -d $(targetprefix)/etc/{default,opt}
	$(INSTALL) -d $(targetprefix)/usr/{bin,include,lib,local,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/lib/X11
	$(INSTALL) -d $(targetprefix)/usr/local/{bin,include,lib,man,sbin,share,src}
	$(INSTALL) -d $(targetprefix)/usr/local/man/{man1,man2,man3,man4,man5,man6,man7,man8}
	$(INSTALL) -d $(targetprefix)/usr/share/{aclocal,doc,info,locale,man,misc,nls}
	$(INSTALL) -d $(targetprefix)/usr/share/man/{man0p,man1,man1p,man2,man3,man3p,man4,man5,man6,man7,man8,man9}
	$(INSTALL) -d $(targetprefix)/var/{backups,cache,lib,local,lock,log,mail,opt,run,spool}
	ln -s /tmp $(targetprefix)/var/tmp
	$(INSTALL) -d $(targetprefix)/var/lib/misc
	$(INSTALL) -d $(targetprefix)/var/lock/subsys
#	$(LN_S) ../mail $(targetprefix)/var/spool/mail
	ln -sf ../mail $(targetprefix)/var/spool/mail
	$(INSTALL) -d $(targetprefix)/etc/{init.d,rc.d}
	$(INSTALL) -d $(targetprefix)/etc/rc.d/{rc3.d,rcS.d}
	ln -s ../init.d $(targetprefix)/etc/rc.d/init.d
	$(INSTALL) -d $(targetprefix)/jffs
	$(INSTALL) -d $(targetprefix)/media
#	$(INSTALL) -d $(targetprefix)/include
	$(INSTALL) -d $(targetprefix)/ram
	$(INSTALL) -d $(targetprefix)/rom
#	$(INSTALL) -d $(targetprefix)/share/{doc,info,locale,man,misc,nls}
	$(INSTALL) -d $(targetprefix)/srv
	$(INSTALL) -d $(targetprefix)/srv/www
	$(INSTALL) -d $(targetprefix)/var/bin
	[ "x$*" = "x" ] && touch $@ || true

if !STM22
#
# KERNELHEADERS
#
KERNELHEADERS := linux-kernel-headers
if ENABLE_P0119
KERNELHEADERS_VERSION := 2.6.23.17_stm23_0119-41
KERNELHEADERS_SPEC := SPECS/stm-target-kernel-headers-kbuild.spec 
KERNELHEADERS_SPEC_PATCH := Patches/stm-target-kernel-headers-kbuild_0123.spec.diff
KERNELHEADERS_PATCHES :=
else !ENABLE_P0119
if ENABLE_P0123
KERNELHEADERS_VERSION := 2.6.23.17_stm23_0123-41
KERNELHEADERS_SPEC := SPECS/stm-target-kernel-headers-kbuild.spec
KERNELHEADERS_SPEC_PATCH := Patches/stm-target-kernel-headers-kbuild_0123.spec.diff
KERNELHEADERS_PATCHES :=
else !ENABLE_P0123
# STM24
KERNELHEADERS_VERSION := 2.6.32.10_stm24_0201-42
KERNELHEADERS_SPEC := SPECS/stm-target-kernel-headers-kbuild.spec 
KERNELHEADERS_SPEC_PATCH := 
KERNELHEADERS_PATCHES :=
endif !ENABLE_P0123
endif !ENABLE_P0119
KERNELHEADERS_RPM := RPMS/noarch/$(STLINUX)-sh4-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).noarch.rpm

$(KERNELHEADERS_RPM): Archive/$(STLINUX)-target-$(KERNELHEADERS)-$(KERNELHEADERS_VERSION).src.rpm \
		$(KERNELHEADERS_SPEC_PATCH) $(KERNELHEADERS_PATCHES)
	rpm $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(KERNELHEADERS_SPEC_PATCH)" ] && patch $(KERNELHEADERS_SPEC) < "$(KERNELHEADERS_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(KERNELHEADERS_PATCHES)" ] && cp $(KERNELHEADERS_PATCHES) SOURCES/ || true ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux $(KERNELHEADERS_SPEC)

$(DEPDIR)/max-$(KERNELHEADERS) \
$(DEPDIR)/$(KERNELHEADERS): \
$(DEPDIR)/%$(KERNELHEADERS): $(KERNELHEADERS_RPM)
	@rpm $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(KERNELHEADERS_RPM)
	touch $@

endif !STM22

#
# GLIBC
#
GLIBC := glibc
GLIBC_DEV := $(GLIBC)-dev
if STM22
GLIBC_VERSION := 2.5-27
GLIBC_RAWVERSION := 2.5
GLIBC_SPEC := SPECS/stm-target-$(GLIBC)-sh4processed.spec
GLIBC_SPEC_PATCH := Patches/stm-target-$(GLIBC)-sh4processed.spec22.diff
GLIBC_PATCHES :=
else !STM22
if STM23
GLIBC_VERSION := 2.6.1-53
GLIBC_RAWVERSION := 2.6.1
GLIBC_SPEC := SPECS/stm-target-$(GLIBC).spec
GLIBC_SPEC_PATCH :=
GLIBC_PATCHES :=
else !STM23
# STM24
GLIBC_VERSION := 2.10.1-7
GLIBC_RAWVERSION := 2.10.1
GLIBC_SPEC := SPECS/stm-target-$(GLIBC).spec
GLIBC_SPEC_PATCH :=
GLIBC_PATCHES :=
endif !STM23
endif !STM22
GLIBC_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC)-$(GLIBC_VERSION).sh4.rpm
GLIBC_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(GLIBC_DEV)-$(GLIBC_VERSION).sh4.rpm

$(GLIBC_RPM) $(GLIBC_DEV_RPM): Archive/$(STLINUX)-target-$(GLIBC)-$(GLIBC_VERSION).src.rpm \
		$(GLIBC_SPEC_PATCH) $(GLIBC_PATCHES) | filesystem
	rpm $(DRPM) --nosignature -Uhv $< && \
	( [ ! -z "$(GLIBC_SPEC_PATCH)" ] && patch $(GLIBC_SPEC) < "$(GLIBC_SPEC_PATCH)" || true ) && \
	( [ ! -z "$(GLIBC_PATCHES)" ] && cp $(GLIBC_PATCHES) SOURCES/ || true ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux $(GLIBC_SPEC)

$(DEPDIR)/min-$(GLIBC) $(DEPDIR)/std-$(GLIBC) $(DEPDIR)/max-$(GLIBC) \
$(DEPDIR)/$(GLIBC): \
$(DEPDIR)/%$(GLIBC): $(GLIBC_RPM) | $(DEPDIR)/%filesystem
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(GLIBC_DEV) $(DEPDIR)/std-$(GLIBC_DEV) $(DEPDIR)/max-$(GLIBC_DEV) \
$(DEPDIR)/$(GLIBC_DEV): \
$(DEPDIR)/%$(GLIBC_DEV): $(DEPDIR)/%$(GLIBC) $(GLIBC_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

flash-glibc: $(flashprefix)/root/lib/libc-$(GLIBC_RAWVERSION).so

$(flashprefix)/root/lib/libc-$(GLIBC_RAWVERSION).so: $(GLIBC_RPM)
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	touch $@
	@FLASHROOTDIR_MODIFIED@

#
# CROSS-SH4-LIBGCC
#
# see make/bootstrap.mk

#
# GCC LIBSTDC++
#
GCC		:= gcc
LIBSTDC		:= libstdc++
LIBSTDC_DEV	:= libstdc++-dev
LIBGCC		:= libgcc

if STM22
GCC_VERSION	:= 4.1.1-26

RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(GCC)-$(GCC_VERSION).src.rpm | $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(GCC)-sh4processed.spec < ../Patches/stm-target-$(GCC)-sh4processed.spec22.diff )
	rpmbuild $(DRPMBUILD) -bb  --clean --target=sh4-linux SPECS/stm-target-$(GCC)-sh4processed.spec
else !STM22

#stlinux23

GCC_VERSION := 4.2.4-50

RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm: \
		Archive/stlinux23-target-$(GCC)-$(GCC_VERSION).src.rpm | $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(GCC).spec < ../Patches/stm-target-$(GCC).spec23.diff )
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb  --clean --target=sh4-linux SPECS/stm-target-$(GCC).spec
endif !STM22

$(DEPDIR)/min-$(GCC) $(DEPDIR)/std-$(GCC) $(DEPDIR)/max-$(GCC) $(DEPDIR)/$(GCC): \
$(DEPDIR)/%$(GCC): $(DEPDIR)/%$(GLIBC_DEV) RPMS/sh4/$(STLINUX)-sh4-$(GCC)-$(GCC_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(LIBSTDC) $(DEPDIR)/std-$(LIBSTDC) $(DEPDIR)/max-$(LIBSTDC) $(DEPDIR)/$(LIBSTDC): \
$(DEPDIR)/%$(LIBSTDC): $(DEPDIR)/%$(CROSS_LIBGCC) RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/min-$(LIBSTDC_DEV) $(DEPDIR)/std-$(LIBSTDC_DEV) $(DEPDIR)/max-$(LIBSTDC_DEV) $(DEPDIR)/$(LIBSTDC_DEV): \
$(DEPDIR)/%$(LIBSTDC_DEV): $(DEPDIR)/%$(LIBSTDC) RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC_DEV)-$(GCC_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/lib{std,sup}c++.la
	sed -i "/^dependency_libs/s|-L/usr/lib -L/lib ||" $(targetprefix)/usr/lib/lib{std,sup}c++.la

$(DEPDIR)/min-$(LIBGCC) $(DEPDIR)/std-$(LIBGCC) $(DEPDIR)/max-$(LIBGCC) $(DEPDIR)/$(LIBGCC): \
$(DEPDIR)/%$(LIBGCC): RPMS/sh4/$(STLINUX)-sh4-$(LIBGCC)-$(GCC_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true

#flash-libstdc++: $(flashprefix)/root/usr/lib/libstdc++.so.6.0.3
#
#$(flashprefix)/root/usr/lib/libstdc++.so.6.0.3: RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm
#	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
#		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
#	touch $@
#	@FLASHROOTDIR_MODIFIED@

#Wrote: RPMS/sh4/stlinux20-sh4-cpp-3.4.3-22.sh4.rpm
#Wrote: RPMS/sh4/stlinux20-sh4-cpp-doc-3.4.3-22.sh4.rpm
#Wrote: RPMS/sh4/stlinux20-sh4-g++-3.4.3-22.sh4.rpm
#Wrote: RPMS/sh4/stlinux20-sh4-gcc-doc-3.4.3-22.sh4.rpm

# END OF BOOTSTRAP

#
# LIBTERMCAP
#
LIBTERMCAP		:= libtermcap
LIBTERMCAP_DEV		:= libtermcap-dev
LIBTERMCAP_DOC		:= libtermcap-doc
LIBTERMCAP_VERSION	:= 2.0.8-8
LIBTERMCAP_RAWVERSION	:= 2.0.8

RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DEV)-$(LIBTERMCAP_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DOC)-$(LIBTERMCAP_VERSION).sh4.rpm: \
		Archive/$(STM_SRC)-target-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).src.rpm | $(DEPDIR)/$(GLIBC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(LIBTERMCAP).spec

$(DEPDIR)/min-$(LIBTERMCAP) $(DEPDIR)/std-$(LIBTERMCAP) $(DEPDIR)/max-$(LIBTERMCAP) \
$(DEPDIR)/$(LIBTERMCAP): \
$(DEPDIR)/%$(LIBTERMCAP): bootstrap RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	ln -sf libtermcap.so.2 $(prefix)/$*cdkroot/usr/lib/libtermcap.so && \
	$(INSTALL) -m 644 $(buildprefix)/root/etc/termcap $(prefix)/$*cdkroot/etc && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(LIBTERMCAP_DEV) $(DEPDIR)/std-$(LIBTERMCAP_DEV) $(DEPDIR)/max-$(LIBTERMCAP_DEV) \
$(DEPDIR)/$(LIBTERMCAP_DEV): \
$(DEPDIR)/%$(LIBTERMCAP_DEV): $(DEPDIR)/%$(LIBTERMCAP) RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DEV)-$(LIBTERMCAP_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(LIBTERMCAP_DOC) $(DEPDIR)/std-$(LIBTERMCAP_DOC) $(DEPDIR)/max-$(LIBTERMCAP_DOC) \
$(DEPDIR)/$(LIBTERMCAP_DOC): \
$(DEPDIR)/%$(LIBTERMCAP_DOC): RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP_DOC)-$(LIBTERMCAP_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-libtermcap: $(flashprefix)/root/usr/lib/libtermcap.so.$(LIBTERMCAP_RAWVERSION)

$(flashprefix)/root/usr/lib/libtermcap.so.$(LIBTERMCAP_RAWVERSION): ncurses RPMS/sh4/$(STLINUX)-sh4-$(LIBTERMCAP)-$(LIBTERMCAP_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
	$(INSTALL) -m 644 $(buildprefix)/root/etc/termcap $(flashprefix)/root/etc && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# NCURSES
#
NCURSES		:= ncurses
NCURSES_BASE	:= ncurses-base
NCURSES_DEV	:= ncurses-dev
NCURSES_VERSION	:= 5.5-9

$(DEPDIR)/ncurses.do_compile \
RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm \
RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm: \
		Archive/$(STM_SRC)-target-$(NCURSES)-$(NCURSES_VERSION).src.rpm | $(DEPDIR)/$(LIBSTDC_DEV)
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(NCURSES).spec
	touch $(DEPDIR)/ncurses.do_compile

$(DEPDIR)/min-$(NCURSES_BASE) $(DEPDIR)/std-$(NCURSES_BASE) $(DEPDIR)/max-$(NCURSES_BASE) \
$(DEPDIR)/$(NCURSES_BASE): \
$(DEPDIR)/%$(NCURSES_BASE): RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $<)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(NCURSES) $(DEPDIR)/std-$(NCURSES) $(DEPDIR)/max-$(NCURSES) \
$(DEPDIR)/$(NCURSES): \
$(DEPDIR)/%$(NCURSES): $(DEPDIR)/%$(NCURSES_BASE) RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/min-$(NCURSES_DEV) $(DEPDIR)/std-$(NCURSES_DEV) $(DEPDIR)/max-$(NCURSES_DEV) \
$(DEPDIR)/$(NCURSES_DEV): \
$(DEPDIR)/%$(NCURSES_DEV): $(DEPDIR)/%$(NCURSES_BASE) RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm \
		| RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_DEV)-$(NCURSES_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate packages
$(eval $(call Packages,ncurses))

#Wrote: RPMS/sh4/stlinux23-sh4-ncurses-dbg-5.5-9.sh4.rpm
#Wrote: RPMS/sh4/stlinux23-sh4-ncurses-pic-5.5-9.sh4.rpm
#Wrote: RPMS/sh4/stlinux23-sh4-ncurses-bin-5.5-9.sh4.rpm
#Wrote: RPMS/sh4/stlinux23-sh4-ncurses-term-5.5-9.sh4.rpm

#flash-ncurses-base: $(flashprefix)/root/usr/share/terminfo
#
#$(flashprefix)/root/usr/share/terminfo: RPMS/sh4/$(STLINUX)-sh4-$(NCURSES_BASE)-$(NCURSES_VERSION).sh4.rpm
#	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
#		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
#	touch $@
#	@FLASHROOTDIR_MODIFIED@
#
#flash-ncurses: flash-ncurses-base $(flashprefix)/root/lib/libncurses.so.5.4
#
#$(flashprefix)/root/lib/libncurses.so.5.4: RPMS/sh4/$(STLINUX)-sh4-$(NCURSES)-$(NCURSES_VERSION).sh4.rpm
#	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
#		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^)
#	touch $@
#	@FLASHROOTDIR_MODIFIED@

#
# BASE-PASSWD
#
BASE_PASSWD		:= base-passwd

if STM22
BASE_PASSWD_VERSION	:= 3.5.9-6
RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BASE_PASSWD).spec
else
BASE_PASSWD_VERSION	:= 3.5.9-7
RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BASE_PASSWD).spec
endif

$(DEPDIR)/min-$(BASE_PASSWD) $(DEPDIR)/std-$(BASE_PASSWD) $(DEPDIR)/max-$(BASE_PASSWD) \
$(DEPDIR)/$(BASE_PASSWD): \
$(DEPDIR)/%$(BASE_PASSWD): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps  --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
        $(hostprefix)/bin/update-passwd -L -p $(prefix)/$*cdkroot/usr/share/base-passwd/passwd.master \
               	-g $(prefix)/$*cdkroot/usr/share/base-passwd/group.master -P $(prefix)/$*cdkroot/etc/passwd \
               	-S $(prefix)/$*cdkroot/etc/shadow -G $(prefix)/$*cdkroot/etc/group && \
	chmod 600 $(prefix)/$*cdkroot/etc/shadow && \
	( cd $(prefix)/$*cdkroot/etc && sed -e "s|/bin/bash|/bin/sh|g" -i passwd ) && \
	rm -f $(prefix)/$*cdkroot/etc/shadow
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-base-passwd: $(flashprefix)/root/usr/sbin/update-passwd

$(flashprefix)/root/usr/sbin/update-passwd: \
		RPMS/sh4/$(STLINUX)-sh4-$(BASE_PASSWD)-$(BASE_PASSWD_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
        $(hostprefix)/bin/update-passwd -L -p $(flashprefix)/root/usr/share/base-passwd/passwd.master \
               	-g $(flashprefix)/root/usr/share/base-passwd/group.master -P $(flashprefix)/root/etc/passwd \
               	-S $(flashprefix)/root/etc/shadow -G $(flashprefix)/root/etc/group && \
	chmod 600 $(flashprefix)/root/etc/shadow && \
	( cd $(flashprefix)/root/etc && sed -e "s|/bin/bash|/bin/sh|g" -i passwd )
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# MAKEDEV
#
MAKEDEV		:= makedev

if STM22
MAKEDEV_VERSION	:= 2.3.1-15
RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(MAKEDEV)-$(MAKEDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(MAKEDEV).spec < ../Patches//stm-target-$(MAKEDEV).spec22.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(MAKEDEV).spec

$(DEPDIR)/min-$(MAKEDEV) $(DEPDIR)/std-$(MAKEDEV) $(DEPDIR)/max-$(MAKEDEV) \
$(DEPDIR)/$(MAKEDEV): \
$(DEPDIR)/%$(MAKEDEV): root/sbin/MAKEDEV RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(INSTALL) -m 755 root/sbin/MAKEDEV $(prefix)/$*cdkroot/sbin
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
if ENABLE_TF7700
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_9500HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_MINI_FTA
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_250HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_2000HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_UFS922
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

else

#stlinux23

MAKEDEV_VERSION	:= 2.3.1-24
RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(MAKEDEV)-$(MAKEDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	( cd SPECS; patch -p1 stm-target-$(MAKEDEV).spec < ../Patches/stm-target-$(MAKEDEV).spec23.diff ) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(MAKEDEV).spec

$(DEPDIR)/min-$(MAKEDEV) $(DEPDIR)/std-$(MAKEDEV) $(DEPDIR)/max-$(MAKEDEV) \
$(DEPDIR)/$(MAKEDEV): \
$(DEPDIR)/%$(MAKEDEV): root/sbin/MAKEDEV RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^)
	$(INSTALL) -m 755 root/sbin/MAKEDEV $(prefix)/$*cdkroot/sbin
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
if ENABLE_TF7700
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_9500HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_MINI_FTA
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_250HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_CUBEREVO_2000HD
	$(INSTALL) -m 755 root/sbin/MAKEDEV_no_CI $(prefix)/$*cdkroot/sbin
endif

if ENABLE_UFS922
	$(INSTALL) -m 755 root/sbin/MAKEDEV_dual_tuner $(prefix)/$*cdkroot/sbin
endif
endif

if TARGETRULESET_FLASH
flash-makedev: $(flashprefix)/root/sbin/MAKEDEV

$(flashprefix)/root/sbin/MAKEDEV: root/sbin/MAKEDEV RPMS/sh4/$(STLINUX)-sh4-$(MAKEDEV)-$(MAKEDEV_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	$(INSTALL) -m 755 root/sbin/MAKEDEV_flash $(flashprefix)/root/sbin/MAKEDEV
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# BASE-FILES
#
BASE_FILES		:= base-files

if STM22
BASE_FILES_VERSION	:= 2.0-4
RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BASE_FILES)-$(BASE_FILES_VERSION).src.rpm  
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BASE_FILES).spec
else
BASE_FILES_VERSION	:= 2.0-7
RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(BASE_FILES)-$(BASE_FILES_VERSION).src.rpm  
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(BASE_FILES).spec
endif

$(DEPDIR)/min-$(BASE_FILES) $(DEPDIR)/std-$(BASE_FILES) $(DEPDIR)/max-$(BASE_FILES) $(DEPDIR)/$(BASE_FILES): \
$(DEPDIR)/%$(BASE_FILES): $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch  -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( cd root/etc && for i in $(BASE_FILES_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	echo "proc          /proc               proc    defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	echo "tmpfs         /tmp                tmpfs   defaults                        0 0" >> $(prefix)/$*cdkroot/etc/fstab && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH
flash-base-files: $(flashprefix)/root/etc/fstab

$(flashprefix)/root/etc/fstab: $(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		RPMS/sh4/$(STLINUX)-sh4-$(BASE_FILES)-$(BASE_FILES_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps  -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	( cd root/etc && for i in $(BASE_FILES_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; done ) && \
	echo "proc          /proc               proc    defaults                        0 0" >> $(flashprefix)/root/etc/fstab && \
	echo "tmpfs         /tmp                tmpfs   defaults                        0 0" >> $(flashprefix)/root/etc/fstab && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
endif

#
# INITSCRIPTS/SYSVINIT
#
#$(DEPDIR)/sysvinit.do_prepare: @DEPENDS_sysvinit@
#	@PREPARE_sysvinit@
#	cd @DIR_sysvinit@ && \
#		gunzip -cd ../$(lastword $^) | cat > debian.patch && \
#		patch -p1 <debian.patch
#	touch $@
#
#$(DEPDIR)/sysvinit.do_compile: bootstrap $(DEPDIR)/sysvinit.do_prepare
#	cd @DIR_sysvinit@  && \
#		$(BUILDENV) \
#		./configure \
#			--build=$(build) \
#			--host=$(target) \
#			--target=$(target) \
#			--prefix= && \
#		$(MAKE) 
#	touch $@
#
#$(DEPDIR)/min-sysvinit $(DEPDIR)/std-sysvinit $(DEPDIR)/max-sysvinit \
#$(DEPDIR)/sysvinit: \
#$(DEPDIR)/%sysvinit: $(DEPDIR)/sysvinit.do_compile
#	cd @DIR_sysvinit@  && \
#		@INSTALL_sysvinit@
##	@DISTCLEANUP_sysvinit@
#	@[ "x$*" = "x" ] && touch $@ || true
#	@TUXBOX_YAUD_CUSTOMIZE@
#
#if TARGETRULESET_FLASH
#
#flash-sysvinit: $(flashprefix)/root/usr/bin/hgrep
#
#$(flashprefix)/root/usr/bin/hgrep: bootstrap $(DEPDIR)/sysvinit.do_compile | $(flashprefix)/root
#	cd @DIR_sysvinit@  && \
#		$(INSTALL) src/grep $@
#	@FLASHROOTDIR_MODIFIED@
#	@TUXBOX_CUSTOMIZE@
#endif

######################################################################################################

#
# UDEV
#
UDEV := udev

if STM22
UDEV_VERSION := 054-6

RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(UDEV)-$(UDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(UDEV).spec
#	( cd SPECS; patch -p1 stm-target-$(UDEV).spec < ../Patches/stm-target-$(UDEV).spec.diff ) && \
#
else
UDEV_VERSION := 116-23

RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(UDEV)-$(UDEV_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(UDEV).spec
endif

$(DEPDIR)/min-$(UDEV) $(DEPDIR)/std-$(UDEV) $(DEPDIR)/max-$(UDEV) $(DEPDIR)/$(UDEV): \
$(DEPDIR)/%$(UDEV): RPMS/sh4/$(STLINUX)-sh4-$(UDEV)-$(UDEV_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in sysfs udev ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#Wrote: /home/data/ufs/cvs/cdk/RPMS/sh4/stlinux20-sh4-udev-doc-054-5.sh4.rpm

#
# HOTPLUG
#
HOTPLUG := hotplug

if STM22
HOTPLUG_VERSION := 2004_09_23-4

RPMS/sh4/$(STLINUX)-sh4-$(HOTPLUG)-$(HOTPLUG_VERSION).sh4.rpm: \
		Archive/$(STLINUX)-target-$(HOTPLUG)-$(HOTPLUG_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/stm-target-$(HOTPLUG).spec
else

endif

$(DEPDIR)/min-$(HOTPLUG) $(DEPDIR)/std-$(HOTPLUG) $(DEPDIR)/max-$(HOTPLUG) $(DEPDIR)/$(HOTPLUG): \
$(DEPDIR)/%$(HOTPLUG): RPMS/sh4/$(STLINUX)-sh4-$(HOTPLUG)-$(HOTPLUG_VERSION).sh4.rpm
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps --noscripts -Uhv \
		--relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in hotplug ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-hotplug: $(flashprefix)/root/sbin/hotplug

$(flashprefix)/root/sbin/hotplug: RPMS/sh4/$(STLINUX)-sh4-$(HOTPLUG)-$(HOTPLUG_VERSION).sh4.rpm
	@rpm --dbpath $(flashprefix)-rpmdb $(DRPM) --ignorearch --nodeps --nopost -Uhv \
		--replacepkgs --relocate $(targetprefix)=$(flashprefix)/root $(lastword $^) && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
#	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && \
#	  $(INSTALL_DIR) $(flashprefix)/root/etc/rc.d/rc{S,0,1,2,3,4,5,6}.d && \
#	  $(LN_SF) ../init.d $(flashprefix)/root/etc/rc.d/init.d && \
#	  cd $(flashprefix)/root/etc/init.d && \
#		for s in hotplug ; do \
#			$(hostprefix)/bin/target-initdconfig --add $$s || \
#			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave *.orig 2>/dev/null || true )

