
$(flashprefix)/root-cramfs \
$(flashprefix)/root-squashfs \
$(flashprefix)/root-jffs2 \
$(flashprefix)/root-focramfs \
$(flashprefix)/root-fosquashfs: \
$(flashprefix)/root-%: \
		$(flashprefix)/root-%/lib
if ENABLE_OSD910
	$(MAKE) flash-osd910.$*
endif
	@touch $@
	@TUXBOX_CUSTOMIZE@
	@FLASHROOTDIR_MODIFIED@

$(flashprefix)/root-disk: \
$(flashprefix)/root-%: \
		$(flashprefix)/root-%/lib
	@touch $@
	@TUXBOX_CUSTOMIZE@


