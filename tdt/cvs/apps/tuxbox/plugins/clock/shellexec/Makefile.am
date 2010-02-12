install-exec-local:
	install -m 0755 $(srcdir)/cops $(DESTDIR)$(bindir)
	install -m 0644 $(srcdir)/plconfig_clock.mnu $(DESTDIR)$(CONFIGDIR)/flexinc
	echo "INCLUDE=/var/tuxbox/config/flexinc/plconfig_clock.mnu" >> $(DESTDIR)$(CONFIGDIR)/shellexec.conf
	echo "COMMENT=!" >> $(DESTDIR)$(CONFIGDIR)/shellexec.conf
