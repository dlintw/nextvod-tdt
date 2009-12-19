#
# RECORD
# see http://board.ufs-910.de/viewtopic.php?t=1435 
# and http://board.ufs-910.de/viewtopic.php?t=1524&start=0
#
$(DEPDIR)/record.do_prepare: @DEPENDS_record@
	@PREPARE_record@
	touch $@

$(DEPDIR)/record.do_compile: $(DEPDIR)/record.do_prepare
	cd @DIR_record@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean && \
		$(MAKE) $(MAKE_OPTS) record
	touch $@

$(DEPDIR)/min-record $(DEPDIR)/std-record $(DEPDIR)/max-record $(DEPDIR)/ipk-record $(DEPDIR)/record: \
$(DEPDIR)/%record: $(DEPDIR)/record.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/ipk-cdkroot || true
	cd @DIR_record@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
	[ "x$*" != "xipk-" ] && \
		( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		$(hostprefix)/bin/target-initdconfig --add record || \
		echo "Unable to enable initd service: record" ) || true
#       @CLEANUP_record@
	@TUXBOX_YAUD_CUSTOMIZE@
	@[ "x$*" = "x" ] && touch $@ || true

record.build_ipk: $(DEPDIR)/ipk-record
	cp -prd ipk-control/record/* $(prefix)/ipk-cdkroot && make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
#	-rm -rf  $(prefix)/ipk-cdkroot

