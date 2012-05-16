
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
	patch -p1 < $(buildprefix)/Patches/lzma_zlib-stream.diff && \
	gunzip -cd $(archivedir)/squashfs3.0.tar.gz | TAPE=- tar -x && \
	cd squashfs3.0 && patch -p1 < $(buildprefix)/Patches/mksquashfs_lzma.diff
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
	cd squashfs4.0/squashfs-tools && patch -p1 < $(buildprefix)/Patches/squashfs-tools-4.0-lzma.patch
	$(MAKE) -C @DIR_squashfs@/squashfs4.0/squashfs-tools
	$(INSTALL) -d $(@D)
	$(INSTALL) -m755 @DIR_squashfs@/squashfs4.0/squashfs-tools/mksquashfs $@
	$(INSTALL) -m755 @DIR_squashfs@/squashfs4.0/squashfs-tools/unsquashfs $(@D)
#	rm -rf @DIR_squashfs@
endif

#
# PYTHON-HOST
#
$(DEPDIR)/host_python: @DEPENDS_host_python@
	@PREPARE_host_python@ && \
	( cd @DIR_host_python@ && \
		rm -rf config.cache; \
		autoconf && \
		CONFIG_SITE= \
		OPT="$(HOST_CFLAGS)" \
		./configure \
			--without-cxx-main \
			--without-threads && \
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
	@DISTCLEANUP_host_python@
	touch $@
