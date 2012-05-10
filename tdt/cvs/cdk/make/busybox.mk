#
# busybox
#
$(DEPDIR)/busybox.do_prepare: @DEPENDS_busybox@
	@PREPARE_busybox@
	cd @DIR_busybox@
	cd @DIR_busybox@ && \
		patch -p1 < ../Patches/busybox-1.20.0/busybox-1.20.0-buildsys.patch && \
		patch -p1 < ../Patches/busybox-1.20.0/busybox-1.20.0-getty.patch && \
		patch -p1 < ../Patches/busybox-1.20.0/busybox-1.20.0-lineedit.patch && \
		patch -p1 < ../Patches/busybox-1.20.0/busybox-1.20.0-sed.patch
	touch $@

$(DEPDIR)/busybox.do_compile: bootstrap $(DEPDIR)/busybox.do_prepare Patches/busybox-1.20.0/busybox-1.20.0.config | $(DEPDIR)/$(GLIBC_DEV)
	cd @DIR_busybox@ && \
		export CROSS_COMPILE=$(target)- && \
		$(MAKE) mrproper && \
		$(INSTALL) -m644 ../$(lastword $^) .config && \
		$(MAKE) all \
			CROSS_COMPILE=$(target)- \
			CFLAGS_EXTRA="$(TARGET_CFLAGS)"
	touch $@

$(DEPDIR)/min-busybox $(DEPDIR)/std-busybox $(DEPDIR)/max-busybox \
$(DEPDIR)/busybox: \
$(DEPDIR)/%busybox: $(DEPDIR)/busybox.do_compile
	cd @DIR_busybox@ && \
		export CROSS_COMPILE=$(target)- && \
		@INSTALL_busybox@
#		@CLEANUP_busybox@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
