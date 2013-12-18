
$(hostappsdir)/config.status: bootstrap
	cd $(hostappsdir) && \
	./autogen.sh && \
	./configure --prefix=$(hostprefix)

hostapps: $(hostappsdir)/config.status
	$(MAKE) -C $(hostappsdir)
#	touch $@

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

#
# PYTHON-HOST
#
$(DEPDIR)/host_python: @DEPENDS_host_python@
	@PREPARE_host_python@ && \
	( cd @DIR_host_python@ && \
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
			--prefix=$(hostprefix) \
			--sysconfdir=$(hostprefix)/etc \
			--without-cxx-main \
			--without-threads && \
		$(MAKE) \
			TARGET_OS=$(build) \
			PYTHON_MODULES_INCLUDE="$(hostprefix)/include" \
			PYTHON_MODULES_LIB="$(hostprefix)/lib" \
			HOSTPYTHON=./hostpython \
			HOSTPGEN=./hostpgen \
			all install && \
		cp ./hostpgen $(hostprefix)/bin/pgen ) && \
	@DISTCLEANUP_host_python@
	touch $@
