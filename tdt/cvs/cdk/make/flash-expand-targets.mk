# Public flash targets
#
# flash-$gui-$rootfs[|-full]
#

#
# Partititon images
#
flash-all-all: flash-stock-all

flash-all-cramfs: stock-cramfs.img
flash-all-squashfs: stock-squashfs.img
flash-all-jffs2: stock-jffs2.img
flash-all-enigma2: stock-enigma2.img

flash-stock-all: flash-stock-cramfs flash-stock-squashfs flash-stock-jffs2

flash-stock-cramfs: \
		kernel-cramfs.ubimage \
		root-stock.cramfs \
		var-stock.jffs2
flash-stock-squashfs: \
		kernel-squashfs.ubimage \
		root-stock.squashfs \
		var-stock.jffs2
flash-enigma2-squashfs: \
		kernel-squashfs.ubimage \
		conf-stock.enigma2 \
		root-stock.enigma2 \
		app-stock.enigma2 \
		var-stock.enigma2
flash-stock-jffs2: \
		kernel-jffs2.ubimage \
		root-stock.jffs2
flash-stock-tgz: \
		root-stock.tgz
flash-stock-focramfs: \
		kernel-focramfs.ubimage \
		root-stock.focramfs
flash-stock-fosquashfs: \
		kernel-fosquashfs.ubimage \
		root-stock.fosquashfs

kernel-cramfs.ubimage: $(flashprefix)/mtdblock1.kernel-cramfs.ubimage.update
kernel-squashfs.ubimage: $(flashprefix)/mtdblock1.kernel-squashfs.ubimage.update
kernel-squashfs-hdbox.ubimage: $(flashprefix)/mtdblock1.kernel-squashfs-hdbox.ubimage.update
kernel-jffs2.ubimage: $(flashprefix)/mtdblock1.kernel-jffs2.ubimage.update
kernel-focramfs.ubimage: $(flashprefix)/mtdblock1.kernel-focramfs.ubimage.update
kernel-fosquashfs.ubimage: $(flashprefix)/mtdblock1.kernel-fosquashfs.ubimage.update
conf-stock.jffs2: $(flashprefix)/mtdblock2.conf-stock.jffs2.update
conf-stock.enigma2: $(flashprefix)/mtdblock2.conf-stock.enigma2.update
root-stock.cramfs: $(flashprefix)/mtdblock3.root-stock.cramfs.update
root-stock.squashfs: $(flashprefix)/mtdblock3.root-stock.squashfs.update
root-stock.jffs2: $(flashprefix)/mtdblock3.root-stock.jffs2.update
root-stock.tgz: $(flashprefix)/sdax.root-stock.tgz
root-stock.focramfs: $(flashprefix)/mtdblock3.root-stock.focramfs.update
root-stock.fosquashfs: $(flashprefix)/mtdblock3.root-stock.fosquashfs.update
root-stock.enigma2: $(flashprefix)/mtdblock3.root-stock.enigma2.update
root-stock-hdbox.enigma2: $(flashprefix)/mtdblock2.root-stock-hdbox.enigma2.update
app-stock.squashfs: $(flashprefix)/mtdblock4.app-stock.squashfs.update
app-stock.enigma2: $(flashprefix)/mtdblock4.app-stock.enigma2.update
var-stock.jffs2: $(flashprefix)/mtdblock6.var-stock.jffs2.update
var-stock.enigma2: $(flashprefix)/mtdblock6.var-stock.enigma2.update
var-stock-hdbox.enigma2: $(flashprefix)/mtdblock3.var-stock-hdbox.enigma2.update
data-stock.jffs2: $(flashprefix)/mtdblock6.data-stock.jffs2.update

#flash-null-cramfs: $(flashprefix)/null-cramfs.img
#flash-null-squashfs: $(flashprefix)/null-squashfs.img
#flash-null-jffs2: $(flashprefix)/null-jffs2.img

#
# Full images
#
flash-all-all-full: flash-stock-all-full

flash-all-cramfs-full: stock-cramfs.img
flash-all-squashfs-full: stock-squashfs.img
flash-all-jffs2-full: stock-jffs2.img

flash-stock-all-full: flash-stock-cramfs-full flash-stock-squashfs-full flash-stock-jffs2-full

flash-stock-cramfs-full: stock-cramfs.img
flash-stock-squashfs-full: stock-squashfs.img
flash-stock-jffs2-full: stock-jffs2.img
flash-all-enigma2-full: stock-enigma2.img
flash-enigma2-disk: enigma2-disk.tgz

stock-cramfs.img: $(flashprefix)/stock-cramfs.img \
		kernel-cramfs.ubimage \
		conf-stock.jffs2 \
		root-stock.cramfs \
		app-stock.cramfs \
		var-stock.jffs2

stock-squashfs.img: $(flashprefix)/stock-squashfs.img \
		kernel-squashfs.ubimage \
		conf-stock.jffs2 \
		root-stock.squashfs \
		app-stock.squashfs \
		var-stock.jffs2

stock-jffs2.img: $(flashprefix)/stock-jffs2.img \
		kernel-jffs2.ubimage \
		conf-stock.jffs2 \
		root-stock.jffs2 \
		app-stock.squashfs \
		data-stock.jffs2

stock-focramfs.img: $(flashprefix)/stock-focramfs.img \
		kernel-focramfs.ubimage \
		conf-stock.jffs2 \
		root-stock.focramfs \
		app-stock.squashfs \
		data-stock.jffs2

stock-fosquashfs.img: $(flashprefix)/stock-fosquashfs.img \
		kernel-fosquashfs.ubimage \
		conf-stock.jffs2 \
		root-stock.fosquashfs \
		app-stock.squashfs \
		data-stock.jffs2

stock-enigma2.img: $(flashprefix)/stock-enigma2.img \
		kernel-squashfs.ubimage \
		conf-stock.enigma2 \
		root-stock.enigma2 \
		app-stock.enigma2 \
		var-stock.enigma2

enigma2-disk.tgz: $(flashprefix)/enigma2-disk.tgz
