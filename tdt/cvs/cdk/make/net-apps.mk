#
# NFS-UTILS
#
$(DEPDIR)/nfs-utils.do_prepare: @DEPENDS_nfs_utils@
	@PREPARE_nfs_utils@
	chmod +x @DIR_nfs_utils@/autogen.sh
	cd @DIR_nfs_utils@ && \
		gunzip -cd ../$(lastword $^) | cat > debian.patch && \
		patch -p1 <debian.patch && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: 2345 19 81\n### BEGIN INIT INFO/g' -i debian/nfs-common.init && \
		sed -e 's/### BEGIN INIT INFO/# chkconfig: 2345 20 80\n### BEGIN INIT INFO/g' -i debian/nfs-kernel-server.init && \
		sed -e 's/do_modprobe nfsd/# do_modprobe nfsd/g' -i debian/nfs-kernel-server.init && \
		sed -e 's/RPCNFSDCOUNT=8/RPCNFSDCOUNT=3/g' -i debian/nfs-kernel-server.default
	touch $@

$(DEPDIR)/nfs-utils.do_compile: bootstrap e2fsprogs $(DEPDIR)/nfs-utils.do_prepare
	cd @DIR_nfs_utils@  && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			CC_FOR_BUILD=$(target)-gcc \
			--disable-gss \
			--disable-nfsv4 \
			--without-tcp-wrappers && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-nfs-utils $(DEPDIR)/std-nfs-utils $(DEPDIR)/max-nfs-utils $(DEPDIR)/ipk-nfs-utils \
$(DEPDIR)/nfs-utils: \
$(DEPDIR)/%nfs-utils: $(NFS_UTILS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/nfs-utils.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/{default,init.d} && \
	cd @DIR_nfs_utils@  && \
		@INSTALL_nfs_utils@
	( cd root/etc && for i in $(NFS_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	[ "x$*" != "xipk-" ] && { \
		export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
			for s in nfs-common nfs-kernel-server ; do \
				$(hostprefix)/bin/target-initdconfig --add $$s || \
				echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true ; } || true
#	@DISTCLEANUP_nfs_utils@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-nfs-utils: $(flashprefix)/root/usr/sbin/exportfs

$(flashprefix)/root/usr/sbin/exportfs: $(DEPDIR)/nfs-utils.do_compile \
		$(NFS_UTILS_ADAPTED_ETC_FILES:%=root/etc/%) | $(flashprefix)/root
	cd @DIR_nfs_utils@  && \
		$(MAKE) install SUBDIRS="utils/exportfs utils/mount utils/mountd utils/nfsd utils/statd" DESTDIR=$(flashprefix)/root && \
		$(INSTALL) -m 644 debian/nfs-common.default $(flashprefix)/root/etc/default/nfs-common && \
		$(INSTALL) -m 755 debian/nfs-common.init $(flashprefix)/root/etc/init.d/nfs-common && \
		$(INSTALL) -m 644 debian/nfs-kernel-server.default $(flashprefix)/root/etc/default/nfs-kernel-server && \
		$(INSTALL) -m 755 debian/nfs-kernel-server.init $(flashprefix)/root/etc/init.d/nfs-kernel-server && \
		$(INSTALL) -m 644 debian/etc.exports $(flashprefix)/root/etc/exports; \
	cd $(flashprefix)/root/usr/sbin && rm start-statd sm-notify && \
	cd $(flashprefix)/root/sbin && rm mount.nfs4 umount.nfs4
	( cd root/etc && for i in $(NFS_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done )
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in nfs-common nfs-kernel-server ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	echo "tmpfs         /var/lib/nfs        tmpfs   defaults                        0 0" >> $(flashprefix)/root/etc/fstab
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# AUTOFS
#
if ENABLE_ADB_BOX
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_TF7700
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_UFS912
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_HS7810A
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_HS7110
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_HL101
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_SPARK
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_SPARK7162
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
if ENABLE_ATEVIO7500
$(DEPDIR)/autofs.do_prepare: $(archivedir)/stlinux23-sh4-autofs-3.1.7-13.sh4.rpm
	rpm $(DRPM) --noscripts --badreloc --relocate /opt/STM/STLinux-2.3/devkit/sh4/target=$(prefix)/cdkroot --ignorearch --nodeps --nosignature -Uhv $<
	touch $@
else
$(DEPDIR)/autofs.do_prepare: @DEPENDS_autofs@
	@PREPARE_autofs@
	touch $@
endif
endif
endif
endif
endif
endif
endif
endif
endif

$(DEPDIR)/autofs.do_compile: bootstrap $(DEPDIR)/autofs.do_prepare
if ENABLE_ADB_BOX
else
if ENABLE_TF7700
else
if ENABLE_UFS912
else
if ENABLE_HS7810A
else
if ENABLE_HS7110
else
if ENABLE_HL101
else
if ENABLE_SPARK
else
if ENABLE_SPARK7162
else
if ENABLE_ATEVIO7500
else
	cd @DIR_autofs@  && \
		$(MAKE_OPTS) \
		$(MAKE)
endif
endif
endif
endif
endif
endif
endif
endif
endif
	touch $@

$(DEPDIR)/min-autofs $(DEPDIR)/std-autofs $(DEPDIR)/max-autofs $(DEPDIR)/ipk-autofs \
$(DEPDIR)/autofs: \
$(DEPDIR)/%autofs: $(AUTOFS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(DEPDIR)/autofs.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
if ENABLE_ADB_BOX
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_TF7700
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_UFS912
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_HS7810A
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_HS7110
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_HL101
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_SPARK
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_SPARK7162
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default
else
if ENABLE_ATEVIO7500
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default	
else
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/default && \
	cd @DIR_autofs@  && \
		@INSTALL_autofs@
endif
endif
endif
endif
endif
endif
endif
endif
endif
	( cd root/etc && for i in $(AUTOFS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	[ "x$*" != "xipk-" ] && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in autofs ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true ) || true
#	@DISTCLEANUP_autofs@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-autofs: $(flashprefix)/root/sbin/automount

$(flashprefix)/root/sbin/automount: $(DEPDIR)/autofs.do_compile \
		$(AUTOFS_ADAPTED_ETC_FILES:%=root/etc/%) | $(flashprefix)/root
	cd @DIR_autofs@  && \
		$(MAKE) install SUBDIRS="daemon modules" INSTALLROOT=$(flashprefix)/root
	( cd root/etc && for i in $(AUTOFS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done )
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in autofs ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	rm -f $(flashprefix)/root/lib/autofs/lookup_multi.so
	rm -f $(flashprefix)/root/lib/autofs/lookup_program.so
	rm -f $(flashprefix)/root/lib/autofs/lookup_userhome.so
	rm -f $(flashprefix)/root/lib/autofs/lookup_yp.so
	rm -f $(flashprefix)/root/lib/autofs/mount_afs.so
	rm -f $(flashprefix)/root/lib/autofs/mount_autofs.so
	rm -f $(flashprefix)/root/lib/autofs/mount_changer.so
	@touch $@
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# VSFTPD
#
$(DEPDIR)/vsftpd.do_prepare: @DEPENDS_vsftpd@
	@PREPARE_vsftpd@
	touch $@

$(DEPDIR)/vsftpd.do_compile: bootstrap $(DEPDIR)/vsftpd.do_prepare
	cd @DIR_vsftpd@ && \
		$(MAKE) clean && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

define vsftpd/install/pre
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/sbin
	$(INSTALL_DIR) $(prefix)/$*cdkroot/etc/xinetd.d
	$(INSTALL_DIR) $(prefix)/$*cdkroot/etc/init.d
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/share/man/man5
	$(INSTALL_DIR) $(prefix)/$*cdkroot/usr/share/man/man8
endef

vsftpd_ADAPTED_FILES = /etc/default/vsftpd /etc/init.d/vsftpd /etc/vsftpd.conf
vsftpd_INITD_FILES = vsftpd
VSFTPD_ADAPTED_ETC_FILES = default/vsftpd init.d/vsftpd vsftpd.conf
ETC_RW_FILES += default/vsftpd init.d/vsftpd vsftpd.conf

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,vsftpd))

flash-vsftpd: $(flashprefix)/root/usr/sbin/vsftpd

$(flashprefix)/root/usr/sbin/vsftpd: $(DEPDIR)/vsftpd.do_compile \
		$(VSFTPD_ADAPTED_ETC_FILES:%=root/etc/%) | $(flashprefix)/root
	cd @DIR_vsftpd@ && \
		$(MAKE) install PREFIX=$(flashprefix)/root
	( cd root/etc && for i in $(VSFTPD_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(flashprefix)/root/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(flashprefix)/root/etc/$$i || true; done )
	( export HHL_CROSS_TARGET_DIR=$(flashprefix)/root && cd $(flashprefix)/root/etc/init.d && \
		for s in vsftpd ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || \
			echo "Unable to enable initd service: $$s" ; done && rm *rpmsave 2>/dev/null || true )
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@

#
# ETHTOOL
#
$(DEPDIR)/ethtool.do_prepare: @DEPENDS_ethtool@
	@PREPARE_ethtool@
	touch $@

$(DEPDIR)/ethtool.do_compile: bootstrap $(DEPDIR)/ethtool.do_prepare
	cd @DIR_ethtool@  && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-ethtool $(DEPDIR)/std-ethtool $(DEPDIR)/max-ethtool \
$(DEPDIR)/ethtool: \
$(DEPDIR)/%ethtool: $(DEPDIR)/ethtool.do_compile
	cd @DIR_ethtool@  && \
		@INSTALL_ethtool@
#	@DISTCLEANUP_ethtool@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# SAMBA
#
$(DEPDIR)/samba.do_prepare: @DEPENDS_samba@
	@PREPARE_samba@
	touch $@

$(DEPDIR)/samba.do_compile: bootstrap $(DEPDIR)/samba.do_prepare
	cd @DIR_samba@ && \
		cd source3 && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--with-automount \
			--with-smbmount \
			--with-configdir=/etc/samba \
			--with-privatedir=/etc/samba/private \
			--with-mandir=/usr/share/man \
			--with-piddir=/var/run \
			--with-logfilebase=/var/log \
			--with-lockdir=/var/lock \
			--with-swatdir=/usr/share/swat \
			--disable-cups && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

define samba/install
	cd @DIR_samba@ && \
		cd source3 && \
		$(MAKE) $(MAKE_OPTS) installservers installbin installcifsmount installman installscripts installdat installmodules \
			SBIN_PROGS="bin/smbd bin/nmbd bin/winbindd" DESTDIR=$(prefix)/$*cdkroot/ prefix=./. && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/samba && \
		$(INSTALL) -c -m644 ../examples/smb.conf.default $(prefix)/$*cdkroot/etc/samba/smb.conf
#		$(MAKE) $(MAKE_OPTS) install DESTDIR=$(prefix)/$*cdkroot/ prefix=./.
endef

samba_ADAPTED_FILES = /etc/samba/smb.conf /etc/init.d/samba
samba_INITD_FILES = samba
ETC_RW_FILES += samba/smb.conf init.d/samba
#//10.0.1.12/monkeyboy /home/john/Monkeyboy smbfs auto,credentials=/root/.credentials,uid=john,umask=000,lfs 0 0

# Evaluate yaud and temporary package install
$(eval $(call Cdkroot,samba))

# Evaluate packages
$(eval $(call Package,samba,samba))

#
# NETIO
#
$(DEPDIR)/netio.do_prepare: @DEPENDS_netio@
	@PREPARE_netio@
	touch $@

$(DEPDIR)/netio.do_compile: bootstrap $(DEPDIR)/netio.do_prepare
	cd @DIR_netio@ && \
		$(MAKE_OPTS) \
		$(MAKE) all O=.o X= CFLAGS="-DUNIX" LIBS="$(LDFLAGS) -lpthread" OUT=-o
	touch $@

$(DEPDIR)/min-netio $(DEPDIR)/std-netio $(DEPDIR)/max-netio \
$(DEPDIR)/netio: \
$(DEPDIR)/%netio: $(DEPDIR)/netio.do_compile
	cd @DIR_netio@ && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/bin && \
		@INSTALL_netio@
	@TUXBOX_TOUCH@
	@TUXBOX_YAUD_CUSTOMIZE@

# Evaluate package netio
# call MacroName,Source Package,Package
$(eval $(call Package,netio,netio))

#
# LIGHTTPD
#
$(DEPDIR)/lighttpd.do_prepare: @DEPENDS_lighttpd@
	@PREPARE_lighttpd@
	touch $@

$(DEPDIR)/lighttpd.do_compile: bootstrap $(DEPDIR)/lighttpd.do_prepare
	cd @DIR_lighttpd@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--datarootdir=/usr/share && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-lighttpd $(DEPDIR)/std-lighttpd $(DEPDIR)/max-lighttpd $(DEPDIR)/ipk-lighttpd \
$(DEPDIR)/lighttpd: \
$(DEPDIR)/%lighttpd: $(DEPDIR)/lighttpd.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
	cd @DIR_lighttpd@ && \
		@INSTALL_lighttpd@
	cd @DIR_lighttpd@ && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -c -m644 doc/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
		$(INSTALL) -c -m644 doc/rc.lighttpd.redhat $(prefix)/$*cdkroot/etc/init.d/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && $(INSTALL) -m755 root/etc/lighttpd/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && $(INSTALL) -m755 root/etc/init.d/lighttpd $(prefix)/$*cdkroot/etc/init.d
	[ "x$*" != "xipk-" ] && \
		( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
			$(hostprefix)/bin/target-initdconfig --add lighttpd || \
			echo "Unable to enable initd service: lighttpd" ) || true
#       @DISTCLEANUP_lighttpd@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

lighttpd.build_ipk: $(DEPDIR)/ipk-lighttpd
	cp -prd ipk-control/lighttpd/* $(prefix)/ipk-cdkroot && make $(prefix)/ipk-cdkroot/strippy && \
	ipkg-build -o root -g root $(prefix)/ipk-cdkroot $(prefix)/ipk
	-rm -rf  $(prefix)/ipk-cdkroot

if TARGETRULESET_FLASH

flash-lighttpd: $(flashprefix)/root/usr/sbin/lighttpd

$(flashprefix)/root/usr/sbin/lighttpd: $(DEPDIR)/lighttpd.do_compile | $(flashprefix)/root
	cd @DIR_lighttpd@ && \
		$(INSTALL) -m755 src/lighttpd $@
	$(INSTALL) -d $(flashprefix)/root/etc/lighttpd && $(INSTALL) -m755 root/etc/lighttpd/lighttpd.conf $(flashprefix)/root/etc/lighttpd/
	$(INSTALL) -m755 root/etc/init.d/lighttpd $(flashprefix)/root/etc/init.d/
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
#
# NETKIT_FTP
#
$(DEPDIR)/netkit_ftp.do_prepare: @DEPENDS_netkit_ftp@
	@PREPARE_netkit_ftp@
	touch $@

$(DEPDIR)/netkit_ftp.do_compile: bootstrap ncurses libreadline $(DEPDIR)/netkit_ftp.do_prepare
	cd @DIR_netkit_ftp@  && \
		$(BUILDENV) \
		./configure \
			--with-c-compiler=$(target)-gcc \
			--prefix=/usr \
			--installroot=$(prefix)/$*cdkroot && \
		$(MAKE)
	touch $@

$(DEPDIR)/min-netkit_ftp $(DEPDIR)/std-netkit_ftp $(DEPDIR)/max-netkit_ftp $(DEPDIR)/ipk-netkit_ftp \
$(DEPDIR)/netkit_ftp: \
$(DEPDIR)/%netkit_ftp: $(DEPDIR)/netkit_ftp.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
	cd @DIR_netkit_ftp@  && \
		@INSTALL_netkit_ftp@
#	@DISTCLEANUP_netkit_ftp@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-netkit_ftp: $(flashprefix)/root/usr/bin/ftp

$(flashprefix)/root/usr/bin/ftp: $(DEPDIR)/netkit_ftp.do_compile | $(flashprefix)/root
	cd @DIR_netkit_ftp@ && \
		for i in ftp/ftp ; do \
			$(INSTALL) $$i $@; done && \
		ln -sf ftp $(@D)/pftp
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# WIRELESS_TOOLS
#
$(DEPDIR)/wireless_tools.do_prepare: @DEPENDS_wireless_tools@
	@PREPARE_wireless_tools@
	touch $@

$(DEPDIR)/wireless_tools.do_compile: bootstrap $(DEPDIR)/wireless_tools.do_prepare
	cd @DIR_wireless_tools@  && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-wireless_tools $(DEPDIR)/std-wireless_tools $(DEPDIR)/max-wireless_tools $(DEPDIR)/ipk-wireless_tools \
$(DEPDIR)/wireless_tools: \
$(DEPDIR)/%wireless_tools: $(DEPDIR)/wireless_tools.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
	cd @DIR_wireless_tools@  && \
		@INSTALL_wireless_tools@
#	@DISTCLEANUP_wireless_tools@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-wireless_tools: $(flashprefix)/root/usr/sbin/iwconfig

$(flashprefix)/root/usr/sbin/iwconfig: $(DEPDIR)/wireless_tools.do_compile | $(flashprefix)/root
	cd @DIR_wireless_tools@ && \
		for i in iwconfig ; do \
			$(INSTALL) $$i $@; done
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif

#
# WPA_SUPPLICANT
#
$(DEPDIR)/wpa_supplicant.do_prepare: @DEPENDS_wpa_supplicant@
	@PREPARE_wpa_supplicant@
	touch $@

$(DEPDIR)/wpa_supplicant.do_compile: bootstrap Patches/wpa_supplicant.config $(DEPDIR)/wpa_supplicant.do_prepare
	cd @DIR_wpa_supplicant@  && \
		$(INSTALL) -m 644 ../$(word 2,$^) .config && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/min-wpa_supplicant $(DEPDIR)/std-wpa_supplicant $(DEPDIR)/max-wpa_supplicant $(DEPDIR)/ipk-wpa_supplicant \
$(DEPDIR)/wpa_supplicant: \
$(DEPDIR)/%wpa_supplicant: $(DEPDIR)/wpa_supplicant.do_compile
	@[ "x$*" = "xipk-" ] && rm -rf  $(prefix)/$*cdkroot || true
	cd @DIR_wpa_supplicant@  && \
		@INSTALL_wpa_supplicant@
#	@DISTCLEANUP_wpa_supplicant@
	@[ "x$*" = "x" ] && touch $@ || true
	@[ "x$*" = "xipk-" ] && make $(prefix)/$*cdkroot/strippy || true
	@TUXBOX_YAUD_CUSTOMIZE@

if TARGETRULESET_FLASH

flash-wpa_supplicant: $(flashprefix)/root/usr/sbin/wpa_supplicant

$(flashprefix)/root/usr/sbin/wpa_supplicant: $(DEPDIR)/wpa_supplicant.do_compile | $(flashprefix)/root
	cd @DIR_wpa_supplicant@ && \
		for i in wpa_supplicant ; do \
			$(INSTALL) $$i $@; done
	@FLASHROOTDIR_MODIFIED@
	@TUXBOX_CUSTOMIZE@
endif
