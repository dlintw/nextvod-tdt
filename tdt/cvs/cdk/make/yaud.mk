
min-prepare-yaud std-prepare-yaud max-prepare-yaud: \
%prepare-yaud:
	-rm -rf $(prefix)/$*cdkroot
	-rm -rf $(prefix)/$*cdkroot-rpmdb

#
# BOOTSTRAP
#
$(DEPDIR)/min-bootstrap $(DEPDIR)/std-bootstrap $(DEPDIR)/max-bootstrap $(DEPDIR)/bootstrap: \
$(DEPDIR)/%bootstrap: \
	%libtool \
	%$(FILESYSTEM) \
	| %$(GLIBC) \
	%$(CROSS_LIBGCC) \
	%libz \
	%$(LIBSTDC) \
	%$(LIBSTDC_DEV)
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
	%module_init_tools \
	%busybox \
	\
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
#	%$(RELEASE) \
#	%$(FINDUTILS) \
#

min-net-utils std-net-utils max-net-utils net-utils: \
%net-utils: \
	%$(NETKIT_FTP) \
	%autofs \
	%portmap \
	%$(NFSSERVER) \
	%vsftpd \
	%ethtool \
	%opkg \
	%grep \
	%$(CIFS)

min-disk-utils std-disk-utils max-disk-utils disk-utils: \
%disk-utils: \
	%$(XFSPROGS) \
	%util-linux \
	%jfsutils \
	%$(SG3)

#dummy targets
#really ugly
min-:

std-:

max-:


#
# YAUD
#
yaud-stock: yaud-none stock
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma: yaud-none lirc stslave \
		boot-elf misc-cp remote firstboot enigma
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-vdr: yaud-none stslave openssl openssl-dev \
		boot-elf misc-cp remote firstboot vdr release_vdr
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-vdrdev2: yaud-none stslave openssl openssl-dev \
		boot-elf misc-cp remote firstboot vdrdev2 release_vdrdev2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-static: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino release_neutrino_static
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-beta: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-beta release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd2 release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd2-exp release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

if STM22
yaud-enigma2: yaud-none host_python lirc stslave \
		boot-elf hotplug remote firstboot enigma2 enigma2-misc release
	@TUXBOX_YAUD_CUSTOMIZE@
else
yaud-enigma2: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2 enigma2-misc release
	@TUXBOX_YAUD_CUSTOMIZE@
endif

if STM22
yaud-enigma2-nightly: yaud-none host_python lirc stslave \
		boot-elf hotplug remote firstboot enigma2-nightly release
	@TUXBOX_YAUD_CUSTOMIZE@
else
yaud-enigma2-nightly: yaud-none host_python lirc stslave \
		boot-elf remote firstboot enigma2-nightly release
	@TUXBOX_YAUD_CUSTOMIZE@
endif

if STM22
yaud-enigma1-hd: yaud-none lirc stslave \
		boot-elf hotplug remote firstboot enigma1-hd release_enigma1_hd
	@TUXBOX_YAUD_CUSTOMIZE@
else
yaud-enigma1-hd: yaud-none lirc stslave \
		boot-elf remote firstboot enigma1-hd release_enigma1_hd
	@TUXBOX_YAUD_CUSTOMIZE@
endif

yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2-pli-nightly enigma2-plugins release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-xbmc-nightly: yaud-none host_python boot-elf firstboot xbmc-nightly release_xbmc
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-titan: yaud-none lirc stslave \
		boot-elf remote firstboot titan release_titan_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-none: \
		bare-os \
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
%yaud-stock: %prepare-yaud %yaud-none %stock
	@TUXBOX_YAUD_CUSTOMIZE@

std-yaud-none: \
%yaud-none: \
		%bare-os \
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
%yaud-none: \
		%bare-os \
		%misc-tools \
		%$(UDEV) \
		%$(HOTPLUG) \
		%linux-kernel \
		%net-utils \
		%disk-utils
	@TUXBOX_YAUD_CUSTOMIZE@
