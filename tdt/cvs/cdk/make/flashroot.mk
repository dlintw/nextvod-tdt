$(flashprefix):
	$(INSTALL) -d $@

$(flashprefix)/root: bootstrap $(wildcard root-local.sh) config.status \
		$(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(AUTOFS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(VSFTPD_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(SAMBA_ADAPTED_ETC_FILES:%=root/etc/%) \
		| $(flashprefix)
	rm -rf $@
	rm -rf $(flashprefix)-rpmdb
	$(INSTALL) -d $@/{bin,boot,dev,dev.static,lib,media,mnt,opt,proc,ram,root,sbin,sys,tmp}
#	$(INSTALL) -d $@/{home,share}
	$(INSTALL) -d $@/etc
	$(INSTALL) -d $@/etc/{default,init.d,network,rc.d}
#	$(INSTALL) -d $@/etc/opt
	$(INSTALL) -d $@/etc/rc.d/{rc3.d,rcS.d}
	ln -s ../init.d $@/etc/rc.d/init.d
	$(INSTALL) -d $@/jffs
#	$(INSTALL) -d $@/share/{doc,info,locale,man,misc,nls}
	$(INSTALL) -d $@/usr
	$(INSTALL) -d $@/usr/{bin,include,lib,sbin,share}
#	$(INSTALL) -d $@/usr/{src}
	$(INSTALL) -d $@/usr/share/{doc,info,locale,man,misc,nls}
	$(INSTALL) -d $@/usr/share/man/{man0p,man1,man1p,man2,man3,man3p,man4,man5,man6,man7,man8,man9}
	$(INSTALL) -d $@/ram
	$(INSTALL) -d $@/rom
	$(INSTALL) -d $@/srv
	$(INSTALL) -d $@/srv/www
	$(INSTALL) -d $@/var
	$(INSTALL) -d $@/var/{bin,lock/subsys,log,run}
	ln -s /tmp $@/var/tmp
#	$(INSTALL) -d $@/var/{backups,cache,lib/misc,local,mail,opt,spool}
#	ln -s /var/mail $@/var/spool/mail
#	$(INSTALL) -d $@/lib/tuxbox
#	$(INSTALL) -d $@/usr/share/{tuxbox,fonts}
	$(INSTALL) -d $@/var/etc
	$(MAKE) flash-glibc
#	$(MAKE) flash-cross-libgcc
#	$(MAKE) flash-libstdc++
	$(MAKE) flash-libtermcap
	$(MAKE) flash-base-passwd
	$(MAKE) flash-makedev
	$(MAKE) flash-base-files
	$(MAKE) flash-module-init-tools
	$(MAKE) flash-busybox
	$(MAKE) flash-grep
	$(MAKE) flash-initscripts
	$(MAKE) flash-openrdate
	$(MAKE) flash-netbase
	$(MAKE) flash-sysvinit
	$(MAKE) flash-distributionutils
	$(MAKE) flash-e2fsprogs
	$(MAKE) flash-u-boot-utils
	$(MAKE) flash-diverse-tools
	$(MAKE) flash-autofs
	$(MAKE) flash-portmap
	$(MAKE) flash-ipkg
if ENABLE_NFSSERVER
	$(MAKE) flash-nfs-utils
endif
	$(MAKE) flash-vsftpd
if ENABLE_CIFS
	$(MAKE) flash-samba-client
endif
if ENABLE_XFS
	$(MAKE) flash-xfsprogs
endif
if ENABLE_SG3
	$(MAKE) flash-sg3_utils
endif
if ENABLE_OSD910
	$(MAKE) flash-osd910
endif
	$(MAKE) flash-misc-tools
	$(MAKE) flash-lircd
	$(MAKE) flash-stslave
	$(MAKE) flash-hotplug
	$(MAKE) flash-alsa-lib
	$(MAKE) flash-alsa-utils
	$(MAKE) flash-alsaplayer
#	$(MAKE) flash-splashutils
	$(MAKE) flash-strace
	@TUXBOX_CUSTOMIZE@
	@FLASHROOTDIR_MODIFIED@


#		flash-bc \
#		flash-netkit_ftp \
#

$(flashprefix)/root-hdbox: bootstrap $(wildcard root-local.sh) config.status \
		$(BASE_FILES_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(AUTOFS_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(VSFTPD_ADAPTED_ETC_FILES:%=root/etc/%) \
		$(SAMBA_ADAPTED_ETC_FILES:%=root/etc/%) \
		| $(flashprefix)
	rm -rf $@
	rm -rf $(flashprefix)-rpmdb
	cp -rf $(prefix)/release $@/
	@TUXBOX_CUSTOMIZE@
	@FLASHROOTDIR_MODIFIED@
