# This file contains different cleaning targets. They try to be, at least
# in spirit, compatible with the GNU Makefiles standards.

# Note: automake defines targets clean etc, the Makefile author
# therefore should not. Instead, we define targets like clean-local,
# which are called from automake's clean.


# Delete all marker files in .deps, except those belonging to bootstrap,
# thus forcing unpack-patch-install-delete-targets to be rebuilt.
depsclean:
	$(DEPSCLEANUP)

# currently rpmdepsclean is including targets made by tuxbox rules
rpmdepsclean:
	( cd .deps && find . ! -name "*\.*" -delete )
#	$(RPMDEPSCLEANUP)


if TARGETRULESET_FLASH
mostlyclean-local: flash-clean cdk-clean
else
mostlyclean-local: cdk-clean
endif

# Clean tuxbox source directories
cdk-clean:
	-$(MAKE) -C $(driverdir) KERNEL_LOCATION=$(buildprefix)/linux-sh4 \
		BIN_DEST=$(targetprefix)/bin \
		INSTALL_MOD_PATH=$(targetprefix) clean
	-$(MAKE) -C $(appsdir)/tuxbox/libs clean
	-$(MAKE) -C $(appsdir)/tuxbox/libtuxbox clean
	-$(MAKE) -C $(appsdir)/tuxbox/plugins clean
	-$(MAKE) -C $(appsdir)/misc/libs clean
	-$(MAKE) -C $(appsdir)/misc/tools distclean
	-$(MAKE) -C $(appsdir)/dvb/dvbsnoop clean
	-$(MAKE) -C $(hostappsdir) clean
#	-$(MAKE) -C root clean
	-rm -rf build

# Clean tuxbox source directories. Clean up in cdkroot as much as the
# uninstall facilities of the components allow.
clean-local: mostlyclean-local depsclean rpmdepsclean
	-$(MAKE) -C $(appsdir)/tuxbox/libs uninstall
	-$(MAKE) -C $(appsdir)/tuxbox/libtuxbox uninstall
	-$(MAKE) -C $(appsdir)/tuxbox/plugins uninstall
	-$(MAKE) -C $(appsdir)/misc/libs uninstall
	-$(MAKE) -C $(appsdir)/misc/tools uninstall
	-$(MAKE) -C $(appsdir)/dvb/dvbsnoop uninstall
	-$(MAKE) -C $(hostappsdir) uninstall
	-rm -rf $(hostprefix)
if TARGETRULESET_FLASH
	-rm -rf $(flashprefix)/
	-rm -rf $(flashprefix)-rpmdb/
	-rm -rf $(ipkgbuilddir)/
endif
	-rm -rf $(crossprefix)/
	-rm -rf $(configprefix)/
	-rm -rf $(devkitprefix)/
	-rm -rf $(prefix)/*cdkroot/
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(rpmdbprefix)/
	-rm -rf $(ipkprefix)/
	-rm -rf $(prefix)/release_neutrino*
	-rm -rf SOURCES SPECS BUILD && install -d SOURCES SPECS BUILD
	-rm -rf $(prefix)/ccache
	-rm -rf $(DEPDIR)/autofs.*

# Be brutal...just nuke it!
distclean-local:
#	-$(MAKE) -C root distclean
	-$(MAKE) -C $(appsdir) distclean
#	-$(MAKE) -C $(appsdir)/dvb/dvbsnoop distclean
#	-$(MAKE) -C $(appsdir)/dvb/libdvb++ distclean
#	-$(MAKE) -C $(appsdir)/dvb/libdvbsi++ distclean
	-$(MAKE) -C $(appsdir)/tuxbox/libs distclean
	-$(MAKE) -C $(appsdir)/tuxbox/plugins distclean
	-$(MAKE) -C $(appsdir)/tuxbox/libtuxbox distclean
	-$(MAKE) -C $(appsdir)/misc/libs distclean
	-$(MAKE) -C $(appsdir)/misc/tools distclean
	-$(MAKE) -C $(hostappsdir) distclean
	-$(MAKE) driver-clean
	-$(MAKE) enigma2-clean
	-rm -f Makefile-archive
	-rm -f rules-downcheck.pl
	-rm -f linux
	-rm -rf $(DEPDIR)
#	-rm -rf $(targetprefix)
	-rm -rf $(hostprefix)
	-rm -rf $(serversupport)
if TARGETRULESET_FLASH
	-rm -rf $(flashprefix)/
	-rm -rf $(flashprefix)-rpmdb/
	-rm -rf $(ipkgbuilddir)/
endif
	-rm -rf $(crossprefix)/
	-rm -rf $(configprefix)/
	-rm -rf $(devkitprefix)/
	-rm -rf $(prefix)/*cdkroot/
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(rpmdbprefix)/
	-rm -rf $(ipkprefix)/
	-rm -rf SOURCES SPECS BUILD BUILDROOT SRPMS RPMS
	-rm -rf $(prefix)/ccache
	-rm -rf $(kernelprefix)/u-boot
	-rm -rf $(STGFB_DIR)
	-@DISTCLEANUP@
#	rm symlinks
#	-rm compile config config.guess config.sub COPYING depcomp INSTALL install-sh ltmain.sh missing


if TARGETRULESET_FLASH
################################################################
# flash-clean deletes everything created with the flash-* commands
# flash-semiclean leaves the flfs-images and the root-$filesystem dirs.
# (This is sensible, while these files seldomly change, and take rather
# long to build.)

# flash-semiclean is "homemade",
# flash-clean and flash-mostlyclean have semantics like in the GNU
# Makefile standards.

flash-semiclean:
	rm -f $(flashprefix)/*.cramfs $(flashprefix)/*.squashfs \
	$(flashprefix)/*.jffs2 $(flashprefix)/.*-flfs \
	$(flashprefix)/*.list
	rm -rf $(flashprefix)/root
	rm -rf $(flashprefix)/root-stock*
	rm -rf $(flashprefix)/root-neutrino*
	rm -rf $(flashprefix)/root-radiobox*
	rm -rf $(flashprefix)/root-enigma*
	rm -rf $(flashprefix)/conf*
	rm -rf $(flashprefix)/var*
	rm -rf $(flashprefix)/data*
	rm -rf $(flashprefix)/kernel*
	-rm -rf $(flashprefix)/mtdblock*
	-rm -rf $(flashprefix)/sdax*
	-rm -rf $(flashprefix)-rpmdb/*
	-rm $(flashprefix)/enigma2*

flash-mostlyclean: flash-semiclean
	rm -rf $(flashprefix)/root-*
	rm -f $(flashprefix)/*.flfs*x

flash-clean: flash-mostlyclean
	rm -f $(flashprefix)/*.img*
endif ## TARGETRULESET_FLASH

#
# RPM stuff
#
list-clean:
	make $(LIST_CLEAN)

$(LIST_CLEAN): \
%-clean:
	-$(DEPSCLEANUP_$*)

$(RPMLIST_CLEAN): \
%-clean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -clean,,$@)
	-$(DEPSCLEANUP_$*)

%-clean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-$(subst -clean,,$@)
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -clean,,$@)
	-rm .deps/$(subst -clean,,$@)

list-distclean:
	make $(LIST_DISTCLEAN)

$(LIST_DISTCLEAN): \
%-distclean:
	-$(DISTCLEANUP_$*)
	-$(DEPSDISTCLEANUP_$*)

$(RPMLIST_DISTCLEAN): \
%-distclean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -distclean,,$@)
	-rm RPMS/sh4/$(STLINUX)-sh4-$(subst -distclean,,$@)*
	-$(DEPSDISTCLEANUP_$*)

%-distclean:
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-$(subst -distclean,,$@)
	-rpm $(DRPM) -ev --nodeps $(STLINUX)-sh4-$(subst -distclean,,$@)
	-rm RPMS/${host_arch}/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/noarch/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/sh4/$(STLINUX)-$(subst -distclean,,$@)*
	-rm RPMS/sh4/$(STLINUX)-sh4-$(subst -distclean,,$@)*
	-rm .deps/$(subst -distclean,,$@)*

.PHONY: depsclean mostlyclean-local cdk-clean distclean-local flash-semiclean \
flash-mostlyclean flash-clean
