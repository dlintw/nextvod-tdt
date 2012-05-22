#
# Plugins
#
$(DEPDIR)/enigma2-plugins: enigma2_openwebif enigma2_networkbrowser

#
# enigma2-openwebif
#
$(DEPDIR)/enigma2_openwebif.do_prepare: bootstrap python pythoncheetah @DEPENDS_enigma2_openwebif@
	@PREPARE_enigma2_openwebif@
	touch $@

$(DEPDIR)/enigma2_openwebif.do_compile: $(DEPDIR)/enigma2_openwebif.do_prepare
	cd @DIR_enigma2_openwebif@ && \
		$(BUILDENV) \
		cp -a plugin $(targetprefix)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif
	touch $@

$(DEPDIR)/min-enigma2_openwebif $(DEPDIR)/std-enigma2_openwebif $(DEPDIR)/max-enigma2_openwebif \
$(DEPDIR)/enigma2_openwebif: \
$(DEPDIR)/%enigma2_openwebif: $(DEPDIR)/enigma2_openwebif.do_compile
#	@DISTCLEANUP_enigma2_openwebif@
	@[ "x$*" = "x" ] && touch $@ || true

#
# enigma2-networkbrowser
#
$(DEPDIR)/enigma2_networkbrowser.do_prepare: @DEPENDS_enigma2_networkbrowser@
	@PREPARE_enigma2_networkbrowser@
	touch $@

$(DEPDIR)/enigma2_networkbrowser.do_compile: $(DEPDIR)/enigma2_networkbrowser.do_prepare
	cd @DIR_enigma2_networkbrowser@/src/lib && \
		$(BUILDENV) \
		sh4-linux-gcc -shared -o netscan.so \
			-I $(targetprefix)/usr/include/python2.6 \
			-include Python.h \
			errors.h \
			list.c \
			list.h \
			main.c \
			nbtscan.c \
			nbtscan.h \
			range.c \
			range.h \
			showmount.c \
			showmount.h \
			smb.h \
			smbinfo.c \
			smbinfo.h \
			statusq.c \
			statusq.h \
			time_compat.h
	cd @DIR_enigma2_networkbrowser@ && \
		mkdir -p $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser && \
		cp -a po $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a meta $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/* $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		cp -a src/lib/netscan.so $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ && \
		rm -rf $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/lib
	touch $@

$(DEPDIR)/min-enigma2_networkbrowser $(DEPDIR)/std-enigma2_networkbrowser $(DEPDIR)/max-enigma2_networkbrowser \
$(DEPDIR)/enigma2_networkbrowser: \
$(DEPDIR)/%enigma2_networkbrowser: $(DEPDIR)/enigma2_networkbrowser.do_compile
#	@DISTCLEANUP_enigma2_networkbrowser@
	[ "x$*" = "x" ] && touch $@ || true
