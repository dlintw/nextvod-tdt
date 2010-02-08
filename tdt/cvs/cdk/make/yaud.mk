
min-prepare-yaud std-prepare-yaud max-prepare-yaud: \
%prepare-yaud:
	-rm -rf $(prefix)/$*cdkroot
	-rm -rf $(prefix)/$*cdkroot-rpmdb

#
# BOOTSTRAP
#
$(DEPDIR)/min-bootstrap $(DEPDIR)/std-bootstrap $(DEPDIR)/max-bootstrap $(DEPDIR)/bootstrap: \
$(DEPDIR)/%bootstrap: \
		%$(FILESYSTEM) \
		| %$(GLIBC) \
		%$(CROSS_LIBGCC) \
		%$(LIBSTDC)
	@[ "x$*" = "x" ] && touch -r RPMS/sh4/$(STLINUX)-sh4-$(LIBSTDC)-$(GCC_VERSION).sh4.rpm $@ || true

#
# BARE-OS
#
min-bare-os std-bare-os max-bare-os bare-os: \
%bare-os: \
		%bootstrap \
		%$(LIBTERMCAP) \
		%$(NCURSES_BASE) \
		%$(NCURSES) \
		%$(BASE_PASSWD) \
		%$(MAKEDEV) \
		%$(BASE_FILES) \
		%module-init-tools \
		%busybox \
		\
		%libz \
		%grep \
		%$(INITSCRIPTS) \
		%openrdate \
		%$(NETBASE) \
		%$(BC) \
		%$(SYSVINIT) \
		%$(DISTRIBUTIONUTILS) \
		\
		%e2fsprogs \
		%u-boot-utils \
		%diverse-tools
#		%$(RELEASE) \
#		%$(FINDUTILS) \
#

min-net-utils std-net-utils max-net-utils net-utils: \
%net-utils:	\
		%$(NETKIT_FTP) \
		%autofs \
		%portmap \
		%$(NFSSERVER) \
		%vsftpd \
		%ethtool \
		%$(CIFS)

min-disk-utils std-disk-utils max-disk-utils disk-utils: \
%disk-utils:	\
		%$(XFSPROGS) \
		%util-linux \
		%$(SG3)

#dummy targets
#really ugly
min-:

std-:

max-:


#
# YAUD
#
yaud-stock: yaud-none stock $(OSD910)
	@TUXBOX_YAUD_CUSTOMIZE@

#yaud-enigma: yaud-none splashutils enigma
yaud-enigma: yaud-none lirc stslave \
		boot-elf misc-cp remote firstboot enigma
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-vdr: yaud-none stslave openssl openssl-dev \
		boot-elf misc-cp remote firstboot vdr release_vdr
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino: yaud-none stslave\
		boot-elf hotplug remote firstboot neutrino release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

if STM22
yaud-enigma2: yaud-none lirc stslave\
		boot-elf hotplug remote firstboot enigma2 enigma2-misc release
	@TUXBOX_YAUD_CUSTOMIZE@
else
yaud-enigma2: yaud-none lirc \
		boot-elf remote firstboot enigma2 enigma2-misc release
	@TUXBOX_YAUD_CUSTOMIZE@
endif

yaud-enigma2-nightly: yaud-none lirc stslave\
		boot-elf hotplug remote firstboot enigma2-nightly enigma2-misc release
	@TUXBOX_YAUD_CUSTOMIZE@

#work yet!!!
flash-ufs910-enigma2: yaud-none lirc stslave \
		boot-elf hotplug remote firstboot enigma2 enigma2-misc release \
		kernel-squashfs.ubimage \
		conf-stock.enigma2 \
		root-stock.enigma2 \
		app-stock.enigma2 \
		var-stock.enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

flash-hdbox-enigma2: yaud-none lirc \
		boot-elf hotplug remote firstboot enigma2 enigma2-misc release \
		kernel-squashfs-hdbox.ubimage \
		root-stock-hdbox.enigma2 \
		var-stock-hdbox.enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-none:	bare-os \
		libdvdcss \
		libdvdread \
		libdvdnav \
		linux-kernel \
		net-utils \
		disk-utils \
		driver \
		misc-tools
	@TUXBOX_YAUD_CUSTOMIZE@

#
# MIN-YAUD
#
test-kati: min-yaud-stock

min-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none
	@TUXBOX_YAUD_CUSTOMIZE@

min-yaud-none: \
%yaud-none:	%bare-os \
		%misc-tools \
		%linux-kernel \
		%net-utils \
		%disk-utils
	@TUXBOX_YAUD_CUSTOMIZE@
#
#min-yaud-stock: \
#%yaud-stock: min-prepare-yaud min-yaud-none
#	@TUXBOX_YAUD_CUSTOMIZE@
#
#min-yaud-none: \
#%yaud-none: %bare-os \
#		...
#		%$(RELEASE) \
#		%linux-kernel \
#		%busybox \
#		%libz \
#		%$(GREP)
#	@TUXBOX_YAUD_CUSTOMIZE@

#
# STD-YAUD
#
yaud-kati: std-yaud-stock

std-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none %stock %$(OSD910)
	@TUXBOX_YAUD_CUSTOMIZE@

std-yaud-none: \
%yaud-none:	%bare-os \
		%misc-tools \
		%linux-kernel \
		%net-utils \
		%disk-utils
	@TUXBOX_YAUD_CUSTOMIZE@

#
# MAX-YAUD
#
usb-kati: max-yaud-stock

max-yaud-stock: \
%yaud-stock: %prepare-yaud %yaud-none %stock
	@TUXBOX_YAUD_CUSTOMIZE@

max-yaud-none: \
%yaud-none: 	%bare-os \
		%misc-tools \
		%$(UDEV) \
		%$(HOTPLUG) \
		%linux-kernel \
		%net-utils \
		%disk-utils
	@TUXBOX_YAUD_CUSTOMIZE@
#		%$(BASH) \
#		%$(COREUTILS) \
#		%$(NET_TOOLS) \
#
