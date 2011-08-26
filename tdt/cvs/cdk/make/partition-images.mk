#### Targets for building $mtdblock.$partition-$gui.$fstype


####### mtd1: $mtdblock.$partition-$mtdtype.ubimage (default: .ker)
#Default Size: 1835008d, 1c0000h
KERNEL_PARTITION_SIZE=0x1c0000

$(flashprefix)/mtdblock1.kernel-cramfs.ubimage \
$(flashprefix)/mtdblock1.kernel-squashfs.ubimage \
$(flashprefix)/mtdblock1.kernel-jffs2.ubimage \
$(flashprefix)/mtdblock1.kernel-focramfs.ubimage \
$(flashprefix)/mtdblock1.kernel-fosquashfs.ubimage: \
$(flashprefix)/mtdblock1.kernel-%.ubimage: \
			linux-kernel.%.do_compile | $(flashprefix)
	rm $@* >/dev/null 2>&1 || true
#	$(INSTALL) -m644 @DIR_linux@/arch/sh/boot/uImage $@
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $@
	@FILESIZE=$$(stat -c%s $@); \
	kernel_partition_size=`echo -e "$(KERNEL_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	KERNELSIZE=`echo -e "ibase=16;$$kernel_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$KERNELSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$KERNELSIZE, $(KERNEL_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@


####### mtd2: $mtdblock.$partition-$gui.$fstype (default: conf)
#Default Size: 655360d, a0000h
CONF_PARTITION_SIZE=0xa0000

$(flashprefix)/mtdblock2.conf-stock.jffs2: $(flashprefix)/conf-stock-jffs2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "$(MKJFFS2) -e 0x10000 --pad=$(CONF_PARTITION_SIZE) -r $< -o $@" > $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	conf_partition_size=`echo -e "$(CONF_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	CONFSIZE=`echo -e "ibase=16;$$conf_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$CONFSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$CONFSIZE, $(CONF_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock2.conf-stock.enigma2: $(flashprefix)/conf-stock-enigma2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "$(MKJFFS2) -e 0x10000 -r $< -o $@" > $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	conf_partition_size=`echo -e "$(CONF_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	CONFSIZE=`echo -e "ibase=16;$$conf_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$CONFSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$CONFSIZE, $(CONF_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

####### mtd3: $mtdblock.$partition-$gui.$fstype (default: root)
#Default Size: 2359296d, 240000h
#ROOT_PARTITION_SIZE= (via configure)

$(flashprefix)/mtdblock3.root-stock.cramfs \
$(flashprefix)/mtdblock3.root-stock.focramfs: \
$(flashprefix)/mtdblock3.root-stock.%: $(flashprefix)/root-stock-% $(MKCRAMFS)
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0777 fbsplash c 10 63" >> $$dir/.fakeroot && \
		echo "chown root:root fbsplash" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio video fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo 'ln -sf scd0 sr0' >> $$dir/.fakeroot && \
		echo 'ln -sf scd1 sr1' >> $$dir/.fakeroot && \
		echo "$(MKCRAMFS) $< $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKCRAMFS) $< $@
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock3.root-stock.squashfs \
$(flashprefix)/mtdblock3.root-stock.fosquashfs: \
$(flashprefix)/mtdblock3.root-stock.%: $(flashprefix)/root-stock-% $(MKSQUASHFS)
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0777 fbsplash c 10 63" >> $$dir/.fakeroot && \
		echo "chown root:root fbsplash" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "$(MKSQUASHFS) $< $@ -noappend" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKSQUASHFS) $< $@ -noappend -le -force-uid 0 -force-gid 0 -all-root
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock3.root-stock.jffs2: $(flashprefix)/root-stock-jffs2 $(MKJFFS2)
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0777 fbsplash c 10 63" >> $$dir/.fakeroot && \
		echo "chown root:root fbsplash" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "$(MKJFFS2) -e 0x10000 --pad=$(ROOT_PARTITION_SIZE) -r $< -o $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#		echo "$(MKJFFS2) -e 0x10000 -p -r $< -o $@" >> $$dir/.fakeroot && \
#	$(MKJFFS2) -e 0x10000 -r $< -o $@
#	$(MKJFFS2) -e 0x10000 --pad=0x400000 -r $< -o $@
#	echo -e 'ibase=16;400000' | bc
#	echo -e "obase=16;4194304" | bc
#echo "$ROOTSIZE" | tr '[a-f]' '[A-F]' | cut  -b3-
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/sdax.root-stock.tgz: \
$(flashprefix)/sdax.root-%.tgz: $(flashprefix)/root-%-tgz
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0777 fbsplash c 10 63" >> $$dir/.fakeroot && \
		echo "chown root:root fbsplash" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 vfd c 147 0" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} fd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} dvb' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "tar -zcvf $@ -C $< ." >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock3.root-stock.enigma2: \
$(flashprefix)/mtdblock3.root-stock.%: $(flashprefix)/root-stock-% $(MKSQUASHFS)
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 vfd c 147 0" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} dvb' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "$(MKSQUASHFS) $< $@ -noappend" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKSQUASHFS) $< $@ -noappend -le -force-uid 0 -force-gid 0 -all-root
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

#######mtd2-neutrino for ufs910-beta!
$(flashprefix)/mtdblock2.root-stock.neutrino: \
$(flashprefix)/mtdblock2.root-stock.%: $(flashprefix)/root-stock-% $(MKSQUASHFS)
#######NEW NEUTRINO ROOT PARTITION SIZE:
#ROOT_PARTITION_SIZE=0x8e0000 ####look at ufs910_stboards_p0041_flash.patch
#ROOT_PARTITION_SIZE= (via configure)
if !STM22
LZMACOMP=-comp lzma
else
LZMACOMP=
endif
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 bpamem0 c 153 0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 bpamem1 c 153 1" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 bpamem2 c 153 2" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 bpamem3 c 153 3" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 bpamem4 c 153 4" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 mme c 231 0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB0 c 188 0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB1 c 188 1" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB2 c 188 2" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB3 c 188 3" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB4 c 188 4" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB5 c 188 5" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB6 c 188 6" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB7 c 188 7" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB8 c 188 8" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 ttyUSB9 c 188 9" >> $$dir/.fakeroot && \
		echo "mkdir net" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 net/tun c 10 200" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 vfd c 147 0" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/../cdkroot/sbin/MAKEDEV -p $(flashprefix)/../cdkroot/etc/passwd -g $(flashprefix)/../cdkroot/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} dvb' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "$(MKSQUASHFS) $< $@ -noappend $(LZMACOMP)" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKSQUASHFS) $< $@ -noappend -le -force-uid 0 -force-gid 0 -all-root
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

####### mtd4: $mtdblock.$partition-$gui.$fstype (default: .app)
#Default Size: 6291456d, 600000h
#APP_PARTITION_SIZE to be calculated from ROOT_PARTITION_SIZE and DATA_PARTITION_SIZE

$(flashprefix)/mtdblock4.app-stock.squashfs: $(stockdir)/.app $(MKSQUASHFS) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "$(MKSQUASHFS) $< $@ -noappend" > $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	eme_partition_size=`echo -e "$(EME_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	EMESIZE=`echo -e "ibase=16;$$eme_partition_size" | bc`; \
	data_partition_size=`echo -e "$(DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	APPSIZE=`expr 14024704 - $$ROOTSIZE - $$EMESIZE - $$DATASIZE`; \
	APP_PARTITION_SIZE=0x`echo -e "obase=16;$$APPSIZE" | bc`; \
	if [ $$FILESIZE -gt $$APPSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$APPSIZE, $$APP_PARTITION_SIZE)"; \
		echo "             Reduce ROOT_PARTITION_SIZE or DATA_PARTITION_SIZE"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@
	
$(flashprefix)/mtdblock4.app-stock.enigma2: $(flashprefix)/app-stock-enigma2 $(MKSQUASHFS) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "$(MKSQUASHFS) $< $@ -noappend" > $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	root_partition_size=`echo -e "$(ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$root_partition_size" | bc`; \
	eme_partition_size=`echo -e "$(EME_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	EMESIZE=`echo -e "ibase=16;$$eme_partition_size" | bc`; \
	data_partition_size=`echo -e "$(DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	APPSIZE=`expr 14024704 - $$ROOTSIZE - $$EMESIZE - $$DATASIZE`; \
	APP_PARTITION_SIZE=0x`echo -e "obase=16;$$APPSIZE" | bc`; \
	if [ $$FILESIZE -gt $$APPSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$APPSIZE, $$APP_PARTITION_SIZE)"; \
		echo "             Reduce ROOT_PARTITION_SIZE or DATA_PARTITION_SIZE"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@
	

####### mtd5: $mtdblock.$partition-$gui.$fstype (default: .eme)
#Default Size: 1179648, 120000h
EME_PARTITION_SIZE=0x120000


####### mtd6: $mtdblock.$partition-$gui.$fstype (default: .dat)
#Default Size: 2359296d, 400000h
#DATA_PARTITION_SIZE= (via configure)

$(flashprefix)/mtdblock6.var-stock.jffs2: $(flashprefix)/var-stock-jffs2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cp -rd $(stockdir)/.dat/* $< || true" > $$dir/.fakeroot && \
		echo "$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	data_partition_size=`echo -e "$(DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$DATASIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$DATASIZE, $(DATA_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock6.var-stock.enigma2: $(flashprefix)/var-stock-enigma2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cp -rd $(stockdir)/.dat/* $< || true" > $$dir/.fakeroot && \
		echo "$(MKJFFS2) -e 0x10000 -r $< -o $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	data_partition_size=`echo -e "$(DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$DATASIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$DATASIZE, $(DATA_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

########NEW NEUTRINO VAR PARTITION SIZE:
#NEUTRINO_VAR_PARTITION_SIZE=0x580000 ####look at ufs910_stboards_p0041_flash.patch
#DATA_PARTITION_SIZE= (via configure)
$(flashprefix)/mtdblock3.var-stock.neutrino: $(flashprefix)/var-stock-neutrino $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	data_partition_size=`echo -e "$(--pad=$(DATA_PARTITION_SIZE))" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$DATASIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$DATASIZE, $(DATA_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

$(flashprefix)/mtdblock6.data-stock.jffs2: $(flashprefix)/data-stock-jffs2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cp -rd $(stockdir)/.dat/* $< || true" > $$dir/.fakeroot && \
		echo "$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKJFFS2) -e 0x10000 --pad=$(DATA_PARTITION_SIZE) -r $< -o $@
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	data_partition_size=`echo -e "$(DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$data_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$DATASIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$DATASIZE, $(DATA_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@


#### Targets for building $partition-$gui.$fstype

$(flashprefix)/root-enigma2.disk.tar: \
$(flashprefix)/root-%.disk.tar: $(flashprefix)/root-%-disk
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0777 fbsplash c 10 63" >> $$dir/.fakeroot && \
		echo "chown root:root fbsplash" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 vfd c 147 0" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root/sbin/MAKEDEV -p $(flashprefix)/root/etc/passwd -g $(flashprefix)/root/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} fd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} dvb' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "tar -cvf $@ -C $< ." >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
	chmod 644 $@
	@TUXBOX_CUSTOMIZE@
################################################################################
###################### HDBOX FLASH #############################################
################################################################################
HDBOX_KERNEL_PARTITION_SIZE=0x200000

$(flashprefix)/mtdblock1.kernel-squashfs-hdbox.ubimage: \
			linux-kernel.do_compile | $(flashprefix)
	rm $@* >/dev/null 2>&1 || true
#	$(INSTALL) -m644 @DIR_linux@/arch/sh/boot/uImage $@
	$(INSTALL) -m644 $(KERNEL_DIR)/arch/sh/boot/uImage $@
	@FILESIZE=$$(stat -c%s $@); \
	kernel_partition_size=`echo -e "$(HDBOX_KERNEL_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	KERNELSIZE=`echo -e "ibase=16;$$hdbox_kernel_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$KERNELSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$KERNELSIZE, $(HDBOX_KERNEL_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

HDBOX_ROOT_PARTITION_SIZE=0xa00000
$(flashprefix)/mtdblock2.root-stock-hdbox.enigma2: $(flashprefix)/root-stock-hdbox-enigma2 $(MKSQUASHFS)
#$(flashprefix)/mtdblock.root-stock.%: $(flashprefix)/root-stock-% $(MKSQUASHFS)
	rm $@* >/dev/null 2>&1 || true
	( dir=$(flashprefix) && \
		echo "cd $</dev" > $$dir/.fakeroot && \
		echo "mknod -m 0600 console c 5 1" >> $$dir/.fakeroot && \
		echo "chown root:tty console" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 null c 1 3" >> $$dir/.fakeroot && \
		echo "chown root:root null" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 ttyAS0 c 204 40" >> $$dir/.fakeroot && \
		echo "chown root:root ttyAS0" >> $$dir/.fakeroot && \
		echo "mknod -m 0666 fuse c 10 229" >> $$dir/.fakeroot && \
		echo "mknod -m 0660 vfd c 147 0" >> $$dir/.fakeroot && \
		echo "MAKEDEV=\"$(flashprefix)/root-hdbox/sbin/MAKEDEV -p $(flashprefix)/root-hdbox/etc/passwd -g $(flashprefix)/root-hdbox/etc/group\"" >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} std' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} hda hdb' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sda sdb sdc sdd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} scd0 scd1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} st0 st1' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} sg' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ptyp ptyq' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} console' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} lp par audio fb rtc lirc st200 alsasnd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ppp busmice' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} ttyAS1 ttyAS2 ttyAS3' >> $$dir/.fakeroot && \
		echo 'ln -sf /dev/input/mouse0 mouse' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} input i2c mtd' >> $$dir/.fakeroot && \
		echo '$${MAKEDEV} dvb' >> $$dir/.fakeroot && \
		echo "mkdir pts" >> $$dir/.fakeroot && \
		echo "mkdir shm" >> $$dir/.fakeroot && \
		echo "$(MKSQUASHFS) $< $@ -noappend" >> $$dir/.fakeroot && \
		chmod 755 $$dir/.fakeroot && \
		$(FAKEROOT) -- $$dir/.fakeroot && \
		rm $$dir/.fakeroot )
#	$(MKSQUASHFS) $< $@ -noappend -le -force-uid 0 -force-gid 0 -all-root
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	hdbox_root_partition_size=`echo -e "$(HDBOX_ROOT_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	ROOTSIZE=`echo -e "ibase=16;$$hdbox_root_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$ROOTSIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$ROOTSIZE, $(HDBOX_ROOT_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@

HDBOX_DATA_PARTITION_SIZE=0x13C0000
$(flashprefix)/mtdblock3.var-stock-hdbox.enigma2: $(flashprefix)/var-stock-hdbox-enigma2 $(MKJFFS2) config.status
	rm $@* >/dev/null 2>&1 || true
#	( dir=$(flashprefix) && \
#		echo "cp -rd $(stockdir)/.dat/* $< || true" > $$dir/.fakeroot && \
#		echo "$(MKJFFS2) -e 0x20000 -r $< -o $@" >> $$dir/.fakeroot && \
#		chmod 755 $$dir/.fakeroot && \
#		$(FAKEROOT) -- $$dir/.fakeroot && \
#		rm $$dir/.fakeroot )
	$(MKJFFS2) -e 0x20000 -r $< -o $@
	chmod 644 $@
	@FILESIZE=$$(stat -c%s $@); \
	hdbox_data_partition_size=`echo -e "$(HDBOX_DATA_PARTITION_SIZE)" | tr '[a-f]' '[A-F]' | cut  -b3-`; \
	DATASIZE=`echo -e "ibase=16;$$hdbox_data_partition_size" | bc`; \
	if [ $$FILESIZE -gt $$DATASIZE ]; \
		then echo "fatal error: File $@ too large ($$FILESIZE > $$DATASIZE, $(HDBOX_DATA_PARTITION_SIZE))"; \
		rm $@; exit 1; \
	fi
	@TUXBOX_CUSTOMIZE@