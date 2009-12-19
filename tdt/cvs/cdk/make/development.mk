#
# RUBY
#
$(DEPDIR)/ruby.do_prepare: @DEPENDS_ruby@ Patches/vsftpd.diff
	@PREPARE_ruby@
	touch $@

$(DEPDIR)/ruby.do_compile: $(DEPDIR)/ruby.do_prepare
	cd @DIR_ruby@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean || true && \
		autoconf && \
		echo "ac_cv_func_setpgrp_void=set" >> config.cache && \
		$(BUILDENV) \
		./configure \
			--cache-file=config.cache \
			--build=$(build) \
			--host=$(target) \
			--prefix= && \
		$(MAKE) $(MAKE_OPTS)
	touch $@
#

$(DEPDIR)/min-ruby $(DEPDIR)/std-ruby $(DEPDIR)/max-ruby $(DEPDIR)/ipk-ruby $(DEPDIR)/ruby: \
$(DEPDIR)/%ruby: $(DEPDIR)/ruby.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_ruby@ && \
		export PATH=$(MAKE_PATH) && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/sbin && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/xinetd.d && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/share/man/man5 && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/share/man/man8 && \
		@INSTALL_vsftpd@
	$(INSTALL) -d $(prefix)/$*cdkroot/etc && $(INSTALL) -m644 root/etc/vsftpd.conf $(prefix)/$*cdkroot/etc
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && $(INSTALL) -m644 root/etc/default/vsftpd $(prefix)/$*cdkroot/etc/default
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && $(INSTALL) -m755 root/etc/init.d/vsftpd $(prefix)/$*cdkroot/etc/init.d
	[ "x$*" != "xipk-" ] && \
		( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		$(hostprefix)/bin/target-initdconfig --add vsftpd || \
		echo "Unable to enable initd service: networking" ) || true
#	@CLEANUP_vsftpd@
	@TUXBOX_YAUD_CUSTOMIZE@
	@[ "x$*" = "x" ] && touch $@ || true

ruby.build_ipk: $(DEPDIR)/ipk-ruby
	cp -prd ipk-control/ruby/* $(prefix)/ipk-cdkroot && make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
#	-rm -rf  $(prefix)/ipk-cdkroot
