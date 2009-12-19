#
# BUSYBOX
#
$(DEPDIR)/busybox.do_prepare: @DEPENDS_busybox@
	@PREPARE_busybox@
	touch $@

$(DEPDIR)/busybox.do_compile: bootstrap $(DEPDIR)/busybox.do_prepare Patches/busybox.config | $(DEPDIR)/$(GLIBC_DEV)
	cd @DIR_busybox@ && \
		export CROSS_COMPILE=$(target)- && \
		$(MAKE) mrproper && \
		$(INSTALL) -m644 ../$(lastword $^) .config && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-busybox $(DEPDIR)/std-busybox $(DEPDIR)/max-busybox \
$(DEPDIR)/busybox: \
$(DEPDIR)/%busybox: $(DEPDIR)/busybox.do_compile
if STM22

else
	cp -rd $(buildprefix)/root/etc/fw_env.config $(prefix)/cdkroot/etc
endif
	cd @DIR_busybox@ && \
		cp ../Patches/rcSBB examples && \
		cp ../Patches/inittabBB examples && \
		export CROSS_COMPILE=$(target)- && \
		$(INSTALL) -m644 examples/inittabBB $(prefix)/$*cdkroot/etc && \
		$(INSTALL) -m755 examples/rcSBB $(prefix)/$*cdkroot/etc/init.d && \
		@INSTALL_busybox@
		( cd $(prefix)/$*cdkroot && \
			[ -f linuxrc ] && rm linuxrc || true && \
			[ -f etc/inittabBB ] && rm etc/inittabBB || true && \
			[ -f etc/init.d/rcSBB ] && rm etc/init.d/rcSBB || true )
#       @CLEANUP_busybox@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

flash-busybox: $(flashprefix)/root/bin/busybox

$(flashprefix)/root/bin/busybox: $(DEPDIR)/busybox.do_compile
	@cd @DIR_busybox@ && \
		export CROSS_COMPILE=$(target)- && \
		$(MAKE) install CONFIG_PREFIX=$(flashprefix)/root && \
		export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && $(hostprefix)/bin/target-shellconfig --add /bin/ash 5 && \
		( cd $(flashprefix)/root && \
			[ -f linuxrc ] && rm linuxrc || true ) && \
	touch $@
	@FLASHROOTDIR_MODIFIED@
	
# Enable ftp: 423212 -> 425604 busybox binary
#.PHONY: flash-busybox
