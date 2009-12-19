# osd910
VERSION_osd910	:= 0.0319
DIR_osd910	:= ../apps/OSD910 

$(DEPDIR)/osd910.do_compile: bootstrap libstdc++-dev freetype jpeg lirc libpng libungif
	cd $(appsdir)/OSD910 && \
		$(MAKE_OPTS) $(MAKE) libs prefix=$(targetprefix)
	cd $(appsdir)/OSD910/OSDshell && \
		$(MAKE_OPTS) $(MAKE) OSDshell prefix=$(targetprefix)
	cd $(appsdir)/OSD910/PicViewer && \
		$(MAKE_OPTS) $(MAKE) OSDpicview prefix=$(targetprefix)
	touch $@

define osd910/install
	$(MAKE) -C $(appsdir)/OSD910 install prefix=$(prefix)/$*cdkroot
	$(MAKE) -C $(appsdir)/OSD910/OSDshell install prefix=$(prefix)/$*cdkroot
	$(MAKE) -C $(appsdir)/OSD910/PicViewer install prefix=$(prefix)/$*cdkroot
endef

osd910_ADAPTED_FILES = /etc/default/osdshell /etc/init.d/osdshell /etc/init.d/httpd
osd910_INITD_FILES = osdshell httpd
ETC_RW_FILES += default/osdshell osd910/osdshell osd910/osdpicview init.d/osdshell init.d/httpd

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,osd910,freetype jpeg lirc libpng libungif))

# Evaluate packages
$(eval $(call Package,osd910,libosd910))
$(eval $(call Package,osd910,osdshell))
$(eval $(call Package,osd910,osdpicview))


osd910-clean:
	-rm .deps/osd910

osd910-distclean:
	make -C $(appsdir)/OSD910 clean
	make -C $(appsdir)/OSD910/OSDshell clean
	make -C $(appsdir)/OSD910/PicViewer clean
	-rm .deps/osd910*


#
# vfd
#
$(DEPDIR)/vfd.do_compile: bootstrap
	cd $(appsdir)/misc/tools/vfd/src && \
		$(MAKE_OPTS) $(MAKE) vfdtest prefix=$(targetprefix) || true
	cd $(appsdir)/misc/tools/vfd/modules && \
		$(MAKE_OPTS) $(MAKE) modules KDIR=$(kernelprefix)/linux-sh4
	touch $@

$(DEPDIR)/min-vfd $(DEPDIR)/std-vfd $(DEPDIR)/max-vfd $(DEPDIR)/vfd: \
$(DEPDIR)/%vfd: vfd.do_compile
	$(MAKE) -C $(appsdir)/misc/tools/vfd/src install prefix=$(prefix)/$*cdkroot
	$(MAKE) -C $(appsdir)/misc/tools/vfd/modules modules_install prefix=$(prefix)/$*cdkroot KERNELVERSION=$(KERNELVERSION) && \
		$(DEPMOD) -ae -b $(prefix)/$*cdkroot -r $(KERNELRELEASE)
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-vfd: $(flashprefix)/root/usr/bin/vfdtest

$(flashprefix)/root/usr/bin/vfdtest: $(DEPDIR)/vfd.do_compile \
		| $(flashprefix)/root
	$(MAKE) -C $(appsdir)/misc/tools/vfd/src install prefix=$(flashprefix)/root
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/root-cramfs/lib/modules/$(KERNELVERSION)/vfd/vfd.ko \
$(flashprefix)/root-squashfs/lib/modules/$(KERNELVERSION)/vfd/vfd.ko \
$(flashprefix)/root-jffs2/lib/modules/$(KERNELVERSION)/vfd/vfd.ko: \
$(flashprefix)/root-%/lib/modules/$(KERNELVERSION)/vfd/vfd.ko: $(DEPDIR)/vfd.do_compile \
		| $(flashprefix)/root
	$(MAKE) -C $(appsdir)/misc/tools/vfd/modules modules_install prefix=$(flashprefix)/root-$* KERNELVERSION=$(KERNELVERSION) && \
		$(DEPMOD) -ae -b $(flashprefix)/root-$* -r $(KERNELRELEASE)
	@TUXBOX_CUSTOMIZE@
endif

vfd-distclean:
	make -C $(appsdir)/misc/tools/vfd/src clean
	make -C $(appsdir)/misc/tools/vfd/modules clean
	-rm .deps/vfd*
