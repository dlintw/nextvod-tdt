
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
$(DEPDIR)/libz.do_prepare: bootstrap @DEPENDS_libz@
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
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--without-x \
			--with-driver=userspace \
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
	cd @DIR_libmad@ && \
		aclocal && \
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
		@INSTALL_libxml2@ && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxml2.la,$(targetprefix)/usr/lib/libxml2.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxml2mod.la && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config && \
		chmod 755 $(crossprefix)/bin/xml2-config && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xml2Conf.sh && \
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
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2" \
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
# GLIB2
# You need libglib2.0-dev on host system
#
$(DEPDIR)/glib2.do_prepare: @DEPENDS_glib2@
	@PREPARE_glib2@
	touch $@

$(DEPDIR)/glib2.do_compile: bootstrap $(DEPDIR)/glib2.do_prepare
	echo "ac_cv_func_posix_getpwuid_r=yes" > @DIR_glib2@/config.cache
	echo "glib_cv_stack_grows=no" >> @DIR_glib2@/config.cache
	echo "glib_cv_uscore=no" >> @DIR_glib2@/config.cache
	cd @DIR_glib2@ && \
		$(BUILDENV) \
		./configure \
			--cache-file=config.cache \
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
	cd @DIR_directfb@ && \
		rm -f include/directfb_version.h && \
		rm -f lib/{direct/build.h,fusion/build.h,voodoo/build.h} && \
		autoreconf --verbose --force --install && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--disable-sdl \
			--disable-x11 \
			--with-gfxdrivers=stgfx && \
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
	cd @DIR_fontconfig@ && \
		autoreconf --verbose --force --install && \
		$(BUILDENV) \
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
# PYTHON24 (BROKEN!)
#
#PYTHONHOME=/home/data/npsvn/np/mt_build/tufsbox/devkit/sh4 ../../tufsbox/devkit/sh4/bin/python2.4 -c 'import sys; print sys.path'
$(DEPDIR)/python24.do_prepare: @DEPENDS_python24@
	@PREPARE_python24@
	touch $@

$(DEPDIR)/python24.do_compile: bootstrap python24.do_prepare
	cd @DIR_python24@ && \
		$(MAKE) distclean && \
		rm -rf config.cache; \
		CONFIG_SITE= \
		OPT="$(HOST_CFLAGS)" \
		./configure --without-cxx-main --without-threads && \
		$(MAKE) python Parser/pgen && \
		mv python ./hostpython && \
		mv Parser/pgen ./hostpgen && \
		\
		$(MAKE) distclean && \
		export PYTHONHOME=$(crossprefix) && \
		./configure \
			--prefix=$(crossprefix) \
			--sysconfdir=$(crossprefix)/etc \
			--without-cxx-main \
			--without-threads && \
		$(MAKE) \
			HOSTPYTHON=./hostpython \
			HOSTPGEN=./hostpgen \
			CROSS_LIBDIR=$(crossprefix)/lib \
			CROSS_INCDIR=$(crossprefix)/include \
			all install && \
		$(MAKE) distclean && \
		rm -rf config.cache && \
		export OPT="-O2" && \
		export PYTHON_DISABLE_SSL=1 && \
		sed -e 's,#! /usr/local/bin/python,#! $(crossprefix)/bin/python,' -i Lib/cgi.py && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc && \
		$(MAKE) CC="$(target)-gcc -fno-strict-aliasing " \
			CROSS_COMPILE=yes \
			CROSS_LIBDIR=$(targetprefix)/usr/lib \
			CROSS_INCDIR=$(targetprefix)/usr/include \
			PYTHON_DISABLE_MODULES="dbm gdbm _bsddb _locale _tkinter" \
			HOSTPYTHON=./hostpython
#			HOSTPGEN=./Parser/hostpgen
	touch $@

$(DEPDIR)/min-python24 $(DEPDIR)/std-python24 $(DEPDIR)/max-python24 \
$(DEPDIR)/python24: \
$(DEPDIR)/%python24: python24.do_compile
	cd @DIR_python24@ && \
		export PYTHON_DISABLE_SSL=1 && \
		$(MAKE) install CC="$(target)-gcc -fno-strict-aliasing " \
			DESTDIR=$(prefix)/$*cdkroot \
			CROSS_COMPILE=yes \
			CROSS_LIBDIR=$(prefix)/$*cdkroot/usr/lib \
			CROSS_INCDIR=$(prefix)/$*cdkroot/usr/include \
			PYTHON_DISABLE_MODULES="dbm gdbm _bsddb _locale _tkinter" \
			HOSTPYTHON=/usr/bin/python
	touch $@

#
# Python
#
$(DEPDIR)/python.do_prepare: host-python @DEPENDS_python@
	@PREPARE_python@ && \
	touch $@

$(DEPDIR)/python.do_compile: openssl openssl-dev bootstrap python.do_prepare
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
	cd @DIR_libdvdnav@ && \
		$(BUILDENV) \
		./autogen.sh \
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
	libtoolize && \
	cd @DIR_libdvdread@ && \
		$(BUILDENV) \
		./autogen.sh \
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
