#include <setupvideo.h>

#include <lib/base/i18n.h>

#include <lib/driver/eavswitch.h>
#include <lib/dvb/edvb.h>
#include <lib/dvb/eaudio.h>
#include <lib/dvb/decoder.h>
#include <lib/driver/rc.h>
#include <lib/driver/streamwd.h>
#include <lib/gdi/gfbdc.h>
#include <lib/gui/elabel.h>
#include <lib/gui/ebutton.h>
#include <lib/gui/eskin.h>
#include <lib/gui/echeckbox.h>
#include <lib/gui/emessage.h>
#include <lib/gui/testpicture.h>
#include <lib/system/econfig.h>
#include <lib/system/info.h>
#include <lib/system/init.h>
#include <lib/system/init_num.h>

#include <src/enigma_lcd.h>
#include <src/enigma.h>                                               
#include <src/enigma_main.h>

eZapVideoSetup::eZapVideoSetup()
	:eWindow(0)
{
	init_eZapVideoSetup();
}

void eZapVideoSetup::init_eZapVideoSetup()
{
/*	eSkin *skin=eSkin::getActive();
	if (skin->build(this, "setup.video"))
		qFatal("skin load of \"setup.video\" failed");*/

/*	cresize( eSize(height(), width()) );
	cmove( ePoint(0,0) );*/

	FILE *f=fopen("/etc/videomode", "r");
	if (f){
	  fscanf(f, "%d", &v_videoformat);
	  eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat);
	} else 
		v_videoformat = 0;
	fclose(f);

	v_videochange = 0;

	if (eConfig::getInstance()->getKey("/elitedvb/video/colorformat", v_colorformat))
		v_colorformat = 0;

	if (eConfig::getInstance()->getKey("/elitedvb/video/pin8", v_pin8))
		v_pin8 = 0;

	if (eConfig::getInstance()->getKey("/elitedvb/video/disableWSS", v_disableWSS ))
		v_disableWSS = 0;

	if (eConfig::getInstance()->getKey("/elitedvb/video/tvsystem", v_tvsystem ))
		v_tvsystem = 1;
		
	if (!v_tvsystem)
		v_tvsystem = 1;

	if (eConfig::getInstance()->getKey("/elitedvb/video/vcr_switching", v_VCRSwitching ))
		v_VCRSwitching=1;

	int fd=eSkin::getActive()->queryValue("fontsize", 20);

	setText(_("A/V Settings"));
	move(ePoint(160, 50));
	cresize(eSize(390, 400));

	eLabel *l=new eLabel(this);
	l->setText(_("Video Format:"));
	l->move(ePoint(20, 20));
	l->resize(eSize(150, fd+4));

	videoformat=new eListBox<eListBoxEntryText>(this, l);
	videoformat->loadDeco();
	videoformat->setFlags(eListBox<eListBoxEntryText>::flagNoUpDownMovement);
	videoformat->move(ePoint(180, 20));
	videoformat->resize(eSize(120, 35));
	eListBoxEntryText* entrys[5];	
	entrys[0]=new eListBoxEntryText(videoformat, _("576i"), (void*)0);
	entrys[1]=new eListBoxEntryText(videoformat, _("576p50"), (void*)1);	
	entrys[2]=new eListBoxEntryText(videoformat, _("720p50"), (void*)2);
	entrys[3]=new eListBoxEntryText(videoformat, _("720p60"), (void*)3);
	entrys[4]=new eListBoxEntryText(videoformat, _("1080i50"), (void*)4);      
	entrys[5]=new eListBoxEntryText(videoformat, _("1080i60"), (void*)5);

	videoformat->setCurrent(entrys[v_videoformat]);
	videoformat->setHelpText(_("choose video format ( left, right )"));
	CONNECT( videoformat->selchanged, eZapVideoSetup::VFormatChanged );
    
	if ( eSystemInfo::getInstance()->getHwType() != eSystemInfo::DGS_R91 ){
		l=new eLabel(this);
		l->setText(_("Color Format:"));
		l->move(ePoint(20, 60));
		l->resize(eSize(150, fd+4));

		colorformat=new eListBox<eListBoxEntryText>(this, l);
		colorformat->loadDeco();
		colorformat->setFlags(eListBox<eListBoxEntryText>::flagNoUpDownMovement);
		colorformat->move(ePoint(180, 60));
		colorformat->resize(eSize(120, 35));
	
		entrys[0]=new eListBoxEntryText(colorformat, _("CVBS"), (void*)0);
		entrys[1]=new eListBoxEntryText(colorformat, _("RGB"), (void*)1);
		if ( eSystemInfo::getInstance()->getHwType() != eSystemInfo::DGS_R91 )
	        	entrys[2]=new eListBoxEntryText(colorformat, _("YPbPr"), (void*)2);
		colorformat->setCurrent(entrys[v_colorformat-1]);
		colorformat->setHelpText(_("choose color format ( left, right )"));
		CONNECT( colorformat->selchanged, eZapVideoSetup::CFormatChanged );
	}	

	l=new eLabel(this);
	l->setText(_("Aspect Ratio:"));
	l->move(ePoint(20, 100));
	l->resize(eSize(150, fd+4));

	pin8=new eListBox<eListBoxEntryText>(this, l);
	pin8->loadDeco();	
	pin8->setFlags(eListBox<eListBoxEntryText>::flagNoUpDownMovement);
	
	pin8->move(ePoint(180, 100));
	pin8->resize(eSize(170, 35));
	pin8->setHelpText(_("choose aspect ratio ( left, right )"));
	entrys[0]=new eListBoxEntryText(pin8, _("4:3 letterbox"), (void*)0);
	entrys[1]=new eListBoxEntryText(pin8, _("4:3 panscan"), (void*)1);
	entrys[2]=new eListBoxEntryText(pin8, _("16:9"), (void*)2);
	/* dbox, dm700, dm7020 can do black bars left and right of 4:3 video */
	if ( eSystemInfo::getInstance()->getHwType() >= eSystemInfo::DGS_R900 )
		entrys[3]=new eListBoxEntryText(pin8, _("always 16:9"), (void*)3);
	pin8->setCurrent(entrys[v_pin8]);
	CONNECT( pin8->selchanged, eZapVideoSetup::VPin8Changed );
		
	if( v_videoformat == 0 )	
	{
		l=new eLabel(this);
		l->setText(_("TV System:"));
		l->move(ePoint(20, 140));
		l->resize(eSize(150, fd+4));
	
		tvsystem=new eListBox<eListBoxEntryText>(this, l);
		tvsystem->loadDeco();	
		tvsystem->setFlags(eListBox<eListBoxEntryText>::flagNoUpDownMovement);
	
		// our bitmask is:
	
		// have pal     1
		// have ntsc    2
		// have pal60   4  (aka. PAL-M bis wir PAL60 supporten)
	
		// allowed bitmasks:
	
		//  1    pal only, no ntsc
		//  2    ntsc only, no pal
		//  3    multinorm
		//  5    pal, pal60
	
		tvsystem->move(ePoint(180, 140));
		tvsystem->resize(eSize(170, 35));
//		tvsystem->setHelpText(_("choose TV system ( left, right )"));
		entrys[0]=new eListBoxEntryText(tvsystem, "PAL", (void*)1);
//		entrys[1]=new eListBoxEntryText(tvsystem, "PAL + PAL60", (void*)5);
//		entrys[2]=new eListBoxEntryText(tvsystem, "Multinorm", (void*)3);
//		entrys[3]=new eListBoxEntryText(tvsystem, "NTSC", (void*)2);
	
		int i = 0;
		switch (v_tvsystem)
		{
		case 1: i = 0; break;
		case 5: i = 1; break;
		case 3: i = 2; break;
		case 2: i = 3; break;
		}
		tvsystem->setCurrent(entrys[i]);
		CONNECT( tvsystem->selchanged, eZapVideoSetup::TVSystemChanged );

		c_disableWSS = new eCheckbox(this, v_disableWSS, 1);
		c_disableWSS->move(ePoint(20,180));
		c_disableWSS->resize(eSize(350,30));
		c_disableWSS->setText(_("Disable WSS on 4:3"));
		c_disableWSS->setHelpText(_("don't send WSS signal when A-ratio is 4:3"));
		CONNECT( c_disableWSS->checked, eZapVideoSetup::DisableWSSChanged );
    	}
	int sac3default = 0;
	sac3default=eAudio::getInstance()->getAC3default();

	ac3default=new eCheckbox(this, sac3default, 1);
	ac3default->setText(_("AC3 default output"));
	ac3default->move(ePoint(20, 215));
	ac3default->resize(eSize(350, 30));
	ac3default->setHelpText(_("enable/disable ac3 default output (ok)"));
	CONNECT( ac3default->checked, eZapVideoSetup::ac3defaultChanged );

	if ( eSystemInfo::getInstance()->hasScartSwitch() )
	{
		VCRSwitching=new eCheckbox(this, v_VCRSwitching, 1);
		VCRSwitching->setText(_("Auto VCR switching"));
		VCRSwitching->move(ePoint(20, 240));
		VCRSwitching->resize(eSize(350, 30));
		VCRSwitching->setHelpText(_("auto switch to VCR connector"));
		CONNECT( VCRSwitching->checked, eZapVideoSetup::VCRChanged );
	}

	ok=new eButton(this);
	ok->setText(_("save"));
	ok->setShortcut("green");
	ok->setShortcutPixmap("green");
	ok->move(ePoint(20, 290));
	ok->resize(eSize(220, 40));
	ok->setHelpText(_("save changes and return"));
	ok->loadDeco();

	CONNECT(ok->selected, eZapVideoSetup::okPressed);		

	testpicture=new eButton(this);
	testpicture->setText(_("test"));
	testpicture->setShortcut("blue");
	testpicture->setShortcutPixmap("blue");
	testpicture->move(ePoint(260, 290));
	testpicture->resize(eSize(100, 40));
	testpicture->setHelpText(_("show testpicture"));
	testpicture->loadDeco();

	CONNECT(testpicture->selected, eZapVideoSetup::showTestpicture);		

	status = new eStatusBar(this);	
	status->move( ePoint(0, clientrect.height()-50) );
	status->resize( eSize( clientrect.width(), 50) );
	status->loadDeco();
	setHelpID(86);
}

eZapVideoSetup::~eZapVideoSetup()
{
	if (status)
		delete status;
}

void eZapVideoSetup::showTestpicture()
{
	hide();
	
	int mode = 1;
	while ((mode > 0) && (mode < 9))
		mode = eTestPicture::display(mode-1);
	
	show();
}

void eZapVideoSetup::okPressed()
{
	FILE *f=fopen("/etc/videomode", "w");
	if (f){
	  fprintf(f,"%d", v_videoformat);
	}
	fclose(f);

	eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat );	
	eConfig::getInstance()->setKey("/elitedvb/video/vcr_switching", v_VCRSwitching );
        if(v_videoformat > 0)
    		v_colorformat = 2;
    	if ( eSystemInfo::getInstance()->getHwType() == eSystemInfo::DGS_R91 )
    		v_colorformat = 0;
        eConfig::getInstance()->setKey("/elitedvb/video/colorformat", v_colorformat );
	eConfig::getInstance()->setKey("/elitedvb/video/pin8", v_pin8 );
	eConfig::getInstance()->setKey("/elitedvb/video/disableWSS", v_disableWSS );
	eConfig::getInstance()->setKey("/elitedvb/video/tvsystem", v_tvsystem);
	eConfig::getInstance()->setKey("/elitedvb/system/videochange", v_videochange);		    

	eAudio::getInstance()->saveSettings();
	eConfig::getInstance()->flush();
	
	eConfig::getInstance()->getKey("/elitedvb/system/videochange", v_videochange);

        if(v_videochange!=0) 
        {
		eMessageBox msg (_("Yes to restart GUI for new video setting."),
				_("A/V Settings"),
		eMessageBox::iconQuestion|eMessageBox::btYes|eMessageBox::btNo, eMessageBox::btYes, 15 );
		msg.show();
		int res=msg.exec();
		msg.hide();
		if ( res == eMessageBox::btYes )
		{	
//FIXME
			system("/etc/init.d/videomode stop");
                        Decoder::Flush();
                        fbClass::getInstance()->fbset();
			if ( !service )
    				service = eServiceInterface::getInstance()->service;
    			eServiceInterface::getInstance()->service=eServiceReference();
    			eZapMain::getInstance()->playService(service, eZapMain::psDontAdd|eZapMain::psSetMode );
		}
         }        
 	close(1);
}

int eZapVideoSetup::eventHandler( const eWidgetEvent &e)
{
	switch(e.type)
	{
		case eWidgetEvent::execDone:
			eAVSwitch::getInstance()->reloadSettings();
			eStreamWatchdog::getInstance()->reloadSettings();
			eAudio::getInstance()->reloadSettings();
			break;
		default:
			return eWindow::eventHandler( e );
	}
	return 1;
}

void eZapVideoSetup::VFormatChanged( eListBoxEntryText * e )
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/videoformat", old);
	if ( e )
	{
		v_videoformat = (unsigned int) e->getKey();
		v_videochange = 1;
		eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat );
            	eConfig::getInstance()->setKey("/elitedvb/system/videochange", v_videochange);		    
		eConfig::getInstance()->setKey("/elitedvb/video/videoformat", old );
	}
}

void eZapVideoSetup::CFormatChanged( eListBoxEntryText * e )
{
	unsigned int old = 1;
	eConfig::getInstance()->getKey("/elitedvb/video/colorformat", old);
	if ( e )
	{
		v_colorformat = (unsigned int) e->getKey();
		eConfig::getInstance()->setKey("/elitedvb/video/colorformat", v_colorformat );
                if (v_videoformat == 0 && v_videochange != 1) 
			eAVSwitch::getInstance()->reloadSettings();
		eConfig::getInstance()->setKey("/elitedvb/video/colorformat", old );
	}
}

void eZapVideoSetup::VPin8Changed( eListBoxEntryText * e)
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/pin8", old);

	if ( e )
	{
		v_pin8 = (unsigned int) e->getKey();
		eConfig::getInstance()->setKey("/elitedvb/video/pin8", v_pin8 );
		eStreamWatchdog::getInstance()->reloadSettings();
		eConfig::getInstance()->setKey("/elitedvb/video/pin8", old );
	}
}

void eZapVideoSetup::DisableWSSChanged( int i )
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/disableWSS", old );

	v_disableWSS = (unsigned int) i;
	eConfig::getInstance()->setKey("/elitedvb/video/disableWSS", v_disableWSS );
	eStreamWatchdog::getInstance()->reloadSettings();
	eConfig::getInstance()->setKey("/elitedvb/video/disableWSS", old );
}

void eZapVideoSetup::VCRChanged( int i )
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/vcr_switching", old );

	v_VCRSwitching = (unsigned int) i;
	eConfig::getInstance()->setKey("/elitedvb/video/vcr_switching", v_VCRSwitching );
	eStreamWatchdog::getInstance()->reloadSettings();
	eConfig::getInstance()->setKey("/elitedvb/video/vcr_switching", old );
}

void eZapVideoSetup::TVSystemChanged( eListBoxEntryText *e )
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/tvsystem", old );

	if (e)
	{
		v_tvsystem = (unsigned int) e->getKey();
		eConfig::getInstance()->setKey("/elitedvb/video/tvsystem", v_tvsystem);
		eAVSwitch::getInstance()->reloadSettings();
		eConfig::getInstance()->setKey("/elitedvb/video/tvsystem", old );
	}
}

void eZapVideoSetup::ac3defaultChanged( int i )
{
	eAudio::getInstance()->setAC3default( i );
}

class eWizardTVSystem: public eWindow
{
	eButton *ok;
	eListBox<eListBoxEntryText> *videoformat;
	unsigned int v_videoformat;
	void VFormatChanged( eListBoxEntryText * );
	void okPressed();
	int eventHandler( const eWidgetEvent &e );
	eServiceReference service;	
public:
	eWizardTVSystem();
	static int run();
};

void eWizardTVSystem::VFormatChanged( eListBoxEntryText *e )
{
	unsigned int old = 0;
	eConfig::getInstance()->getKey("/elitedvb/video/videoformat", old );
	if (e)
	{
		v_videoformat = (unsigned int) e->getKey();
		eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat);
		eAVSwitch::getInstance()->reloadSettings();
		eConfig::getInstance()->setKey("/elitedvb/video/videoformat", old );
	}
}

int eWizardTVSystem::eventHandler( const eWidgetEvent &e)
{
	switch(e.type)
	{
		case eWidgetEvent::execDone:
			eAVSwitch::getInstance()->reloadSettings();
			eStreamWatchdog::getInstance()->reloadSettings();
			break;
		case eWidgetEvent::wantClose:
			unsigned int bla;
			if ( eConfig::getInstance()->getKey("/elitedvb/video/videoformat", bla ) )
			    break;
		default:
			return eWindow::eventHandler( e );
	}
	return 1;
}

eWizardTVSystem::eWizardTVSystem(): eWindow(0)
{
//	v_videoformat=0;

	FILE *f=fopen("/etc/videomode", "r");
	if (f){
	fscanf(f, "%d", &v_videoformat);
	eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat);
	}  
	fclose(f);
	
	int fd=eSkin::getActive()->queryValue("fontsize", 20);

	setText(_("TV System Wizard"));
	move(ePoint(160, 120));
	cresize(eSize(390, 170));

	eLabel *l=new eLabel(this);
	l->setText(_("Video Format:"));
	l->move(ePoint(20, 10));
	l->resize(eSize(150, fd+4));

	videoformat=new eListBox<eListBoxEntryText>(this, l);
	videoformat->loadDeco();
	videoformat->setFlags(eListBox<eListBoxEntryText>::flagNoUpDownMovement);
	videoformat->move(ePoint(180, 20));
	videoformat->resize(eSize(120, 35));
	eListBoxEntryText* entrys[5];	
	entrys[0]=new eListBoxEntryText(videoformat, _("576i"), (void*)0);
	entrys[1]=new eListBoxEntryText(videoformat, _("576p50"), (void*)1);	
	entrys[2]=new eListBoxEntryText(videoformat, _("720p50"), (void*)2);
	entrys[3]=new eListBoxEntryText(videoformat, _("720p60"), (void*)3);
	entrys[4]=new eListBoxEntryText(videoformat, _("1080i50"), (void*)4);      
	entrys[5]=new eListBoxEntryText(videoformat, _("1080i60"), (void*)5);

	videoformat->setCurrent(entrys[v_videoformat]);
	videoformat->setHelpText(_("choose video format ( left, right )"));
	CONNECT( videoformat->selchanged, eWizardTVSystem::VFormatChanged );

	ok=new eButton(this);
	ok->setText(_("save"));
	ok->setShortcut("green");
	ok->setShortcutPixmap("green");
	ok->move(ePoint(20, 65));
	ok->resize(eSize(220, 40));
	ok->setHelpText(_("save changes and return"));
	ok->loadDeco();
	CONNECT(ok->selected, eWizardTVSystem::okPressed);

	eStatusBar *status = new eStatusBar(this);
	status->move( ePoint(0, clientrect.height()-50) );
	status->resize( eSize( clientrect.width(), 50) );
	status->loadDeco();
}

void eWizardTVSystem::okPressed()
{
	FILE *f=fopen("/etc/videomode", "w");
	if (f){
		fprintf(f,"%d", v_videoformat);
	}
	fclose(f);

	eConfig::getInstance()->setKey("/elitedvb/video/videoformat", v_videoformat);
	eAudio::getInstance()->saveSettings();
	eConfig::getInstance()->flush();

	system("/etc/init.d/videomode stop");
        Decoder::Flush();
        usleep(500000);
        fbClass::getInstance()->fbset();
	if ( !service )
		service = eServiceInterface::getInstance()->service;
    	eServiceInterface::getInstance()->service=eServiceReference();
    	eZapMain::getInstance()->playService(service, eZapMain::psDontAdd|eZapMain::psSetMode );
	close(1);
}

class eWizardTVSystemInit
{
public:
	eWizardTVSystemInit()
	{
		if ( eSystemInfo::getInstance()->getHwType() >= eSystemInfo::DM7000 )
		{
			// only run wizzard when language not yet setup'ed
			unsigned int videoformat=0;
			if ( eConfig::getInstance()->getKey("/elitedvb/video/videoformat", videoformat) )
			{
				
                                
				eWizardTVSystem w;
#ifndef DISABLE_LCD
				eZapLCD* pLCD = eZapLCD::getInstance();
				pLCD->lcdMain->hide();
				pLCD->lcdMenu->show();
        			w.setLCD( pLCD->lcdMenu->Title, pLCD->lcdMenu->Element );
#endif
				w.show();
				w.exec();
				w.hide();
#ifndef DISABLE_LCD
				pLCD->lcdMenu->hide();
				pLCD->lcdMain->show();
#endif
			}
			else
				eDebug("video format already selected.. do not start video format wizard");
		}
	}
};

eAutoInitP0<eWizardTVSystemInit> init_eWizardTVSystemInit(eAutoInitNumbers::wizard-1, "wizard: video format");
