
$(flashprefix)/root-stock-cramfs/lib/ld-linux.so.2 \
$(flashprefix)/root-stock-squashfs/lib/ld-linux.so.2 \
$(flashprefix)/root-stock-jffs2/lib/ld-linux.so.2 \
$(flashprefix)/root-stock-usb/lib/ld-linux.so.2 \
$(flashprefix)/root-stock-focramfs/lib/ld-linux.so.2 \
$(flashprefix)/root-stock-fosquashfs/lib/ld-linux.so.2: \
%/lib/ld-linux.so.2: %
	find $</lib -maxdepth 1 -type f -o -type l | xargs rm -f
	find $</usr/lib -maxdepth 1 -type f -o -type l | xargs rm -f
	cp -d $(targetprefix)/lib/libnss_dns-?.*.so $</lib
	cp -d $(targetprefix)/lib/libnss_files-?.*.so $</lib
#	rm $</bin/sh
#	rm $</usr/sbin/lircd
#	rm $</usr/sbin/lircmd
	PATH=$(MAKE_PATH) $(MKLIBS) --target $(target) --ldlib ld-linux.so.2 --libc-extras-dir \
		$(targetprefix)/usr/lib \
		-d $</lib \
		-D -L $(mklibs_librarypath) \
		--root $< \
		`find $</bin/ -path "*bin/?*" -type f` \
		`find $</sbin/ -path "*sbin/?*" -type f` \
		`find $</usr/bin/ -path "*bin/?*" -type f` \
		`find $</usr/sbin/ -path "*sbin/?*" -type f` \
		`find $</var/bin/ -path "*bin/?*" -type f` \
		`find $(flashprefix)/root/var/xbin/ -path "*bin/?*" -type f` \
		`find $</lib/ -name "*.so" -type f`
	if [ -e $(targetprefix)/lib/libgcc_s-4.1.1.so.1 -a ! -e $</lib/libgcc_s-4.1.1.so.1 ]; then \
		cp $(targetprefix)/lib/libgcc_s-4.1.1.so.1 $</lib/libgcc_s-4.1.1.so.1 ; \
		ln -sf libgcc_s-4.1.1.so.1 $</lib/libgcc_s.so.1 ; \
	fi
	if [ -e $(targetprefix)/lib/libm-2.5.so -a ! -e $</lib/libm-2.5.so ]; then \
		cp $(targetprefix)/lib/libm-2.5.so $</lib/libm-2.5.so ; \
		ln -sf libm-2.5.so $</lib/libm.so.6 ; \
	fi
	if [ -e $(targetprefix)/lib/libpthread-2.5.so -a ! -e $</lib/libpthread-2.5.so ]; then \
		cp $(targetprefix)/lib/libpthread-2.5.so $</lib/libpthread-2.5.so ; \
		ln -sf libpthread-2.5.so $</lib/libpthread.so.0 ; \
	fi
	if [ -e $(targetprefix)/usr/lib/libstdc++.so.6.0.8 -a ! -e $</lib/libstdc++.so.6.0.8 ]; then \
		cp $(targetprefix)/usr/lib/libstdc++.so.6.0.8 $</lib/libstdc++.so.6.0.8 ; \
		ln -sf libstdc++.so.6.0.8 $</lib/libstdc++.so.6 ; \
	fi
	if [ -e $(targetprefix)/usr/lib/libz.so.1.2.3 -a ! -e $</lib/libz.so.1.2.3 ]; then \
		cp $(targetprefix)/usr/lib/libz.so.1.2.3 $</lib/libz.so.1.2.3 ; \
		ln -sf libz.so.1.2.3 $</lib/libz.so.1 ; \
	fi
	if [ -e $(targetprefix)/lib/librt-2.5.so -a ! -e $</lib/librt-2.5.so ]; then \
		cp $(targetprefix)/lib/librt-2.5.so $</lib/librt-2.5.so ; \
		ln -sf librt-2.5.so $</lib/librt.so.1 ; \
	fi
	if [ -e $(targetprefix)/usr/lib/libjpeg.so.62.0.0 -a ! -e $</lib/libjpeg.so.62.0.0 ]; then \
		cp $(targetprefix)/usr/lib/libjpeg.so.62.0.0 $</lib/ ; \
		ln -sf libjpeg.so.62.0.0 $</lib/libjpeg.so.62 ; \
	fi
	ln -sf /app/usr/lib/libvfsblkid.so $</lib/libvfsblkid.so
	PATH=$(MAKE_PATH) $(target)-strip --remove-section=.comment --remove-section=.note \
		`find $</bin/ -path "*bin/?*"` \
		`find $</sbin/ -path "*sbin/?*"` \
		`find $</usr/bin/ -path "*bin/?*"` \
		`find $</usr/sbin/ -path "*sbin/?*"` \
		`find $</var/bin/ -path "*bin/?*"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/gconv/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/autofs/* 2>/dev/null || /bin/true
#	ln -sf /bin/ash $</bin/sh
#	ln -sf /app/usr/local/bin/lircd $</usr/sbin/lircd
#	ln -sf /app/usr/local/bin/lircmd $</usr/sbin/lircmd
	chmod u+rwX,go+rX -R $</
	find $</lib -name '*.la' | xargs rm -f
	find $</usr/lib -name '*.la' | xargs rm -f
	rm -rf $</include

$(flashprefix)/root/strippy \
$(flashprefix)/root-stock-cramfs/strippy \
$(flashprefix)/root-stock-squashfs/strippy \
$(flashprefix)/root-stock-jffs2/strippy \
$(flashprefix)/var-stock-jffs2/strippy \
$(prefix)/cdkroot/strippy \
$(prefix)/cdkroot-nfs/strippy \
$(prefix)/min-cdkroot/strippy \
$(prefix)/std-cdkroot/strippy \
$(prefix)/max-cdkroot/strippy \
$(prefix)/ipk-cdkroot/strippy \
$(ipkgbuilddir)/strippy: \
%/strippy: 
	PATH=$(MAKE_PATH) $(target)-strip --remove-section=.comment --remove-section=.note \
		`find $*/bin/ -path "*bin/?*"` \
		`find $*/sbin/ -path "*sbin/?*"` \
		`find $*/usr/bin/ -path "*bin/?*"` \
		`find $*/usr/local/bin/ -path "*bin/?*"` \
		`find $*/usr/sbin/ -path "*sbin/?*"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $*/lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $*/usr/lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $*/usr/lib/gconv/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $*/usr/lib/autofs/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip `find $*/usr/lib/python*/ -path "*lib/?*"` 2>/dev/null || /bin/true


$(flashprefix)/root-enigma2-disk/lib/ld-linux.so.2: \
%/lib/ld-linux.so.2: %
	find $</lib -maxdepth 1 -type f -o -type l | xargs rm -f
	find $</usr/lib -maxdepth 1 -type f -o -type l | xargs rm -f
	cp -d $(targetprefix)/lib/libnss_dns-?.*.so $</lib
	cp -d $(targetprefix)/lib/libnss_files-?.*.so $</lib
	PATH=$(MAKE_PATH) $(MKLIBS) --target $(target) --ldlib ld-linux.so.2 --libc-extras-dir \
		$(targetprefix)/usr/lib \
		-d $</lib \
		-D -L $(mklibs_librarypath) \
		--root $< \
		`find $</bin/ -path "*bin/?*" -type f ! -name "*.sh" ! -name "*.static"` \
		`find $</sbin/ -path "*sbin/?*" -type f ! -name "*.sh" ! -name "*.static" ! -name fbcondecor_helper` \
		`find $</usr/bin/ -path "*bin/?*" -type f` \
		`find $</usr/sbin/ -path "*sbin/?*" -type f` \
		`find $</usr/local/bin/ -path "*bin/?*" -type f` \
		`find $</lib/ -name "*.so" -type f` \
		`find $</usr/lib/ -name "*.so" -type f`
#	if [ -e $(targetprefix)/lib/libgcc_s-4.1.1.so.1 -a ! -e $</lib/libgcc_s-4.1.1.so.1 ]; then \
#		cp $(targetprefix)/lib/libgcc_s-4.1.1.so.1 $</lib/libgcc_s-4.1.1.so.1 ; \
#		ln -sf libgcc_s-4.1.1.so.1 $</lib/libgcc_s.so.1 ; \
#	fi
#	if [ -e $(targetprefix)/lib/libm-2.5.so -a ! -e $</lib/libm-2.5.so ]; then \
#		cp $(targetprefix)/lib/libm-2.5.so $</lib/libm-2.5.so ; \
#		ln -sf libm-2.5.so $</lib/libm.so.6 ; \
#	fi
#	if [ -e $(targetprefix)/lib/libpthread-2.5.so -a ! -e $</lib/libpthread-2.5.so ]; then \
#		cp $(targetprefix)/lib/libpthread-2.5.so $</lib/libpthread-2.5.so ; \
#		ln -sf libpthread-2.5.so $</lib/libpthread.so.0 ; \
#	fi
#	if [ -e $(targetprefix)/usr/lib/libstdc++.so.6.0.8 -a ! -e $</lib/libstdc++.so.6.0.8 ]; then \
#		cp $(targetprefix)/usr/lib/libstdc++.so.6.0.8 $</lib/libstdc++.so.6.0.8 ; \
#		ln -sf libstdc++.so.6.0.8 $</lib/libstdc++.so.6 ; \
#	fi
#	if [ -e $(targetprefix)/usr/lib/libz.so.1.2.3 -a ! -e $</lib/libz.so.1.2.3 ]; then \
#		cp $(targetprefix)/usr/lib/libz.so.1.2.3 $</lib/libz.so.1.2.3 ; \
#		ln -sf libz.so.1.2.3 $</lib/libz.so.1 ; \
#	fi
#	if [ -e $(targetprefix)/lib/librt-2.5.so -a ! -e $</lib/librt-2.5.so ]; then \
#		cp $(targetprefix)/lib/librt-2.5.so $</lib/librt-2.5.so ; \
#		ln -sf librt-2.5.so $</lib/librt.so.1 ; \
#	fi
	if [ -e $(targetprefix)/usr/lib/libdvdcss.so.2.0.8  ]; then \
		cp $(targetprefix)/usr/lib/libdvdcss.so.2.0.8 $</lib/ ; \
		ln -sf libdvdcss.so.2.0.8 $</lib/libdvdcss.so.2 ; \
	fi
	PATH=$(MAKE_PATH) $(target)-strip --remove-section=.comment --remove-section=.note \
		`find $</bin/ -path "*bin/?*"` \
		`find $</sbin/ -path "*sbin/?*"` \
		`find $</usr/bin/ -path "*bin/?*"` \
		`find $</usr/sbin/ -path "*sbin/?*"` \
		`find $</usr/local/bin/ -path "*bin/?*"` \
		`find $</var/bin/ -path "*bin/?*"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/gconv/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/python2.6/lib-dynload/* 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip `find $</usr/lib/python2.6/site-packages/* -type f -name "*.so"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip `find $</usr/lib/enigma2/* -type f -name "*.so"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip `find $</usr/lib/alsaplayer/* -type f -name "*.so"` 2>/dev/null || /bin/true
	PATH=$(MAKE_PATH) $(target)-strip $</usr/lib/autofs/* 2>/dev/null || /bin/true
	chmod u+rwX,go+rX -R $</
	find $</lib -name '*.la' | xargs rm -f
	find $</usr/lib -name '*.la' | xargs rm -f
	rm -rf $</include
