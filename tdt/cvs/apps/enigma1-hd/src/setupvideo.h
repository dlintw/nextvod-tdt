#ifndef __setupvideo_h
#define __setupvideo_h

#include <lib/gui/ewindow.h>
#include <lib/gui/listbox.h>
#include <lib/gui/statusbar.h>
#include <lib/dvb/dvb.h>

class eNumber;
class eButton;
class eCheckbox;

class eZapVideoSetup: public eWindow
{
	eButton *ok, *testpicture;
	eStatusBar *status;
	eCheckbox *c_disableWSS, *ac3default, *VCRSwitching;
	eListBox<eListBoxEntryText> *videoformat, *colorformat, *pin8, *tvsystem;

	unsigned int  v_videoformat, v_colorformat,v_pin8, v_disableWSS, v_tvsystem, v_VCRSwitching;
	int v_videochange;
	eStatusBar *statusbar;
private:
	void ac3defaultChanged( int i );
	void VFormatChanged( eListBoxEntryText * );	
	void CFormatChanged( eListBoxEntryText * );
	void VPin8Changed( eListBoxEntryText *);
	void DisableWSSChanged(int);
	void TVSystemChanged( eListBoxEntryText * );
	void VCRChanged(int);	
	void okPressed();
	void showTestpicture();
	int eventHandler( const eWidgetEvent &e );
	void init_eZapVideoSetup();
	eServiceReference service;	
public:
	eZapVideoSetup();
	~eZapVideoSetup();
};

#endif
