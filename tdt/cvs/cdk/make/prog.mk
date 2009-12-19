#
# PROG
# see 
#
#$(DEPDIR)/prog.do_prepare: @DEPENDS_prog@
#	@PREPARE_prog@
#	touch $@
#$(DEPDIR)/prog.do_prepare
$(DEPDIR)/prog.do_compile:
	cd fb-stapi-0.1.20070720 && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) clean && \
		$(MAKE) INCDIR=$(prefix)/$*cdkroot/usr/include $(MAKE_OPTS) prog
	touch $@
#	cd @DIR_prog@ && \
#
$(DEPDIR)/min-prog $(DEPDIR)/std-prog $(DEPDIR)/max-prog $(DEPDIR)/prog: \
$(DEPDIR)/%prog: $(DEPDIR)/prog.do_compile
	cd @DIR_prog@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) install DESTDIR=$(prefix)/$*cdkroot
#       @CLEANUP_prog@
	@TUXBOX_YAUD_CUSTOMIZE@
	@[ "x$*" = "x" ] && touch $@ || true
prog.do_clean:
	@CLEANUP_prog@
	-rm .deps/$(subst do_clean,do_prepare,$@)
	-rm .deps/$(subst do_clean,do_compile,$@)
	-rm .deps/$(subst .do_clean,,$@)
prog.build_ipk: $(DEPDIR)/prog.do_compile
	[ -d $(buildprefix)/tmp-ipk ] && rm -rf $(buildprefix)/tmp-ipk || true
	cd @DIR_prog@ && \
		export PATH=$(MAKE_PATH) && \
		$(MAKE) install DESTDIR=$(buildprefix)/tmp-ipk
	cp -prd ipk-control/prog/* $(buildprefix)/tmp-ipk && make $(buildprefix)/tmp-ipk/strippy && \
	ipkg-build -o root -g root $(buildprefix)/tmp-ipk $(prefix)/ipk

