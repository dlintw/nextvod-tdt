# ipkg overall stuff

#include @buildprefix@/make/shared.mk

# Variables to be exported to packages Makefiles
#
export INCLUDE_DIR=@buildprefix@/make
export IPKPREFIX=@ipkprefix@
export IPKGBUILDDIR=@ipkgbuilddir@
export CDKPREFIX=@cdkprefix@
export DEPSDIR=@buildprefix@/.deps
export BUILDPREFIX=@buildprefix@
export APPSDIR=@appsdir@
export TARGET=@target@
export TARGETPREFIX=@targetprefix@
export FLASHPREFIX=@flashprefix@
export FLASHROOT_MODIFIED=@FLASHROOT_MODIFIED@
export FLASH_CUSTOMIZE=@FLASH_CUSTOMIZE@
export TMP_INSTALL_DIR=@prefix@/tmpinst-cdkroot

export DEPMOD
export INSTALL_DIR
export INSTALL_BIN
export INSTALL_FILE
export LN_SF
export CP_D
export CP_P
export CP_RD
export SED

export MAKE_PATH

export IPKG_BUILD_BIN
export IPKG_BIN
export IPKG_CONF


# Fill ipk directory with packages
#
packages: $(IPKG_BUILD_BIN) \
	make pkg-netio \
	make pkg-nano \
	make pkg-pngquant \
	make pkg-libncurses \
	make pkg-libncurses-extra \
	make pkg-ncurses-terminfo \
	make pkg-libglib2 \
	make pkg-mc \
	make pkg-libcurl \
	make pkg-curl \
	make pkg-libfuse \
	make pkg-fuse-utils \
	make pkg-curlftpfs \
	make pkg-libfreetype \
	make pkg-libjpeg \
	make pkg-libjpeg-dev \
	make pkg-jpeg-tools \
	make pkg-libpng \
	make pkg-libpng-dev \
	make pkg-libungif \
	make pkg-libungif-dev \
	make pkg-liblirc \
	make pkg-liblirc-dev \
	make pkg-lirc-tools
	( cd $(ipkprefix) && \
		$(crossprefix)/bin/ipkg-make-index . >Packages \
	)
	$(CP_P) $(ipkprefix)/Packages $(ipkprefix)/Packages_unzipped && \
	gzip -f $(ipkprefix)/Packages && \
	mv $(ipkprefix)/Packages_unzipped $(ipkprefix)/Packages

#	make pkg-libfreetype-dev \
#

packages-small: $(IPKG_BUILD_BIN) \
	make pkg-netio \
	make pkg-nano \
	make pkg-pngquant \
	make pkg-libncurses \
	make pkg-libncurses-extra \
	make pkg-ncurses-terminfo \
	make pkg-libglib2 \
	make pkg-mc \
	make pkg-libcurl \
	make pkg-curl \
	make pkg-libfuse \
	make pkg-fuse-utils \
	make pkg-curlftpfs \
	make pkg-libfreetype \
	make pkg-libjpeg \
	make pkg-libjpeg-dev \
	make pkg-jpeg-tools \
	make pkg-libpng \
	make pkg-libpng-dev \
	make pkg-libungif \
	make pkg-libungif-dev \
	make pkg-liblirc \
	make pkg-liblirc-dev \
	make pkg-lirc-tools
	( cd $(ipkprefix) && \
		$(crossprefix)/bin/ipkg-make-index . >Packages \
	)
	$(CP_P) $(ipkprefix)/Packages $(ipkprefix)/Packages_unzipped && \
	gzip -f $(ipkprefix)/Packages && \
	mv $(ipkprefix)/Packages_unzipped $(ipkprefix)/Packages

pkg-index:
	@( cd $(ipkprefix) && \
		$(crossprefix)/bin/ipkg-make-index . >Packages \
	) && \
	$(CP_P) $(ipkprefix)/Packages $(ipkprefix)/Packages_unzipped && \
	gzip -f $(ipkprefix)/Packages && \
	mv $(ipkprefix)/Packages_unzipped $(ipkprefix)/Packages
	@ls -l $(ipkprefix)/*

# Helper targets for packages status
#
flashstatus:
	@D=true $(IPKG_BIN) -conf $(IPKG_CONF) status

flashupdate:
	@D=true $(IPKG_BIN) -conf $(IPKG_CONF) update

flashupgrade:
	@D=true $(IPKG_BIN) -conf $(IPKG_CONF) upgrade

flashlistinstalled:
	@D=true $(IPKG_BIN) -conf $(IPKG_CONF) list_installed

flashhelp:
	@D=true $(IPKG_BIN) -conf $(IPKG_CONF) --help


$(ipkprefix):
	$(INSTALL) -d $@

$(ipkgbuilddir): | $(ipkprefix)
	-rm -rf $@
	$(INSTALL) -d $@

############################

define Install/Default
	$(if $($(1)/install/pre),$$($(1)/install/pre),)
	cd $$(DIR_$(1)) && \
		$$(INSTALL_$(1))
	$(if $($(1)/install/post),$$($(1)/install/post),)
endef

define Install/Default/pre
	@echo "N/A"
endef

define Install/AdaptFiles
	cd root && \
		for s in $$($(1)_ADAPTED_FILES); do \
			i="$$$${s#/}" && \
			$(INSTALL_DIR) $$(prefix)/$$*cdkroot/$$$${i%/*}; \
			[ -f $$$$i ] && $(INSTALL) -m644 $$$$i $$(prefix)/$$*cdkroot/$$$$i || true; \
			[ "$$$${i%/*}" = "etc/init.d" ] && chmod 755 $$(prefix)/$$*cdkroot/$$$$i || true; \
		done
endef

define Install/UpdateRc
	$(INSTALL_DIR) $$(prefix)/$$*cdkroot/etc/rc.d/rc{S,3}.d
	$(LN_SF) ../init.d $$(prefix)/$$*cdkroot/etc/rc.d/init.d
	export HHL_CROSS_TARGET_DIR=$$(prefix)/$$*cdkroot && \
	cd $$(prefix)/$$*cdkroot/etc/init.d && \
		for s in $$($(1)_INITD_FILES) ; do \
			$$(hostprefix)/bin/target-initdconfig --add $$$$s \
				|| echo "Unable to enable initd service: $$$$s" ; \
		done && \
		rm *rpmsave 2>/dev/null || true
endef

# call Cdkroot/Install,<Package $(1)>,<Depends %$(3)>,<Depends $(4)>
#
define Cdkroot
  $(DEPDIR)/min-$(1) $(DEPDIR)/std-$(1) $(DEPDIR)/max-$(1) \
  $(DEPDIR)/$(1): \
  $(DEPDIR)/%$(1): $$($(1)_ADAPTED_FILES:%=root/%) \
		$(addprefix %,$(2)) $(3) $(1).do_compile
	$(if $($(1)/install),$$($(1)/install),$(Install/Default))
    ifdef $(1)_ADAPTED_FILES
	$(Install/AdaptFiles)
    endif
    ifdef $(1)_INITD_FILES
	$(Install/UpdateRc)
    endif
#	$$(DISTCLEANUP_$(1))
	@[ "x$$*" = "x" ] && touch $$@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

  $(DEPDIR)/tmpinst-$(1): \
  $(DEPDIR)/%$(1): $(1).do_compile
	rm -rf $(TMP_INSTALL_DIR)/
	$(INSTALL_DIR) $(TMP_INSTALL_DIR)
	$(if $($(1)/install),$$($(1)/install),$(Install/Default))
    ifdef $(1)_ADAPTED_FILES
	@echo "Adapted files: $$($(1)_ADAPTED_FILES)"
	$(Install/AdaptFiles)
    endif
    ifdef $(1)_INITD_FILES
	@echo "Initd files: $$($(1)_INITD_FILES)"
	$(Install/UpdateRc)
    endif

endef

# call Package,<Source Package $(1)>,<Package $(2)>,<Depends $(3)>
#
define Package
  pkg-$(2) \
  flash-$(2) flashinstall-$(2) \
  flashuninstall-$(2) \
  flashstatus-$(2) flashinfo-$(2) flashwhatdepends-$(2): \
  %$(2): bootstrap $(1).do_compile $(3) | $(IPKG_BUILD_BIN) $(IPKG_BIN)
	make -C packages/$(1) $(subst $$*,,$$@) \
		PKG_VERSION=$(VERSION_$(1)) \
		BUILD_DIR=$(buildprefix)/$(DIR_$(1))
endef


.PHONY: $(ipkgbuilddir) packages packages-small
