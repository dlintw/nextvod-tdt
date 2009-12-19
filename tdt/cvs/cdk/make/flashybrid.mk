#
# FLASHYBRID
#
$(DEPDIR)/flashybrid.do_prepare: @DEPENDS_flashybrid@ Patches/flashybrid.diff
	@PREPARE_flashybrid@
	touch $@
flashybrid.do_clean:
	@CLEANUP_lighttpd@
	-rm .deps/$(subst do_clean,do_prepare,$@)
	-rm .deps/$(subst do_clean,do_compile,$@)
	-rm .deps/$(subst .do_clean,,$@)
flashybrid.build_ipk: $(DEPDIR)/flashybrid.do_prepare
	[ -d $(buildprefix)/tmp-ipk ] && rm -rf $(buildprefix)/tmp-ipk || true
	$(INSTALL) -d $(buildprefix)/tmp-ipk && \
	cp -prd ipk-control/flashybrid/* $(buildprefix)/tmp-ipk && make $(buildprefix)/tmp-ipk/strippy && \
	ipkg-build -o root -g root $(buildprefix)/tmp-ipk $(prefix)/ipk


