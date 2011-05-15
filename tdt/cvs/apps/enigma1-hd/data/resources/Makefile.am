EXTRA_DIST = rcdboxnew.xml rcdboxold.xml rcdboxbuttons.xml help.xml \
	rcdm7000.xml rcdm5xxx.xml rctrdvb272.xml rc_hl101.xml rc_vip2.xml\
	rcdreambox_inputdev.xml rcgeneric_inputdev.xml rcdbox_inputdev.xml \
	rcufs9101w.xml rcufs91014w.xml rc_atevio7500.xml\
	keymappings.xml rcdreambox_keyboard.xml

install-data-local:
	install -d $(DESTDIR)$(TUXBOXDATADIR)/enigma/resources
	install -m 0644 $(EXTRA_DIST) $(DESTDIR)$(TUXBOXDATADIR)/enigma/resources
