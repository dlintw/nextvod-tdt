
URLDIV1=ftp://mirrors.kernel.org/fedora/core/6/i386/os/Fedora/RPMS
URL=ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/RPM_Distribution/sh4-target-glibc-packages
URLU=ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/RPM_Distribution/sh4-updates
URL2=ftp://ftp.stlinux.com/pub/stlinux/2.2/STLinux/sh4
URL2U=ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/RPMS/sh4
URL3=ftp://ftp.stlinux.com/pub/stlinux/2.3/STLinux/sh4
URL3U=ftp://ftp.stlinux.com/pub/stlinux/2.3/updates/RPMS/sh4
URL4=ftp://ftp.stlinux.com/pub/stlinux/2.4/STLinux/sh4
URL4U=ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/RPMS/sh4


URLSH=http://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/SRPM_Distribution/host-SRPMS
URLSHU=http://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/SRPM_Distribution/sh4-SRPMS-updates
URL2SH=ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS/
URL2SHU=ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS
URLS=ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/SRPM_Distribution/sh4-SRPMS
URLSU=ftp://ftp.stlinux.com/pub/stlinux/2.0/ST_Linux_2.0/SRPM_Distribution/sh4-SRPMS-updates
URL2S=ftp://ftp.stlinux.com/pub/stlinux/2.2/SRPMS
URL2SU=ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS
URL3S=ftp://ftp.stlinux.com/pub/stlinux/2.3/SRPMS
URL3SU=ftp://ftp.stlinux.com/pub/stlinux/2.3/updates/SRPMS
URL4S=ftp://ftp.stlinux.com/pub/stlinux/2.4/SRPMS
URL4SU=ftp://ftp.stlinux.com/pub/stlinux/2.4/updates/SRPMS

$(archivedir)/bash-3.1-16.1.i386.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URLDIV1)/$(notdir $@)) || true
$(archivedir)/stlinux20-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL)/$(notdir $@) || $(WGET) $(URLU)/$(notdir $@)) || true
$(archivedir)/stlinux22-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL2)/$(notdir $@) || $(WGET) $(URL2U)/$(notdir $@)) || true
$(archivedir)/stlinux23-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3)/$(notdir $@) || $(WGET) $(URL3U)/$(notdir $@)) || true
$(archivedir)/stlinux24-sh4-%.sh4.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4)/$(notdir $@) || $(WGET) $(URL4U)/$(notdir $@)) || true

$(archivedir)/stlinux20-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URLSH)/$(notdir $@) || $(WGET) $(URLSHU)/$(notdir $@)) || true
$(archivedir)/stlinux22-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL2SH)/$(notdir $@) || $(WGET) $(URL2SHU)/$(notdir $@)) || true
$(archivedir)/stlinux23-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-host-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true
$(archivedir)/stlinux20-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URLSH)/$(notdir $@) || $(WGET) $(URLSHU)/$(notdir $@)) || true
$(archivedir)/stlinux22-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL2SH)/$(notdir $@) || $(WGET) $(URL2SHU)/$(notdir $@)) || true
$(archivedir)/stlinux23-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-cross-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true
$(archivedir)/stlinux20-target-%.src.rpm:
	[ ! -f $(archivedir)/$(notdir $@) ] && \
	(cd $(archivedir) && $(WGET) $(URLS)/$(notdir $@) || $(WGET) $(URLSU)/$(notdir $@)) || true
$(archivedir)/stlinux22-target-%.src.rpm:
	[ ! -f $(archivedir)/$@ ] && \
	(cd $(archivedir) && $(WGET) $(URL2S)/$(notdir $@) || $(WGET) $(URL2SU)/$(notdir $@)) || true
$(archivedir)/stlinux23-target-%.src.rpm:
	[ ! -f $(archivedir)/$@ ] && \
	(cd $(archivedir) && $(WGET) $(URL3S)/$(notdir $@) || $(WGET) $(URL3SU)/$(notdir $@)) || true
$(archivedir)/stlinux24-target-%.src.rpm:
	[ ! -f $(archivedir)/$@ ] && \
	(cd $(archivedir) && $(WGET) $(URL4S)/$(notdir $@) || $(WGET) $(URL4SU)/$(notdir $@)) || true
