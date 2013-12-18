#
# DIVERSE STUFF / TOOLS
#
$(DEPDIR)/diverse-tools: $(DIVERSE_TOOLS_ADAPTED_ETC_FILES:%=root/etc/%)
	( cd root/etc && for i in $(DIVERSE_TOOLS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done ) && \
	( export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in $(DIVERSE_TOOLS_ADAPTED_ETC_FILES); do \
			[ "$${s%%/*}" = "init.d" ] && ( \
			$(hostprefix)/bin/target-initdconfig --add $${s#init.d/} || \
			echo "Unable to enable initd service: $${s#init.d/}" ) ; done && rm *rpmsave 2>/dev/null || true ) && \
	ln -sf /usr/share/zoneinfo/CET $(prefix)/$*cdkroot/etc/localtime
#	$(INSTALL_BIN) root/usr/sbin/mountro $(prefix)/$*cdkroot/usr/sbin/
#	$(INSTALL_BIN) root/usr/sbin/mountrw $(prefix)/$*cdkroot/usr/sbin/
#	$(INSTALL_BIN) root/bin/devinit $(prefix)/$*cdkroot/bin
	touch $@

#
# Adapted etc files and etc read-write files
#
GLIBC_ADAPTED_ETC_FILES =
ETC_RW_FILES += host.conf init.d/nscd ld.so.cache ld.so.conf nsswitch.conf rpc

BASE_PASSWD_ADAPTED_ETC_FILES =
ETC_RW_FILES += passwd passwd.org group group.org shadow

BASE_FILES_ADAPTED_ETC_FILES = timezone.xml fstab issue.net motd profile resolv.conf
ETC_RW_FILES += hosts issue.net motd profile resolv.conf inputrc issue skel

BUSYBOX_ADAPTED_ETC_FILES =
ETC_RW_FILES += shells shells.conf init.d/httpd

SYSVINIT_ADAPTED_ETC_FILES = inittab
#ETC_RW_FILES +=

INITSCRIPTS_ADAPTED_ETC_FILES = \
	hostname \
	vdstandby.cfg \
	init.d/autofs \
	init.d/bootclean.sh \
	init.d/checkroot.sh \
	init.d/getfb.awk \
	init.d/hostname \
	init.d/makedev \
	init.d/mountvirtfs \
	init.d/mountall \
	init.d/network \
	init.d/networking \
	init.d/rc \
	init.d/reboot \
	init.d/sendsigs \
	init.d/udhcpc \
	init.d/umountfs \
	init.d/vsftpd

ETC_RW_FILES += \
	hostname \
	vdstandby.cfg \
	init.d/autofs \
	init.d/bootclean.sh \
	init.d/checkroot.sh \
	init.d/getfb.awk \
	init.d/hostname \
	init.d/makedev \
	init.d/mountvirtfs \
	init.d/mountall \
	init.d/network \
	init.d/networking \
	init.d/rc \
	init.d/reboot \
	init.d/rmnologin \
	init.d/sendsigs \
	init.d/udhcpc \
	init.d/umountfs \
	init.d/vsftpd

OPENRDATE_ADAPTED_ETC_FILES = init.d/rdate.sh
ETC_RW_FILES += init.d/rdate.sh localtime

NETBASE_ADAPTED_ETC_FILES = network/interfaces
ETC_RW_FILES += network/interfaces gateways init.d/networking network network/options protocols services

MODULE_INIT_TOOLS_ADAPTED_ETC_FILES = modules init.d/module-init-tools
ETC_RW_FILES += modules init.d/module-init-tools

AUTOFS_ADAPTED_ETC_FILES = auto.master auto.ufs910 timezone.xml init.d/autofs
ETC_RW_FILES += auto.master auto.ufs910 timezone.xml init.d/autofs auto.misc

TCP_WRAPPERS_ADAPTED_ETC_FILES =
ETC_RW_FILES += hosts.allow hosts.deny

PORTMAP_ADAPTED_ETC_FILES =
ETC_RW_FILES += init.d/portmap

NFS_UTILS_ADAPTED_ETC_FILES = exports init.d/nfs-common init.d/nfs-kernel-server
ETC_RW_FILES += exports init.d/nfs-common init.d/nfs-kernel-server

SAMBA_ADAPTED_ETC_FILES = samba/smb.conf init.d/samba
ETC_RW_FILES += samba/smb.conf init.d/samba

E2FSPROGS_ADAPTED_ETC_FILES =
ETC_RW_FILES += mke2fs.conf

DIVERSE_TOOLS_ADAPTED_ETC_FILES = init.d/swap
ETC_RW_FILES += init.d/swap

FUSE_ADAPTED_ETC_FILES = init.d/fuse
#ETC_RW_FILES +=

#
# Functions for copying customized etc files from cvs/cdk/root/etc into yaud targets and
# for updating init scripts in runlevel for yaud targets
#
define adapted-etc-files
	cd root/etc && \
	for i in $(1); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; \
	done
endef

define initdconfig
	export HHL_CROSS_TARGET_DIR=$(prefix)/$*cdkroot && \
	cd $(prefix)/$*cdkroot/etc/init.d && \
		for s in $(1) ; do \
			$(hostprefix)/bin/target-initdconfig --add $$s || echo "Unable to enable initd service: $$s" ; \
		done && \
		rm *rpmsave 2>/dev/null || true
endef
