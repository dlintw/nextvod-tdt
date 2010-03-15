export CFLAGS
export CXXFLAGS

export DRPM 
export DRPMBUILD 

if ENABLE_CCACHE
PATH := $(hostprefix)/ccache-bin:$(crossprefix)/bin:$(PATH):/usr/sbin
else
PATH := $(crossprefix)/bin:$(PATH):/usr/sbin
endif

SOCKSIFY=
CMD_CVS=$(SOCKSIFY) $(shell which cvs)
WGET=$(SOCKSIFY) wget

INSTALL_DIR=$(INSTALL) -d
INSTALL_BIN=$(INSTALL) -m 755
INSTALL_FILE=$(INSTALL) -m 644
LN_SF=$(shell which ln) -sf
CP_D=$(shell which cp) -d
CP_P=$(shell which cp) -p
CP_RD=$(shell which cp) -rd
SED=$(shell which sed)

MAKE_PATH := $(hostprefix)/bin:$(crossprefix)/bin:$(PATH)

ADAPTED_ETC_FILES =
ETC_RW_FILES =

if STM22
STLINUX := stlinux22
else
STLINUX := stlinux23
endif
STM_SRC := stlinux23

BUILDENV := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	PKG_CONFIG_PATH="$(targetprefix)/usr/lib/pkgconfig"
#	PKG_CONFIG_PATH="$(targetprefix)/lib/pkgconfig:$(targetprefix)/usr/lib/pkgconfig"

MAKE_OPTS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s" \
	ARCH=sh \
	CROSS_COMPILE=$(target)-

MAKE_ARGS := \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	LD=$(target)-ld \
	NM=$(target)-nm \
	AR=$(target)-ar \
	AS=$(target)-as \
	RANLIB=$(target)-ranlib \
	STRIP=$(target)-strip \
	OBJCOPY=$(target)-objcopy \
	OBJDUMP=$(target)-objdump \
	LN_S="ln -s"

DEPDIR = .deps

VPATH = $(DEPDIR)

ACLOCAL_AMFLAGS = -I .

CONFIG_STATUS_DEPENDENCIES = \
	$(top_srcdir)/rules.pl \
	$(top_srcdir)/rules-install $(top_srcdir)/rules-install-flash \
	$(top_srcdir)/rules-make \
	Makefile-archive

CONFIGURE_OPTS = \
        --build=$(build) \
        --host=$(target) \
        --prefix=$(targetprefix)/usr \
        --with-driver=$(driverdir) \
        --with-dvbincludes=$(driverdir)/dvb/include \
        --with-target=cdk

export DRPM 
export DRPMBUILD 

if ENABLE_CCACHE
CONFIGURE_OPTS += --enable-ccache
endif

if MAINTAINER_MODE
CONFIGURE_OPTS_MAINTAINER = \
	--enable-maintainer-mode
endif

if TARGETRULESET_FLASH
CONFIGURE_OPTS_DEBUG = \
	--without-debug
endif

CONFIGURE = \
	./autogen.sh && \
	CC=$(target)-gcc \
	CXX=$(target)-g++ \
	CFLAGS="-Wall $(TARGET_CFLAGS)" \
	CXXFLAGS="-Wall $(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	./configure $(CONFIGURE_OPTS) $(CONFIGURE_OPTS_MAINTAINER) $(CONFIGURE_OPTS_DEBUG)

min-query std-query max-query query: \
%query:
	rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) -qa

query-%:
	@for i in sh4 noarch ${host_arch} ; do \
		FOUND=`ls RPMS/$$i | grep $*` || true && \
		( for j in $$FOUND ; do \
			echo "RPMS/$$i/$$j:" && \
			rpm $(DRPM) -qplv --scripts RPMS/$$i/$$j || true; echo;done ) || true ; done
