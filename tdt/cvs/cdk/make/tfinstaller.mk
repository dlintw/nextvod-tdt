# TF7700 installer

.PHONY: tfinstaller
tfinstaller:
	@export PATH=$(hostprefix)/bin:$(PATH) && \
	$(MAKE) $(MAKE_OPTS) -C tfinstaller
