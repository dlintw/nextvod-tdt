#
# titan
#

$(DEPDIR)/titan.do_prepare:
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.myphotos.cc/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libipkg" ] || \
	ln -s $(appsdir)/titan/libipkg $(appsdir)/titan/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan; \
	touch $@

$(appsdir)/titan/titan/config.status: \
	bootstrap libfreetype libpng libid3tag openssl libcurl libmad libboost libgif sdparm ethtool \
		titan-libipkg titan-libdreamdvd	\
		$(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/titan && \
		libtoolize --force && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--build=$(build) \
			--prefix=/usr/local \
			--with-target=cdk \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"
		$(MAKE)
	touch $@

$(DEPDIR)/titan.do_compile: $(appsdir)/titan/titan/config.status
	cd $(appsdir)/titan/titan && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan: titan.do_prepare titan.do_compile
	$(MAKE) -C $(appsdir)/titan/titan install DESTDIR=$(targetprefix)
	$(target)-strip $(targetprefix)/usr/local/bin/titan
	touch $@
	
titan-clean:
	rm -f $(DEPDIR)/titan
	cd $(appsdir)/titan/titan && \
		$(MAKE) distclean

titan-distclean:
	rm -f $(DEPDIR)/titan*
	rm -rf $(appsdir)/titan	

titan-updateyaud: titan-clean titan
	mkdir -p $(prefix)/release/usr/local/bin
	cp $(targetprefix)/usr/local/bin/titan $(prefix)/release_titan/usr/local/bin/
	
#
# titan-libipkg
#
$(DEPDIR)/titan-libipkg.do_prepare:
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.myphotos.cc/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libipkg" ] || \
	ln -s $(appsdir)/titan/libipkg $(appsdir)/titan/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan; \
	touch $@

$(appsdir)/titan/libipkg/config.status: bootstrap
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/libipkg && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan-libipkg.do_compile: $(appsdir)/titan/libipkg/config.status
	cd $(appsdir)/titan/libipkg && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan-libipkg: titan-libipkg.do_prepare titan-libipkg.do_compile
	$(MAKE) -C $(appsdir)/titan/libipkg install DESTDIR=$(targetprefix)
	touch $@
	
titan-libipkg-clean:
	rm -f $(DEPDIR)/titan-libipkg
	cd $(appsdir)/titan/libipkg && \
		$(MAKE) distclean

titan-libipkg-distclean:
	rm -f $(DEPDIR)/titan-libipkg*
	rm -rf $(appsdir)/titan/libipkg

#
# titan-libdreamdvd
#
$(DEPDIR)/titan-libdreamdvd.do_prepare:
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.myphotos.cc/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libipkg" ] || \
	ln -s $(appsdir)/titan/libipkg $(appsdir)/titan/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan; \
	touch $@

$(appsdir)/titan/libdreamdvd/config.status: bootstrap libdvdnav
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/libdreamdvd && \
		libtoolize --force && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		automake --foreign --add-missing && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/titan-libdreamdvd.do_compile: $(appsdir)/titan/libdreamdvd/config.status
	cd $(appsdir)/titan/libdreamdvd && \
		$(MAKE)
	touch $@

$(DEPDIR)/titan-libdreamdvd: titan-libdreamdvd.do_prepare titan-libdreamdvd.do_compile
	$(MAKE) -C $(appsdir)/titan/libdreamdvd install DESTDIR=$(targetprefix)
	touch $@

titan-libdreamdvd-clean:
	rm -f $(DEPDIR)/titan-libdreamdvd
	cd $(appsdir)/titan/libdreamdvd && \
		$(MAKE) distclean

titan-libdreamdvd-distclean:
	rm -f $(DEPDIR)/titan-libdreamdvd*
	rm -rf $(appsdir)/titan/libdreamdvd	

#
# titan-plugins
#

$(DEPDIR)/titan-plugins.do_prepare:
	[ -d "$(appsdir)/titan" ] && \
	(cd $(appsdir)/titan; svn up; cd "$(buildprefix)";); \
	[ -d "$(appsdir)/titan" ] || \
	svn checkout --username public --password public http://sbnc.myphotos.cc/svn/titan $(appsdir)/titan; \
	[ -d "$(appsdir)/titan/titan/libipkg" ] || \
	ln -s $(appsdir)/titan/libipkg $(appsdir)/titan/titan; \
	[ -d "$(appsdir)/titan/titan/libdreamdvd" ] || \
	ln -s $(appsdir)/titan/libdreamdvd $(appsdir)/titan/titan;
	touch $@

$(appsdir)/titan/plugins/config.status: titan-libdreamdvd
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/titan/plugins && \
	libtoolize --force && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	$(CONFIGURE) --prefix= \
	$(if $(MULTICOM324), --enable-multicom324) \
	$(if $(EPLAYER3), --enable-eplayer3)
	touch $@

$(DEPDIR)/titan-plugins.do_compile: $(appsdir)/titan/plugins/config.status
	cd $(appsdir)/titan/plugins && \
			$(MAKE) -C $(appsdir)/titan/plugins all install DESTDIR=$(prefix)/$*cdkroot
	touch $@

$(DEPDIR)/titan-plugins: titan-plugins.do_prepare titan-plugins.do_compile
	$(MAKE) -C $(appsdir)/titan/plugins all install DESTDIR=$(targetprefix)
	touch $@

titan-plugins-clean:
	rm -f $(DEPDIR)/titan-plugins
	-$(MAKE) -C $(appsdir)/titan/plugins distclean
	
titan-plugins-distclean:
	rm -f $(DEPDIR)/titan-plugins*
	rm -rf $(appsdir)/titan/plugins	