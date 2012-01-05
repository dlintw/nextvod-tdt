
$(hostappsdir)/config.status: bootstrap
	cd $(hostappsdir) && \
	./autogen.sh && \
	./configure --prefix=$(hostprefix)

hostapps: $(hostappsdir)/config.status
	$(MAKE) -C $(hostappsdir)
#	touch $@

if ENABLE_CCACHE
$(hostprefix)/bin/ccache: @DEPENDS_ccache@
	@PREPARE_ccache@
	cd @DIR_ccache@ && \
		./configure \
			--build=$(build) \
			--host=$(build) \
			--prefix= && \
			$(MAKE) all && \
			@INSTALL_ccache@
#	@CLEANUP_ccache@
endif

if TARGETRULESET_FLASH

#
# MKCRAMFS
#
mkcramfs: @MKCRAMFS@

$(hostprefix)/bin/mkcramfs: @DEPENDS_cramfs@
	@PREPARE_cramfs@
	cd @DIR_cramfs@ && \
		$(MAKE) mkcramfs && \
		@INSTALL_cramfs@
#	@DISTCLEANUP_cramfs@

#
# MKSQUASHFS with LZMA support
#
MKSQUASHFS = $(hostprefix)/bin/mksquashfs
mksquashfs: $(MKSQUASHFS)

if STM22
$(hostprefix)/bin/mksquashfs: @DEPENDS_squashfs@
	rm -rf @DIR_squashfs@
	mkdir -p @DIR_squashfs@
	cd @DIR_squashfs@ && \
	bunzip2 -cd $(archivedir)/lzma442.tar.bz2 | TAPE=- tar -x && \
	patch -p1 < ../Patches/lzma_zlib-stream.diff && \
	gunzip -cd $(archivedir)/squashfs3.0.tar.gz | TAPE=- tar -x && \
	cd squashfs3.0 && patch -p1 < ../../Patches/mksquashfs_lzma.diff
	$(MAKE) -C @DIR_squashfs@/C/7zip/Compress/LZMA_Lib
	$(MAKE) -C @DIR_squashfs@/squashfs3.0/squashfs-tools
	$(INSTALL) -d $(@D)
	$(INSTALL) -m755 @DIR_squashfs@/squashfs3.0/squashfs-tools/mksquashfs $@
	$(INSTALL) -m755 @DIR_squashfs@/squashfs3.0/squashfs-tools/unsquashfs $(@D)
#	rm -rf @DIR_squashfs@
else
$(hostprefix)/bin/mksquashfs: @DEPENDS_squashfs@
	rm -rf @DIR_squashfs@
	mkdir -p @DIR_squashfs@
	cd @DIR_squashfs@ && \
	bunzip2 -cd $(archivedir)/lzma465.tar.bz2 | TAPE=- tar -x && \
	gunzip -cd $(archivedir)/squashfs4.0.tar.gz | TAPE=- tar -x && \
	cd squashfs4.0/squashfs-tools && patch -p1 < ../../../Patches/squashfs-tools-4.0-lzma.patch
	$(MAKE) -C @DIR_squashfs@/squashfs4.0/squashfs-tools
	$(INSTALL) -d $(@D)
	$(INSTALL) -m755 @DIR_squashfs@/squashfs4.0/squashfs-tools/mksquashfs $@
	$(INSTALL) -m755 @DIR_squashfs@/squashfs4.0/squashfs-tools/unsquashfs $(@D)
#	rm -rf @DIR_squashfs@
endif

endif
#
# IPKG-UTILS
#
IPKG_BUILD_BIN = $(crossprefix)/bin/ipkg-build

ipkg-utils: $(IPKG_BUILD_BIN)

$(crossprefix)/bin/ipkg-build: @DEPENDS_ipkg_utils@ | $(ipkprefix)
	@PREPARE_ipkg_utils@
	cd @DIR_ipkg_utils@ && \
		$(MAKE) all PREFIX=$(crossprefix) && \
		$(MAKE) install PREFIX=$(crossprefix)
#       @DISTCLEANUP_ipkg_utils@

#
# IPKG-HOST
#
IPKG_BIN = $(crossprefix)/bin/ipkg
IPKG_CONF = $(crossprefix)/etc/ipkg.conf

ipkg-host: $(IPKG_BIN)

$(crossprefix)/bin/ipkg: @DEPENDS_ipkg_host@
	@PREPARE_ipkg_host@
	cd @DIR_ipkg_host@/ipkg-@VERSION_ipkg_host@ && \
		./configure \
			--prefix=$(crossprefix) && \
		$(MAKE) && \
		$(MAKE) install && \
	$(LN_SF) ipkg-cl $@
	echo "dest root $(flashprefix)/root" >$(IPKG_CONF)
	( echo "lists_dir ext $(flashprefix)/root/usr/lib/ipkg"; \
	  echo "arch sh4 10"; \
	  echo "arch all 1"; \
	  echo "src/gz cross file://$(ipkprefix)" ) >>$(IPKG_CONF)

#	$(INSTALL_DIR) $(crossprefix)/etc/ipkg
#	echo "src/gz cross file://$(ipkprefix)" >$(crossprefix)/etc/ipkg/cross-feed.conf

#
# PYTHON-HOST
#
$(DEPDIR)/host-python: @DEPENDS_host_python@
	@PREPARE_host_python@ && \
	( cd @DIR_host_python@ && \
		rm -rf config.cache; \
		CONFIG_SITE= \
		OPT="$(HOST_CFLAGS)" \
		./configure --without-cxx-main --without-threads && \
		$(MAKE) python Parser/pgen && \
		mv python ./hostpython && \
		mv Parser/pgen ./hostpgen && \
		\
		$(MAKE) distclean && \
		./configure \
			--prefix=$(crossprefix) \
			--sysconfdir=$(crossprefix)/etc \
			--without-cxx-main \
			--without-threads && \
		$(MAKE) \
			TARGET_OS=$(build) \
			PYTHON_MODULES_INCLUDE="$(crossprefix)/include" \
			PYTHON_MODULES_LIB="$(crossprefix)/lib" \
			HOSTPYTHON=./hostpython \
			HOSTPGEN=./hostpgen \
			all install && \
		cp ./hostpgen $(crossprefix)/bin/pgen ) && \
	touch $@
