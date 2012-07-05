SUBDIRS = images scripts

install-data-local:
	for f in ./*.js; do gzip $$f -c >$$f.gz; done
	install -d $(datadir)/neutrino/httpd-y
	install -m 0644 *.yhtm $(datadir)/neutrino/httpd-y
	install -m 0644 *.htm $(datadir)/neutrino/httpd-y
	install -m 0644 *.html $(datadir)/neutrino/httpd-y
	install -m 0644 *.css $(datadir)/neutrino/httpd-y
	install -m 0644 *.gz $(datadir)/neutrino/httpd-y
	install -m 0644 *.txt $(datadir)/neutrino/httpd-y
	install -m 0644 *.ico $(datadir)/neutrino/httpd-y

uninstall-local:
	-rm -rf $(datadir)/neutrino/httpd-y