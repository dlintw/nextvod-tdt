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
