## Makefile for Tuxbox UFS-910
# http://www.stlinux.com/docs/getting_started-1.0/doc.php?print=1

##################################################################################################

# Set up the build environment
include make/buildenv.mk

# Include Archive targets (SPECS derived)
include make/archive-specs.mk

# Include host apps targets
# ipkg-utils
include make/hostapps.mk

# Include ipk stuff
include make/ipkg.mk

# Include bootstrap targets (SPECS derived)
include make/bootstrap.mk

#  Include u-boot targets
if ENABLE_TF7700
include make/tf_u-boot.mk
else
include make/u-boot.mk
endif

# Include adapted etc files and etc read-write files
include make/root-etc.mk

# Include bare-os targets (mainly SPECS derived)
include make/bare-os.mk

# Include linux kernel targets
include make/linux-kernel.mk

# Include busybox targets
include make/busybox.mk

# Include contrib lib targets
include make/contrib-libs.mk

# Include contrib apps (SPECS derived)
include make/contrib-apps-specs.mk

# Include contrib apps
include make/contrib-apps.mk

# Include net apps
include make/net-apps.mk

# Include divers tools targets
include make/diverse-tools.mk

# More misc libs, mostly nonessential
include make/misc_libs.mk

# Misc tools, not essential
include make/misc_tools.mk

# Plugins
include make/plugins.mk

# Include stock gui targets
include make/stock.mk

# Include enigma gui targets
include make/enigma.mk

# Include enigma2 gui targets
include make/enigma2.mk

# Include enigma2-nightly gui targets
include make/enigma2-nightly.mk

# Include enigma2-nightly gui targets
include make/enigma1-hd.mk

# Include neutrino gui targets
include make/neutrino.mk

# Include osd910 gui targets
include make/osd910.mk

# Include vdr gui targets
include make/vdr.mk

# Include enigma1-hd gui targets
include make/enigma1-hd.mk

# Essential, and some less essential, libraries
#include make/tuxbox_libs.mk

# A small, but absolutely essential library
include make/libtuxbox.mk

# Include yaud targets
include make/yaud.mk

# Include record targets
include make/record.mk

# Include prog targets
include make/prog.mk

# Include usb targets
include make/flashybrid.mk

# Include development targets
include make/development.mk

# Include stg-framebuffer targets (SPECS derived)
# (stgfb X... freetype directfb)
include make/stg-framebuffer-specs.mk

# Include misc targets (SPECS derived)
# (splashutils)
include make/misc-specs.mk

# flash_parts-[root]-[cramfs,squashfs,jffs2,all]
# Expand all flash targets containg the word "all"
include make/flash-expand-targets.mk

# Create complete images ("without u-boot bootloader stuff")
include make/fullimages.mk

# Create update images
include make/partition-update-images.mk

# Create images of the root and var file systems
include make/partition-images.mk

# Create root and var filesystems, ready for image creation
include make/flashable-dirs.mk

# Strip libraries of symbols not needed.
include make/reduce-libs.mk

# Create the root file systems for jffs2-only, cramfs, and squashfs
# images (containing kernel modules but not GUI)
include make/flashroot-fs.mk

# Create the root file system, without kernel and GUI (be aware of RW_FILES)
include make/flashroot.mk

# Create partition und update partition images from given directories
include make/helper-images.mk

# A number of cleaning targets
include make/cleantargets.mk

# "Phony" make targets
include make/phony.mk

# Create the TAGS file
include make/tags.mk

# Target for building source distributions (hardly used these days of CVS :-)
include make/disttargets.mk

#Trick
include make/release.mk

include make/release_neutrino.mk

include make/release_vdr.mk

# New static folder
include make/release_neutrino_static.mk

# Give the user rope to hang himself :-).  (Note: read from the
# generated Makefile during make run, automake or configure does not
# see it.)
-include ./Makefile.local

# installer image for TF7700
include make/tfinstaller.mk
