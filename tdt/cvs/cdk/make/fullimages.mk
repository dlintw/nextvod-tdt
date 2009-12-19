
$(stockdir):
	$(INSTALL) -d $(stockdir)

#######################################################

$(flashprefix)/stock-cramfs.img \
$(flashprefix)/stock-squashfs.img: \
$(flashprefix)/stock-%.img: \
		$(flashprefix)/mtdblock1.kernel-%.ubimage \
		$(flashprefix)/mtdblock2.conf-stock.jffs2 \
		$(flashprefix)/mtdblock3.root-stock.% \
		$(flashprefix)/mtdblock4.app-stock.squashfs \
		$(stockdir)/.eme.mtd \
		$(flashprefix)/mtdblock6.var-stock.jffs2
	$(hostappsdir)/flash/flashmanage.stock.pl -i $@ -o build \
		--rootsize=$(ROOT_PARTITION_SIZE) \
		--datasize=$(DATA_PARTITION_SIZE) \
		--part kernel=$< \
		--part conf=$(word 2,$+) \
		--part root=$(word 3,$+) \
		--part app=$(word 4,$+) \
		--part eme=$(word 5,$+) \
		--part data=$(word 6,$+)
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/stock-jffs2.img: \
$(flashprefix)/stock-%.img: \
		$(flashprefix)/mtdblock1.kernel-%.ubimage \
		$(flashprefix)/mtdblock2.conf-stock.jffs2 \
		$(flashprefix)/mtdblock3.root-stock.% \
		$(flashprefix)/mtdblock4.app-stock.squashfs \
		$(stockdir)/.eme.mtd \
		$(flashprefix)/mtdblock6.data-stock.jffs2
	$(hostappsdir)/flash/flashmanage.stock.pl -i $@ -o build \
		--rootsize=$(ROOT_PARTITION_SIZE) \
		--datasize=$(DATA_PARTITION_SIZE) \
		--part kernel=$< \
		--part conf=$(word 2,$+) \
		--part root=$(word 3,$+) \
		--part app=$(word 4,$+) \
		--part eme=$(word 5,$+) \
		--part data=$(word 6,$+)
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/stock-enigma2.img: \
$(flashprefix)/stock-%.img: \
		$(flashprefix)/mtdblock1.kernel-squashfs.ubimage \
		$(flashprefix)/mtdblock2.conf-stock.enigma2 \
		$(flashprefix)/mtdblock3.root-stock.enigma2 \
		$(flashprefix)/mtdblock4.app-stock.enigma2 \
		$(flashprefix)/mtdblock6.var-stock.enigma2
	$(hostappsdir)/flash/flashmanage.stock.pl -i $@ -o build \
		--rootsize=$(ROOT_PARTITION_SIZE) \
		--datasize=$(DATA_PARTITION_SIZE) \
		--part kernel=$< \
		--part conf=$(word 2,$+) \
		--part root=$(word 3,$+) \
		--part app=$(word 4,$+) \
		--part data=$(word 5,$+)
	@TUXBOX_CUSTOMIZE@
	
$(flashprefix)/enigma2-disk.tgz: \
$(flashprefix)/enigma2-%.tgz: \
		$(flashprefix)/root-enigma2.disk.tar
	rm $@ >/dev/null 2>&1 || true
	cp -p $< $(basename $@).tar
	gzip -9 $(basename $@).tar
	mv $(basename $@).tar.gz $@
	chmod 644 $@
	@TUXBOX_CUSTOMIZE@

stock-cramfs.img-print \
stock-squashfs.img-print \
stock-jffs2.img-print: \
stock-%.img-print: $(flashprefix)/stock-%.img \
		$(hostappsdir)/flash/flashmanage.stock.pl
	$(lastword $^) -i $< -o print \
		--rootsize=$(ROOT_PARTITION_SIZE) \
		--datasize=$(DATA_PARTITION_SIZE)

