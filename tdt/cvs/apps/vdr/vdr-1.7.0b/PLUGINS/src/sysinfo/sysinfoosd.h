#ifndef __SYSINFOOSD_H
#define __SYSINFOOSD_H

#include <vdr/osd.h>
#include <vdr/menuitems.h>
#include "utility.h"
#include <ctype.h>

static const cFont *font = cFont::GetFont(fontOsd);
static const int LINEHEIGHT = font->Height();
#define NBLINES 4

class cSysInfoOsd : public cThread, public cOsdObject {
private:
	cOsd *osd;
	int pal[16];
	cTimeMs lastTime;
	int number;
	int group;
	//char ChanName[255];
	int extraInfo;
	const cEvent *Present;
	const cEvent *Following;
	const cEvent **pArray;
	int currentEvent;
	int offset;
	int lines;
	int type;
protected:
	int iTop;
	int iLeft;
	int iWidth;
	int iHeight;
	virtual void Action(void);
public:
	cSysInfoOsd(void);
	~cSysInfoOsd();
	virtual void Show(void);
	virtual eOSState ProcessKey(eKeys Key);
	
	void SendPalette(void);
	void SetColor(int Index, int Red, int Green, int Blue, int Alpha);
	void PleaseWait();
	void ShowData();
	
	void DrawMenu();
	void DisplayBitmap(); 
	void SensorData(int iTop);
	void StaticData(int iTop);
	void MemData(int iTop, int iPartialTop);
	void CpuData(int iTop, int iPartialTop);
	void VideoSpace(int iTop);
	
	static void *Run(void *process);
	void ExecShellCmd(char *cCommand, char *cReturn);
};

#endif //__SYSINFOOSD_H
