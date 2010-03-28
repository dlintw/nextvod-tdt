#### Targets for building $partition-$gui.$fstype.$mtdblock.update

# Target makes header and trailer for mtd images being installed by kati update program
update_header:
	rm $(FILEIMAGE).update >/dev/null 2>&1 || true
	echo -n "MARU`date +%Y%m%d`$(PARTITION)" >$(FILEIMAGE).update
	cat $(FILEIMAGE) >>$(FILEIMAGE).update
	rm crc32* >/dev/null 2>&1 || true
	cfv -C -f crc32.sfv $(FILEIMAGE)
	grep $(FILEIMAGE) crc32.sfv | cut -d " " -f 2 >crc32
	printf "\x`cut -b 7,8 crc32`" >>$(FILEIMAGE).update
	printf "\x`cut -b 5,6 crc32`" >>$(FILEIMAGE).update
	printf "\x`cut -b 3,4 crc32`" >>$(FILEIMAGE).update
	printf "\x`cut -b 1,2 crc32`" >>$(FILEIMAGE).update
	-rm crc32*


####### mtd1: $mtdblock.$partition-$mtdtype.ubimage (default: .ker)
$(flashprefix)/mtdblock1.kernel-cramfs.ubimage.update \
$(flashprefix)/mtdblock1.kernel-squashfs.ubimage.update \
$(flashprefix)/mtdblock1.kernel-jffs2.ubimage.update \
$(flashprefix)/mtdblock1.kernel-focramfs.ubimage.update \
$(flashprefix)/mtdblock1.kernel-fosquashfs.ubimage.update: \
$(flashprefix)/mtdblock1.kernel-%.ubimage.update: \
			$(flashprefix)/mtdblock1.kernel-%.ubimage
	make update_header PARTITION=.ker FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@


####### mtd2: $mtdblock.$partition-$gui.$fstype (default: conf)
$(flashprefix)/mtdblock2.conf-stock.jffs2.update: \
$(flashprefix)/mtdblock2.%-stock.jffs2.update: \
		$(flashprefix)/mtdblock2.conf-stock.jffs2
	make update_header PARTITION=conf FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd2: $mtdblock.$partition-$gui.$fstype (default: conf)
$(flashprefix)/mtdblock2.conf-stock.enigma2.update: \
$(flashprefix)/mtdblock2.%-stock.enigma2.update: \
		$(flashprefix)/mtdblock2.conf-stock.enigma2
	make update_header PARTITION=conf FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd2-neutrino:
$(flashprefix)/mtdblock2.root-stock.neutrino.update: \
$(flashprefix)/mtdblock2.%-stock.neutrino.update: \
		$(flashprefix)/mtdblock2.root-stock.neutrino
	make update_header PARTITION=root FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd3: $mtdblock.$partition-$gui.$fstype (default: root)
$(flashprefix)/mtdblock3.root-stock.cramfs.update \
$(flashprefix)/mtdblock3.root-stock.squashfs.update \
$(flashprefix)/mtdblock3.root-stock.enigma2.update \
$(flashprefix)/mtdblock3.root-stock.jffs2.update \
$(flashprefix)/mtdblock3.root-stock.focramfs.update \
$(flashprefix)/mtdblock3.root-stock.fosquashfs.update: \
$(flashprefix)/mtdblock3.root-stock.%.update: \
			$(flashprefix)/mtdblock3.root-stock.%
	make update_header PARTITION=root FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd3-neutrino:
$(flashprefix)/mtdblock3.var-stock.neutrino.update: \
$(flashprefix)/mtdblock3.var-stock.%.update: \
		$(flashprefix)/mtdblock3.var-stock.%
	make update_header PARTITION=var FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd4: $mtdblock.$partition-$gui.$fstype (default: .app)
$(flashprefix)/mtdblock4.app-stock.cramfs.update \
$(flashprefix)/mtdblock4.app-stock.squashfs.update \
$(flashprefix)/mtdblock4.app-stock.enigma2.update \
$(flashprefix)/mtdblock4.app-stock.jffs2.update: \
$(flashprefix)/mtdblock4.app-stock.%.update: \
			$(flashprefix)/mtdblock4.app-stock.%
	make update_header PARTITION=.app FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@


####### mtd5: $mtdblock.$partition-$gui.$fstype (default: .eme)


####### mtd6: $mtdblock.$partition-$gui.$fstype (default: .dat)
$(flashprefix)/mtdblock6.var-stock.jffs2.update: \
		$(flashprefix)/mtdblock6.var-stock.jffs2
	make update_header PARTITION=.dat FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### mtd6: $mtdblock.$partition-$gui.$fstype (default: .dat)
$(flashprefix)/mtdblock6.var-stock.enigma2.update: \
		$(flashprefix)/mtdblock6.var-stock.enigma2
	make update_header PARTITION=.dat FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock6.data-stock.jffs2.update: \
		$(flashprefix)/mtdblock6.data-stock.jffs2
	make update_header PARTITION=.dat FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### hdbox mtd1: $mtdblock.$partition-$mtdtype.ubimage (default: .ker)
$(flashprefix)/mtdblock1.kernel-squashfs-hdbox.ubimage.update: \
			$(flashprefix)/mtdblock1.kernel-squashfs-hdbox.ubimage
	make update_header PARTITION=.ker FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### hdbox mtd2: $mtdblock.$partition-$gui.$fstype (default: root)
$(flashprefix)/mtdblock2.root-stock-hdbox.enigma2.update: \
			$(flashprefix)/mtdblock2.root-stock-hdbox.enigma2
	make update_header PARTITION=root FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@

####### hdbox mtd3: $mtdblock.$partition-$gui.$fstype (default: .dat)
$(flashprefix)/mtdblock3.var-stock-hdbox.enigma2.update: \
		$(flashprefix)/mtdblock3.var-stock-hdbox.enigma2
	make update_header PARTITION=.var FILEIMAGE=$<
	@TUXBOX_CUSTOMIZE@
