
URLVDR="ftp://ftp.tvdr.de/vdr/Developer/"

$(DEPDIR)/vdrdev.do_prepare: bootstrap freetype libxml2 fontconfig libcap
	[ -d "$(appsdir)/vdr/vdr" ] && \
	rm -rf $(appsdir)/vdr/vdr; \
	clear; \
	echo "Choose between the following versions:"; \
	echo "1) Sun,  4 Sep 2011 15:42 - vdr-1.7.21"; \
	read -p "Select: "; \
	echo "Selection: " $$REPLY; \
	[ "$$REPLY" == "1" ] && PREPARE="vdr-1.7.21"; \
	echo "Version: " $$PREPARE; \
	[ -d "$(appsdir)/vdr/$$PREPARE" ] && \
	rm -rf $(appsdir)/vdr/$$PREPARE; \
	[ -d "$(appsdir)/vdr/$$PREPARE.org" ] && \
	rm -rf $(appsdir)/vdr/$$PREPARE.org; \
	(cd $(appsdir)/vdr; wget $(URLVDR)/$$PREPARE.tar.bz2; tar -xjf $$PREPARE.tar.bz2; rm -f $$PREPARE.tar.bz2;); \
	cp -ra $(appsdir)/vdr/$$PREPARE $(appsdir)/vdr/$$PREPARE.org; \
	ln -s $(appsdir)/vdr/$$PREPARE $(appsdir)/vdr/vdr; \
	rm -rf $(appsdir)/vdr/vdr/PLUGINS/src/skincurses;
	touch $@

$(DEPDIR)/vdrdev.do_compile:
	cd $(appsdir)/vdr/vdr && \
		$(BUILDENV) $(MAKE) all plugins install-bin install-conf install-plugins install-i18n \
		DESTDIR=$(targetprefix) \
		VIDEODIR=/hdd \
		CONFDIR=/usr/local/share/vdr \
		PLUGINLIBDIR=/usr/lib/vdr
	touch $@

$(DEPDIR)/vdrdev: vdr.do_prepare vdr.do_compile
	touch $@

vdrdev-clean vdrdev-distclean:
	rm -f $(DEPDIR)/vdr
	rm -f $(DEPDIR)/vdr.do_compile
	rm -f $(DEPDIR)/vdr.do_prepare
	rm -rf $(appsdir)/vdr/vdr

