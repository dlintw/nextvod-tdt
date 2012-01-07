
#
# LIBBOOST
#
$(DEPDIR)/libboost: bootstrap @DEPENDS_libboost@
	@PREPARE_libboost@
	cd @DIR_libboost@ && \
		@INSTALL_libboost@
#	@CLEANUP_libboost@
	touch $@

#
# LIBZ
#
if !STM22
LIBZ_ORDER = binutils-dev
endif !STM22

$(DEPDIR)/libz.do_prepare: bootstrap @DEPENDS_libz@ $(if $(LIBZ_ORDER),| $(LIBZ_ORDER))
	@PREPARE_libz@
	touch $@

$(DEPDIR)/libz.do_compile: $(DEPDIR)/libz.do_prepare
	cd @DIR_libz@ && \
		$(BUILDENV) \
		./configure \
			--prefix=/usr \
			--shared && \
		$(MAKE) all libz.a AR="$(target)-ar rc" CFLAGS="-fpic -O2"
	touch $@

$(DEPDIR)/min-libz $(DEPDIR)/std-libz $(DEPDIR)/max-libz \
$(DEPDIR)/libz: \
$(DEPDIR)/%libz: $(DEPDIR)/libz.do_compile
	cd @DIR_libz@ && \
		@INSTALL_libz@
#	@DISTCLEANUP_libz@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBREADLINE
#
$(DEPDIR)/libreadline.do_prepare: bootstrap @DEPENDS_libreadline@
	@PREPARE_libreadline@
	touch $@

$(DEPDIR)/libreadline.do_compile: ncurses-dev $(DEPDIR)/libreadline.do_prepare
	cd @DIR_libreadline@ && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libreadline $(DEPDIR)/std-libreadline $(DEPDIR)/max-libreadline \
$(DEPDIR)/libreadline: \
$(DEPDIR)/%libreadline: $(DEPDIR)/libreadline.do_compile
	cd @DIR_libreadline@ && \
		@INSTALL_libreadline@
#	@DISTCLEANUP_libreadline@
	@[ "x$*" = "x" ] && touch $@ || true

#
# FREETYPE_OLD
#
$(DEPDIR)/freetype-old.do_prepare: bootstrap @DEPENDS_freetype_old@
	@PREPARE_freetype_old@
	touch $@

$(DEPDIR)/freetype-old.do_compile: $(DEPDIR)/freetype-old.do_prepare
	cd @DIR_freetype_old@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/freetype-old: $(DEPDIR)/freetype-old.do_compile
	cd @DIR_freetype_old@ && \
		@INSTALL_freetype_old@
	cd freetype-2.1.4; \
		$(INSTALL_DIR) $(crossprefix)/bin; \
		cp install_dir/usr/bin/freetype-config $(crossprefix)/bin/freetype-old-config; \
		$(INSTALL_DIR) $(targetprefix)/usr/include/freetype-old; \
		$(CP_RD) install_dir/usr/include/* $(targetprefix)/usr/include/freetype-old/; \
		$(INSTALL_DIR) $(targetprefix)/usr/lib/freetype-old; \
		$(CP_RD) install_dir/usr/lib/libfreetype.{a,so*} $(targetprefix)/usr/lib/freetype-old/; \
		sed 's,-I$${prefix}/include/freetype2,-I$(targetprefix)/usr/include/freetype-old -I$(targetprefix)/usr/include/freetype-old/freetype2,g' -i $(crossprefix)/bin/freetype-old-config; \
		sed 's,/usr/include/freetype2/,$(targetprefix)/usr/include/freetype-old/freetype2/,g' -i $(crossprefix)/bin/freetype-old-config
#	@DISTCLEANUP_freetype_old@
	@[ "x$*" = "x" ] && touch $@ || true

#
# FREETYPE
#
$(DEPDIR)/freetype.do_prepare: bootstrap @DEPENDS_freetype@
	@PREPARE_freetype@
	touch $@

$(DEPDIR)/freetype.do_compile: $(DEPDIR)/freetype.do_prepare
	cd @DIR_freetype@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

define freetype/install/post
	cd @DIR_freetype@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		ln -sf freetype-config $(target)-freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype
endef

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,freetype))

# Evaluate packages
$(eval $(call Package,freetype,libfreetype))
$(eval $(call Package,freetype,libfreetype-dev))

#
# LIRC
#
$(DEPDIR)/lirc.do_prepare: bootstrap @DEPENDS_lirc@
	@PREPARE_lirc@
	touch $@

$(DEPDIR)/lirc.do_compile: $(DEPDIR)/lirc.do_prepare
	cd @DIR_lirc@ && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -Os -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed && \
		$(MAKE) all
	touch $@

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,lirc))

flash-lircd: $(flashprefix)/root/usr/bin/lircd

$(flashprefix)/root/usr/bin/lircd: lirc.do_compile
	( cd @DIR_lirc@ && \
		$(MAKE) install DESTDIR=$(flashprefix)/root ) && \
	touch $@ && \
	@FLASHROOTDIR_MODIFIED@

#
# JPEG
#
$(DEPDIR)/jpeg.do_prepare: bootstrap @DEPENDS_jpeg@
	@PREPARE_jpeg@
	touch $@

$(DEPDIR)/jpeg.do_compile: $(DEPDIR)/jpeg.do_prepare
	cd @DIR_jpeg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--enable-static \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

define jpeg/install/pre
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/bin
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/lib
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/include
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/man/man1
endef

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,jpeg))

# Evaluate packages
$(eval $(call Package,jpeg,libjpeg))
$(eval $(call Package,jpeg,libjpeg-dev))
$(eval $(call Package,jpeg,jpeg-tools))

#
# LIBPNG
#
$(DEPDIR)/libpng.do_prepare: bootstrap @DEPENDS_libpng@
	@PREPARE_libpng@
	touch $@

$(DEPDIR)/libpng.do_compile: libz $(DEPDIR)/libpng.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpng@ && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

define libpng/install/post
	cd @DIR_libpng@ && \
		sed -e "s,^prefix=\",prefix=\"$(targetprefix)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config
endef

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,libpng,libz))

# Evaluate packages
$(eval $(call Package,libpng,libpng))
$(eval $(call Package,libpng,libpng-dev))

#
# LIBUNGIF
#
$(DEPDIR)/libungif.do_prepare: bootstrap @DEPENDS_libungif@
	@PREPARE_libungif@
	touch $@

$(DEPDIR)/libungif.do_compile: $(DEPDIR)/libungif.do_prepare
	cd @DIR_libungif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,libungif))

# Evaluate packages
$(eval $(call Package,libungif,libungif))
$(eval $(call Package,libungif,libungif-utils))
$(eval $(call Package,libungif,libungif-dev))

#
# LIBGIF
#
$(DEPDIR)/libgif.do_prepare: bootstrap @DEPENDS_libgif@
	@PREPARE_libgif@
	touch $@

$(DEPDIR)/libgif.do_compile: $(DEPDIR)/libgif.do_prepare
	cd @DIR_libgif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,libgif))

#
# LIBCURL
#
$(DEPDIR)/curl.do_prepare: @DEPENDS_curl@
	@PREPARE_curl@
	touch $@

$(DEPDIR)/curl.do_compile: bootstrap libz $(DEPDIR)/curl.do_prepare
	cd @DIR_curl@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-random && \
		$(MAKE) all
	touch $@

define curl/install/post
	cd @DIR_curl@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config
endef

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,curl,libz))

# Evaluate packages
$(eval $(call Package,curl,libcurl))
$(eval $(call Package,curl,curl))

#
# LIBFRIBIDI
#
$(DEPDIR)/libfribidi.do_prepare: bootstrap @DEPENDS_libfribidi@
	@PREPARE_libfribidi@
	touch $@

$(DEPDIR)/libfribidi.do_compile: $(DEPDIR)/libfribidi.do_prepare
	cd @DIR_libfribidi@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-memopt && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libfribidi $(DEPDIR)/std-libfribidi $(DEPDIR)/max-libfribidi \
$(DEPDIR)/libfribidi: \
$(DEPDIR)/%libfribidi: $(DEPDIR)/libfribidi.do_compile
	cd @DIR_libfribidi@ && \
		@INSTALL_libfribidi@
#	@DISTCLEANUP_libfribidi@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBSIGC
#
$(DEPDIR)/libsigc.do_prepare: bootstrap @DEPENDS_libsigc@
	@PREPARE_libsigc@
	touch $@

$(DEPDIR)/libsigc.do_compile: libstdc++-dev $(DEPDIR)/libsigc.do_prepare
	cd @DIR_libsigc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libsigc $(DEPDIR)/std-libsigc $(DEPDIR)/max-libsigc \
$(DEPDIR)/libsigc: \
$(DEPDIR)/%libsigc: $(DEPDIR)/libsigc.do_compile
	cd @DIR_libsigc@ && \
		@INSTALL_libsigc@
#	@DISTCLEANUP_libsigc@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBMAD
#
$(DEPDIR)/libmad.do_prepare: bootstrap @DEPENDS_libmad@
	@PREPARE_libmad@
	touch $@

$(DEPDIR)/libmad.do_compile: $(DEPDIR)/libmad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmad@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		autoheader && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libmad $(DEPDIR)/std-libmad $(DEPDIR)/max-libmad \
$(DEPDIR)/libmad: \
$(DEPDIR)/%libmad: $(DEPDIR)/libmad.do_compile
	cd @DIR_libmad@ && \
		@INSTALL_libmad@
#	@DISTCLEANUP_libmad@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBID3TAG
#
$(DEPDIR)/libid3tag.do_prepare: bootstrap @DEPENDS_libid3tag@
	@PREPARE_libid3tag@
	touch $@

$(DEPDIR)/libid3tag.do_compile: libz $(DEPDIR)/libid3tag.do_prepare
	cd @DIR_libid3tag@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared=yes && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libid3tag $(DEPDIR)/std-libid3tag $(DEPDIR)/max-libid3tag \
$(DEPDIR)/libid3tag: \
$(DEPDIR)/%libid3tag: %libz $(DEPDIR)/libid3tag.do_compile
	cd @DIR_libid3tag@ && \
		@INSTALL_libid3tag@
#	@DISTCLEANUP_libid3tag@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBXML2
#
$(DEPDIR)/libxml2.do_prepare: bootstrap @DEPENDS_libxml2@
	@PREPARE_libxml2@
	touch $@

$(DEPDIR)/libxml2.do_compile: libxml2.do_prepare
	cd @DIR_libxml2@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-python=$(crossprefix) \
			--without-c14n \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/min-libxml2 $(DEPDIR)/std-libxml2 $(DEPDIR)/max-libxml2 \
$(DEPDIR)/libxml2: \
$(DEPDIR)/%libxml2: libxml2.do_compile
	cd @DIR_libxml2@ && \
		@INSTALL_libxml2@; \
		[ -f "$(targetprefix)/usr/lib/python2.6/site-packages/libxml2mod.la" ] && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxml2.la,$(targetprefix)/usr/lib/libxml2.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxml2mod.la; \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config; \
		chmod 755 $(crossprefix)/bin/xml2-config; \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xml2Conf.sh; \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xml2Conf.sh
	@[ "x$*" = "x" ] && touch $@ || true

flash-libxml2-enigma2: $(flashprefix)/root-enigma2/usr/lib/libxml2mod.so

$(flashprefix)/root-enigma2/usr/lib/libxml2mod.so: \
%/usr/lib/libxml2mod.so: libxml2.do_compile
	( cd @DIR_libxml2@ && \
		$(MAKE) install DESTDIR=$* ) && \
	rm $*/usr/bin/{xml2-config,xmlcatalog,xmllint} && \
	rm $*/usr/lib/python2.6/site-packages/libxml2mod.a && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@


#
# LIBXSLT
#
$(DEPDIR)/libxslt.do_prepare: @DEPENDS_libxslt@
	@PREPARE_libxslt@
	touch $@

$(DEPDIR)/libxslt.do_compile: bootstrap libxml2 libxslt.do_prepare
	cd @DIR_libxslt@ && \
		$(BUILDENV) \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2 -Os" \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libxml-prefix="$(crossprefix)" \
			--with-libxml-include-prefix="$(targetprefix)/usr/include" \
			--with-libxml-libs-prefix="$(targetprefix)/usr/lib" \
			--with-python=$(crossprefix) \
			--without-crypto \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libxslt $(DEPDIR)/std-libxslt $(DEPDIR)/max-libxslt \
$(DEPDIR)/libxslt: \
$(DEPDIR)/%libxslt: %libxml2 libxslt.do_compile
	cd @DIR_libxslt@ && \
		@INSTALL_libxslt@ && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxsltmod.la && \
		sed -e "/^dependency_libs/ s,/usr/lib/libexslt.la,$(targetprefix)/usr/lib/libexslt.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxsltmod.la && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/libexslt.la && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xsltConf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xsltConf.sh
	@[ "x$*" = "x" ] && touch $@ || true

flash-libxslt-enigma2: $(flashprefix)/root-enigma2/usr/lib/libxsltmod.so

$(flashprefix)/root-enigma2/usr/lib/libxsltmod.so: \
%/usr/lib/libxsltmod.so: libxslt.do_compile
	( cd @DIR_libxslt@ && \
		$(MAKE) install DESTDIR=$* ) && \
	rm $*/usr/bin/{xslt-config,xsltproc} && \
	rm $*/usr/lib/python2.6/site-packages/libxsltmod.a && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# LIBVORBISIDEC
#

$(DEPDIR)/libvorbisidec.do_prepare: @DEPENDS_libvorbisidec@
	@PREPARE_libvorbisidec@
	touch $@

$(DEPDIR)/libvorbisidec.do_compile: bootstrap $(DEPDIR)/libvorbisidec.do_prepare
	cd @DIR_libvorbisidec@ && \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libvorbisidec: $(DEPDIR)/libvorbisidec.do_compile
	cd @DIR_libvorbisidec@ && \
		@INSTALL_libvorbisidec@
#	@DISTCLEANUP_libvorbisidec@
	@[ "x$*" = "x" ] && touch $@ || true

#
# GLIB2
# You need libglib2.0-dev on host system
#
$(DEPDIR)/glib2.do_prepare: @DEPENDS_glib2@
	@PREPARE_glib2@
	touch $@

$(DEPDIR)/glib2.do_compile: bootstrap libz $(DEPDIR)/glib2.do_prepare
	echo "glib_cv_va_copy=no" > @DIR_glib2@/config.cache
	echo "glib_cv___va_copy=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_va_val_copy=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_stack_grows=no" >> @DIR_glib2@/config.cache
	echo "glib_cv_uscore=no" >> @DIR_glib2@/config.cache
	cd @DIR_glib2@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		LDFLAGS="$(TARGET_LDFLAGS) -L\$(targetprefix)/usr/lib" \
		./configure \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-glib2 $(DEPDIR)/std-glib2 $(DEPDIR)/max-glib2 \
$(DEPDIR)/glib2: \
$(DEPDIR)/%glib2: $(DEPDIR)/glib2.do_compile
	cd @DIR_glib2@ && \
		@INSTALL_glib2@
#	@DISTCLEANUP_glib2@
	@[ "x$*" = "x" ] && touch $@ || true

# Evaluate package glib2
# call MacroName,Source Package,Package
$(eval $(call Package,glib2,libglib2))

#
# LIBICONV
#
$(DEPDIR)/libiconv.do_prepare: bootstrap @DEPENDS_libiconv@
	@PREPARE_libiconv@
	touch $@

$(DEPDIR)/libiconv.do_compile: $(DEPDIR)/libiconv.do_prepare
	cd @DIR_libiconv@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-libiconv $(DEPDIR)/std-libiconv $(DEPDIR)/max-libiconv $(DEPDIR)/ipk-libiconv \
$(DEPDIR)/libiconv: \
$(DEPDIR)/%libiconv: $(DEPDIR)/libiconv.do_compile
	cd @DIR_libiconv@ && \
		@INSTALL_libiconv@
#	@DISTCLEANUP_libiconv@
	@[ "x$*" = "x" ] && touch $@ || true

#
# LIBMNG
#
$(DEPDIR)/libmng.do_prepare: @DEPENDS_libmng@
	@PREPARE_libmng@
	touch $@

$(DEPDIR)/libmng.do_compile: bootstrap libz jpeg lcms libmng.do_prepare
	cd @DIR_libmng@ && \
		cat unmaintained/autogen.sh | tr -d \\r > autogen.sh && chmod 755 autogen.sh && \
		[ ! -x ./configure ] && ./autogen.sh --help || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static \
			--with-zlib \
			--with-jpeg \
			--with-gnu-ld \
			--with-lcms && \
		$(MAKE)
	touch $@

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,libmng))

#
# LCMS
#
$(DEPDIR)/lcms.do_prepare: @DEPENDS_lcms@
	@PREPARE_lcms@
	touch $@

$(DEPDIR)/lcms.do_compile: bootstrap libz jpeg lcms.do_prepare
	cd @DIR_lcms@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static && \
		$(MAKE)
	touch $@

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,lcms))

#
# DirectFB
#
$(DEPDIR)/directfb.do_prepare: @DEPENDS_directfb@
	@PREPARE_directfb@
	touch $@

$(DEPDIR)/directfb.do_compile: bootstrap freetype directfb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_directfb@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--disable-sdl \
			--disable-x11 \
			--disable-devmem \
			--disable-multi \
			--with-gfxdrivers=stgfx \
			--with-inputdrivers=linuxinput \
			--without-software \
			--enable-stmfbdev \
			--disable-fbdev \
			--enable-mme=yes && \
			export top_builddir=`pwd` && \
		$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/directfb: directfb.do_compile
	cd @DIR_directfb@ && \
		@INSTALL_directfb@
	touch $@

#
# DFB++
#
$(DEPDIR)/dfbpp.do_prepare: @DEPENDS_dfbpp@
	@PREPARE_dfbpp@
	touch $@

$(DEPDIR)/dfbpp.do_compile: bootstrap libz jpeg directfb dfbpp.do_prepare
	cd @DIR_dfbpp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
			export top_builddir=`pwd` && \
		$(MAKE) all
	touch $@
#		$(BUILDENV) PKG_CONFIG=$(hostprefix)/bin/pkg-config \
#

$(DEPDIR)/dfbpp: dfbpp.do_compile
	cd @DIR_dfbpp@ && \
		@INSTALL_dfbpp@
#	sed -e "s, /usr/lib, $(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libdfb++.la
	touch $@

#
# EXPAT
#
$(DEPDIR)/expat.do_prepare: @DEPENDS_expat@
	@PREPARE_expat@
	touch $@

$(DEPDIR)/expat.do_compile: bootstrap expat.do_prepare
	cd @DIR_expat@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/expat: expat.do_compile
	cd @DIR_expat@ && \
		@INSTALL_expat@
	touch $@

#
# FONTCONFIG
#
$(DEPDIR)/fontconfig.do_prepare: @DEPENDS_fontconfig@
	@PREPARE_fontconfig@
	touch $@

$(DEPDIR)/fontconfig.do_compile: bootstrap libz fontconfig.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_fontconfig@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(crossprefix)/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts && \
		$(MAKE)
	touch $@

$(DEPDIR)/fontconfig: fontconfig.do_compile
	cd @DIR_fontconfig@ && \
		@INSTALL_fontconfig@
	touch $@

#
# Python
#
$(DEPDIR)/python.do_prepare: host-python @DEPENDS_python@
	@PREPARE_python@ && \
	touch $@

$(DEPDIR)/python.do_compile: openssl openssl-dev sqlite bootstrap python.do_prepare
	( cd @DIR_python@ && \
		CONFIG_SITE= \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--disable-ipv6 \
			--without-cxx-main \
			--with-threads \
			HOSTPYTHON=$(crossprefix)/bin/python \
			OPT="$(TARGET_CFLAGS)" && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			PYTHON_DISABLE_MODULES="_tkinter" \
			PYTHON_MODULES_INCLUDE="$(prefix)/$*cdkroot/usr/include" \
			PYTHON_MODULES_LIB="$(prefix)/$*cdkroot/usr/lib" \
			CROSS_COMPILE=yes \
			CFLAGS="$(TARGET_CFLAGS) -fno-inline" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			all ) && \
	touch $@

$(DEPDIR)/min-python $(DEPDIR)/std-python $(DEPDIR)/max-python \
$(DEPDIR)/python: \
$(DEPDIR)/%python: python.do_compile
	( cd @DIR_python@ && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			install DESTDIR=$(prefix)/$*cdkroot ) && \
	$(LN_SF) ../../libpython2.6.so.1.0 $(prefix)/$*cdkroot/usr/lib/python2.6/config/libpython2.6.so && \
	[ "x$*" = "x" ] && touch $@ || true

flash-python-enigma2: $(flashprefix)/root-enigma2/usr/bin/python

$(flashprefix)/root-enigma2/usr/bin/python: \
%/usr/bin/python: python.do_compile
	( cd @DIR_python@ && \
		$(MAKE) $(MAKE_ARGS) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			install DESTDIR=$* ) && \
	rm $*/usr/bin/{python,idle,pydoc,python2.6-config,python-config,smtpd.py} && \
	$(LN_SF) python2.6 $@ && \
	chmod 755 $*/usr/lib/libpython2.6.so.1.0 && \
	rm -rf $*/usr/lib/python2.6/config/ && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# ELEMENTTREE
#
$(DEPDIR)/elementtree.do_prepare: @DEPENDS_elementtree@
	@PREPARE_elementtree@
	touch $@

$(DEPDIR)/elementtree.do_compile: bootstrap elementtree.do_prepare
	touch $@

$(DEPDIR)/min-elementtree $(DEPDIR)/std-elementtree $(DEPDIR)/max-elementtree \
$(DEPDIR)/elementtree: \
$(DEPDIR)/%elementtree: %python elementtree.do_compile
	cd @DIR_elementtree@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONHOME=$(targetprefix)/usr \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true
#		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
#

flash-elementtree-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/elementtree

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/elementtree: \
%/usr/lib/python2.6/site-packages/elementtree: elementtree.do_compile
	( cd @DIR_elementtree@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# LXML
#
$(DEPDIR)/lxml.do_prepare: @DEPENDS_lxml@
	@PREPARE_lxml@
	touch $@

$(DEPDIR)/lxml.do_compile: bootstrap python lxml.do_prepare
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/min-lxml $(DEPDIR)/std-lxml $(DEPDIR)/max-lxml \
$(DEPDIR)/lxml: \
$(DEPDIR)/%lxml: lxml.do_compile
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

flash-lxml-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/lxml

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/lxml: \
%/usr/lib/python2.6/site-packages/lxml: lxml.do_compile
	( cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@


#
# LIBXMLCCWRAP
#
$(DEPDIR)/libxmlccwrap.do_prepare: @DEPENDS_libxmlccwrap@
	@PREPARE_libxmlccwrap@
	touch $@

$(DEPDIR)/libxmlccwrap.do_compile: bootstrap libxmlccwrap.do_prepare
	cd @DIR_libxmlccwrap@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libxmlccwrap $(DEPDIR)/std-libxmlccwrap $(DEPDIR)/max-libxmlccwrap \
$(DEPDIR)/libxmlccwrap: \
$(DEPDIR)/%libxmlccwrap: libxmlccwrap.do_compile
	cd @DIR_libxmlccwrap@ && \
		@INSTALL_libxmlccwrap@ && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la
	[ "x$*" = "x" ] && touch $@ || true

flash-libxmlccwrap-enigma2: $(flashprefix)/root-enigma2/usr/lib/libxmlccwrap.so

$(flashprefix)/root-enigma2/usr/lib/libxmlccwrap.so: \
%/usr/lib/libxmlccwrap.so: libxmlccwrap.do_compile
	( cd @DIR_libxmlccwrap@ && \
		$(MAKE) install DESTDIR=$* ) && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# SETUPTOOLS
#
$(DEPDIR)/setuptools.do_prepare: @DEPENDS_setuptools@
	@PREPARE_setuptools@
	touch $@

$(DEPDIR)/setuptools.do_compile: bootstrap setuptools.do_prepare
	cd @DIR_setuptools@ && \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-setuptools $(DEPDIR)/std-setuptools $(DEPDIR)/max-setuptools \
$(DEPDIR)/setuptools: \
$(DEPDIR)/%setuptools: setuptools.do_compile
	cd @DIR_setuptools@ && \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

#
# ZOPE INTERFACE
#
$(DEPDIR)/zope-interface.do_prepare: @DEPENDS_zope_interface@
	@PREPARE_zope_interface@
	touch $@

$(DEPDIR)/zope-interface.do_compile: bootstrap setuptools zope-interface.do_prepare
	cd @DIR_zope_interface@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-zope-interface $(DEPDIR)/std-zope-interface $(DEPDIR)/max-zope-interface \
$(DEPDIR)/zope-interface: \
$(DEPDIR)/%zope-interface: zope-interface.do_compile
	cd @DIR_zope_interface@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

flash-zope-interface-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/zope/interface

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/zope/interface: \
%/usr/lib/python2.6/site-packages/zope/interface: zope-interface.do_compile
	( cd @DIR_zope_interface@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# TWISTED
#
$(DEPDIR)/twisted.do_prepare: @DEPENDS_twisted@
	@PREPARE_twisted@
	touch $@

$(DEPDIR)/twisted.do_compile: bootstrap setuptools twisted.do_prepare
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/min-twisted $(DEPDIR)/std-twisted $(DEPDIR)/max-twisted \
$(DEPDIR)/twisted: \
$(DEPDIR)/%twisted: twisted.do_prepare
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

flash-twisted-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/twisted

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/twisted: \
%/usr/lib/python2.6/site-packages/twisted: twisted.do_compile
	( cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	rm $*/usr/bin/{tap2deb,tapconvert,manhole,tap2rpm,t-im,pyhtmlizer,trial,mktap,twistd,bookify,lore,mailmail,ckeygen,tkconch,conch,cftp,im} && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# TWISTEDWEB2
#
$(DEPDIR)/twistedweb2.do_prepare: @DEPENDS_twistedweb2@
	@PREPARE_twistedweb2@
	touch $@

$(DEPDIR)/twistedweb2.do_compile: bootstrap setuptools twistedweb2.do_prepare
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/min-twistedweb2 $(DEPDIR)/std-twistedweb2 $(DEPDIR)/max-twistedweb2 \
$(DEPDIR)/twistedweb2: \
$(DEPDIR)/%twistedweb2: twistedweb2.do_prepare
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

flash-twistedweb2-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/twisted/web2

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/twisted/web2: \
%/usr/lib/python2.6/site-packages/twisted/web2: twisted.do_compile
	( cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# A52DEC
#
$(DEPDIR)/a52dec.do_prepare: @DEPENDS_a52dec@
	@PREPARE_a52dec@
	touch $@

$(DEPDIR)/a52dec.do_compile: bootstrap a52dec.do_prepare
	cd @DIR_a52dec@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix)/usr && \
		$(MAKE) install
	touch $@

$(DEPDIR)/a52dec: a52dec.do_compile
	cd @DIR_a52dec@ && \
		@INSTALL_a52dec@
	touch $@

#
# LIBDVDCSS
#
$(DEPDIR)/libdvdcss.do_prepare: @DEPENDS_libdvdcss@
	@PREPARE_libdvdcss@
	touch $@

$(DEPDIR)/libdvdcss.do_compile: bootstrap libdvdcss.do_prepare
	cd @DIR_libdvdcss@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdcss: libdvdcss.do_compile
	cd @DIR_libdvdcss@ && \
		@INSTALL_libdvdcss@
	touch $@

#
# LIBDVDNAV
#
$(DEPDIR)/libdvdnav.do_prepare: @DEPENDS_libdvdnav@
	@PREPARE_libdvdnav@
	touch $@

$(DEPDIR)/libdvdnav.do_compile: bootstrap libdvdread libdvdnav.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdnav@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			--with-dvdread-config=$(targetprefix)/usr/bin/dvdread-config && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdnav: libdvdnav.do_compile
	cd @DIR_libdvdnav@ && \
		@INSTALL_libdvdnav@
	touch $@

#
# LIBDVDREAD
#
$(DEPDIR)/libdvdread.do_prepare: @DEPENDS_libdvdread@
	@PREPARE_libdvdread@
	touch $@

$(DEPDIR)/libdvdread.do_compile: bootstrap libdvdread.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdread@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf -f -i -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-static \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE) all
	echo '#!/bin/sh' > $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	echo 'prefix='$(targetprefix)/usr >> $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	echo 'libdir='$(targetprefix)/usr/lib >> $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	echo >> $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	cat $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config.sh >> $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	chmod 0755 $(buildprefix)/libdvdread-4.1.3/misc/dvdread-config
	touch $@

$(DEPDIR)/libdvdread: libdvdread.do_compile
	cd @DIR_libdvdread@ && \
		@INSTALL_libdvdread@
	sed 's!/usr/lib!$(targetprefix)/usr/lib!g' $(targetprefix)/usr/lib/libdvdread.la > $(targetprefix)/usr/lib/libdvdread.la1
	cp $(targetprefix)/usr/lib/libdvdread.la1 $(targetprefix)/usr/lib/libdvdread.la
	rm $(targetprefix)/usr/lib/libdvdread.la1
	touch $@

#
# PYOPENSSL
#
$(DEPDIR)/pyopenssl.do_prepare: @DEPENDS_pyopenssl@
	@PREPARE_pyopenssl@
	touch $@

$(DEPDIR)/pyopenssl.do_compile: bootstrap setuptools pyopenssl.do_prepare
	cd @DIR_pyopenssl@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-pyopenssl $(DEPDIR)/std-pyopenssl $(DEPDIR)/max-pyopenssl \
$(DEPDIR)/pyopenssl: \
$(DEPDIR)/%pyopenssl: pyopenssl.do_compile
	cd @DIR_pyopenssl@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	[ "x$*" = "x" ] && touch $@ || true

flash-pyopenssl-enigma2: $(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/OpenSSL

$(flashprefix)/root-enigma2/usr/lib/python2.6/site-packages/OpenSSL: \
%/usr/lib/python2.6/site-packages/OpenSSL: pyopenssl.do_compile
	( cd @DIR_pyopenssl@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$*/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$* --prefix=/usr ) && \
	rm $*/usr/lib/python2.6/site-packages/OpenSSL/test && \
	touch $@ && \
	@TUXBOX_CUSTOMIZE@

#
# ffmpeg
#
$(DEPDIR)/ffmpeg.do_prepare: bootstrap libass @DEPENDS_ffmpeg@
	@PREPARE_ffmpeg@
	cd @DIR_ffmpeg@ && \
	patch -p1 < ../Patches/ffmpeg.patch;
	touch $@

#$(DEPDIR)/ffmpeg.do_compile: $(DEPDIR)/ffmpeg.do_prepare
#	export PATH=$(hostprefix)/bin:$(PATH) && \
#	cd @DIR_ffmpeg@ && \
#	$(BUILDENV) \
#	./configure \
#		--enable-parsers --disable-decoders --disable-encoders --enable-demuxers \
#		--disable-muxers --disable-ffplay --disable-ffmpeg --disable-ffserver \
#		--disable-devices \
#		--disable-protocols --enable-protocol=file --enable-bsfs \
#		--disable-mpegaudio-hp --disable-zlib --enable-bzlib \
#		--disable-static --enable-shared \
#		--enable-cross-compile \
#		--cross-prefix=$(target)- \
#		--target-os=linux \
#		--arch=sh4 \
#		--extra-cflags=-fno-strict-aliasing \
#		--enable-stripping \
#		--prefix=/usr
#	touch $@

$(DEPDIR)/ffmpeg.do_compile: bootstrap libass $(DEPDIR)/ffmpeg.do_prepare
	cd @DIR_ffmpeg@ && \
	$(BUILDENV) \
	./configure \
		--disable-static --enable-shared \
		--enable-cross-compile \
		--disable-ffserver \
		--disable-altivec \
		--disable-debug \
		--disable-asm \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmx2 \
		--disable-sse \
		--disable-ssse3 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-armvfp \
		--disable-iwmmxt \
		--disable-mmi \
		--disable-neon \
		--disable-vis \
		--disable-yasm \
		--disable-indevs \
		--disable-outdevs \
		--disable-muxers \
		--enable-muxer=ogg \
		--enable-muxer=flac \
		--enable-muxer=aac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=mpeg1video \
		--enable-muxer=image2 \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=mp3 \
		--enable-encoder=theora \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=png \
		--enable-encoder=mpeg1video \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=mp3 \
		--enable-decoder=theora \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h264 \
		--enable-decoder=mpeg2video \
		--enable-decoder=png \
		--enable-decoder=ljpeg \
		--enable-decoder=mjpeg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		--enable-small \
		--enable-decoder=dvbsub \
		--enable-decoder=iff_byterun1 \
		--enable-pthreads \
		--enable-bzlib \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--extra-cflags=-fno-strict-aliasing \
		--enable-stripping \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-ffmpeg $(DEPDIR)/std-ffmpeg $(DEPDIR)/max-ffmpeg \
$(DEPDIR)/ffmpeg: \
$(DEPDIR)/%ffmpeg: $(DEPDIR)/ffmpeg.do_compile
	cd @DIR_ffmpeg@ && \
		@INSTALL_ffmpeg@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@


#
# libass
#
$(DEPDIR)/libass.do_prepare: bootstrap freetype @DEPENDS_libass@
	@PREPARE_libass@
	touch $@

$(DEPDIR)/libass.do_compile: $(DEPDIR)/libass.do_prepare
	cd @DIR_libass@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
                --host=$(target) \
                --disable-fontconfig \
		        --prefix=/usr
	touch $@

$(DEPDIR)/min-libass $(DEPDIR)/std-libass $(DEPDIR)/max-libass \
$(DEPDIR)/libass: \
$(DEPDIR)/%libass: $(DEPDIR)/libass.do_compile
	cd @DIR_libass@ && \
		@INSTALL_libass@
	echo "libdir='$(targetprefix)/usr/lib'" >> $(targetprefix)/usr/lib/libass.la
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@


#
# WebKitDFB
#
$(DEPDIR)/webkitdfb.do_prepare: bootstrap glib2 icu4c libxml2 enchant lite curl fontconfig sqlite libsoup cairo jpeg @DEPENDS_webkitdfb@
	@PREPARE_webkitdfb@
	touch $@


#
$(DEPDIR)/webkitdfb.do_compile: $(DEPDIR)/webkitdfb.do_prepare
	export PATH=$(BUILDPREFIX)/@DIR_icu4c@/host/config:$(PATH) && \
	cd @DIR_webkitdfb@ && \
	$(BUILDENV) \
	./autogen.sh --with-target=directfb --without-gtkplus \
		--host=$(target) \
		--prefix=/usr \
		--with-cairo-directfb \
		--disable-shared-workers \
		--enable-optimizations	\
		--disable-channel-messaging	\
		--disable-javascript-debugger	\
		--enable-offline-web-applications	\
		--enable-dom-storage	\
		--enable-database	\
		--disable-eventsource	\
		--enable-icon-database	\
		--enable-datalist	\
		--disable-video	\
		--enable-svg	\
		--enable-xpath	\
		--disable-xslt	\
		--disable-dashboard-support \
		--disable-geolocation \
		--disable-workers	\
		--disable-web-sockets	\
		--with-networking-backend=soup
	touch $@

$(DEPDIR)/min-webkitdfb $(DEPDIR)/std-webkitdfb $(DEPDIR)/max-webkitdfb \
$(DEPDIR)/webkitdfb: \
$(DEPDIR)/%webkitdfb: $(DEPDIR)/webkitdfb.do_compile
	cd @DIR_webkitdfb@ && \
		@INSTALL_webkitdfb@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@


$(DEPDIR)/icu4c.do_prepare: bootstrap @DEPENDS_icu4c@
	@PREPARE_icu4c@
	cd @DIR_icu4c@ && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < ../../Patches/icu4c-4_4_1_locales.patch;
	touch $@

$(DEPDIR)/icu4c.do_compile: $(DEPDIR)/icu4c.do_prepare
	echo "Building host icu"
	mkdir -p @DIR_icu4c@/host && \
	cd @DIR_icu4c@/host && \
	sh ../configure --disable-samples --disable-tests && \
	unset TARGET && \
	make
	echo "Building cross icu"
	cd @DIR_icu4c@ && \
	$(BUILDENV) \
	./configure \
		--with-cross-build=$(BUILDPREFIX)/@DIR_icu4c@/host \
		--host=$(target) \
		--prefix=/usr \
		--disable-extras \
		--disable-layout \
		--disable-tests \
		--disable-samples
	touch $@

$(DEPDIR)/min-icu4c $(DEPDIR)/std-icu4c $(DEPDIR)/max-icu4c \
$(DEPDIR)/icu4c: \
$(DEPDIR)/%icu4c: $(DEPDIR)/icu4c.do_compile
	cd @DIR_icu4c@ && \
	   unset TARGET && \
		@INSTALL_icu4c@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
	
$(DEPDIR)/enchant.do_prepare: bootstrap @DEPENDS_enchant@
	@PREPARE_enchant@
	touch $@

#	libtoolize -f -c && \
#	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal

$(DEPDIR)/enchant.do_compile: $(DEPDIR)/enchant.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_enchant@ && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV)  \
	./configure --disable-aspell --disable-ispell --disable-myspell --disable-zemberek \
	--host=$(target) \
	--prefix=/usr && \
	$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/min-enchant $(DEPDIR)/std-enchant $(DEPDIR)/max-enchant \
$(DEPDIR)/enchant: \
$(DEPDIR)/%enchant: $(DEPDIR)/enchant.do_compile
	cd @DIR_enchant@ && \
		@INSTALL_enchant@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# lite
#
$(DEPDIR)/lite.do_prepare: bootstrap directfb @DEPENDS_lite@
	@PREPARE_lite@
	touch $@

$(DEPDIR)/lite.do_compile: $(DEPDIR)/lite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lite@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
      --disable-debug
	touch $@

$(DEPDIR)/min-lite $(DEPDIR)/std-lite $(DEPDIR)/max-lite \
$(DEPDIR)/lite: \
$(DEPDIR)/%lite: $(DEPDIR)/lite.do_compile
	cd @DIR_lite@ && \
		@INSTALL_lite@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# sqlite
#
$(DEPDIR)/sqlite.do_prepare: bootstrap @DEPENDS_sqlite@
	@PREPARE_sqlite@
	touch $@

$(DEPDIR)/sqlite.do_compile: $(DEPDIR)/sqlite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sqlite@ && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-tcl \
		--disable-debug
	touch $@

$(DEPDIR)/min-sqlite $(DEPDIR)/std-sqlite $(DEPDIR)/max-sqlite \
$(DEPDIR)/sqlite: \
$(DEPDIR)/%sqlite: $(DEPDIR)/sqlite.do_compile
	cd @DIR_sqlite@ && \
		@INSTALL_sqlite@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
	
#
# libsoup
#
$(DEPDIR)/libsoup.do_prepare: bootstrap @DEPENDS_libsoup@
	@PREPARE_libsoup@
	touch $@

$(DEPDIR)/libsoup.do_compile: $(DEPDIR)/libsoup.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsoup@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-more-warnings \
		--without-gnome
	touch $@

$(DEPDIR)/min-libsoup $(DEPDIR)/std-libsoup $(DEPDIR)/max-libsoup \
$(DEPDIR)/libsoup: \
$(DEPDIR)/%libsoup: $(DEPDIR)/libsoup.do_compile
	cd @DIR_libsoup@ && \
		@INSTALL_libsoup@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# pixman
#
$(DEPDIR)/pixman.do_prepare: bootstrap @DEPENDS_pixman@
	@PREPARE_pixman@
	touch $@

$(DEPDIR)/pixman.do_compile: $(DEPDIR)/pixman.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_pixman@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-pixman $(DEPDIR)/std-pixman $(DEPDIR)/max-pixman \
$(DEPDIR)/pixman: \
$(DEPDIR)/%pixman: $(DEPDIR)/pixman.do_compile
	cd @DIR_pixman@ && \
		@INSTALL_pixman@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# cairo
#
$(DEPDIR)/cairo.do_prepare: bootstrap libpng pixman @DEPENDS_cairo@
	@PREPARE_cairo@
	touch $@

$(DEPDIR)/cairo.do_compile: $(DEPDIR)/cairo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_cairo@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-gtk-doc \
		--enable-ft=yes \
		--enable-png=yes \
		--enable-ps=no \
		--enable-pdf=no \
		--enable-svg=no \
		--disable-glitz \
		--disable-xcb \
		--disable-xlib \
		--enable-directfb \
		--program-suffix=-directfb
	touch $@

$(DEPDIR)/min-cairo $(DEPDIR)/std-cairo $(DEPDIR)/max-cairo \
$(DEPDIR)/cairo: \
$(DEPDIR)/%cairo: $(DEPDIR)/cairo.do_compile
	cd @DIR_cairo@ && \
		@INSTALL_cairo@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# libogg
$(DEPDIR)/libogg.do_prepare: bootstrap  @DEPENDS_libogg@
	@PREPARE_libogg@
	touch $@

$(DEPDIR)/libogg.do_compile: $(DEPDIR)/libogg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libogg@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-libogg $(DEPDIR)/std-libogg $(DEPDIR)/max-libogg \
$(DEPDIR)/libogg: \
$(DEPDIR)/%libogg: $(DEPDIR)/libogg.do_compile
	cd @DIR_libogg@ && \
		@INSTALL_libogg@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# libflac
$(DEPDIR)/libflac.do_prepare: bootstrap  @DEPENDS_libflac@
	@PREPARE_libflac@
	touch $@

$(DEPDIR)/libflac.do_compile: $(DEPDIR)/libflac.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libflac@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-ogg \
		--disable-oggtest \
		--disable-id3libtest \
		--disable-asm-optimizations \
		--disable-doxygen-docs \
		--disable-xmms-plugin \
		--without-xmms-prefix \
		--without-xmms-exec-prefix \
		--without-libiconv-prefix \
		--without-id3lib \
		--with-ogg-includes=. \
		--disable-cpplibs
	touch $@

$(DEPDIR)/min-libflac $(DEPDIR)/std-libflac $(DEPDIR)/max-libflac \
$(DEPDIR)/libflac: \
$(DEPDIR)/%libflac: $(DEPDIR)/libflac.do_compile
	cd @DIR_libflac@ && \
		@INSTALL_libflac@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
#
# GSTREAMER + PLUGINS
# This will become the "libeplayer4"
#

# GSTREAMER
$(DEPDIR)/gstreamer.do_prepare: bootstrap glib2 libxml2 @DEPENDS_gstreamer@
	@PREPARE_gstreamer@
	touch $@

$(DEPDIR)/gstreamer.do_compile: $(DEPDIR)/gstreamer.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gstreamer@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-gstreamer $(DEPDIR)/std-gstreamer $(DEPDIR)/max-gstreamer \
$(DEPDIR)/gstreamer: \
$(DEPDIR)/%gstreamer: $(DEPDIR)/gstreamer.do_compile
	cd @DIR_gstreamer@ && \
		@INSTALL_gstreamer@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-PLUGINS-BASE
$(DEPDIR)/gst_plugins_base.do_prepare: bootstrap glib2 gstreamer libogg libalsa @DEPENDS_gst_plugins_base@
	@PREPARE_gst_plugins_base@
	touch $@

$(DEPDIR)/gst_plugins_base.do_compile: $(DEPDIR)/gst_plugins_base.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_base@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-theora --disable-pango --disable-vorbis --disable-x
	touch $@

$(DEPDIR)/min-gst_plugins_base $(DEPDIR)/std-gst_plugins_base $(DEPDIR)/max-gst_plugins_base \
$(DEPDIR)/gst_plugins_base: \
$(DEPDIR)/%gst_plugins_base: $(DEPDIR)/gst_plugins_base.do_compile
	cd @DIR_gst_plugins_base@ && \
		@INSTALL_gst_plugins_base@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-PLUGINS-GOOD
$(DEPDIR)/gst_plugins_good.do_prepare: bootstrap gstreamer gst_plugins_base libsoup libflac @DEPENDS_gst_plugins_good@
	@PREPARE_gst_plugins_good@
	touch $@

$(DEPDIR)/gst_plugins_good.do_compile: $(DEPDIR)/gst_plugins_good.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_good@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-esd --disable-esdtest \
		--disable-shout2 --disable-shout2test --disable-x
	touch $@

$(DEPDIR)/min-gst_plugins_good $(DEPDIR)/std-gst_plugins_good $(DEPDIR)/max-gst_plugins_good \
$(DEPDIR)/gst_plugins_good: \
$(DEPDIR)/%gst_plugins_good: $(DEPDIR)/gst_plugins_good.do_compile
	cd @DIR_gst_plugins_good@ && \
		@INSTALL_gst_plugins_good@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-PLUGINS-BAD
$(DEPDIR)/gst_plugins_bad.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_bad@
	@PREPARE_gst_plugins_bad@
	touch $@

$(DEPDIR)/gst_plugins_bad.do_compile: $(DEPDIR)/gst_plugins_bad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_bad@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-gst_plugins_bad $(DEPDIR)/std-gst_plugins_bad $(DEPDIR)/max-gst_plugins_bad \
$(DEPDIR)/gst_plugins_bad: \
$(DEPDIR)/%gst_plugins_bad: $(DEPDIR)/gst_plugins_bad.do_compile
	cd @DIR_gst_plugins_bad@ && \
		@INSTALL_gst_plugins_bad@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-PLUGINS-UGLY
$(DEPDIR)/gst_plugins_ugly.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_ugly@
	@PREPARE_gst_plugins_ugly@
	touch $@

$(DEPDIR)/gst_plugins_ugly.do_compile: $(DEPDIR)/gst_plugins_ugly.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_ugly@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-gst_plugins_ugly $(DEPDIR)/std-gst_plugins_ugly $(DEPDIR)/max-gst_plugins_ugly \
$(DEPDIR)/gst_plugins_ugly: \
$(DEPDIR)/%gst_plugins_ugly: $(DEPDIR)/gst_plugins_ugly.do_compile
	cd @DIR_gst_plugins_ugly@ && \
		@INSTALL_gst_plugins_ugly@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-FFMPEG
$(DEPDIR)/gst_ffmpeg.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_ffmpeg@
	@PREPARE_gst_ffmpeg@
	touch $@

#configuring included Libav instance with args --prefix=/usr --disable-ffserver --disable-ffplay        --disable-ffmpeg --disable-ffprobe --enable-postproc --enable-gpl --enable-static --enable-pic 	--disable-encoder=flac --disable-decoder=cavs --disable-protocols --disable-devices	--disable-network --disable-hwaccels --disable-filters --disable-doc	--enable-optimizations --enable-cross-compile         --target-os=linux --arch=sh4 --cross-prefix=sh4-linux-
$(DEPDIR)/gst_ffmpeg.do_compile: $(DEPDIR)/gst_ffmpeg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_ffmpeg@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		\
		--with-ffmpeg-extra-configure=" \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffmpeg \
		--disable-ffprobe \
		--enable-postproc \
		--enable-gpl \
		--enable-static \
		--enable-pic \
		--disable-protocols \
		--disable-devices \
		--disable-network \
		--disable-hwaccels \
		--disable-filters \
		--disable-doc \
		--enable-optimizations \
		--enable-cross-compile \
		--target-os=linux \
		--arch=sh4 \
		--cross-prefix=$(target)- \
		\
		--disable-muxers \
		--disable-encoders \
		--disable-decoders \
		--enable-decoder=ogg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		\
		--disable-demuxers \
		--enable-demuxer=ogg \
		--enable-demuxer=vorbis \
		--enable-demuxer=flac \
		\
		--disable-parsers \
		--enable-parser=ogg \
		--enable-parser=vorbis \
		--enable-parser=flac \
		\
		--disable-bsfs \
		--enable-small \
		--enable-pthreads \
		--enable-bzlib"
	touch $@

$(DEPDIR)/min-gst_ffmpeg $(DEPDIR)/std-gst_ffmpeg $(DEPDIR)/max-gst_ffmpeg \
$(DEPDIR)/gst_ffmpeg: \
$(DEPDIR)/%gst_ffmpeg: $(DEPDIR)/gst_ffmpeg.do_compile
	cd @DIR_gst_ffmpeg@ && \
		@INSTALL_gst_ffmpeg@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

# GST-PLUGINS-DVBMEDIASINK
$(DEPDIR)/gst_plugins_dvbmediasink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly @DEPENDS_gst_plugins_dvbmediasink@
	@PREPARE_gst_plugins_dvbmediasink@
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink.do_compile: $(DEPDIR)/gst_plugins_dvbmediasink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_dvbmediasink@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-gst_plugins_dvbmediasink $(DEPDIR)/std-gst_plugins_dvbmediasink $(DEPDIR)/max-gst_plugins_dvbmediasink \
$(DEPDIR)/gst_plugins_dvbmediasink: \
$(DEPDIR)/%gst_plugins_dvbmediasink: $(DEPDIR)/gst_plugins_dvbmediasink.do_compile
	cd @DIR_gst_plugins_dvbmediasink@ && \
		@INSTALL_gst_plugins_dvbmediasink@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

################ EXTERNAL_CLD #############################

# libusb 
# 
$(DEPDIR)/libusb.do_prepare:  @DEPENDS_libusb@ 
	@PREPARE_libusb@ 
	touch $@ 
 
$(DEPDIR)/libusb.do_compile: $(DEPDIR)/libusb.do_prepare 
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libusb@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@
 
$(DEPDIR)/min-libusb $(DEPDIR)/std-libusb $(DEPDIR)/max-libusb \
$(DEPDIR)/libusb: \
$(DEPDIR)/%libusb: $(DEPDIR)/libusb.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_libusb@ && \
		@INSTALL_libusb@
	@TUXBOX_YAUD_CUSTOMIZE@

# graphlcd
$(DEPDIR)/graphlcd.do_prepare:	libusb
	[ -d graphlcd-base ] && \
    rm -rf graphlcd-base; \
	git clone git://projects.vdr-developer.org/graphlcd-base.git --branch touchcol graphlcd-base;
	cd graphlcd-base && \
    patch -p0 <../Patches/graphlcd.patch
	touch $@

$(DEPDIR)/graphlcd.do_compile: $(DEPDIR)/graphlcd.do_prepare
	cd graphlcd-base && \
	$(BUILDENV) && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-graphlcd $(DEPDIR)/std-graphlcd $(DEPDIR)/max-graphlcd \
$(DEPDIR)/graphlcd: \
$(DEPDIR)/%graphlcd: $(DEPDIR)/graphlcd.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd graphlcd-base && \
		cp glcddrivers/*.so* $(targetprefix)/usr/lib/ && \
		cp glcdgraphics/*.so* $(targetprefix)/usr/lib/ && \
		cp glcdskin/*.so* $(targetprefix)/usr/lib/ && \
		cp tools/showpic/showpic $(targetprefix)/usr/bin/ && \
		cp tools/showtext/showtext $(targetprefix)/usr/bin/ && \
		cp graphlcd.conf $(targetprefix)/etc/
	@TUXBOX_YAUD_CUSTOMIZE@

#$(DEPDIR)/graphlcd: graphlcd.do_compile
#	touch $@

################ END EXTERNAL_CLD #############################

#
# eve-browser
#
$(DEPDIR)/evebrowser.do_prepare: webkitdfb @DEPENDS_evebrowser@
	svn checkout https://eve-browser.googlecode.com/svn/trunk/ @DIR_evebrowser@
	touch $@

$(DEPDIR)/evebrowser.do_compile: $(DEPDIR)/evebrowser.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_evebrowser@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-evebrowser $(DEPDIR)/std-evebrowser $(DEPDIR)/max-evebrowser \
$(DEPDIR)/evebrowser: \
$(DEPDIR)/%evebrowser: $(DEPDIR)/evebrowser.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_evebrowser@ && \
		@INSTALL_evebrowser@ && \
		cp -ar enigma2/HbbTv $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/
	@TUXBOX_YAUD_CUSTOMIZE@

#
# brofs
#
$(DEPDIR)/brofs.do_prepare:  @DEPENDS_brofs@
	@PREPARE_brofs@
	touch $@

$(DEPDIR)/brofs.do_compile: $(DEPDIR)/brofs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_brofs@ && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-brofs $(DEPDIR)/std-brofs $(DEPDIR)/max-brofs \
$(DEPDIR)/brofs: \
$(DEPDIR)/%brofs: $(DEPDIR)/brofs.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_brofs@ && \
		@INSTALL_brofs@
	@TUXBOX_YAUD_CUSTOMIZE@

#
# libcap
#
$(DEPDIR)/libcap.do_prepare:  @DEPENDS_libcap@
	@PREPARE_libcap@
	touch $@

$(DEPDIR)/libcap.do_compile: $(DEPDIR)/libcap.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcap@ && \
	$(MAKE) \
	DESTDIR=$(prefix)/cdkroot \
	PREFIX=$(prefix)/cdkroot/usr \
	LIBDIR=$(prefix)/cdkroot/usr/lib \
	SBINDIR=$(prefix)/cdkroot/usr/sbin \
	INCDIR=$(prefix)/cdkroot/usr/include \
	BUILD_CC=gcc \
	PAM_CAP=no \
	LIBATTR=no \
	CC=sh4-linux-gcc
	touch $@

$(DEPDIR)/min-libcap $(DEPDIR)/std-libcap $(DEPDIR)/max-libcap \
$(DEPDIR)/libcap: \
$(DEPDIR)/%libcap: $(DEPDIR)/libcap.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_libcap@ && \
		@INSTALL_libcap@ \
		DESTDIR=$(prefix)/cdkroot \
		PREFIX=$(prefix)/cdkroot/usr \
		LIBDIR=$(prefix)/cdkroot/usr/lib \
		SBINDIR=$(prefix)/cdkroot/usr/sbin \
		INCDIR=$(prefix)/cdkroot/usr/include \
		BUILD_CC=gcc \
		PAM_CAP=no \
		LIBATTR=no \
		CC=sh4-linux-gcc
	@TUXBOX_YAUD_CUSTOMIZE@

#
# alsa-lib
#
$(DEPDIR)/libalsa.do_prepare:  @DEPENDS_libalsa@
	@PREPARE_libalsa@
	touch $@

$(DEPDIR)/libalsa.do_compile: $(DEPDIR)/libalsa.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libalsa@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-debug=no \
		--enable-static \
		--disable-python && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libalsa $(DEPDIR)/std-libalsa $(DEPDIR)/max-libalsa \
$(DEPDIR)/libalsa: \
$(DEPDIR)/%libalsa: $(DEPDIR)/libalsa.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_libalsa@ && \
		@INSTALL_libalsa@
	@TUXBOX_YAUD_CUSTOMIZE@

