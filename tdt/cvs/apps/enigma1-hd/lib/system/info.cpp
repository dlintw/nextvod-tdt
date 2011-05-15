#include <lib/system/info.h>

#include <lib/base/estring.h>
#include <lib/system/init.h>
#include <lib/system/init_num.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <lib/dvb/frontend.h>
#include <errno.h>
#if HAVE_DVB_API_VERSION >= 3
#include <tuxbox.h>
#endif

eSystemInfo *eSystemInfo::instance;

eSystemInfo::eSystemInfo()
	:hashdd(0), hasci(0), hasrfmod(0), haslcd(0), hasnetwork(1)
	,haskeyboard(0) ,canmeasurelnbcurrent(0), hasnegfilter(0)
	,canupdateTransponder(0), canshutdown(1), canrecordts(0)
	,alphaincrement(10), hasstandbywakeuptimer(0), cantimeshift(0)
	,hasscartswitch(0)
{
	init_eSystemInfo();
}
void eSystemInfo::init_eSystemInfo()
{

	instance=this;
#if HAVE_DVB_API_VERSION >= 3
	int fd=::open(DEMOD_DEV, O_RDONLY);
	fetype = feUnknown;

	if (fd>=0)
	{
		dvb_frontend_info info;
		if ( ::ioctl(fd, FE_GET_INFO, &info) >= 0 )
		{
			switch (info.type)
			{
				case FE_QPSK:
					fetype = feSatellite;
					break;
				case FE_QAM:
					fetype = feCable;
					break;
				default:
				case FE_OFDM:
					fetype = feTerrestrial;
					break;
			}
		}
		else
			eDebug("[SystemInfo] HW type: FE_GET_INFO failed (%m)");
		::close (fd);
	}
	else
		eDebug("[SystemInfo] HW type: open demod failed (%m)");
	std::set<int> caids;
	hasnegfilter=1;
	eString tuner=getTuner("Name").c_str();
	eString cpu = getCpu("cpu type").c_str();
	eString cpuFamily = getCpu("cpu family").c_str();

	if(!strncmp("sh4", cpuFamily.c_str(), 3))
	{
		switch (getBoxModel())
		{
		case HL101:
		    eDebug("[SystemInfo] HW type: HL101");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="Spider";
			helpstr="hl101";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
			modelstr="SpiderBox HL101 HD";
			if(!strncmp(" STB0899 Multistandard", tuner.c_str(), 22))
				tunerstr = "ST STB0899 DVB S2";
			else if (!strncmp(" ST STV0903", tuner.c_str(), 11))
				tunerstr = "ST STV0903 DVB S2";
			else if (!strncmp(" Zarlink", tuner.c_str(), 8))
				tunerstr = "Zarlink ZL10353 DVB T";
			else if (!strncmp(" Philips", tuner.c_str(), 8))
				tunerstr = "Philips TDA1023 DVB C";
			else
				tunerstr = "Unknown";
			midstr="91";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 0;
			hasci=1;
			hasscartswitch = 1;
			break;
		case VIP2:
		    eDebug("[SystemInfo] HW type: VIP2");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="EDISION";
			helpstr="vip2";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
			modelstr="EDISION Argus vip2";
			if(!strncmp(" STB0899 Multistandard", tuner.c_str(), 22))
				tunerstr = "ST STB0899 DVB S2";
			else if (!strncmp(" ST STV0903", tuner.c_str(), 11))
				tunerstr = "ST STV0903 DVB S2";
			else if (!strncmp(" Zarlink", tuner.c_str(), 8))
				tunerstr = "Zarlink ZL10353 DVB T";
			else if (!strncmp(" Philips", tuner.c_str(), 8))
				tunerstr = "Philips TDA1023 DVB C";
			else
				tunerstr = "Unknown";
			midstr="91";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 0;
			hasci=1;
			hasscartswitch = 1;
			break;
		case UFS9101W:
		    eDebug("[SystemInfo] HW type: UFS9101W");
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="Kathrein";
			helpstr="ufs9101w";
			cpustr="STi7100, 265MHz";
			haskeyboard=1;
			modelstr="Kathrein UFS910 1W";
			if(!strncmp(" Conexant", tuner.c_str(), 9))
				tunerstr = "Conexant cx24116 DVB S2";
			else
				tunerstr = "Unknown";
			midstr="92";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=1;
			hasscartswitch = 1;
			break;
		case UFS91014W:
		    eDebug("[SystemInfo] HW type: UFS91014W");
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="Kathrein";
			helpstr="ufs91014w";
			cpustr="STi7100, 265MHz";
			haskeyboard=1;
			modelstr="Kathrein UFS910 14W";
			if(!strncmp(" Conexant", tuner.c_str(), 9))
				tunerstr = "Conexant cx24116 DVB S2";
			else
				tunerstr = "Unknown";
			midstr="92";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 0;
			hasci=1;
			hasscartswitch = 1;
			break;
		case ATEVIO7500:
		    eDebug("[SystemInfo] HW type: Atevio 7500");
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="Atevio";
			helpstr="atevio7500";
			cpustr="STi7105";
			haskeyboard=1;
			modelstr="Atevio 7500";
			if(!strncmp(" avl2108", tuner.c_str(), 9))
				tunerstr = "AVL2108 DVB S2";
			else
				tunerstr = "Unknown";
			midstr="92";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=1;
			hasscartswitch = 1;
			break;
		case DGS_R900:
		    eDebug("[SystemInfo] HW type: IPBOX 900");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="AB-COM";
			helpstr="ipbox";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
            modelstr="AB IPBox 900HD";
            if(!strncmp(" Conexant", tuner.c_str(), 9))
            	tunerstr = "Conexant cx24116 DVB S2";
            else if (!strncmp(" ST STV0903", tuner.c_str(), 11))
            	tunerstr = "ST STV0903 DVB S2";
            else if (!strncmp(" Zarlink", tuner.c_str(), 8))
            	tunerstr = "Zarlink ZL10353 DVB T";
            else if (!strncmp(" Philips", tuner.c_str(), 8))
            	tunerstr = "Philips TDA1023 DVB C";
            else
            	tunerstr = "Unknown";
			midstr="60";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=1;
			hasscartswitch = 0;
			break;
		case DGS_R910:
		    eDebug("[SystemInfo] HW type: IPBOX 910");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="AB-COM";
			helpstr="ipbox";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
            modelstr="AB IPBox 910HD";
            if(!strncmp(" Conexant", tuner.c_str(), 9))
        	    tunerstr = "Conexant cx24116 DVB S2";
            else if (!strncmp(" ST STV0903", tuner.c_str(), 11))
            	tunerstr = "ST STV0903 DVB S2";
            else if (!strncmp(" Zarlink", tuner.c_str(), 8))
                tunerstr = "Zarlink ZL10353 DVB T";
            else if (!strncmp(" Philips", tuner.c_str(), 8))
                tunerstr = "Philips TDA1023 DVB C";
            else
                tunerstr = "Unknown";
			midstr="70";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=1;
			hasscartswitch = 0;
			break;
		case DGS_R9000:
		    eDebug("[SystemInfo] HW type: IPBOX 9000");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="AB-COM";
			helpstr="ipbox";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
            modelstr="AB IPBox 9000HD";
            if(!strncmp(" Conexant", tuner.c_str(), 9))
        	    tunerstr = "Conexant cx24116 DVB S2";
            else if (!strncmp(" ST STV0903", tuner.c_str(), 11))
            	tunerstr = "ST STV0903 DVB S2";
            else if (!strncmp(" Zarlink", tuner.c_str(), 8))
                tunerstr = "Zarlink ZL10353 DVB T";
            else if (!strncmp(" Philips", tuner.c_str(), 8))
                tunerstr = "Philips TDA1023 DVB C";
            else
                tunerstr = "Unknown";
			midstr="80";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=1;
			hasscartswitch = 1;
			break;
		case DGS_R91:
		    eDebug("[SystemInfo] HW type: IPBOX 91");
			caids.insert(0x4a70);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
			manufactstr="AB-COM";
			helpstr="ipbox";
			cpustr="STi7101, 265MHz";
			haskeyboard=1;
			modelstr="AB IPBox 91HD";
			tunerstr = "ST STV0903 DVB S2";
			midstr="90";
			haslcd = hashdd = canmeasurelnbcurrent = canrecordts = cantimeshift = 1;
			hasstandbywakeuptimer = 1;
			hasci=0;
			hasscartswitch = 0;
			break;
		default:
			eDebug("[SystemInfo] HW type: Unknown");
			hwtype = Unknown;
			break;
		}
		if(hwtype!=Unknown)
		{
			eDebug("[SystemInfo] Manufacure: %s", manufactstr);
			eDebug("[SystemInfo] Model: %s", modelstr);
			eDebug("[SystemInfo] CPU: %s", cpustr);
			eDebug("[SystemInfo] Tuner: %s", tunerstr);
		}
	}
	else
	{
		switch (tuxbox_get_submodel())
		{
			case TUXBOX_SUBMODEL_DREAMBOX_DM7000:
				defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
				canupdateTransponder = canrecordts = hashdd =
				haslcd = canmeasurelnbcurrent =
				hasci = 1;
				hwtype = DM7000;
	//			caids.insert(0x4a70);
				midstr="5";
				helpstr="dreambox";
				modelstr="DM7000";
				cpustr="STB04500, 252MHz";
				break;
			case TUXBOX_SUBMODEL_DBOX2:
				defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
				caids.insert(0x1702);
				caids.insert(0x1722);
				caids.insert(0x1762);
				canrecordts=1;
				hasstandbywakeuptimer=haslcd=1;
				helpstr="dbox2";
				modelstr="d-Box 2";
				cpustr="XPC823, 66MHz";
				switch ( tuxbox_get_vendor() )
				{
					case TUXBOX_VENDOR_NOKIA:
						hwtype = dbox2Nokia;
						midstr="1";
						manufactstr="Nokia";
						break;
					case TUXBOX_VENDOR_PHILIPS:
						midstr="2";
						hwtype = dbox2Philips;
						manufactstr="Philips";
						break;
					case TUXBOX_VENDOR_SAGEM:
						midstr="3";
						hwtype = dbox2Sagem;
						manufactstr="Sagem";
						break;
					default:
						hwtype = Unknown;
				}
				break;
			default:
			        eDebug("[SystemInfo] HW type: Unknown");
				hwtype = Unknown;
				break;
		}
	}

#else
	int mid = atoi(getInfo("mID").c_str());

	switch (mid)
	{
		case 5 ... 7:
		case 9:
		case 11:
		case 12:
			manufactstr="Dream-Multimedia-TV";
			helpstr="dreambox";
			canupdateTransponder=haskeyboard=1;
			caids.insert(0x4a70);
			switch(mid)
			{
				case 5:
					midstr="5";
					modelstr="DM7000";
					cpustr="STB04500, 252MHz";
					hashdd = haslcd = canmeasurelnbcurrent = hasci
					= canrecordts = cantimeshift = 1;
					hwtype = DM7000;
					defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
					{
						// check if new FP Firmware is avail...
						int fd = open("/dev/dbox/fp0", O_RDWR);
						if ( fd >=0)
						{
#define FP_IOCTL_GET_ID 0
							int ret = ::ioctl(fd,FP_IOCTL_GET_ID);
							if ( ret < 0 )
								eDebug("old fp driver.. no support for wakeup timer");
							else if ( ret == 0 )
								eDebug("old fp firmware... no support for wakeup timer");
							else
								hasstandbywakeuptimer=1;
							close(fd);
						}
					}
					break;
				case 6:
					midstr="6";
					cpustr="STBx25xx, 252MHz";
					alphaincrement=25;
					canshutdown=0;
					hasci = 2;
					hwtype = getInfo("type", true) == "DM5600" ? DM5600 : DM5620;
					if ( hwtype == DM5600 )
					{
						defaulttimertype=ePlaylistEntry::SwitchTimerEntry;
						hasnetwork=0;
						modelstr="DM5600";
					}
					else
					{
						modelstr="DM5620";
						defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recNgrab;
					}
					break;
				case 7:
					midstr="7";
					cpustr="STBx25xx, 252MHz";
					modelstr="DM500";
					alphaincrement=25;
					defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recNgrab;
					canshutdown=canrecordts=hasscartswitch=0;
					hwtype = DM500;
					break;
				case 9:
				{
					midstr="9";
					modelstr="DM7020";
					cpustr="STB04500, 252MHz";
    					hasrfmod = hashdd = haslcd = hasci
					= canrecordts = hasstandbywakeuptimer = cantimeshift = 1;
					// check if the box revision is new enough to measure
					// lnb power with > 13V ( revisions with lnbp21 can this )
					int fd = open("/dev/dbox/fp0", O_RDWR);
					if ( fd >=0 )
					{
						if ( ::ioctl( fd, 0x100, 0 ) == 0 )
							canmeasurelnbcurrent=1;
						else
							canmeasurelnbcurrent=2;
						close(fd);
					}
					hwtype = DM7020;
					defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
					break;
				}
				case 11:
				{
					alphaincrement=25;
					midstr="11";
					modelstr="DM600PVR";
					cpustr="STBx25xx, 252MHz";
					hashdd = canrecordts = cantimeshift = 1;
					hasscartswitch = 0;
					hwtype = DM600PVR;
					defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recDVR;
					break;
				}
				case 12:
				{
					alphaincrement=25;
					midstr="12";
					modelstr="DM500PLUS";
					cpustr="STBx25xx, 252MHz";
					defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recNgrab;
					canrecordts=hasscartswitch=0;
					hwtype = DM500PLUS;
					break;
				}
			}
			break;
		case 1 ... 3:
			modelstr="d-Box 2";
			helpstr="dbox2";
			cpustr="XPC823, 66MHz";
			caids.insert(0x1702);
			caids.insert(0x1722);
			caids.insert(0x1762);
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recNgrab;
			hasstandbywakeuptimer=haslcd=1;
			switch ( mid )
			{
				case 1:
					manufactstr="Nokia";
					midstr="1";
					hwtype = dbox2Nokia;
					break;
				case 2:
					manufactstr="Philips";
					midstr="2";
					hwtype = dbox2Philips;
					break;
				case 3:
					manufactstr="Sagem";
					midstr="3";
					hwtype = dbox2Sagem;
					break;
				default:
					break;
			}
			break;
		case 8:
			manufactstr="Triax";
			helpstr="dreambox";
			midstr="8";
			cpustr="STBx25xx, 252MHz";
			modelstr="DVB 272S";
			alphaincrement=25;
			defaulttimertype=ePlaylistEntry::RecTimerEntry|ePlaylistEntry::recNgrab;
			canshutdown=0;
			haskeyboard=canupdateTransponder=1;
			hwtype = TR_DVB272S;
			caids.insert(0x4a70);
			hasci=2;
			break;
		default:
			break;
	}
	int fd = open ("/dev/rfmod0", O_RDWR);
	if ( fd >= 0 )
	{
		hasrfmod=1;
		close(fd);
	}
	fd = open("/dev/dvb/card0/demux0", O_RDWR);
	if ( fd >=0 )
	{
		if ( ::ioctl( fd, DMX_SET_NEGFILTER_MASK, 0 ) >= 0 )
			hasnegfilter=1;
		close(fd);
	}
	if ( hwtype < DM7000 )
	{
		switch (atoi(getInfo("fe").c_str()))
		{
			case 0: // DBOX_FE_CABLE
				fetype=feCable;
				break;
			case 1: // DBOX_FE_SATELLITE
				fetype=feSatellite;
				break;
			default:
				fetype=feSatellite;
		}
	}
	else
	{
		fetype = feUnknown;
		int fd=::open(DEMOD_DEV, O_RDONLY);
		if (fd>=0)
		{
			FrontendInfo info;
			fetype = feSatellite;	// default
			if ( ::ioctl(fd, FE_GET_INFO, &info) >= 0 )
			{
				switch (info.type)
				{
					case FE_QPSK:
						fetype = feSatellite;
						break;
					case FE_QAM:
						fetype = feCable;
						break;
					case FE_OFDM:
						fetype = feTerrestrial;
						break;
				}
			}
			else
				eDebug("FE_GET_INFO failed (%m)");
			::close (fd);
		}
	}
#endif
}

#if HAVE_DVB_API_VERSION < 3
eString eSystemInfo::getInfo(const char *info, bool dreambox)
{
	FILE *f=0;
	if ( dreambox )
		f=fopen("/proc/bus/dreambox", "rt");
	else
		f=fopen("/proc/bus/dbox", "rt");
	if (!f)
		return "";
	eString result;
	while (1)
		{
		char buffer[128];
		if (!fgets(buffer, 128, f))
			break;
		if (strlen(buffer))
			buffer[strlen(buffer)-1]=0;
		if ((!strncmp(buffer, info, strlen(info)) && (buffer[strlen(info)]=='=')))
		{
			int i = strlen(info)+1;
			result = eString(buffer).mid(i, strlen(buffer)-i);
			break;
		}
	}
	fclose(f);
	return result;
}
#endif

#if HAVE_DVB_API_VERSION >= 3
eString eSystemInfo::getTuner(const char *info)
{
	FILE *f=0;
	f=fopen("/proc/bus/nim_sockets", "rt");
	if (!f)
		return "";
	eString result;
	while (1)
		{
		char buffer[128];
		if (!fgets(buffer, 128, f))
			break;
		if (strlen(buffer))
			buffer[strlen(buffer)-1]=0;
		if ((!strncmp(buffer, info, strlen(info)) && (buffer[strlen(info)]==':')))
		{
			int i = strlen(info)+1;
			result = eString(buffer).mid(i, strlen(buffer)-i);
			break;
		}
	}
	fclose(f);
	//eDebug("[%s] %s: %s", __FUNCTION__, info, result.c_str());
	return result;
}

eString eSystemInfo::getCpu(const char *info)
{
	FILE *f=0;
	f=fopen("/proc/cpuinfo", "rt");
	if (!f)
		return "";
	eString result;
	while (1)
	{
		char buffer[128];
		if (!fgets(buffer, 128, f))
			break;
		if (strlen(buffer))
			buffer[strlen(buffer)-1]=0;
		if (strstr(buffer, info))
		{
			result = eString(strchr(buffer, ':')+2);
			break;
		}
	}
	fclose(f);
	//eDebug("[%s] %s: %s", __FUNCTION__, info, result.c_str());
	return result;
}

/* from fp_control */
int eSystemInfo::getKathreinUfs910BoxType()
{
    char vType;
    int vFdBox = open("/proc/boxtype", O_RDONLY);

    read (vFdBox, &vType, 1);

    close(vFdBox);

    return vType=='0'?0:vType=='1'||vType=='3'?1:-1;
}

int eSystemInfo::getBoxModel()
{
    int         vFd             = -1;
    const int   cSize           = 128;
    char        vName[129]      = "Unknown";
    int         vLen            = -1;
    int	    	vBoxType        = Unknown;

    vFd = open("/proc/stb/info/model", O_RDONLY);
    vLen = read (vFd, vName, cSize);

    close(vFd);

    if(vLen > 0) {
        vName[vLen-1] = '\0';

        if(!strncasecmp(vName,"ufs910", 6)) {
            switch(getKathreinUfs910BoxType())
            {
                case 0:
                	vBoxType = UFS9101W;
                    break;
                case 1:
                	vBoxType = UFS91014W;
                    break;
                default:
                	vBoxType = Unknown;
                    break;
            }
        } else if(!strncasecmp(vName,"ufs922", 6))
        	vBoxType = UFS922;
        else if(!strncasecmp(vName,"tf7700hdpvr", 11))
        	vBoxType = TF7700;
        else if(!strncasecmp(vName,"hl101", 5))
        	vBoxType = HL101;
        else if(!strncasecmp(vName,"vip2", 4))
        	vBoxType = VIP2;
        else if(!strncasecmp(vName,"hdbox", 5))
        	vBoxType = HDBOX;
        else if(!strncasecmp(vName,"atevio7500", 5))
        	vBoxType = ATEVIO7500;
        else
        	vBoxType = Unknown;
    }

    hwtype = vBoxType;
    return vBoxType;
}
#endif

eAutoInitP0<eSystemInfo> init_info(eAutoInitNumbers::sysinfo, "SystemInfo");
