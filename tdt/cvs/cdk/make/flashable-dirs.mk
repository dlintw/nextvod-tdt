
####### app
$(flashprefix)/app-stock-enigma2: \
$(flashprefix)/app-%-enigma2: \
		$(stockdir)/.app $(flashprefix)/app-stock-enigma2
	$(INSTALL) -d $@
	mkdir $@/{bin,elfs,usr,modules}
	mkdir $@/usr/{bin,lib,local,sbin,share}
	( cd $@/usr/sbin && ln -sf /bin/busybox chroot && ln -sf /bin/busybox crond && ln -sf /bin/busybox fbset && ln -sf /bin/busybox httpd \
			 && ln -sf /bin/busybox inetd && ln -sf /bin/busybox setlogcons && ln -sf /bin/busybox telnetd)
	cp -rd $(prefix)/release/sbin/sfdisk $@/usr/sbin/
	cp -rd $(prefix)/release/boot/{audio.elf,video.elf} $@/elfs
	cp -rd $(prefix)/release/usr/bin/* $@/usr/bin/
	rm -f $@/usr/bin/{tuxtxt,showiframe}
	cp -rd $(prefix)/release/bin/{stslave,showiframe,streamproxy,vdstandby,vfdctl,tfd2mtd,tffpctl,gotosleep} $@/usr/bin
#	cp -rd $(prefix)/release/lib/modules/player2.ko $@/modules
#new
#	cp -rd $(flashprefix)/root/usr/bin/strace $@/usr/bin
	cp -rd $(prefix)/release/lib/{libdreamdvd.so,libdreamdvd.so.0,libdreamdvd.so.0.0.0} $@/usr/lib
	cp -a $(prefix)/release/usr/lib/* $@/usr/lib/
	rm -rf $@/usr/lib/enigma2
	rm -rf $@/usr/lib/python2.6/{hotshot,idlelib,json,lib2to3,lib-old,lib-tk,multiprocessing,plat-linux2,sqlite3,wsgiref}
	rm -rf $@/usr/lib/python2.6/site-packages/{lxml-2.0.5-py2.6.egg-info,OpenSSL,setuptools-0.6c8-py2.6.egg-info,twisted,Twisted-8.2.0-py2.6.egg-info,zope.interface-3.3.0-py2.6.egg-info}
	rm -f $@/usr/lib/python2.6/{*.py,*.pyo}
	cp -rd $(prefix)/release/usr/lib//python2.6/{bisect.py,collections.py,functools.py,gettext.py,keyword.py,locale.py,mimetypes.py,new.py,socket.py,ssl.py,struct.py,textwrap.py,tokenize.py,token.py,urllib.py,urlparse.py,weakref.py} $@/usr/lib/python2.6
	rm -f $@/usr/lib/python2.6/encodings/{*.py,*.pyo}
	cp -rd $(prefix)/release/usr/lib//python2.6/encodings/{ascii.py,utf_16_be.py} $@//usr/lib/python2.6/encodings
	rm -f $@/usr/lib/python2.6/lib-dynload/{*.py,*.pyo}
	rm -f $@/usr/lib/python2.6/lib-dynload/{_codecs_cn.so,_codecs_hk.so,_codecs_jp.so,_codecs_kr.so,_codecs_tw.so,Python-2.6-py2.6.egg-info,_testcapi.so}
	rm -f $@/usr/lib/python2.6/site-packages/{*.py,*.pyo}
	( cd $@/usr/lib && ln -sf /var/python/enigma2 enigma2 \
			&& ln -sf /var/lib/libeplayer2.so.0 libeplayer2.so.0)
	( cd $@/usr/local && ln -sf /var/bin bin)
	mkdir $@/usr/local/{etc,share}
	( cd $@/usr/local/etc && ln -sf /usr/local/share/enigma2 enigma2 \
			      && ln -sf /var/config/keymaps keymaps )
	( cd $@/usr/local/share && ln -sf /config/enigma2/config enigma2)
	( cd $@/usr/share && ln -sf /usr/local/share/enigma2 enigma2 \
			  && ln -sf /var/fonts fonts \
			  && ln -sf /var/config/keymaps keymaps \
			  && ln -sf /config/zoneinfo zoneinfo)
	rm -f $@/usr/lib/{libalsaplayer.so,libalsaplayer.so.0,libalsaplayer.so.0.0.2,libasound.so,libasound.so.2,libasound.so.2.0.0}
	rm -f $@/usr/lib/{libcrypto.so,libcrypto.so.0.9.8,libfontconfig.so,libfontconfig.so.1,libfontconfig.so.1.3.0,libform.so,libform.so.5,libform.so.5.5}
	rm -f $@/usr/lib/{libncurses.so,libncurses.so.5,libreadline.so,libreadline.so.5,libreadline.so.5.2,libssl.so,libssl.so.0.9.8,xml2Conf.sh,xsltConf.sh}
	rm -f $@/usr/lib/{libdvdnavmini.so,libdvdnavmini.so.4,libdvdnavmini.so.4.1.2,libfbsplashrender.so,libfbsplashrender.so.1,libfbsplashrender.so.1.0.0}
	rm -f $@/usr/lib/{libfbsplash.so,libfbsplash.so.1,libfbsplash.so.1.0.0,liblcms.so,liblcms.so.1,liblcms.so.1.0.16}
	rm -f $@/usr/lib/python2.6/site-packages/{elementtree-1.2.6_20050316-py2.6.egg-info,pyOpenSSL-0.8-py2.6.egg-info,README,Twisted_Web2-8.2.0-py2.6.egg-info}
	rm -f $@/usr/lib/python2.6/site-packages/elementtree/{*.py,*.pyo}
	rm -rd $@/usr/lib/python2.6/site-packages/zope/interface/tests
	rm -rd $@/usr/lib/python2.6/site-packages/zope/interface/common/tests
	rm -f $@/usr/lib/python2.6/site-packages/zope/interface/{*.py,*.pyo}
	rm -f $@/usr/lib/python2.6/site-packages/zope/interface/{adapter.txt,human.ru.txt,human.txt,PUBLICATION.cfg,README.ru.txt,README.txt,_zope_interface_coptimizations.c}
	rm -f $@/usr/lib/python2.6/site-packages/zope/interface/common/{*.py,*.pyo}
	rm -f $@/usr/lib/python2.6/logging/{*.py,*.pyo}
	( cd $@/usr/lib/python2.6/site-packages && ln -sf /mnt/usb/twisted twisted )
	touch $@
	@TUXBOX_CUSTOMIZE@

####### conf

$(flashprefix)/conf-stock-jffs2: \
$(flashprefix)/conf-%-jffs2: \
		$(stockdir)/conf $(flashprefix)/conf-stock
	-rm -rf $@
	-cp -rd $< $@
	-cp -rd $(word 2,$^)/* $@
	touch $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/conf-stock-enigma2: \
$(flashprefix)/conf-%-enigma2: \
		$(stockdir)/conf $(flashprefix)/conf-stock
	-rm -rf $@
	-cp -rd $< $@
	-cp -rd $(word 2,$^)/* $@
#	cp -rd $(buildprefix)/root/ufs910_flash/config/* $@/
#	( cd $@/enigma2/config && ln -sf /var/config/skin_default skin_default)
#	rm -f $@/enigma2/config/{lamedb,.svn}
#	rm -rd $@/enigma2/config/{countries,extensions,po}
#	( cd $@/enigma2/config && ln -sf /var/config/skin_default skin_default \
#				&& ln -sf /var/config/countries countries \
#				&& ln -sf /var/config/extensions extensions \
#				&& ln -sf /var/config/po po \
#				&& ln -sf /var/config/lamedb lamedb)
	mkdir $@/etc
	mkdir $@/etc/network
	cp -rd $(prefix)/release/etc/network/* $@/etc/network
	cp -rd $(prefix)/release/etc/resolv.conf $@/etc
	mkdir $@/enigma2
	mkdir $@/enigma2/config
	cp -rd $(prefix)/release/usr/local/share/enigma2/* $@/enigma2/config
	rm -rd $@/enigma2/config/{defaults,skin_default}
	( cd $@/enigma2/config && ln -sf /var/config/skin_default skin_default)
	rm -f $@/enigma2/config/countries/{ad.png,ae.png,cz.png,dk.png,es.png,fi.png,fr.png,gr.png,hr.png,hu.png,is.png,it.png,lt.png lv.png,missing.png,nl.png,no.png,pl.png,pt.png,ro.png,ru.png,se.png,si.png,tr.png,ua.png,x-fy.png}
	rm -rd $@/enigma2/config/po/{ar,ca,cs,da,el,es,fi,fr,fy,hr,hu,is,it,lt,lv,nl,no,pl,pt,ru,sv,tr,uk}
	touch $@
	@TUXBOX_CUSTOMIZE@

####### root

$(flashprefix)/root-stock-cramfs \
$(flashprefix)/root-stock-squashfs: \
$(flashprefix)/root-stock-%: \
			$(flashprefix)/root $(flashprefix)/root-stock $(flashprefix)/root-%
	rm -rf $@
	cp -rd $< $@
	cp -rd $(flashprefix)/root-stock/* $@
	cp -rd $(flashprefix)/root-$*/* $@
	[ "$*" == "cramfs" ] || [ "$*" == "squashfs" ] && \
		( rm -rf $@/var/* || true && \
		cd $@/etc && for i in $(ETC_RW_FILES); do \
			[ -f $$i ] && ( rm $$i && ln -sf /var/etc/$$i $@/etc/$$i ) || true && \
			[ "$$i" == "nologin" ] && ( ln -sf /var/etc/$$i $@/etc/$$i ) || true; done && \
			sed -e "s|^proc|/dev/mtdblock6     /var     jffs2     defaults     0 0\nproc|g" -i fstab || true && \
		$(INSTALL) -d $@/{app,config,data} && \
		( cd $@/root && rm modules26 && \
				ln -s /var/root/modules26 modules26 ) && \
		( cd $@/usr/sbin && rm lircd lircmd && \
				ln -sf /var/bin/lircd lircd && \
				ln -sf /var/bin/lircmd lircmd ) && \
		( cd $@/etc && rm lircd.conf lircmd.conf && \
				ln -sf /var/etc/lircd.conf lircd.conf && \
				ln -sf /var/etc/lircmd.conf lircmd.conf ) ) || true
#	rm -rf $@/boot
	echo "tmpfs         /var/run            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lock           tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/tmp            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/log            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lib/urandom    tmpfs   defaults                        0 0" >> $@/etc/fstab
	-rm -rf $@/usr/lib/gconv
#	mkdir $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/gconv-modules $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/ISO8859* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/UTF* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM937.so $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM850.so $@/usr/lib/gconv
	-rm -rf $@/usr/include
	-rm -rf $@/usr/local
	-rm $@/usr/bin/local*
	-rm -rf $@/usr/X11R6
	-rm -rf $@/usr/share/{doc,info,locale,man,misc,nls}
	-rm -rf $@/usr/share/zoneinfo
	mkdir $@/usr/share/zoneinfo
	cp -rd $</usr/share/zoneinfo/Europe $@/usr/share/zoneinfo
	-rm $@/sbin/ldconfig
	-rm $@/sbin/sln
	-rm $@/sbin/MAKEDEV
	-rm $@/sbin/sulogin
	-rm $@/usr/bin/{catchsegv,getent,iconv,rpcgen,zdump,tzselect,utmpdump}
	-rm $@/usr/sbin/{shellconfig,sh4-linux-shellconfig}
	-rm $@/usr/sbin/{iconvconfig,tzconfig,update-passwd,zic}
	-rm $@/lib/modules/$(KERNELVERSION)/kernel/drivers/i2c/busses/*
	-rm -rf $@/usr/share/base-passwd
	-rm -rf $@/usr/libexec
	-rm -rf $@/lib/modules/2.6.17.14_stm22_0041/kernel/fs
	-rm -f $@/bin/{showiframe,stfbcontrol,stfbset,stslave}
	-rm -f $@/lib/{libipkg.so.0,libjpeg.so.62,libjpeg.so.62.0.0}
	-rm -f $@/usr/bin/{ip*,ir*}
	rm $@/lib/ld-linux.so.2
	$(MAKE) --assume-old=$@ $@/lib/ld-linux.so.2 \
		mklibs_librarypath=$</lib:$</usr/lib:$</usr/lib/gconv:$</usr/lib/autofs:$(targetprefix)/lib:$(targetprefix)/usr/lib
	$(target)-strip --remove-section=.comment --remove-section=.note $@/bin/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/media/dvb/dvb-core/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/media/dvb/frontend/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/net/smsc_911x/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/usb/serial/* 2>/dev/null || /bin/true && \
	touch $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/root-stock-jffs2 \
$(flashprefix)/root-stock-tgz \
$(flashprefix)/root-stock-focramfs \
$(flashprefix)/root-stock-fosquashfs: \
$(flashprefix)/root-stock-%: \
			$(flashprefix)/root $(flashprefix)/root-stock $(flashprefix)/root-%
	rm -rf $@
	cp -rd $< $@
	cp -rd $(flashprefix)/root-stock/* $@
	cp -rd $(flashprefix)/root-$*/* $@
	echo "tmpfs         /var                tmpfs   defaults                        0 0" >> $@/etc/fstab
if ENABLE_OSD910
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libfreetype.so.6.3.3 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libfreetype.so.6.3.3 -a \
		-e $(targetprefix)/usr/lib/libfreetype.so.6.3.3 ]; then \
		cp $(targetprefix)/usr/lib/libfreetype.so.6.3.3 $@/lib/libfreetype.so.6.3.3 ; \
		ln -sf libfreetype.so.6.3.3 $@/lib/libfreetype.so.6 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libjpeg.so.62.0.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libjpeg.so.62.0.0 -a \
		-e $(targetprefix)/usr/lib/libjpeg.so.62.0.0 ]; then \
		cp $(targetprefix)/usr/lib/libjpeg.so.62.0.0 $@/lib/libjpeg.so.62.0.0 ; \
		ln -sf libjpeg.so.62.0.0 $@/lib/libjpeg.so.62 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/liblirc_client.so.0.2.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/liblirc_client.so.0.2.0 -a \
		-e $(targetprefix)/usr/lib/liblirc_client.so.0.2.0 ]; then \
		cp $(targetprefix)/usr/lib/liblirc_client.so.0.2.0 $@/lib/liblirc_client.so.0.2.0 ; \
		ln -sf liblirc_client.so.0.2.0 $@/lib/liblirc_client.so.0 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libpng12.so.0.16.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libpng12.so.0.16.0 -a \
		-e $(targetprefix)/usr/lib/libpng12.so.0.16.0 ]; then \
		cp $(targetprefix)/usr/lib/libpng12.so.0.16.0 $@/lib/libpng12.so.0.16.0 ; \
		ln -sf libpng12.so.0.16.0 $@/lib/libpng12.so.0 ; \
	fi
endif
#	rm -rf $@/boot
	-rm -rf $@/usr/lib/gconv
#	mkdir $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/gconv-modules $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/ISO8859* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/UTF* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM937.so $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM850.so $@/usr/lib/gconv
	-rm -rf $@/usr/include
	-rm -rf $@/usr/local
	-rm $@/usr/bin/local*
	-rm -rf $@/usr/X11R6
	-rm -rf $@/usr/share/{doc,info,locale,man,misc,nls}
	-rm -rf $@/usr/share/zoneinfo
	mkdir $@/usr/share/zoneinfo
	cp -rd $</usr/share/zoneinfo/Europe $@/usr/share/zoneinfo
	-rm $@/sbin/ldconfig
	-rm $@/sbin/sln
	-rm $@/sbin/MAKEDEV
	-rm $@/sbin/sulogin
	-rm $@/usr/bin/{catchsegv,getent,iconv,rpcgen,zdump,tzselect,utmpdump}
	-rm $@/usr/sbin/{shellconfig,sh4-linux-shellconfig}
	-rm $@/usr/sbin/{iconvconfig,tzconfig,update-passwd,zic}
	-rm $@/lib/modules/$(KERNELVERSION)/kernel/drivers/i2c/busses/*
	-rm -rf $@/usr/share/base-passwd
	-rm -rf $@/usr/libexec
	rm $@/lib/ld-linux.so.2
	$(MAKE) --assume-old=$@ $@/lib/ld-linux.so.2 \
		mklibs_librarypath=$</lib:$</usr/lib:$</usr/lib/gconv:$</usr/lib/autofs:$(targetprefix)/lib:$(targetprefix)/usr/lib
	touch $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/root-stock-enigma2: \
$(flashprefix)/root-stock-%: \
			$(flashprefix)/root $(flashprefix)/root-stock $(flashprefix)/root-squashfs
	rm -rf $@
	rm -rf $@/{app,app.static,bin,boot,config,data,dev,dev.static,jffs,lib,media,mnt,opt,proc,ram,ramdisk,rom,root,sbin,srv,sys,tmp,usr,var}
	$(INSTALL) -d $@/{app,config,dev,lib,usr,var}
	( cd $@/usr && ln -sf /app/usr/bin bin \
		    && ln -sf /app/usr/lib lib \
		    && ln -sf /app/usr/local local \
		    && ln -sf /app/usr/sbin sbin \
		    && ln -sf /app/usr/share share)
	cp -rd $(prefix)/release/{bin,etc,hdd,media,mnt,proc,ram,root,sbin,sys,tmp} $@/
	cp -rd $(buildprefix)/root/ufs910_flash/etc/rcS $@/etc/init.d
	cp -rd $(buildprefix)/root/release/rc $@/etc/init.d
	rm -rd $@/etc/network
	( cd $@/etc && ln -sf /config/etc/network network)
	rm -f $@/etc/resolv.conf
	( cd $@/etc && ln -sf /config/etc/resolv.conf resolv.conf)
	rm -f $@/bin/{devinit,stslave,hdmi-control,hdmi-info,showiframe,stfbcontrol,stfbset,streamproxy,splash_util.static,vdstandby,vfdctl,tfd2mtd,tffpctl,rset,gotosleep}
	( cd $@/bin && ln -sf /usr/bin/stslave stslave \
		    && ln -sf /var/bin/stfbcontrol stfbcontrol \
		    && ln -sf /usr/bin/showiframe showiframe \
		    && ln -sf /usr/bin/strace strace \
		    && ln -sf /usr/bin/streamproxy streamproxy \
		    && ln -sf /usr/bin/vdstandby vdstandby \
		    && ln -sf /usr/bin/vfdctl vfdctl \
		    && ln -sf /usr/bin/gotosleep gotosleep \
		    && ln -sf /usr/bin/tfd2mtd tfd2mtd \
		    && ln -sf /usr/bin/tffpctl tffpctl )
	rm -f $@/sbin/{fsck.ext2,fsck.ext3,fsck.nfs,mke2fs,mkfs.ext2,mkfs.ext3,sfdisk}
	sed -e "s|^proc|/dev/mtdblock2     /config     jffs2     defaults     0 0\nproc|g" -i $@/etc/fstab
	sed -e "s|^proc|/dev/mtdblock4     /app     squashfs     defaults     0 0\nproc|g" -i $@/etc/fstab
	sed -e "s|^proc|/dev/mtdblock6     /var     jffs2     defaults     0 0\nproc|g" -i $@/etc/fstab
	echo "tmpfs         /var/run            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lock           tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/tmp            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/log            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lib/urandom    tmpfs   defaults                        0 0" >> $@/etc/fstab
	cp -rd $(prefix)/release/lib/{ld-2.5.so,ld-linux.so.2,libanl-2.5.so,libanl.so.1,libblkid.so.1,libblkid.so.1.0,libBrokenLocale-2.5.so,libBrokenLocale.so.1} $@/lib
	cp -rd $(prefix)/release/lib/{libc-2.5.so,libcom_err.so.2,libcom_err.so.2.1,libcrypt-2.5.so,libcrypt.so.1,libc.so.6,libdl-2.5.so,libdl.so.2} $@/lib
	cp -rd $(prefix)/release/lib/{libext2fs.so.2,libext2fs.so.2.4,libm-2.5.so,libm.so.6,libgcc_s-4.1.1.so.1,libgcc_s.so.1} $@/lib
	cp -rd $(prefix)/release/lib/{libnsl-2.5.so,libnsl.so.1,libpcprofile.so,libpthread-2.5.so,libpthread.so.0} $@/lib
	cp -rd $(prefix)/release/lib/{libresolv-2.5.so,libresolv.so.2,librt-2.5.so,librt.so.1,libSegFault.so,libthread_db-1.0.so,libthread_db.so.1} $@/lib
	cp -rd $(prefix)/release/lib/{libutil-2.5.so,libutil.so.1,libuuid.so.1,libuuid.so.1.2} $@/lib
	cp -rd $(prefix)/release/lib/{firmware,lsb,modules} $@/lib
	( cd $@/lib && ln -sf /var/lib/libe2p.so.2 libep2.so.2 \
		    && ln -sf /var/lib/libe2p.so.2.3 libep2.so.2.3 \
		    && ln -sf /var/lib/libnss_compat-2.5.so libnss_compat-2.5.so \
		    && ln -sf /var/lib/libnss_compat.so.2 libnss_compat.so.2 \
		    && ln -sf /var/lib/libnss_dns-2.5.so libnss_dns-2.5.so \
		    && ln -sf /var/lib/libnss_dns.so.2 libnss_dns.so.2 \
		    && ln -sf /var/lib/libnss_files.so.2 libnss_files.so.2 \
		    && ln -sf /var/lib/libnss_files-2.5.so libnss_files-2.5.so \
		    && ln -sf /var/lib/libnss_hesiod-2.5.so libnss_hesiod-2.5.so \
		    && ln -sf /var/lib/libnss_hesiod.so.2 libnss_hesiod.so.2 \
		    && ln -sf /var/lib/libnss_nis.so.2 libnss_nis.so.2 \
		    && ln -sf /var/lib/libnss_nis-2.5.so libnss_nis-2.5.so \
		    && ln -sf /var/lib/libnss_nisplus-2.5.so libnss_nisplus-2.5.so \
		    && ln -sf /var/lib/libnss_nisplus.so.2 libnss_nisplus.so.2 \
		    && ln -sf /var/lib/libss.so.2 libss.so.2 \
		    && ln -sf /var/lib/libss.so.2.0 libss.so.2.0 )
	cp -rd $(flashprefix)/root-squashfs/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/media/dvb/dvb-core/dvb-core.ko $@/lib/modules
	cp -rd $(flashprefix)/root-squashfs/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/media/dvb/frontends/dvb-pll.ko $@/lib/modules
	cp -rd $(flashprefix)/root-squashfs/lib/modules/2.6.17.14_stm22_0041/kernel/drivers/net/smsc_911x/smsc911x.ko $@/lib/modules
	find $@/lib/modules/ -name  *.ko -exec sh4-linux-strip --strip-unneeded {} \;
	@TUXBOX_CUSTOMIZE@

####### var and data

$(flashprefix)/var-stock-jffs2: \
$(flashprefix)/var-%-jffs2: \
		$(flashprefix)/root $(flashprefix)/root-stock
	rm -rf $@
	cp -rd $</var $@
	-cp -rd $(flashprefix)/root-stock/var/* $@
	$(INSTALL) -d $@/etc/{default,init.d,network,opt}
	cd $</etc && \
	for i in $(ETC_RW_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $@/etc/$$i || true; \
		[ -f $$i -a "$${i%%/*}" = "init.d" ] && chmod 755 $@/etc/$$i || true; done
	cd $(word 2,$^)/etc && \
	for i in $(ETC_RW_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $@/etc/$$i || true; \
		[ -f $$i -a "$${i%%/*}" = "init.d" ] && chmod 755 $@/etc/$$i || true; done
	$(INSTALL) -d $@/{bin,root} && \
	( cd $@/bin && ln -sf /app/usr/local/bin/lircd lircd && \
			ln -sf /app/usr/local/bin/lircmd lircmd ) && \
	( cd $@/root && ln -s /app/modules_sys/modules26 modules26 )
	( cd $@/etc && ln -sf /app/script/lircd.conf lircd.conf && \
			ln -sf /app/script/lircmd.conf lircmd.conf && \
			sed -e "s|/root|/var/root|g" -i passwd )
if ENABLE_VAR
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libgcc_s-4.1.1.so.1 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libgcc_s-4.1.1.so.1 -a \
		-e $(targetprefix)/lib/libgcc_s-4.1.1.so.1 ]; then \
		cp $(targetprefix)/lib/libgcc_s-4.1.1.so.1 $@/lib/libgcc_s-4.1.1.so.1 ; \
		ln -sf libgcc_s-4.1.1.so.1 $@/lib/libgcc_s.so.1 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libm-2.5.so -a ! -e $(flashprefix)/root-stock-squashfs/lib/libm-2.5.so -a \
		-e $(targetprefix)/lib/libm-2.5.so ]; then \
		cp $(targetprefix)/lib/libm-2.5.so $@/lib/libm-2.5.so ; \
		ln -sf libm-2.5.so $@/lib/libm.so.6 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libpthread-2.5.so -a ! -e $(flashprefix)/root-stock-squashfs/lib/libpthread-2.5.so -a \
		-e $(targetprefix)/lib/libpthread-2.5.so ]; then \
		cp $(targetprefix)/lib/libpthread-2.5.so $@/lib/libpthread-2.5.so ; \
		ln -sf libpthread-2.5.so $@/lib/libpthread.so.0 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libstdc++.so.6.0.8 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libstdc++.so.6.0.8 -a \
		-e $(targetprefix)/usr/lib/libstdc++.so.6.0.8 ]; then \
		cp $(targetprefix)/usr/lib/libstdc++.so.6.0.8 $@/lib/libstdc++.so.6.0.8 ; \
		ln -sf libstdc++.so.6.0.8 $@/lib/libstdc++.so.6 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libz.so.1.2.3 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libz.so.1.2.3 -a \
		-e $(targetprefix)/usr/lib/libz.so.1.2.3 ]; then \
		cp $(targetprefix)/usr/lib/libz.so.1.2.3 $@/lib/libz.so.1.2.3 ; \
		ln -sf libz.so.1.2.3 $@/lib/libz.so.1 ; \
	fi
if ENABLE_OSD910
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libfreetype.so.6.3.3 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libfreetype.so.6.3.3 -a \
		-e $(targetprefix)/usr/lib/libfreetype.so.6.3.3 ]; then \
		cp $(targetprefix)/usr/lib/libfreetype.so.6.3.3 $@/lib/libfreetype.so.6.3.3 ; \
		ln -sf libfreetype.so.6.3.3 $@/lib/libfreetype.so.6 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libjpeg.so.62.0.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libjpeg.so.62.0.0 -a \
		-e $(targetprefix)/usr/lib/libjpeg.so.62.0.0 ]; then \
		cp $(targetprefix)/usr/lib/libjpeg.so.62.0.0 $@/lib/libjpeg.so.62.0.0 ; \
		ln -sf libjpeg.so.62.0.0 $@/lib/libjpeg.so.62 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/liblirc_client.so.0.2.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/liblirc_client.so.0.2.0 -a \
		-e $(targetprefix)/usr/lib/liblirc_client.so.0.2.0 ]; then \
		cp $(targetprefix)/usr/lib/liblirc_client.so.0.2.0 $@/lib/liblirc_client.so.0.2.0 ; \
		ln -sf liblirc_client.so.0.2.0 $@/lib/liblirc_client.so.0 ; \
	fi
	if [ ! -e $(flashprefix)/root-stock-cramfs/lib/libpng12.so.0.16.0 -a ! -e $(flashprefix)/root-stock-squashfs/lib/libpng12.so.0.16.0 -a \
		-e $(targetprefix)/usr/lib/libpng12.so.0.16.0 ]; then \
		cp $(targetprefix)/usr/lib/libpng12.so.0.16.0 $@/lib/libpng12.so.0.16.0 ; \
		ln -sf libpng12.so.0.16.0 $@/lib/libpng12.so.0 ; \
	fi
endif
endif
	$(target)-strip --remove-section=.comment --remove-section=.note $@/bin/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/* 2>/dev/null || /bin/true && \
	touch $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/var-stock-enigma2: \
$(flashprefix)/var-%-enigma2: \
		$(flashprefix)/root $(flashprefix)/root-stock
	rm -rf $@
	cp -rd $</var $@
	-cp -rd $(flashprefix)/root-stock/var/* $@
	$(INSTALL) -d $@/etc/{default,init.d,network,opt}
	cd $</etc && \
	for i in $(ETC_RW_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $@/etc/$$i || true; \
		[ -f $$i -a "$${i%%/*}" = "init.d" ] && chmod 755 $@/etc/$$i || true; done
	cd $(word 2,$^)/etc && \
	for i in $(ETC_RW_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $@/etc/$$i || true; \
		[ -f $$i -a "$${i%%/*}" = "init.d" ] && chmod 755 $@/etc/$$i || true; done
	$(INSTALL) -d $@/{bin,root} && \
	( cd $@/bin && ln -sf /app/usr/local/bin/lircd lircd && \
			ln -sf /app/usr/local/bin/lircmd lircmd ) && \
	( cd $@/root && ln -s /app/modules_sys/modules26 modules26 )
	( cd $@/etc && ln -sf /app/script/lircd.conf lircd.conf && \
			ln -sf /app/script/lircmd.conf lircmd.conf && \
			sed -e "s|/root|/var/root|g" -i passwd )
#enigma2
	rm -f $@/bin/*
	rm -rd $@/etc/*
	cp $(prefix)/release/boot/bootlogo.mvi $@/bin
	cp -rd $(prefix)/release/lib/{libe2p.so.2,libe2p.so.2.3,libnss_compat-2.5.so,libnss_compat.so.2,libnss_dns-2.5.so,libnss_dns.so.2,libnss_files-2.5.so,libnss_files.so.2,libnss_hesiod-2.5.so,libnss_hesiod.so.2,libnss_nis-2.5.so,libnss_nisplus-2.5.so,libnss_nisplus.so.2,libnss_nis.so.2,libss.so.2,libss.so.2.0,libeplayer2.so,libeplayer2.so.0,libeplayer2.so.0.0.0} $@/lib
	cp $(prefix)/release/usr/local/bin/enigma2 $@/bin
	cp -rd $(prefix)/release/bin/stfbcontrol $@/bin
	mkdir $@/{config,fonts,python}
	mkdir $@/config/{skin_default,keymaps}
	cp -rd $(prefix)/release/usr/local/share/enigma2/skin_default/* $@/config/skin_default
	cp $(prefix)/release/usr/share/fonts/{ae_AlMateen.ttf,lcd.ttf,nmsbd.ttf,tuxtxt.ttf} $@/fonts
	mkdir $@/python/enigma2
	mkdir $@/python/enigma2/python
	cp -rd $(prefix)/release/usr/lib/enigma2/python/* $@/python/enigma2/python/
	rm -f $@/python/enigma2/python/{*.py,*.pyo}
	cp -rd $(prefix)/release/usr/lib/enigma2/python/{mytest.py,enigma.py} $@/python/enigma2/python/
	rm -f $@/python/enigma2/python/Components/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Components/Converter/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Components/Renderer/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Components/Sources/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Tools/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Screens/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/{*.py,*.pyo}
	rm -rf $@/python/enigma2/python/Plugins/DemoPlugins
	rm -rf $@/python/enigma2/python/Plugins/Extensions/CutListEditor
	rm -rf $@/python/enigma2/python/Plugins/Extensions/DVDBurn
	rm -rf $@/python/enigma2/python/Plugins/Extensions/FileManager
#	rm -rf $@/python/enigma2/python/Plugins/Extensions/PicturePlayer
	rm -rf $@/python/enigma2/python/Plugins/Extensions/SocketMMI
	rm -rf $@/python/enigma2/python/Plugins/Extensions/TuxboxPlugins
	rm -rf $@/python/enigma2/python/Plugins/Extensions/WebInterface
	rm -f $@/python/enigma2/python/Plugins/Extensions/DVDPlayer/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/Extensions/GraphMultiEPG/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/Extensions/IpkgInstaller/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/Extensions/MediaPlayer/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/Extensions/MediaScanner/{*.py,*.pyo}
	rm -rf $@/python/enigma2/python/Plugins/SystemPlugins/{ConfigurationBackup,DefaultServicesScanner,DiseqcTester,FrontprocessorUpgrade,NFIFlash,SoftwareUpdate,VideoTune}
	rm -rf $@/python/enigma2/python/Plugins/SystemPlugins/{CommonInterfaceAssignment,SoftwareManager,Tuxtxt}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/PositionerSetup/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/Satfinder/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/SatelliteEquipmentControl/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/Hotplug/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/SkinSelector/{*.py,*.pyo}
	rm -f $@/epython/enigma2/python/Plugins/SystemPlugins/Tuxtxt/{*.py,*.pyo}
	rm -f $@/python/enigma2/python/Plugins/SystemPlugins/VFD-Icons/{*.py,*.pyo}
	rm -f $@/epython/enigma2/python/Plugins/SystemPlugins/Videomode/{*.py,*.pyo}
	$(target)-strip --remove-section=.comment --remove-section=.note $@/bin/* 2>/dev/null || /bin/true && \
	$(target)-strip $@/lib/* 2>/dev/null || /bin/true && \
	touch $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/data-stock-jffs2: \
$(flashprefix)/data-%-jffs2: \
		$(flashprefix)/root $(flashprefix)/root-stock
	-rm -rf $@
	$(INSTALL) -d $@
	touch $@
	@TUXBOX_CUSTOMIZE@


####### var and disk

$(flashprefix)/root-enigma2-disk: \
$(flashprefix)/root-enigma2-%: \
			$(flashprefix)/root $(flashprefix)/root-enigma2 $(flashprefix)/root-%
	rm -rf $@
	cp -rd $< $@
	cp -rd $(flashprefix)/root-enigma2/* $@
	cp -rd $(flashprefix)/root-$*/* $@
	echo "tmpfs         /var                tmpfs   defaults                        0 0" >> $@/etc/fstab
#	rm -rf $@/boot
	-rm -rf $@/usr/lib/gconv
#	mkdir $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/gconv-modules $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/ISO8859* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/UTF* $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM937.so $@/usr/lib/gconv
#	cp -rd $</usr/lib/gconv/IBM850.so $@/usr/lib/gconv
	-rm -rf $@/usr/include
#	-rm -rf $@/usr/local
#	-rm $@/usr/bin/local*
	-rm -rf $@/usr/X11R6
	-rm -rf $@/usr/share/{aclocal,doc,gtk-doc,info,locale,man,misc,nls}
	-rm -rf $@/usr/share/zoneinfo
	mkdir $@/usr/share/zoneinfo
#	cp -rd $</usr/share/zoneinfo/Europe $@/usr/share/zoneinfo
	cp -rd $</usr/share/zoneinfo/CET $@/usr/share/zoneinfo
	-rm $@/sbin/ldconfig
	-rm $@/sbin/sln
	-rm $@/sbin/MAKEDEV
	-rm $@/sbin/sulogin
	-rm $@/usr/bin/{catchsegv,getent,iconv,rpcgen,zdump,tzselect,utmpdump}
	-rm $@/usr/sbin/{shellconfig,sh4-linux-shellconfig}
	-rm $@/usr/sbin/{iconvconfig,tzconfig,update-passwd,zic}
	-rm -rf $@/usr/share/base-passwd
	-rm -rf $@/usr/libexec
	-rm -rf $@/usr/lib/pkgconfig
	rm $@/lib/ld-linux.so.2
	$(MAKE) --assume-old=$@ $@/lib/ld-linux.so.2 \
		mklibs_librarypath=$</lib:$</usr/lib:$</usr/lib/gconv:$</usr/lib/autofs:$(targetprefix)/lib:$(targetprefix)/usr/lib
	touch $@
	@TUXBOX_CUSTOMIZE@

####### HDBOX root

$(flashprefix)/root-stock-hdbox-enigma2: \
		$(flashprefix)/root-hdbox
	rm -rf $@
	cp -rd $< $@

	rm -rf $@/var/*
	rm -rf $@/etc/init.d/rcS
	cp -rd $(buildprefix)/root/release/rcS_fortis_hdbox_flash_e2 $@/etc/init.d/rcS
#	cd $@/etc && sed -i -e "s|^proc|/dev/mtdblock3     /var     jffs2     defaults     0 0\nproc|g" fstab
	sed -i -e "s/\/bin\/stslave -t stb7100.0 -R \/boot\/video.elf/\/bin\/ustslave \/dev\/st231-0 \/boot\/video.elf/g" $@/etc/init.d/rcS
	sed -i -e "s/\/bin\/stslave -t stb7100.1 -R \/boot\/audio.elf/\/bin\/ustslave \/dev\/st231-1 \/boot\/audio.elf/g" $@/etc/init.d/rcS
#	echo "/dev/mtdblock3     /var     jffs2     defaults     0 0" >> $@/etc/fstab
	echo "tmpfs         /var/run            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lock           tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/tmp            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/log            tmpfs   defaults                        0 0" >> $@/etc/fstab
	echo "tmpfs         /var/lib/urandom    tmpfs   defaults                        0 0" >> $@/etc/fstab

	rm $@/boot/uImage
#	rm $@/bin/{stslave,devinit,hdmi-control,hdmi-info}
	rm $@/usr/share/fonts/{valis_enigma.ttf,valis_lcd.ttf,ae_AlMateen.ttf,md_khmurabi_10.ttf,seg_internat.ttf,goodtime.ttf,nmsbd.ttf}
	rm -Rf  $@/usr/lib/python2.6
	ln -s /var/usr/lib/python2.6 $@/usr/lib/python2.6
	ln -s /var/lib/init $@/lib/init
	rm -Rf  $@/usr/lib/enigma2/python
	ln -s /var/usr/lib/enigma2/python $@/usr/lib/enigma2/python
	rm -Rf  $@/usr/local/share/enigma2
	ln -s /var/usr/local/share/enigma2 $@/usr/local/share/enigma2
	rm -Rf  $@/etc/enigma2
	ln -s /var/etc/enigma2 $@/etc/enigma2
	rm -Rf  $@/etc/resolv.conf
	ln -s /var/etc/resolv.conf $@/etc/resolv.conf
	rm -Rf  $@/etc/network
	ln -s /var/etc/network $@/etc/network
	rm $@/usr/local/bin/enigma2
	ln -s /var/usr/local/bin/enigma2 $@/usr/local/bin/enigma2
	rm -Rf $@/rbin/splash*
	find $@/ -name libncurses* -exec rm {} \;
	find $@/ -name libfbsp* -exec rm {} \;
#	find $@/lib/modules/ -name  *.ko -exec sh4-linux-strip --strip-unneeded {} \;
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/var-stock-hdbox-enigma2: \
		$(flashprefix)/root-hdbox
	rm -rf $@
	cp -rd $</var $@
#	-cp -rd $(flashprefix)/root-hdbox/var/* $@
	mkdir $@/{usr,lock,lib,log,run,tmp}
	mkdir $@/lib/init
	mkdir $@/usr/{lib,local}
	mkdir $@/usr/lib/enigma2
	mkdir $@/usr/local/{share,bin}
	cp -rf  $</usr/lib/python2.6 $@/usr/lib/
	cp -rf  $</usr/lib/enigma2/python $@/usr/lib/enigma2
	cp -rf  $</usr/local/share/enigma2 $@/usr/local/share/
	cp -rf  $</etc/enigma2 $@/etc/
	cp -rf  $</etc/resolv.conf $@/etc/
	cp -rf  $</etc/network $@/etc/
	cp -rf  $</usr/local/bin/enigma2 $@/usr/local/bin/
	rm $@/etc/.firstboot
#	rm -rf $@/usr/lib/enigma2/python/Plugins/Extensions/*
#	find $@/ -name *.pyo -exec rm {} \;

#	rm -f $@/bin/*
#	rm -rd $@/etc/*
#	$(target)-strip --remove-section=.comment --remove-section=.note $@/bin/* 2>/dev/null || /bin/true && \
#	$(target)-strip $@/lib/* 2>/dev/null || /bin/true && \
	touch $@
	@TUXBOX_CUSTOMIZE@