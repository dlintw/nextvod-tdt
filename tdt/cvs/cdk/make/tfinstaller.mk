# TF7700 installer

tfinstaller:
	@export PATH=$(hostprefix)/bin:$(PATH) && \
	$(MAKE) $(MAKE_OPTS) -C tfinstaller

.PHONY: tfinstaller