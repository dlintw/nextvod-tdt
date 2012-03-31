
# Plugins
$(DEPDIR)/enigma2-plugins: enigma2-openwebif

#
# enigma2-openwebif
#
$(DEPDIR)/enigma2-openwebif.do_prepare: bootstrap python pythoncheetah
	rm -rf e2openplugin-OpenWebif
	git clone git://github.com/E2OpenPlugins/e2openplugin-OpenWebif.git
	touch $@

$(DEPDIR)/enigma2-openwebif.do_compile: $(DEPDIR)/enigma2-openwebif.do_prepare
	cd e2openplugin-OpenWebif && \
		$(BUILDENV) \
		cp -a plugin $(targetprefix)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif
	touch $@

$(DEPDIR)/min-enigma2-openwebif $(DEPDIR)/std-enigma2-openwebif $(DEPDIR)/max-enigma2-openwebif \
$(DEPDIR)/enigma2-openwebif: \
$(DEPDIR)/%enigma2-openwebif: $(DEPDIR)/enigma2-openwebif.do_compile
#	@DISTCLEANUP_enigma2-openwebif@
	@[ "x$*" = "x" ] && touch $@ || true
