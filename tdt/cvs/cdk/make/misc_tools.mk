# misc/tools

#$(appsdir)/misc/tools/config.status: bootstrap libpng
$(appsdir)/misc/tools/config.status: bootstrap
	cd $(appsdir)/misc/tools && \
	libtoolize -f -c && \
	$(CONFIGURE) --prefix=

$(DEPDIR)/min-misc-tools $(DEPDIR)/std-misc-tools $(DEPDIR)/max-misc-tools $(DEPDIR)/misc-tools: \
$(DEPDIR)/%misc-tools: driver libstdc++-dev libdvdnav libdvdcss libpng jpeg $(appsdir)/misc/tools/config.status
	$(MAKE) -C $(appsdir)/misc/tools all install DESTDIR=$(prefix)/$*cdkroot \
	$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO") \
	$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI") \
	$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI2") \
	$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI_FTA") \
	$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_250HD") \
	$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_2000HD") \
	$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_9500HD")
	[ "x$*" = "x" ] && touch $@ || true

flash-misc-tools: $(DEPDIR)/misc-tools \
		| $(flashprefix)/root
	$(MAKE) -C $(appsdir)/misc/tools install DESTDIR=$(flashprefix)/root
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@


flash-vfdctl: $(flashprefix)/root/bin/vfdctl

$(flashprefix)/root/bin/vfdctl: $(DEPDIR)/misc-tools \
		| $(flashprefix)/root
	$(MAKE) -C $(appsdir)/misc/tools/vfdctl install DESTDIR=$(flashprefix)/root
	touch $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
