#
# libboost
#
$(DEPDIR)/libboost: bootstrap @DEPENDS_libboost@
	@PREPARE_libboost@
	cd @DIR_libboost@ && \
		@INSTALL_libboost@
#	@DISTCLEANUP_libboost@
	touch $@

#
# libz
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libreadline
#
$(DEPDIR)/libreadline.do_prepare: bootstrap ncurses-dev @DEPENDS_libreadline@
	@PREPARE_libreadline@
	touch $@

$(DEPDIR)/libreadline.do_compile: $(DEPDIR)/libreadline.do_prepare
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
	[ "x$*" = "x" ] && touch $@ || true

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
	[ "x$*" = "x" ] && touch $@ || true

#
# freetype
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

$(DEPDIR)/min-freetype $(DEPDIR)/std-freetype $(DEPDIR)/max-freetype \
$(DEPDIR)/freetype: \
$(DEPDIR)/%freetype: $(DEPDIR)/freetype.do_compile
	cd @DIR_freetype@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config && \
		ln -sf $(crossprefix)/bin/freetype-config $(crossprefix)/bin/$(target)-freetype-config && \
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype && \
		@INSTALL_freetype@
		rm -f $(targetprefix)/usr/bin/freetype-config
#	@DISTCLEANUP_freetype@
	[ "x$*" = "x" ] && touch $@ || true

#
# lirc
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

$(DEPDIR)/min-lirc $(DEPDIR)/std-lirc $(DEPDIR)/max-lirc \
$(DEPDIR)/lirc: \
$(DEPDIR)/%lirc: $(DEPDIR)/lirc.do_compile
	cd @DIR_lirc@ && \
		@INSTALL_lirc@
#	@DISTCLEANUP_lirc@
	[ "x$*" = "x" ] && touch $@ || true

#
# jpeg
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

$(DEPDIR)/min-jpeg $(DEPDIR)/std-jpeg $(DEPDIR)/max-jpeg \
$(DEPDIR)/jpeg: \
$(DEPDIR)/%jpeg: $(DEPDIR)/jpeg.do_compile
	cd @DIR_jpeg@ && \
		@INSTALL_jpeg@
#	@DISTCLEANUP_jpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# libpng
#
$(DEPDIR)/libpng.do_prepare: bootstrap libz @DEPENDS_libpng@
	@PREPARE_libpng@
	touch $@

$(DEPDIR)/libpng.do_compile: $(DEPDIR)/libpng.do_prepare
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

$(DEPDIR)/min-libpng $(DEPDIR)/std-libpng $(DEPDIR)/max-libpng \
$(DEPDIR)/libpng: \
$(DEPDIR)/%libpng: $(DEPDIR)/libpng.do_compile
	cd @DIR_libpng@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		@INSTALL_libpng@
		rm -f $(targetprefix)/usr/bin/libpng*-config
#	@DISTCLEANUP_libpng@
	[ "x$*" = "x" ] && touch $@ || true

#
# libungif
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

$(DEPDIR)/min-libungif $(DEPDIR)/std-libungif $(DEPDIR)/max-libungif \
$(DEPDIR)/libungif: \
$(DEPDIR)/%libungif: $(DEPDIR)/libungif.do_compile
	cd @DIR_libungif@ && \
		@INSTALL_libungif@
#	@DISTCLEANUP_libungif@
	[ "x$*" = "x" ] && touch $@ || true

#
# libgif
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

$(DEPDIR)/min-libgif $(DEPDIR)/std-libgif $(DEPDIR)/max-libgif \
$(DEPDIR)/libgif: \
$(DEPDIR)/%libgif: $(DEPDIR)/libgif.do_compile
	cd @DIR_libgif@ && \
		@INSTALL_libgif@
#	@DISTCLEANUP_libgif@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcurl
#
$(DEPDIR)/curl.do_prepare: bootstrap openssl rtmpdump libz @DEPENDS_curl@
	@PREPARE_curl@
	touch $@

$(DEPDIR)/curl.do_compile: $(DEPDIR)/curl.do_prepare
	cd @DIR_curl@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-ssl \
			--disable-debug \
			--disable-verbose \
			--disable-manual \
			--mandir=/usr/share/man \
			--with-random && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-curl $(DEPDIR)/std-curl $(DEPDIR)/max-curl \
$(DEPDIR)/curl: \
$(DEPDIR)/%curl: $(DEPDIR)/curl.do_compile
	cd @DIR_curl@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config && \
		@INSTALL_curl@
		rm -f $(targetprefix)/usr/bin/curl-config
#	@DISTCLEANUP_curl@
	[ "x$*" = "x" ] && touch $@ || true

#
# libfribidi
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libsigc
#
$(DEPDIR)/libsigc.do_prepare: bootstrap libstdc++-dev @DEPENDS_libsigc@
	@PREPARE_libsigc@
	touch $@

$(DEPDIR)/libsigc.do_compile: $(DEPDIR)/libsigc.do_prepare
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libmad
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libid3tag
#
$(DEPDIR)/libid3tag.do_prepare: bootstrap libz @DEPENDS_libid3tag@
	@PREPARE_libid3tag@
	touch $@

$(DEPDIR)/libid3tag.do_compile: $(DEPDIR)/libid3tag.do_prepare
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libvorbisidec
#

$(DEPDIR)/libvorbisidec.do_prepare: bootstrap @DEPENDS_libvorbisidec@
	@PREPARE_libvorbisidec@
	touch $@

$(DEPDIR)/libvorbisidec.do_compile: $(DEPDIR)/libvorbisidec.do_prepare
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
# libglib2
# You need libglib2.0-dev on host system
#
$(DEPDIR)/glib2.do_prepare: bootstrap libz @DEPENDS_glib2@
	@PREPARE_glib2@
	touch $@

$(DEPDIR)/glib2.do_compile: $(DEPDIR)/glib2.do_prepare
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
	[ "x$*" = "x" ] && touch $@ || true

#
# libiconv
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

$(DEPDIR)/min-libiconv $(DEPDIR)/std-libiconv $(DEPDIR)/max-libiconv \
$(DEPDIR)/libiconv: \
$(DEPDIR)/%libiconv: $(DEPDIR)/libiconv.do_compile
	cd @DIR_libiconv@ && \
		cp ./srcm4/* $(hostprefix)/share/aclocal/ && \
		@INSTALL_libiconv@
#	@DISTCLEANUP_libiconv@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmng
#
$(DEPDIR)/libmng.do_prepare: bootstrap libz jpeg lcms @DEPENDS_libmng@
	@PREPARE_libmng@
	touch $@

$(DEPDIR)/libmng.do_compile: $(DEPDIR)/libmng.do_prepare
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

$(DEPDIR)/min-libmng $(DEPDIR)/std-libmng $(DEPDIR)/max-libmng \
$(DEPDIR)/libmng: \
$(DEPDIR)/%libmng: $(DEPDIR)/libmng.do_compile
	cd @DIR_libmng@ && \
		@INSTALL_libmng@
#	@DISTCLEANUP_libmng@
	[ "x$*" = "x" ] && touch $@ || true	

#
# lcms
#
$(DEPDIR)/lcms.do_prepare: bootstrap libz jpeg @DEPENDS_lcms@
	@PREPARE_lcms@
	touch $@

$(DEPDIR)/lcms.do_compile: $(DEPDIR)/lcms.do_prepare
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

#
# directfb
#
$(DEPDIR)/directfb.do_prepare: bootstrap freetype @DEPENDS_directfb@
	@PREPARE_directfb@
	touch $@

$(DEPDIR)/directfb.do_compile: $(DEPDIR)/directfb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_directfb@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
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
			--with-inputdrivers=linuxinput,enigma2remote \
			--without-software \
			--enable-stmfbdev \
			--disable-fbdev \
			--enable-mme=yes && \
			export top_builddir=`pwd` && \
		$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/min-directfb $(DEPDIR)/std-directfb $(DEPDIR)/max-directfb \
$(DEPDIR)/directfb: \
$(DEPDIR)/%directfb: $(DEPDIR)/directfb.do_compile
	cd @DIR_directfb@ && \
		@INSTALL_directfb@
#	@DISTCLEANUP_directfb@
	[ "x$*" = "x" ] && touch $@ || true

#
# DFB++
#
$(DEPDIR)/dfbpp.do_prepare: bootstrap libz jpeg directfb @DEPENDS_dfbpp@
	@PREPARE_dfbpp@
	touch $@

$(DEPDIR)/dfbpp.do_compile: $(DEPDIR)/dfbpp.do_prepare
	cd @DIR_dfbpp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
			export top_builddir=`pwd` && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-dfbpp $(DEPDIR)/std-dfbpp $(DEPDIR)/max-dfbpp \
$(DEPDIR)/dfbpp: \
$(DEPDIR)/%dfbpp: $(DEPDIR)/dfbpp.do_compile
	cd @DIR_dfbpp@ && \
		@INSTALL_dfbpp@
#	@DISTCLEANUP_dfbpp@
	[ "x$*" = "x" ] && touch $@ || true

#
# LIBSTGLES
#
$(DEPDIR)/libstgles.do_prepare: bootstrap directfb @DEPENDS_libstgles@
	@PREPARE_libstgles@
	touch $@

$(DEPDIR)/libstgles.do_compile: $(DEPDIR)/libstgles.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libstgles@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-libstgles $(DEPDIR)/std-libstgles $(DEPDIR)/max-libstgles \
$(DEPDIR)/libstgles: \
$(DEPDIR)/%libstgles: $(DEPDIR)/libstgles.do_compile
	cd @DIR_libstgles@ && \
		@INSTALL_libstgles@
#	@DISTCLEANUP_libstgles@
	[ "x$*" = "x" ] && touch $@ || true

#
# expat
#
$(DEPDIR)/expat.do_prepare: bootstrap @DEPENDS_expat@
	@PREPARE_expat@
	touch $@

$(DEPDIR)/expat.do_compile: $(DEPDIR)/expat.do_prepare
	cd @DIR_expat@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-expat $(DEPDIR)/std-expat $(DEPDIR)/max-expat \
$(DEPDIR)/expat: \
$(DEPDIR)/%expat: $(DEPDIR)/expat.do_compile
	cd @DIR_expat@ && \
		@INSTALL_expat@
#	@DISTCLEANUP_expat@
	[ "x$*" = "x" ] && touch $@ || true

#
# fontconfig
#
$(DEPDIR)/fontconfig.do_prepare: bootstrap libz libxml2 @DEPENDS_fontconfig@
	@PREPARE_fontconfig@
	touch $@

$(DEPDIR)/fontconfig.do_compile: $(DEPDIR)/fontconfig.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_fontconfig@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os -I$(targetprefix)/usr/include/libxml2" \
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

$(DEPDIR)/min-fontconfig $(DEPDIR)/std-fontconfig $(DEPDIR)/max-fontconfig \
$(DEPDIR)/fontconfig: \
$(DEPDIR)/%fontconfig: $(DEPDIR)/fontconfig.do_compile
	cd @DIR_fontconfig@ && \
		@INSTALL_fontconfig@
#	@DISTCLEANUP_fontconfig@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxmlccwrap
#
$(DEPDIR)/libxmlccwrap.do_prepare: bootstrap @DEPENDS_libxmlccwrap@
	@PREPARE_libxmlccwrap@
	touch $@

$(DEPDIR)/libxmlccwrap.do_compile: $(DEPDIR)/libxmlccwrap.do_prepare
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
$(DEPDIR)/%libxmlccwrap: $(DEPDIR)/libxmlccwrap.do_compile
	cd @DIR_libxmlccwrap@ && \
		@INSTALL_libxmlccwrap@ && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la
#	@DISTCLEANUP_libxmlccwrap@
	[ "x$*" = "x" ] && touch $@ || true

#
# a52dec
#
$(DEPDIR)/a52dec.do_prepare: bootstrap @DEPENDS_a52dec@
	@PREPARE_a52dec@
	touch $@

$(DEPDIR)/a52dec.do_compile: $(DEPDIR)/a52dec.do_prepare
	cd @DIR_a52dec@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix)/usr && \
		$(MAKE) install
	touch $@

$(DEPDIR)/min-a52dec $(DEPDIR)/std-a52dec $(DEPDIR)/max-a52dec \
$(DEPDIR)/a52dec: \
$(DEPDIR)/%a52dec: $(DEPDIR)/a52dec.do_compile
	cd @DIR_a52dec@ && \
		@INSTALL_a52dec@
#	@DISTCLEANUP_a52dec@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdcss
#
$(DEPDIR)/libdvdcss.do_prepare: bootstrap @DEPENDS_libdvdcss@
	@PREPARE_libdvdcss@
	touch $@

$(DEPDIR)/libdvdcss.do_compile: $(DEPDIR)/libdvdcss.do_prepare
	cd @DIR_libdvdcss@ && \
		$(BUILDENV) \
		CFLAGS="$(TARGET_CFLAGS) -Os" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libdvdcss $(DEPDIR)/std-libdvdcss $(DEPDIR)/max-libdvdcss \
$(DEPDIR)/libdvdcss: \
$(DEPDIR)/%libdvdcss: $(DEPDIR)/libdvdcss.do_compile
	cd @DIR_libdvdcss@ && \
		@INSTALL_libdvdcss@
#	@DISTCLEANUP_libdvdcss@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdnav
#
$(DEPDIR)/libdvdnav.do_prepare: bootstrap libdvdread @DEPENDS_libdvdnav@
	@PREPARE_libdvdnav@
	touch $@

$(DEPDIR)/libdvdnav.do_compile: $(DEPDIR)/libdvdnav.do_prepare
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
			--with-dvdread-config=$(crossprefix)/bin/dvdread-config && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libdvdnav $(DEPDIR)/std-libdvdnav $(DEPDIR)/max-libdvdnav \
$(DEPDIR)/libdvdnav: \
$(DEPDIR)/%libdvdnav: $(DEPDIR)/libdvdnav.do_compile
	cd @DIR_libdvdnav@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdnav-config > $(crossprefix)/bin/dvdnav-config && \
		chmod 755 $(crossprefix)/bin/dvdnav-config && \
		@INSTALL_libdvdnav@
		rm -f $(targetprefix)/usr/bin/dvdnav-config
#	@DISTCLEANUP_libdvdnav@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdread
#
$(DEPDIR)/libdvdread.do_prepare: bootstrap @DEPENDS_libdvdread@
	@PREPARE_libdvdread@
	touch $@

$(DEPDIR)/libdvdread.do_compile: $(DEPDIR)/libdvdread.do_prepare
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
	touch $@

$(DEPDIR)/min-libdvdread $(DEPDIR)/std-libdvdread $(DEPDIR)/max-libdvdread \
$(DEPDIR)/libdvdread: \
$(DEPDIR)/%libdvdread: $(DEPDIR)/libdvdread.do_compile
	cd @DIR_libdvdread@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdread-config > $(crossprefix)/bin/dvdread-config && \
		chmod 755 $(crossprefix)/bin/dvdread-config && \
		@INSTALL_libdvdread@
		rm -f $(targetprefix)/usr/bin/dvdread-config
#	@DISTCLEANUP_libdvdread@
	[ "x$*" = "x" ] && touch $@ || true

#
# ffmpeg
#
$(DEPDIR)/ffmpeg.do_prepare: bootstrap libass rtmpdump @DEPENDS_ffmpeg@
	@PREPARE_ffmpeg@
	touch $@

$(DEPDIR)/ffmpeg.do_compile: $(DEPDIR)/ffmpeg.do_prepare
	cd @DIR_ffmpeg@ && \
	$(BUILDENV) \
	./configure \
		--disable-static \
		--enable-shared \
		--enable-cross-compile \
		--disable-ffserver \
		--disable-ffplay \
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
		--enable-muxer=mpeg2video \
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
		--enable-encoder=mpeg2video \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=mp3 \
		--enable-decoder=theora \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h264 \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=png \
		--enable-decoder=ljpeg \
		--enable-decoder=mjpeg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		--enable-protocol=file \
		--enable-encoder=mpeg2video \
		--enable-muxer=mpeg2video \
		--enable-parser=mjpeg \
		--enable-demuxer=mjpeg \
		--enable-decoder=dvbsub \
		--enable-decoder=iff_byterun1 \
		--enable-small \
		--enable-pthreads \
		--enable-bzlib \
		--enable-librtmp \
		--pkg-config=pkg-config \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--extra-cflags=-fno-strict-aliasing \
		--enable-stripping \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-ffmpeg $(DEPDIR)/std-ffmpeg $(DEPDIR)/max-ffmpeg \
$(DEPDIR)/ffmpeg: \
$(DEPDIR)/%ffmpeg: $(DEPDIR)/ffmpeg.do_compile
	cd @DIR_ffmpeg@ && \
		@INSTALL_ffmpeg@
#	@DISTCLEANUP_ffmpeg@
	[ "x$*" = "x" ] && touch $@ || true

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
		--disable-enca \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-libass $(DEPDIR)/std-libass $(DEPDIR)/max-libass \
$(DEPDIR)/libass: \
$(DEPDIR)/%libass: $(DEPDIR)/libass.do_compile
	cd @DIR_libass@ && \
		@INSTALL_libass@
#	@DISTCLEANUP_libass@
	[ "x$*" = "x" ] && touch $@ || true

#
# WebKitDFB
#
$(DEPDIR)/webkitdfb.do_prepare: bootstrap glib2 icu4c libxml2 enchant lite curl fontconfig sqlite libsoup cairo jpeg @DEPENDS_webkitdfb@
	@PREPARE_webkitdfb@
	touch $@

$(DEPDIR)/webkitdfb.do_compile: $(DEPDIR)/webkitdfb.do_prepare
	export PATH=$(buildprefix)/@DIR_icu4c@/host/config:$(PATH) && \
	cd @DIR_webkitdfb@ && \
	$(BUILDENV) \
	./autogen.sh \
		--with-target=directfb \
		--without-gtkplus \
		--host=$(target) \
		--prefix=/usr \
		--with-cairo-directfb \
		--disable-shared-workers \
		--enable-optimizations \
		--disable-channel-messaging \
		--disable-javascript-debugger \
		--enable-offline-web-applications \
		--enable-dom-storage \
		--enable-database \
		--disable-eventsource \
		--enable-icon-database \
		--enable-datalist \
		--disable-video \
		--enable-svg \
		--enable-xpath \
		--disable-xslt \
		--disable-dashboard-support \
		--disable-geolocation \
		--disable-workers \
		--disable-web-sockets \
		--with-networking-backend=soup
	touch $@

$(DEPDIR)/min-webkitdfb $(DEPDIR)/std-webkitdfb $(DEPDIR)/max-webkitdfb \
$(DEPDIR)/webkitdfb: \
$(DEPDIR)/%webkitdfb: $(DEPDIR)/webkitdfb.do_compile
	cd @DIR_webkitdfb@ && \
		@INSTALL_webkitdfb@
#	@DISTCLEANUP_webkitdfb@
	[ "x$*" = "x" ] && touch $@ || true

#
# icu4c
#
$(DEPDIR)/icu4c.do_prepare: bootstrap @DEPENDS_icu4c@
	@PREPARE_icu4c@
	cd @DIR_icu4c@ && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < $(buildprefix)/Patches/icu4c-4_4_1_locales.patch;
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
		--with-cross-build=$(buildprefix)/@DIR_icu4c@/host \
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
#	@DISTCLEANUP_icu4c@
	[ "x$*" = "x" ] && touch $@ || true

#
# enchant
#
$(DEPDIR)/enchant.do_prepare: bootstrap glib2 @DEPENDS_enchant@
	@PREPARE_enchant@
	touch $@

$(DEPDIR)/enchant.do_compile: $(DEPDIR)/enchant.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_enchant@ && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--with-gnu-ld \
		--disable-aspell \
		--disable-ispell \
		--disable-myspell \
		--disable-zemberek && \
	$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/min-enchant $(DEPDIR)/std-enchant $(DEPDIR)/max-enchant \
$(DEPDIR)/enchant: \
$(DEPDIR)/%enchant: $(DEPDIR)/enchant.do_compile
	cd @DIR_enchant@ && \
		@INSTALL_enchant@
#	@DISTCLEANUP_enchant@
	[ "x$*" = "x" ] && touch $@ || true

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
#	@DISTCLEANUP_lite@
	[ "x$*" = "x" ] && touch $@ || true

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
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-sqlite $(DEPDIR)/std-sqlite $(DEPDIR)/max-sqlite \
$(DEPDIR)/sqlite: \
$(DEPDIR)/%sqlite: $(DEPDIR)/sqlite.do_compile
	cd @DIR_sqlite@ && \
		@INSTALL_sqlite@
#	@DISTCLEANUP_sqlite@
	[ "x$*" = "x" ] && touch $@ || true

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
#	@DISTCLEANUP_libsoup@
	[ "x$*" = "x" ] && touch $@ || true

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
#	@DISTCLEANUP_pixman@
	[ "x$*" = "x" ] && touch $@ || true

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
#	@DISTCLEANUP_cairo@
	[ "x$*" = "x" ] && touch $@ || true

#
# libogg
#
$(DEPDIR)/libogg.do_prepare: bootstrap @DEPENDS_libogg@
	@PREPARE_libogg@
	touch $@

$(DEPDIR)/libogg.do_compile: $(DEPDIR)/libogg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libogg@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-libogg $(DEPDIR)/std-libogg $(DEPDIR)/max-libogg \
$(DEPDIR)/libogg: \
$(DEPDIR)/%libogg: $(DEPDIR)/libogg.do_compile
	cd @DIR_libogg@ && \
		@INSTALL_libogg@
#	@DISTCLEANUP_libogg@
	[ "x$*" = "x" ] && touch $@ || true

#
# libflac
#
$(DEPDIR)/libflac.do_prepare: bootstrap @DEPENDS_libflac@
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
		--disable-cpplibs && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-libflac $(DEPDIR)/std-libflac $(DEPDIR)/max-libflac \
$(DEPDIR)/libflac: \
$(DEPDIR)/%libflac: $(DEPDIR)/libflac.do_compile
	cd @DIR_libflac@ && \
		@INSTALL_libflac@
#	@DISTCLEANUP_libflac@
	[ "x$*" = "x" ] && touch $@ || true


##############################   PYTHON   #####################################

#
# elementtree
#
$(DEPDIR)/elementtree.do_prepare: bootstrap @DEPENDS_elementtree@
	@PREPARE_elementtree@
	touch $@

$(DEPDIR)/elementtree.do_compile: $(DEPDIR)/elementtree.do_prepare
	touch $@

$(DEPDIR)/min-elementtree $(DEPDIR)/std-elementtree $(DEPDIR)/max-elementtree \
$(DEPDIR)/elementtree: \
$(DEPDIR)/%elementtree: %python $(DEPDIR)/elementtree.do_compile
	cd @DIR_elementtree@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_elementtree@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxml2
#
$(DEPDIR)/libxml2.do_prepare: bootstrap @DEPENDS_libxml2@
	@PREPARE_libxml2@
	touch $@

$(DEPDIR)/libxml2.do_compile: $(DEPDIR)/libxml2.do_prepare
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
$(DEPDIR)/%libxml2: $(DEPDIR)/libxml2.do_compile
	cd @DIR_libxml2@ && \
		@INSTALL_libxml2@; \
		[ -f "$(targetprefix)/usr/lib/python2.6/site-packages/libxml2mod.la" ] && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxml2.la,$(targetprefix)/usr/lib/libxml2.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxml2mod.la; \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config; \
		chmod 755 $(crossprefix)/bin/xml2-config; \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xml2Conf.sh; \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xml2Conf.sh
#	@DISTCLEANUP_libxml2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxslt
#
$(DEPDIR)/libxslt.do_prepare: bootstrap libxml2 @DEPENDS_libxslt@
	@PREPARE_libxslt@
	touch $@

$(DEPDIR)/libxslt.do_compile: $(DEPDIR)/libxslt.do_prepare
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
$(DEPDIR)/%libxslt: %libxml2 $(DEPDIR)/libxslt.do_compile
	cd @DIR_libxslt@ && \
		@INSTALL_libxslt@ && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxsltmod.la && \
		sed -e "/^dependency_libs/ s,/usr/lib/libexslt.la,$(targetprefix)/usr/lib/libexslt.la,g" -i $(targetprefix)/usr/lib/python2.6/site-packages/libxsltmod.la && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/libexslt.la && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xsltConf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xsltConf.sh
#	@DISTCLEANUP_libxslt@
	@[ "x$*" = "x" ] && touch $@ || true

#
# lxml
#
$(DEPDIR)/lxml.do_prepare: bootstrap python @DEPENDS_lxml@
	@PREPARE_lxml@
	touch $@

$(DEPDIR)/lxml.do_compile: $(DEPDIR)/lxml.do_prepare
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/min-lxml $(DEPDIR)/std-lxml $(DEPDIR)/max-lxml \
$(DEPDIR)/lxml: \
$(DEPDIR)/%lxml: $(DEPDIR)/lxml.do_compile
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_lxml@
	[ "x$*" = "x" ] && touch $@ || true

#
# setuptools
#
$(DEPDIR)/setuptools.do_prepare: bootstrap @DEPENDS_setuptools@
	@PREPARE_setuptools@
	touch $@

$(DEPDIR)/setuptools.do_compile: $(DEPDIR)/setuptools.do_prepare
	cd @DIR_setuptools@ && \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-setuptools $(DEPDIR)/std-setuptools $(DEPDIR)/max-setuptools \
$(DEPDIR)/setuptools: \
$(DEPDIR)/%setuptools: $(DEPDIR)/setuptools.do_compile
	cd @DIR_setuptools@ && \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_setuptools@
	[ "x$*" = "x" ] && touch $@ || true

#
# twisted
#
$(DEPDIR)/twisted.do_prepare: bootstrap setuptools @DEPENDS_twisted@
	@PREPARE_twisted@
	touch $@

$(DEPDIR)/twisted.do_compile: $(DEPDIR)/twisted.do_prepare
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/min-twisted $(DEPDIR)/std-twisted $(DEPDIR)/max-twisted \
$(DEPDIR)/twisted: \
$(DEPDIR)/%twisted: $(DEPDIR)/twisted.do_compile
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_twisted@
	[ "x$*" = "x" ] && touch $@ || true

#
# twistetweb2
#
$(DEPDIR)/twistedweb2.do_prepare: bootstrap setuptools @DEPENDS_twistedweb2@
	@PREPARE_twistedweb2@
	touch $@

$(DEPDIR)/twistedweb2.do_compile: $(DEPDIR)/twistedweb2.do_prepare
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/min-twistedweb2 $(DEPDIR)/std-twistedweb2 $(DEPDIR)/max-twistedweb2 \
$(DEPDIR)/twistedweb2: \
$(DEPDIR)/%twistedweb2: $(DEPDIR)/twistedweb2.do_compile
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_twistedweb2@
	[ "x$*" = "x" ] && touch $@ || true

#
# pilimaging
#
$(DEPDIR)/pilimaging: bootstrap python @DEPENDS_pilimaging@
	@PREPARE_pilimaging@
	cd @DIR_pilimaging@ && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build && \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr && \
		@DISTCLEANUP_pilimaging@
	@DISTCLEANUP_pilimaging@
	@touch $@
	@TUXBOX_YAUD_CUSTOMIZE@

#
# pyopenssl
#
$(DEPDIR)/pyopenssl.do_prepare: bootstrap setuptools @DEPENDS_pyopenssl@
	@PREPARE_pyopenssl@
	touch $@

$(DEPDIR)/pyopenssl.do_compile: $(DEPDIR)/pyopenssl.do_prepare
	cd @DIR_pyopenssl@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-pyopenssl $(DEPDIR)/std-pyopenssl $(DEPDIR)/max-pyopenssl \
$(DEPDIR)/pyopenssl: \
$(DEPDIR)/%pyopenssl: $(DEPDIR)/pyopenssl.do_compile
	cd @DIR_pyopenssl@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_pyopenssl@
	[ "x$*" = "x" ] && touch $@ || true

#
# python
#
$(DEPDIR)/python.do_prepare: bootstrap host_python openssl openssl-dev sqlite @DEPENDS_python@
	@PREPARE_python@
	touch $@

$(DEPDIR)/python.do_compile: $(DEPDIR)/python.do_prepare
	( cd @DIR_python@ && \
		autoconf && \
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
			--with-pymalloc \
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
$(DEPDIR)/%python: $(DEPDIR)/python.do_compile
	( cd @DIR_python@ && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(crossprefix)/bin/python \
			HOSTPGEN=$(crossprefix)/bin/pgen \
			install DESTDIR=$(prefix)/$*cdkroot ) && \
	$(LN_SF) ../../libpython2.6.so.1.0 $(prefix)/$*cdkroot/usr/lib/python2.6/config/libpython2.6.so
#	@DISTCLEANUP_python@
	[ "x$*" = "x" ] && touch $@ || true

#
# pythonwifi
#
$(DEPDIR)/pythonwifi.do_prepare: bootstrap setuptools @DEPENDS_pythonwifi@
	@PREPARE_pythonwifi@
	touch $@

$(DEPDIR)/pythonwifi.do_compile: $(DEPDIR)/pythonwifi.do_prepare
	cd @DIR_pythonwifi@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-pythonwifi $(DEPDIR)/std-pythonwifi $(DEPDIR)/max-pythonwifi \
$(DEPDIR)/pythonwifi: \
$(DEPDIR)/%pythonwifi: $(DEPDIR)/pythonwifi.do_compile
	cd @DIR_pythonwifi@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_pythonwifi@
	[ "x$*" = "x" ] && touch $@ || true

#
# pythoncheetah
#
$(DEPDIR)/pythoncheetah.do_prepare: bootstrap setuptools @DEPENDS_pythoncheetah@
	@PREPARE_pythoncheetah@
	touch $@

$(DEPDIR)/pythoncheetah.do_compile: $(DEPDIR)/pythoncheetah.do_prepare
	cd @DIR_pythoncheetah@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-pythoncheetah $(DEPDIR)/std-pythoncheetah $(DEPDIR)/max-pythoncheetah \
$(DEPDIR)/pythoncheetah: \
$(DEPDIR)/%pythoncheetah: $(DEPDIR)/pythoncheetah.do_compile
	cd @DIR_pythoncheetah@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_pythoncheetah@
	[ "x$*" = "x" ] && touch $@ || true

#
# zope interface
#
$(DEPDIR)/zope_interface.do_prepare: bootstrap python setuptools @DEPENDS_zope_interface@
	@PREPARE_zope_interface@
	touch $@

$(DEPDIR)/zope_interface.do_compile: $(DEPDIR)/zope_interface.do_prepare
	cd @DIR_zope_interface@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/min-zope_interface $(DEPDIR)/std-zope_interface $(DEPDIR)/max-zope_interface \
$(DEPDIR)/zope_interface: \
$(DEPDIR)/%zope_interface: $(DEPDIR)/zope_interface.do_compile
	cd @DIR_zope_interface@ && \
		PYTHONPATH=$(targetprefix)/usr/lib/python2.6/site-packages \
		$(crossprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
#	@DISTCLEANUP_zope_interface@
	[ "x$*" = "x" ] && touch $@ || true



##############################   GSTREAMER + PLUGINS   #########################

#
# GSTREAMER
#
$(DEPDIR)/gstreamer.do_prepare: bootstrap glib2 libxml2 @DEPENDS_gstreamer@
	@PREPARE_gstreamer@
	touch $@

$(DEPDIR)/gstreamer.do_compile: $(DEPDIR)/gstreamer.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gstreamer@ && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-dependency-tracking \
		--disable-check \
		ac_cv_func_register_printf_function=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gstreamer $(DEPDIR)/std-gstreamer $(DEPDIR)/max-gstreamer \
$(DEPDIR)/gstreamer: \
$(DEPDIR)/%gstreamer: $(DEPDIR)/gstreamer.do_compile
	cd @DIR_gstreamer@ && \
		@INSTALL_gstreamer@
#	@DISTCLEANUP_gstreamer@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-BASE
#
$(DEPDIR)/gst_plugins_base.do_prepare: bootstrap glib2 gstreamer libogg libalsa @DEPENDS_gst_plugins_base@
	@PREPARE_gst_plugins_base@
	touch $@

$(DEPDIR)/gst_plugins_base.do_compile: $(DEPDIR)/gst_plugins_base.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_base@ && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-theora \
		--disable-gnome_vfs \
		--disable-pango \
		--disable-vorbis \
		--disable-x \
		--disable-examples \
		--with-audioresample-format=int && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_base $(DEPDIR)/std-gst_plugins_base $(DEPDIR)/max-gst_plugins_base \
$(DEPDIR)/gst_plugins_base: \
$(DEPDIR)/%gst_plugins_base: $(DEPDIR)/gst_plugins_base.do_compile
	cd @DIR_gst_plugins_base@ && \
		@INSTALL_gst_plugins_base@
#	@DISTCLEANUP_gst_plugins_base@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-GOOD
#
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
		--disable-esd \
		--disable-esdtest \
		--disable-aalib \
		--disable-shout2 \
		--disable-shout2test \
		--disable-x \
		--with-check=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_good $(DEPDIR)/std-gst_plugins_good $(DEPDIR)/max-gst_plugins_good \
$(DEPDIR)/gst_plugins_good: \
$(DEPDIR)/%gst_plugins_good: $(DEPDIR)/gst_plugins_good.do_compile
	cd @DIR_gst_plugins_good@ && \
		@INSTALL_gst_plugins_good@
#	@DISTCLEANUP_gst_plugins_good@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-BAD
#
$(DEPDIR)/gst_plugins_bad.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_bad@
	@PREPARE_gst_plugins_bad@
	touch $@

$(DEPDIR)/gst_plugins_bad.do_compile: $(DEPDIR)/gst_plugins_bad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_bad@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-sdl \
		ac_cv_openssldir=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_bad $(DEPDIR)/std-gst_plugins_bad $(DEPDIR)/max-gst_plugins_bad \
$(DEPDIR)/gst_plugins_bad: \
$(DEPDIR)/%gst_plugins_bad: $(DEPDIR)/gst_plugins_bad.do_compile
	cd @DIR_gst_plugins_bad@ && \
		@INSTALL_gst_plugins_bad@
#	@DISTCLEANUP_gst_plugins_bad@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-UGLY
#
$(DEPDIR)/gst_plugins_ugly.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_ugly@
	@PREPARE_gst_plugins_ugly@
	touch $@

$(DEPDIR)/gst_plugins_ugly.do_compile: $(DEPDIR)/gst_plugins_ugly.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_ugly@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_ugly $(DEPDIR)/std-gst_plugins_ugly $(DEPDIR)/max-gst_plugins_ugly \
$(DEPDIR)/gst_plugins_ugly: \
$(DEPDIR)/%gst_plugins_ugly: $(DEPDIR)/gst_plugins_ugly.do_compile
	cd @DIR_gst_plugins_ugly@ && \
		@INSTALL_gst_plugins_ugly@
#	@DISTCLEANUP_gst_plugins_ugly@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-FFMPEG
#
$(DEPDIR)/gst_ffmpeg.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_ffmpeg@
	@PREPARE_gst_ffmpeg@
	touch $@

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
		--enable-demuxer=mpegts \
		\
		--disable-bsfs \
		--enable-pthreads \
		--enable-bzlib"
	touch $@

$(DEPDIR)/min-gst_ffmpeg $(DEPDIR)/std-gst_ffmpeg $(DEPDIR)/max-gst_ffmpeg \
$(DEPDIR)/gst_ffmpeg: \
$(DEPDIR)/%gst_ffmpeg: $(DEPDIR)/gst_ffmpeg.do_compile
	cd @DIR_gst_ffmpeg@ && \
		@INSTALL_gst_ffmpeg@
#	@DISTCLEANUP_gst_ffmpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-FLUENDO-MPEGDEMUX
#
$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_fluendo_mpegdemux@
	@PREPARE_gst_plugins_fluendo_mpegdemux@
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_fluendo_mpegdemux@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_fluendo_mpegdemux $(DEPDIR)/std-gst_plugins_fluendo_mpegdemux $(DEPDIR)/max-gst_plugins_fluendo_mpegdemux \
$(DEPDIR)/gst_plugins_fluendo_mpegdemux: \
$(DEPDIR)/%gst_plugins_fluendo_mpegdemux: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile
	cd @DIR_gst_plugins_fluendo_mpegdemux@ && \
		@INSTALL_gst_plugins_fluendo_mpegdemux@
#	@DISTCLEANUP_gst_ffmpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGIN-SUBSINK
#
$(DEPDIR)/gst_plugin_subsink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly @DEPENDS_gst_plugin_subsink@
	@PREPARE_gst_plugin_subsink@
	touch $@

$(DEPDIR)/gst_plugin_subsink.do_compile: $(DEPDIR)/gst_plugin_subsink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugin_subsink@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugin_subsink $(DEPDIR)/std-gst_plugin_subsink $(DEPDIR)/max-gst_plugin_subsink \
$(DEPDIR)/gst_plugin_subsink: \
$(DEPDIR)/%gst_plugin_subsink: $(DEPDIR)/gst_plugin_subsink.do_compile
	cd @DIR_gst_plugin_subsink@ && \
		@INSTALL_gst_plugin_subsink@
#	@DISTCLEANUP_gst_plugin_subsink@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-DVBMEDIASINK
#
$(DEPDIR)/gst_plugins_dvbmediasink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugin_subsink @DEPENDS_gst_plugins_dvbmediasink@
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
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-gst_plugins_dvbmediasink $(DEPDIR)/std-gst_plugins_dvbmediasink $(DEPDIR)/max-gst_plugins_dvbmediasink \
$(DEPDIR)/gst_plugins_dvbmediasink: \
$(DEPDIR)/%gst_plugins_dvbmediasink: $(DEPDIR)/gst_plugins_dvbmediasink.do_compile
	cd @DIR_gst_plugins_dvbmediasink@ && \
		@INSTALL_gst_plugins_dvbmediasink@
#	@DISTCLEANUP_gst_plugins_dvbmediasink@
	[ "x$*" = "x" ] && touch $@ || true



##############################   EXTERNAL_LCD   ################################

#
# libusb
#
$(DEPDIR)/libusb.do_prepare: @DEPENDS_libusb@
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
	cd @DIR_libusb@ && \
		@INSTALL_libusb@
#	@DISTCLEANUP_libusb@
	[ "x$*" = "x" ] && touch $@ || true

#
# graphlcd
#
$(DEPDIR)/graphlcd.do_prepare: bootstrap libusb @DEPENDS_graphlcd@
	@PREPARE_graphlcd@
	touch $@

$(DEPDIR)/graphlcd.do_compile: $(DEPDIR)/graphlcd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_graphlcd@ && \
	$(BUILDENV) \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-graphlcd $(DEPDIR)/std-graphlcd $(DEPDIR)/max-graphlcd \
$(DEPDIR)/graphlcd: \
$(DEPDIR)/%graphlcd: $(DEPDIR)/graphlcd.do_compile
	cd @DIR_graphlcd@ && \
		@INSTALL_graphlcd@
#	@DISTCLEANUP_graphlcd@
	[ "x$*" = "x" ] && touch $@ || true

##############################   LCD4LINUX   ###################################

#
#
# libgd2
#
$(DEPDIR)/libgd2.do_prepare: bootstrap libz libpng jpeg libiconv freetype fontconfig @DEPENDS_libgd2@
	@PREPARE_libgd2@
	touch $@

$(DEPDIR)/libgd2.do_compile: $(DEPDIR)/libgd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libgd2@ && \
	chmod +w configure && \
	libtoolize -f -c && \
	autoreconf --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-libgd2 $(DEPDIR)/std-libgd2 $(DEPDIR)/max-libgd2 \
$(DEPDIR)/libgd2: \
$(DEPDIR)/%libgd2: $(DEPDIR)/libgd2.do_compile
	cd @DIR_libgd2@ && \
		@INSTALL_libgd2@
#	@DISTCLEANUP_libgd2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libusb2
#
$(DEPDIR)/libusb2.do_prepare: bootstrap @DEPENDS_libusb2@
	@PREPARE_libusb2@
	touch $@

$(DEPDIR)/libusb2.do_compile: $(DEPDIR)/libusb2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libusb2@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/min-libusb2 $(DEPDIR)/std-libusb2 $(DEPDIR)/max-libusb2 \
$(DEPDIR)/libusb2: \
$(DEPDIR)/%libusb2: $(DEPDIR)/libusb2.do_compile
	cd @DIR_libusb2@ && \
		@INSTALL_libusb2@
#	@DISTCLEANUP_libusb2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libusbcompat
#
$(DEPDIR)/libusbcompat.do_prepare: bootstrap libusb2 @DEPENDS_libusbcompat@
	@PREPARE_libusbcompat@
	touch $@

$(DEPDIR)/libusbcompat.do_compile: $(DEPDIR)/libusbcompat.do_prepare
	cd @DIR_libusbcompat@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-libusbcompat $(DEPDIR)/std-libusbcompat $(DEPDIR)/max-libusbcompat \
$(DEPDIR)/libusbcompat: \
$(DEPDIR)/%libusbcompat: $(DEPDIR)/libusbcompat.do_compile
	cd @DIR_libusbcompat@ && \
		@INSTALL_libusbcompat@
#	@DISTCLEANUP_libusbcompat@
	[ "x$*" = "x" ] && touch $@ || true

##############################   END EXTERNAL_LCD   #############################


#
# eve-browser
#
$(DEPDIR)/evebrowser.do_prepare: bootstrap webkitdfb @DEPENDS_evebrowser@
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
	cd @DIR_evebrowser@ && \
		@INSTALL_evebrowser@ && \
		cp -ar enigma2/HbbTv $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/
#	@DISTCLEANUP_evebrowser@
	[ "x$*" = "x" ] && touch $@ || true

#
# brofs
#
$(DEPDIR)/brofs.do_prepare: bootstrap @DEPENDS_brofs@
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
	cd @DIR_brofs@ && \
		@INSTALL_brofs@
#	@DISTCLEANUP_brofs@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcap
#
$(DEPDIR)/libcap.do_prepare: bootstrap @DEPENDS_libcap@
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
#	@DISTCLEANUP_libcap@
	[ "x$*" = "x" ] && touch $@ || true

#
# alsa-lib
#
$(DEPDIR)/libalsa.do_prepare: bootstrap @DEPENDS_libalsa@
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
	cd @DIR_libalsa@ && \
		@INSTALL_libalsa@
#	@DISTCLEANUP_libalsa@
	[ "x$*" = "x" ] && touch $@ || true

#
# rtmpdump
#
$(DEPDIR)/rtmpdump.do_prepare: bootstrap openssl openssl-dev libz @DEPENDS_rtmpdump@
	@PREPARE_rtmpdump@
	touch $@

$(DEPDIR)/rtmpdump.do_compile: $(DEPDIR)/rtmpdump.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rtmpdump@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	$(BUILDENV) \
		make CROSS_COMPILE=$(target)-
	touch $@

$(DEPDIR)/min-rtmpdump $(DEPDIR)/std-rtmpdump $(DEPDIR)/max-rtmpdump \
$(DEPDIR)/rtmpdump: \
$(DEPDIR)/%rtmpdump: $(DEPDIR)/rtmpdump.do_compile
	cd @DIR_rtmpdump@ && \
		@INSTALL_rtmpdump@
#	@DISTCLEANUP_rtmpdump@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvbsi++
#
$(DEPDIR)/libdvbsipp.do_prepare: bootstrap @DEPENDS_libdvbsipp@
	@PREPARE_libdvbsipp@
	touch $@

$(DEPDIR)/libdvbsipp.do_compile: $(DEPDIR)/libdvbsipp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvbsipp@ && \
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

$(DEPDIR)/min-libdvbsipp $(DEPDIR)/std-libdvbsipp $(DEPDIR)/max-libdvbsipp \
$(DEPDIR)/libdvbsipp: \
$(DEPDIR)/%libdvbsipp: $(DEPDIR)/libdvbsipp.do_compile
	cd @DIR_libdvbsipp@ && \
		@INSTALL_libdvbsipp@
#	@DISTCLEANUP_libdvbsipp@
	[ "x$*" = "x" ] && touch $@ || true

#
# tuxtxtlib
#
$(DEPDIR)/tuxtxtlib.do_prepare: bootstrap @DEPENDS_tuxtxtlib@
	@PREPARE_tuxtxtlib@
	touch $@

$(DEPDIR)/tuxtxtlib.do_compile: $(DEPDIR)/tuxtxtlib.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxtlib@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/usr \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-tuxtxtlib $(DEPDIR)/std-tuxtxtlib $(DEPDIR)/max-tuxtxtlib \
$(DEPDIR)/tuxtxtlib: \
$(DEPDIR)/%tuxtxtlib: $(DEPDIR)/tuxtxtlib.do_compile
	cd @DIR_tuxtxtlib@ && \
		@INSTALL_tuxtxtlib@
#	@DISTCLEANUP_tuxtxtlib@
	[ "x$*" = "x" ] && touch $@ || true

#
# tuxtxt32bpp
#
$(DEPDIR)/tuxtxt32bpp.do_prepare: tuxtxtlib @DEPENDS_tuxtxt32bpp@
	@PREPARE_tuxtxt32bpp@
	touch $@

$(DEPDIR)/tuxtxt32bpp.do_compile: $(DEPDIR)/tuxtxt32bpp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxt32bpp@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/usr \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-tuxtxt32bpp $(DEPDIR)/std-tuxtxt32bpp $(DEPDIR)/max-tuxtxt32bpp \
$(DEPDIR)/tuxtxt32bpp: \
$(DEPDIR)/%tuxtxt32bpp: $(DEPDIR)/tuxtxt32bpp.do_compile
	cd @DIR_tuxtxt32bpp@ && \
		@INSTALL_tuxtxt32bpp@
#	@DISTCLEANUP_tuxtxt32bpp@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdreamdvd
#
$(DEPDIR)/libdreamdvd.do_prepare: bootstrap @DEPENDS_libdreamdvd@
	@PREPARE_libdreamdvd@
	touch $@

$(DEPDIR)/libdreamdvd.do_compile: $(DEPDIR)/libdreamdvd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
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

$(DEPDIR)/min-libdreamdvd $(DEPDIR)/std-libdreamdvd $(DEPDIR)/max-libdreamdvd \
$(DEPDIR)/libdreamdvd: \
$(DEPDIR)/%libdreamdvd: $(DEPDIR)/libdreamdvd.do_compile
	cd @DIR_libdreamdvd@ && \
		@INSTALL_libdreamdvd@
#	@DISTCLEANUP_libdreamdvd@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdreamdvd2
#
$(DEPDIR)/libdreamdvd2.do_prepare: bootstrap @DEPENDS_libdreamdvd2@
	[ -d "libdreamdvd" ] && \
	cd libdreamdvd && git pull; \
	[ -d "libdreamdvd" ] || \
	git clone git://schwerkraft.elitedvb.net/libdreamdvd/libdreamdvd.git;
	touch $@

$(DEPDIR)/libdreamdvd2.do_compile: $(DEPDIR)/libdreamdvd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd2@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
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

$(DEPDIR)/min-libdreamdvd2 $(DEPDIR)/std-libdreamdvd2 $(DEPDIR)/max-libdreamdvd2 \
$(DEPDIR)/libdreamdvd2: \
$(DEPDIR)/%libdreamdvd2: $(DEPDIR)/libdreamdvd2.do_compile
	cd @DIR_libdreamdvd2@ && \
		@INSTALL_libdreamdvd2@
#	@DISTCLEANUP_libdreamdvd2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmpeg2
#
$(DEPDIR)/libmpeg2.do_prepare: bootstrap @DEPENDS_libmpeg2@
	@PREPARE_libmpeg2@
	touch $@

$(DEPDIR)/libmpeg2.do_compile: $(DEPDIR)/libmpeg2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmpeg2@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libmpeg2 $(DEPDIR)/std-libmpeg2 $(DEPDIR)/max-libmpeg2 \
$(DEPDIR)/libmpeg2: \
$(DEPDIR)/%libmpeg2: $(DEPDIR)/libmpeg2.do_compile
	cd @DIR_libmpeg2@ && \
		@INSTALL_libmpeg2@
#	@DISTCLEANUP_libmpeg2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libsamplerate
#
$(DEPDIR)/libsamplerate.do_prepare: bootstrap @DEPENDS_libsamplerate@
	@PREPARE_libsamplerate@
	touch $@

$(DEPDIR)/libsamplerate.do_compile: $(DEPDIR)/libsamplerate.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsamplerate@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libsamplerate $(DEPDIR)/std-libsamplerate $(DEPDIR)/max-libsamplerate \
$(DEPDIR)/libsamplerate: \
$(DEPDIR)/%libsamplerate: $(DEPDIR)/libsamplerate.do_compile
	cd @DIR_libsamplerate@ && \
		@INSTALL_libsamplerate@
#	@DISTCLEANUP_libsamplerate@
	[ "x$*" = "x" ] && touch $@ || true

#
# libvorbis
#
$(DEPDIR)/libvorbis.do_prepare: bootstrap @DEPENDS_libvorbis@
	@PREPARE_libvorbis@
	touch $@

$(DEPDIR)/libvorbis.do_compile: $(DEPDIR)/libvorbis.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libvorbis@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libvorbis $(DEPDIR)/std-libvorbis $(DEPDIR)/max-libvorbis \
$(DEPDIR)/libvorbis: \
$(DEPDIR)/%libvorbis: $(DEPDIR)/libvorbis.do_compile
	cd @DIR_libvorbis@ && \
		@INSTALL_libvorbis@
#	@DISTCLEANUP_libvorbis@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmodplug
#
$(DEPDIR)/libmodplug.do_prepare: bootstrap @DEPENDS_libmodplug@
	@PREPARE_libmodplug@
	touch $@

$(DEPDIR)/libmodplug.do_compile: $(DEPDIR)/libmodplug.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmodplug@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libmodplug $(DEPDIR)/std-libmodplug $(DEPDIR)/max-libmodplug \
$(DEPDIR)/libmodplug: \
$(DEPDIR)/%libmodplug: $(DEPDIR)/libmodplug.do_compile
	cd @DIR_libmodplug@ && \
		@INSTALL_libmodplug@
#	@DISTCLEANUP_libmodplug@
	[ "x$*" = "x" ] && touch $@ || true

#
# bzip - already in contrib-apps, check which is better
#
#$(DEPDIR)/bzip.do_prepare: bootstrap @DEPENDS_bzip@
#	@PREPARE_bzip@
#	touch $@
#
#$(DEPDIR)/bzip.do_compile: $(DEPDIR)/bzip.do_prepare
#	export PATH=$(hostprefix)/bin:$(PATH) && \
#	cd @DIR_bzip@ && \
#	$(BUILDENV) \
#	sed -i "s/CC=gcc/CC=sh4-linux-gcc/g" Makefile && \
#	sed -i "s/AR=ar/AR=sh4-linux-ar/g" Makefile && \
#	sed -i "s/RANLIB=ranlib/RANLIB=sh4-linux-ranlib/g" Makefile&& \
#	sed -i -e 's|PREFIX=/usr/local|PREFIX=$(prefix)/cdkroot/usr|g' Makefile
#	$(MAKE) all
#	touch $@
#
#$(DEPDIR)/min-bzip $(DEPDIR)/std-bzip $(DEPDIR)/max-bzip \
#$(DEPDIR)/bzip: \
#$(DEPDIR)/%bzip: $(DEPDIR)/bzip.do_compile
#	cd @DIR_bzip@ && \
#		@INSTALL_bzip@
#	@DISTCLEANUP_bzip@
#	[ "x$*" = "x" ] && touch $@ || true

#
# tiff
#
$(DEPDIR)/tiff.do_prepare: bootstrap @DEPENDS_tiff@
	@PREPARE_tiff@
	touch $@

$(DEPDIR)/tiff.do_compile: $(DEPDIR)/tiff.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tiff@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-tiff $(DEPDIR)/std-tiff $(DEPDIR)/max-tiff \
$(DEPDIR)/tiff: \
$(DEPDIR)/%tiff: $(DEPDIR)/tiff.do_compile
	cd @DIR_tiff@ && \
		@INSTALL_tiff@
#	@DISTCLEANUP_tiff@
	[ "x$*" = "x" ] && touch $@ || true

#
# lzo
#
$(DEPDIR)/lzo.do_prepare: @DEPENDS_lzo@
	@PREPARE_lzo@
	touch $@

$(DEPDIR)/lzo.do_compile: $(DEPDIR)/lzo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lzo@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-lzo $(DEPDIR)/std-lzo $(DEPDIR)/max-lzo \
$(DEPDIR)/lzo: \
$(DEPDIR)/%lzo: $(DEPDIR)/lzo.do_compile
	cd @DIR_lzo@ && \
		@INSTALL_lzo@
#	@DISTCLEANUP_lzo@
	[ "x$*" = "x" ] && touch $@ || true

#
# yajl
#
$(DEPDIR)/yajl.do_prepare: bootstrap @DEPENDS_yajl@
	@PREPARE_yajl@
	touch $@

$(DEPDIR)/yajl.do_compile: $(DEPDIR)/yajl.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_yajl@ && \
	sed -i "s/install: all/install: distro/g" Makefile && \
	$(BUILDENV) \
	./configure \
		--prefix=/usr && \
	$(MAKE) distro
	touch $@

$(DEPDIR)/min-yajl $(DEPDIR)/std-yajl $(DEPDIR)/max-yajl \
$(DEPDIR)/yajl: \
$(DEPDIR)/%yajl: $(DEPDIR)/yajl.do_compile
	cd @DIR_yajl@ && \
		@INSTALL_yajl@
#	@DISTCLEANUP_yajl@
	[ "x$*" = "x" ] && touch $@ || true

#
# libpcre (shouldn't this be named pcre without the lib?)
#
$(DEPDIR)/libpcre.do_prepare: bootstrap @DEPENDS_libpcre@
	@PREPARE_libpcre@
	touch $@

$(DEPDIR)/libpcre.do_compile: $(DEPDIR)/libpcre.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpcre@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--enable-utf8 \
		--enable-unicode-properties && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libpcre $(DEPDIR)/std-libpcre $(DEPDIR)/max-libpcre \
$(DEPDIR)/libpcre: \
$(DEPDIR)/%libpcre: $(DEPDIR)/libpcre.do_compile
	cd @DIR_libpcre@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
		chmod 755 $(crossprefix)/bin/pcre-config && \
		@INSTALL_libpcre@
		rm -f $(targetprefix)/usr/bin/pcre-config
#	@DISTCLEANUP_libpcre@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcdio
#
$(DEPDIR)/libcdio.do_prepare: bootstrap @DEPENDS_libcdio@
	@PREPARE_libcdio@
	touch $@

$(DEPDIR)/libcdio.do_compile: $(DEPDIR)/libcdio.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcdio@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libcdio $(DEPDIR)/std-libcdio $(DEPDIR)/max-libcdio \
$(DEPDIR)/libcdio: \
$(DEPDIR)/%libcdio: $(DEPDIR)/libcdio.do_compile
	cd @DIR_libcdio@ && \
		@INSTALL_libcdio@
#	@DISTCLEANUP_libcdio@
	[ "x$*" = "x" ] && touch $@ || true

#
# jasper
#
$(DEPDIR)/jasper.do_prepare: bootstrap @DEPENDS_jasper@
	@PREPARE_jasper@
	touch $@

$(DEPDIR)/jasper.do_compile: $(DEPDIR)/jasper.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_jasper@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-jasper $(DEPDIR)/std-jasper $(DEPDIR)/max-jasper \
$(DEPDIR)/jasper: \
$(DEPDIR)/%jasper: $(DEPDIR)/jasper.do_compile
	cd @DIR_jasper@ && \
		@INSTALL_jasper@
#	@DISTCLEANUP_jasper@
	[ "x$*" = "x" ] && touch $@ || true

#
# mysql
#
$(DEPDIR)/mysql.do_prepare: bootstrap @DEPENDS_mysql@
	@PREPARE_mysql@
	touch $@

$(DEPDIR)/mysql.do_compile: $(DEPDIR)/mysql.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_mysql@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--with-atomic-ops=up --with-embedded-server --prefix=/usr --sysconfdir=/etc/mysql --localstatedir=/var/mysql --disable-dependency-tracking --without-raid --without-debug --with-low-memory --without-query-cache --without-man --without-docs --without-innodb && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-mysql $(DEPDIR)/std-mysql $(DEPDIR)/max-mysql \
$(DEPDIR)/mysql: \
$(DEPDIR)/%mysql: $(DEPDIR)/mysql.do_compile
	cd @DIR_mysql@ && \
		@INSTALL_mysql@
#	@DISTCLEANUP_mysql@
	[ "x$*" = "x" ] && touch $@ || true


#
# libmicrohttpd
#
$(DEPDIR)/libmicrohttpd.do_prepare: bootstrap @DEPENDS_libmicrohttpd@
	@PREPARE_libmicrohttpd@
	touch $@

$(DEPDIR)/libmicrohttpd.do_compile: $(DEPDIR)/libmicrohttpd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmicrohttpd@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libmicrohttpd $(DEPDIR)/std-libmicrohttpd $(DEPDIR)/max-libmicrohttpd \
$(DEPDIR)/libmicrohttpd: \
$(DEPDIR)/%libmicrohttpd: $(DEPDIR)/libmicrohttpd.do_compile
	cd @DIR_libmicrohttpd@ && \
		@INSTALL_libmicrohttpd@
#	@DISTCLEANUP_libmicrohttpd@
	[ "x$*" = "x" ] && touch $@ || true

#
# libexif
#
$(DEPDIR)/libexif.do_prepare: bootstrap @DEPENDS_libexif@
	@PREPARE_libexif@
	touch $@

$(DEPDIR)/libexif.do_compile: $(DEPDIR)/libexif.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libexif@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-libexif $(DEPDIR)/std-libexif $(DEPDIR)/max-libexif \
$(DEPDIR)/libexif: \
$(DEPDIR)/%libexif: $(DEPDIR)/libexif.do_compile
	cd @DIR_libexif@ && \
		@INSTALL_libexif@
#	@DISTCLEANUP_libexif@
	[ "x$*" = "x" ] && touch $@ || true

#
# minidlna
#
$(DEPDIR)/minidlna.do_prepare: bootstrap ffmpeg libflac libogg libvorbis libid3tag sqlite libexif jpeg @DEPENDS_minidlna@
	@PREPARE_minidlna@
	touch $@

$(DEPDIR)/minidlna.do_compile: $(DEPDIR)/minidlna.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_minidlna@ && \
	libtoolize -f -c && \
	$(BUILDENV) \
	DESTDIR=$(prefix)/cdkroot \
	$(MAKE) \
	PREFIX=$(prefix)/cdkroot/usr \
	LIBDIR=$(prefix)/cdkroot/usr/lib \
	SBINDIR=$(prefix)/cdkroot/usr/sbin \
	INCDIR=$(prefix)/cdkroot/usr/include \
	PAM_CAP=no \
	LIBATTR=no
	touch $@

$(DEPDIR)/min-minidlna $(DEPDIR)/std-minidlna $(DEPDIR)/max-minidlna \
$(DEPDIR)/minidlna: \
$(DEPDIR)/%minidlna: $(DEPDIR)/minidlna.do_compile
	cd @DIR_minidlna@ && \
		@INSTALL_minidlna@
#	@DISTCLEANUP_minidlna@
	[ "x$*" = "x" ] && touch $@ || true

#
# vlc
#
$(DEPDIR)/vlc.do_prepare: bootstrap libstdc++-dev libfribidi ffmpeg @DEPENDS_vlc@
	@PREPARE_vlc@
	touch $@

$(DEPDIR)/vlc.do_compile: $(DEPDIR)/vlc.do_prepare
	cd @DIR_vlc@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--prefix=/usr \
		--disable-xcb \
		--disable-glx \
		--disable-qt4 \
		--disable-mad \
		--disable-postproc \
		--disable-a52 \
		--disable-qt4 \
		--disable-skins2 \
		--disable-remoteosd \
		--disable-lua \
		--disable-libgcrypt \
		--disable-nls \
		--disable-mozilla \
		--disable-dbus \
		--disable-sdl \
		--enable-run-as-root
	touch $@

$(DEPDIR)/min-vlc $(DEPDIR)/std-vlc $(DEPDIR)/max-vlc \
$(DEPDIR)/vlc: \
$(DEPDIR)/%vlc: $(DEPDIR)/vlc.do_compile
	cd @DIR_vlc@ && \
		@INSTALL_vlc@
#	@DISTCLEANUP_vlc@
	@[ "x$*" = "x" ] && touch $@ || true

#
# djmount
#
$(DEPDIR)/djmount.do_prepare: bootstrap fuse @DEPENDS_djmount@
	@PREPARE_djmount@
	touch $@

$(DEPDIR)/djmount.do_compile: $(DEPDIR)/djmount.do_prepare
	cd @DIR_djmount@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-djmount $(DEPDIR)/std-djmount $(DEPDIR)/max-djmount \
$(DEPDIR)/djmount: \
$(DEPDIR)/%djmount: $(DEPDIR)/djmount.do_compile
	cd @DIR_djmount@ && \
		@INSTALL_djmount@
#	@DISTCLEANUP_djmount@
	[ "x$*" = "x" ] && touch $@ || true

#
# libupnp
#
$(DEPDIR)/libupnp.do_prepare: bootstrap @DEPENDS_libupnp@
	@PREPARE_libupnp@
	touch $@

$(DEPDIR)/libupnp.do_compile: $(DEPDIR)/libupnp.do_prepare
	cd @DIR_libupnp@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-libupnp $(DEPDIR)/std-libupnp $(DEPDIR)/max-libupnp \
$(DEPDIR)/libupnp: \
$(DEPDIR)/%libupnp: $(DEPDIR)/libupnp.do_compile
	cd @DIR_libupnp@ && \
		@INSTALL_libupnp@
#	@DISTCLEANUP_libupnp@
	[ "x$*" = "x" ] && touch $@ || true

#
# rarfs
#
$(DEPDIR)/rarfs.do_prepare: bootstrap libstdc++-dev fuse @DEPENDS_rarfs@
	@PREPARE_rarfs@
	touch $@

$(DEPDIR)/rarfs.do_compile: $(DEPDIR)/rarfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rarfs@ && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os -D_FILE_OFFSET_BITS=64" \
	./configure \
		--host=$(target) \
		--disable-option-checking \
		--includedir=/usr/include/fuse \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-rarfs $(DEPDIR)/std-rarfs $(DEPDIR)/max-rarfs \
$(DEPDIR)/rarfs: \
$(DEPDIR)/%rarfs: $(DEPDIR)/rarfs.do_compile
	cd @DIR_rarfs@ && \
		@INSTALL_rarfs@
#	@DISTCLEANUP_rarfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# sshfs
#
$(DEPDIR)/sshfs.do_prepare: bootstrap fuse @DEPENDS_sshfs@
	@PREPARE_sshfs@
	touch $@

$(DEPDIR)/sshfs.do_compile: $(DEPDIR)/sshfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sshfs@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/min-sshfs $(DEPDIR)/std-sshfs $(DEPDIR)/max-sshfs \
$(DEPDIR)/sshfs: \
$(DEPDIR)/%sshfs: $(DEPDIR)/sshfs.do_compile
	cd @DIR_sshfs@ && \
		@INSTALL_sshfs@
#	@DISTCLEANUP_sshfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# gmediarender
#
$(DEPDIR)/gmediarender.do_prepare: bootstrap libstdc++-dev gst_plugins_dvbmediasink libupnp @DEPENDS_gmediarender@
	@PREPARE_gmediarender@
	touch $@

$(DEPDIR)/gmediarender.do_compile: $(DEPDIR)/gmediarender.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gmediarender@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-libupnp=$(targetprefix)/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-gmediarender $(DEPDIR)/std-gmediarender $(DEPDIR)/max-gmediarender \
$(DEPDIR)/gmediarender: \
$(DEPDIR)/%gmediarender: $(DEPDIR)/gmediarender.do_compile
	cd @DIR_gmediarender@ && \
		@INSTALL_gmediarender@
#	@DISTCLEANUP_gmediarender@
	[ "x$*" = "x" ] && touch $@ || true

#
# mediatomb
#
$(DEPDIR)/mediatomb.do_prepare: bootstrap libstdc++-dev ffmpeg curl sqlite expat @DEPENDS_mediatomb@
	@PREPARE_mediatomb@
	touch $@

$(DEPDIR)/mediatomb.do_compile: $(DEPDIR)/mediatomb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_mediatomb@ && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -Os" \
	./configure \
		--host=$(target) \
		--disable-ffmpegthumbnailer \
		--disable-libmagic \
		--disable-mysql \
		--disable-id3lib \
		--disable-taglib \
		--disable-lastfmlib \
		--disable-libexif \
		--disable-libmp4v2 \
		--disable-inotify \
		--with-avformat-h=$(targetprefix)/usr/include \
		--disable-rpl-malloc \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/min-mediatomb $(DEPDIR)/std-mediatomb $(DEPDIR)/max-mediatomb \
$(DEPDIR)/mediatomb: \
$(DEPDIR)/%mediatomb: $(DEPDIR)/mediatomb.do_compile
	cd @DIR_mediatomb@ && \
		@INSTALL_mediatomb@
#	@DISTCLEANUP_mediatomb@
	[ "x$*" = "x" ] && touch $@ || true

#
# tinyxml
#
$(DEPDIR)/tinyxml.do_prepare: @DEPENDS_tinyxml@
	@PREPARE_tinyxml@
	touch $@

$(DEPDIR)/tinyxml.do_compile: $(DEPDIR)/tinyxml.do_prepare
	cd @DIR_tinyxml@ && \
	$(BUILDENV) \
	$(MAKE)
	touch $@

$(DEPDIR)/min-tinyxml $(DEPDIR)/std-tinyxml $(DEPDIR)/max-tinyxml \
$(DEPDIR)/tinyxml: \
$(DEPDIR)/%tinyxml: $(DEPDIR)/tinyxml.do_compile
	cd @DIR_tinyxml@ && \
		@INSTALL_tinyxml@
#	@DISTCLEANUP_tinyxml@
	[ "x$*" = "x" ] && touch $@ || true
