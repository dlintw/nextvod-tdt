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

mostlyclean-local: cdk-clean

# Clean tuxbox source directories
cdk-clean:
	-$(MAKE) -C $(driverdir) KERNEL_LOCATION=$(buildprefix)/linux-sh4 \
		BIN_DEST=$(targetprefix)/bin \
		INSTALL_MOD_PATH=$(targetprefix) clean
	-$(MAKE) -C $(appsdir)/neutrino distclean
	-$(MAKE) -C $(appsdir)/neutrino-beta distclean
	-$(MAKE) -C $(appsdir)/enigma2-nightly distclean
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
	-rm -rf $(crossprefix)/
	-rm -rf $(configprefix)/
	-rm -rf $(devkitprefix)/
	-rm -rf $(prefix)/*cdkroot/
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(rpmdbprefix)
	-rm -rf $(prefix)/release*
	-rm -rf SOURCES SPECS BUILD && install -d SOURCES SPECS BUILD
	-rm -rf $(prefix)/ccache


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
	-rm -f linux-sh4
	-rm -rf $(appsdir)/enigma2-*
	-rm -rf $(appsdir)/neutrino-*
	-rm -rf $(DEPDIR)
#	-rm -rf $(targetprefix)
	-rm -rf $(hostprefix)
	-rm -rf $(serversupport)
	-rm -rf $(crossprefix)/
	-rm -rf $(configprefix)/
	-rm -rf $(devkitprefix)/
	-rm -rf $(prefix)/*cdkroot/
	-rm -rf $(prefix)/*cdkroot-rpmdb
	-rm -rf $(prefix)/*cdkroot-tftpboot
	-rm -rf $(rpmdbprefix)/
	-rm -rf SOURCES SPECS BUILD BUILDROOT SRPMS RPMS
	-rm -rf $(prefix)/ccache
	-rm -rf $(kernelprefix)/u-boot
	-rm -rf $(STGFB_DIR)
	-@DISTCLEANUP@

#
# RPM stuff
#
list-clean:
	make $(LIST_CLEAN)

$(LIST_CLEAN): \
%-clean:
	-[ ! -z "$(UNINSTALL_$*)" -a -d $(DIR_$*) ] && ( cd $(DIR_$*) && $(UNINSTALL_$*) || true )
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
	-[ ! -z "$(UNINSTALL_$*)" -a -d $(DIR_$*) ] && ( cd $(DIR_$*) && $(UNINSTALL_$*) || true )
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

.PHONY: depsclean mostlyclean-local cdk-clean distclean-local list-clean
