# misc/tools

#$(appsdir)/misc/tools/config.status: bootstrap libpng
$(appsdir)/misc/tools/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/misc/tools && \
	libtoolize -f -c && \
	$(CONFIGURE) --prefix=

$(DEPDIR)/min-misc-tools $(DEPDIR)/std-misc-tools $(DEPDIR)/max-misc-tools $(DEPDIR)/misc-tools: \
$(DEPDIR)/%misc-tools: driver libstdc++-dev libdvdnav libdvdcss libpng jpeg ffmpeg $(appsdir)/misc/tools/config.status
	$(MAKE) -C $(appsdir)/misc/tools all install DESTDIR=$(prefix)/$*cdkroot \
	$(if $(UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_UFS910") \
	$(if $(FLASH_UFS910),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FLASH_UFS910") \
	$(if $(FORTIS_HDBOX),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_FORTIS_HDBOX") \
	$(if $(OCTAGON1008),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_OCTAGON1008") \
	$(if $(CUBEREVO),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO") \
	$(if $(CUBEREVO_MINI),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI") \
	$(if $(CUBEREVO_MINI2),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI2") \
	$(if $(CUBEREVO_MINI_FTA),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_MINI_FTA") \
	$(if $(CUBEREVO_250HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_250HD") \
	$(if $(CUBEREVO_2000HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_2000HD") \
	$(if $(CUBEREVO_9500HD),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_CUBEREVO_9500HD") \
	$(if $(ATEVIO7500),CPPFLAGS="$(CPPFLAGS) -DPLATFORM_ATEVIO7500") \
	$(if $(PLAYER131),CPPFLAGS="$(CPPFLAGS) -DPLAYER131") \
	$(if $(PLAYER179),CPPFLAGS="$(CPPFLAGS) -DPLAYER179") \
	$(if $(PLAYER191),CPPFLAGS="$(CPPFLAGS) -DPLAYER191") \
	$(if $(STM22),CPPFLAGS="$(CPPFLAGS) -DSTM22")
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
