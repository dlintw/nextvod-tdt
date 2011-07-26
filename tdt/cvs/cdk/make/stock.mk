#
# STOCK (pvrmain GUI)
#

$(DEPDIR)/min-stock $(DEPDIR)/std-stock $(DEPDIR)/max-stock $(DEPDIR)/stock: \
$(DEPDIR)/%stock: %jpeg $(STOCK_GUI_ADAPTED_ETC_FILES:%=root/etc/%)
	( cd root/etc && for i in $(STOCK_GUI_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in $(STOCK_GUI_ADAPTED_ETC_FILES); do \
			[ "$${s%%/*}" = "init.d" ] && ( \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ) ; done && rm *rpmsave 2>/dev/null || true ) && \
	$(INSTALL) -d $(prefix)/$*cdkroot/{app,app.static,config,data,etc.static} && \
	$(INSTALL) -d $(prefix)/$*cdkroot/{var/CI,ramdisk} && \
	( cd $(prefix)/$*cdkroot/root && ln -sf /app/modules_sys/modules26 modules26 ) && \
	( cd $(prefix)/$*cdkroot/usr/sbin && ln -sf /app/usr/local/bin/lircd lircd && \
			ln -sf /app/usr/local/bin/lircmd lircmd ) && \
	( cd $(prefix)/$*cdkroot/etc && ln -sf /app/script/lircd.conf lircd.conf && \
			ln -sf /app/script/lircmd.conf lircmd.conf ) && \
	ln -sf /app/usr/lib/libvfsblkid.so $(prefix)/$*cdkroot/usr/lib/libvfsblkid.so && \
	ln -sf /tmp/ttyIO $(prefix)/$*cdkroot/var/ttyIO && \
	[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-stock: $(flashprefix)/root-stock

$(flashprefix)/root-stock: bootstrap $(wildcard root-stock-local.sh) config.status \
		$(STOCK_GUI_ADAPTED_ETC_FILES:%=root/etc/%) libz jpeg | $(CROSS_LIBGCC) $(LIBSTDC)
	$(INSTALL) -d $@/etc/{default,init.d,rc.d/rcS.d,rc.d/rc3.d}
	$(INSTALL) -d $@/var
	( cd root/etc && for i in $(STOCK_GUI_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $@/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $@/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$@ && cd $@/etc/init.d && \
		for s in ufs910-common ufs910 ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true ) && \
	$(INSTALL) -d $@/{app,app.static,config,data,etc.static,usr/sbin,root} && \
	$(INSTALL) -d $@/{var/CI,ramdisk} && \
	( cd $@/root && ln -sf /app/modules_sys/modules26 modules26 ) && \
	( cd $@/usr/sbin && ln -sf /app/usr/local/bin/lircd lircd && \
			ln -sf /app/usr/local/bin/lircmd lircmd ) && \
	( cd $@/etc && ln -sf /app/script/lircd.conf lircd.conf && \
			ln -sf /app/script/lircmd.conf lircmd.conf ) && \
	ln -sf /tmp/ttyIO $@/var/ttyIO && \
	touch $@
	@TUXBOX_CUSTOMIZE@


$(flashprefix)/conf-stock: bootstrap $(wildcard conf-stock-local.sh) config.status \
		| $(flashprefix)
	rm -rf $@
	$(INSTALL) -d $@
	[ -f $(stockdir)/.app/start.sh ] && ( \
		$(INSTALL) -m 755 $(stockdir)/.app/start.sh $@/start-ext.sh; \
		sed -e 's|/usr/sbin/telnetd -l /bin/sh|#/usr/sbin/telnetd -l /bin/sh|' -i $@/start-ext.sh; \
		sed -e 's|insmod /app/modules_sys/smsc911x.ko tx_dma=256 rx_dma=256|#insmod /app/modules_sys/smsc911x.ko tx_dma=256 rx_dma=256|' -i $@/start-ext.sh; \
		sed -e 's|mount  -t usbfs none /proc/bus/usb/|#mount  -t usbfs none /proc/bus/usb/|' -i $@/start-ext.sh ) || true

	@TUXBOX_CUSTOMIZE@
endif
