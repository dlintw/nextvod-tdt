install-data-local:
	install -d $(datadir)/neutrino/httpd-y/scripts
	install -m 0755 Y_*.sh $(datadir)/neutrino/httpd-y/scripts
	install -m 0644 _Y_*.sh $(datadir)/neutrino/httpd-y/scripts
	install -m 0755 api.sh $(datadir)/neutrino/httpd-y/scripts

uninstall-local:
	-rm -rf $(datadir)/neutrino/httpd-y/scripts