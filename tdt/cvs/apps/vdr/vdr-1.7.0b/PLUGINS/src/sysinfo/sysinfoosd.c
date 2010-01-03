#include <pthread.h>
#include "sysinfoosd.h"
#include "config.h"
#include "unistd.h"
#include <vdr/plugin.h>
#ifndef VDRVERSNUM
#include <vdr/config.h>
#endif

#include <iostream>
#include <string>
#include "osdresources.h"

using namespace std;

cSysInfoOsd::cSysInfoOsd(void) {
	osd = NULL;
	group = -1;
	number = 0;
	lastTime.Now();
	extraInfo = false;
	offset = 0;
	lines = 0;
	Present = NULL;
	Following = NULL;
	pArray = NULL;
	currentEvent = 0;
	// Get vdr osd dimension
	const char *ConfDir = cPlugin::ConfigDirectory();	
	char cDir[255];	
	strcpy(cDir,ConfDir);
	strcat(cDir,"//..//setup.conf");
	cout << "Read configuration data from: " << cDir << endl;
	cOsdResources oOsdRes(cDir);
	iLeft = oOsdRes.iLeft;
	iTop = oOsdRes.iTop;
	if (oOsdRes.iWidth > 560) {
		iWidth = oOsdRes.iWidth;
	} else {
		iWidth = 560;
	}
	if (oOsdRes.iHeight > 420) {
		iHeight = oOsdRes.iHeight;
	} else {
		iHeight = 420;
	}
}
 
cSysInfoOsd::~cSysInfoOsd(void) {
	Cancel(0);
	delete osd;
}

eOSState cSysInfoOsd::ProcessKey(eKeys Key) {
	eOSState state = cOsdObject::ProcessKey(Key);
	if (state == osUnknown) {	
		switch (Key) {			
			case kBack:
				return osEnd;
				break;
			case kOk:
				return osEnd;
				break;
			default:
				return state;
		};
	}
	return osContinue;
}

void cSysInfoOsd::Action() {
	int iRefresh = config.refresh;
	while(true) {
		ShowData();
		usleep(iRefresh * 1000000);
	}
}


void cSysInfoOsd::Show() {
	osd = cOsdProvider::NewOsd(iLeft, iTop);
    tArea Area = {0,0, iWidth-1, iHeight-1, 2};
	osd->SetAreas(&Area, 1);
    if(osd) {
		SendPalette();
		// Show pleas wait
		PleaseWait();
		// Show plugin data
		ShowData();
		Start();
	}
}

void cSysInfoOsd::PleaseWait() {
	char cTemp[100];
	cSysInfoOsd::DrawMenu();
	int iHalfWidth = (int)(iWidth/2);
	int iHalfHeight = (int)(iHeight/2);
	sprintf(cTemp, tr("PLEASE WAIT..."));
	
	osd->DrawText(iHalfWidth-100, iHalfHeight-20, cTemp, pal[3],pal[1],font);
	DisplayBitmap();
}

void cSysInfoOsd::ShowData() {
	cSysInfoOsd::DrawMenu();
	StaticData(0);
	SensorData(100);
	VideoSpace(170);
	int iPartialTop = (int)(((iHeight-220)/2));
	CpuData(220, iPartialTop);
	MemData(220+iPartialTop, iPartialTop);
	DisplayBitmap();
}

void cSysInfoOsd::SendPalette() {
	if (config.usedxr3 == 0) {
		pal[10]= 0xFF0000CC; // 70% Red
		pal[11]= 0x00FF00CC; // 70% Green
		pal[12]= 0xFFFCFC00;
		pal[13]= 0xFFFCFC00;
		pal[14]= 0xFFFCFC00;
		pal[15]= 0xFFFCFC00;
		// Main window color
		SetColor(1,   config.red,  config.green,   config.blue, config.alpha1);
		// Line color
		SetColor(2,   0,   0,   0, config.alphaborder);
		// Channel name background, Time and titles color
		SetColor(3, 255, 255, 255, config.alpha1);
		// Yellow button
		SetColor(4, 255, 255,   0, config.alpha1);
		// Blue button
		SetColor(5,   0,   0, 255, config.alpha1);
		// Green button color
		SetColor(6,   0, 255,   0, config.alpha1);
		// Dark Yellow
		SetColor(7,  50,  50,   0, config.alpha1);
		// Darker color for second half background
		SetColor(8,   (config.red>50) ? config.red-50 : 0, 
			(config.green>50) ? config.green-50 : 0,
			(config.blue>50) ? config.blue-50 : 0,
			config.alpha1);
		// Subtitle text
		SetColor(9, 255, 255, 0, config.alpha1); 
	} else {
		// DXR3 workaround
		pal[0]= clrTransparent; 
		// Main window color
		//    pal[1]= clrBackground; 
		// Line color
		pal[2]= clrBlack; 
		// Channel name background, Time and titles color
		pal[3]= clrWhite; 
		// Yellow button
		pal[4]= clrYellow; 
		// Blue button
		pal[5]= clrBlue; 
		// Green button color
		pal[6]= clrGreen; 
		// Black
		pal[7]= clrBlack; 
		// Darker color for second half background
		pal[8]= clrBlack; 
		// Subtitle text
		pal[9]= clrRed; 
		// Red button color
		pal[10]= clrRed;
		pal[11]= 0xFFFCFC00;
		pal[12]= 0xFFFCFC00;
		pal[13]= 0xFFFCFC00;
		pal[14]= 0xFFFCFC00;
		pal[15]= 0xFFFCFC00;
	}
}


void cSysInfoOsd::SetColor(int Index, int Red, int Green, int Blue, int Alpha) {
  if ((Index >= 0) && (Index <= 15) && (Red >= 0) && (Red <= 255) && (Blue >= 0) && (Blue <= 255) && (Green >= 0) && (Green <= 255)&& (Alpha >= 0) && (Alpha <= 255)) {
    pal[Index] = 0;
    pal[Index] += Alpha;
    pal[Index] <<= 8;
    pal[Index] += Blue;
    pal[Index] <<= 8;
    pal[Index] += Green;
    pal[Index] <<= 8;
    pal[Index] += Red;
  }
}


void cSysInfoOsd::DrawMenu() {
    // Draw main window
    osd->DrawRectangle(0, 0, iWidth, iHeight, pal[1]);
    osd->DrawRectangle(0, 0, iWidth, 33, pal[3]);
	// Draw orizontal line
	cOsdResources::DrawOrizontalLine(osd, 0, 0, iWidth, pal[2]);
	cOsdResources::DrawOrizontalLine(osd, 33, 0, iWidth, pal[2]);
	cOsdResources::DrawOrizontalLine(osd, iHeight-2, 0, iWidth, pal[2]);
	// Draw vertical line
	cOsdResources::DrawVerticallLine(osd, 0, 0, iHeight, pal[2]);
	cOsdResources::DrawVerticallLine(osd, iWidth-2, 0, iHeight-2, pal[2]);
    cOsdResources::DrawVerticallLine(osd, iWidth-129, 0, 33, pal[2]);
	// Draw test
	osd->DrawText(10, 3, "SysInfo 0.1.0a", pal[2],pal[3],font);
	osd->DrawText(iWidth-120, 3, "by Kikko77", pal[2],pal[3],font);	
}

void cSysInfoOsd::SensorData(int iTop) {
	// Temperature
	char cTemp[100];
	sprintf(cTemp, tr("Cpu temperature:"));
	osd->DrawText(15, iTop+10, cTemp, pal[3],pal[1],font);
	sprintf(cTemp, tr("M/B temperature:"));
	osd->DrawText(15, iTop+40, cTemp, pal[3],pal[1],font);
	ExecShellCmd("sysinfo.sh cputemp", cTemp);
	osd->DrawText(270, iTop+10, cTemp, pal[3],pal[1],font);
	ExecShellCmd("sysinfo.sh mbtemp", cTemp);
	osd->DrawText(270, iTop+40, cTemp, pal[3],pal[1],font);
	// Fan rpm
	sprintf(cTemp, tr("Fan1:"));
	osd->DrawText(((config.width/2)+20), iTop+10, cTemp, pal[3],pal[1],font);
	sprintf(cTemp, tr("Fan2:"));
	osd->DrawText(((config.width/2)+20), iTop+40, cTemp, pal[3],pal[1],font);
	ExecShellCmd("sysinfo.sh cpufan", cTemp);
	osd->DrawText(((config.width/2)+170), iTop+10, cTemp, pal[3],pal[1],font);
	ExecShellCmd("sysinfo.sh mbfan", cTemp);
	osd->DrawText(((config.width/2)+170), iTop+40, cTemp, pal[3],pal[1],font);
	// Draw line separator
	cOsdResources::DrawOrizontalLine(osd, iTop+74, 0, iWidth, pal[2]);
}


void cSysInfoOsd::VideoSpace(int iTop) {
	char cTemp[100];
	sprintf(cTemp, tr("Video disk free space:"));
	osd->DrawText(15, iTop+10, cTemp, pal[3],pal[1],font);
	ExecShellCmd("sysinfo.sh vidspace", cTemp);
	osd->DrawText(285, iTop+10, cTemp, pal[3],pal[1],font);
	// Draw line separator
	cOsdResources::DrawOrizontalLine(osd, iTop+46, 0, iWidth, pal[2]);
}

void cSysInfoOsd::StaticData(int iTop) {
	char cTemp[100];
	
	sprintf(cTemp, tr("Linux kernel:"));
    osd->DrawText(15, 40, cTemp, pal[3],pal[1],font);
    sprintf(cTemp, tr("Cpu type:"));
	osd->DrawText(15, 70, cTemp, pal[3],pal[1],font);
	// Kernel e cpu type
	ExecShellCmd("uname -r", cTemp);
	osd->DrawText(160, iTop+40, cTemp, pal[3],pal[1],font);
	ExecShellCmd("cat //proc//cpuinfo | grep 'processor' |grep '1'", cTemp);
	if (cTemp[0]=='\0') {
		ExecShellCmd("cat //proc//cpuinfo | grep 'model name' | cut -c 14-58 | uniq", cTemp);
		osd->DrawText(160, iTop+70, cTemp, pal[3],pal[1],font);
	} else {
		ExecShellCmd("cat //proc//cpuinfo | grep 'model name' | cut -c 14-58 | uniq", cTemp);
		osd->DrawText(160, iTop+70, "2 x ", pal[3],pal[1],font);
		osd->DrawText(200, iTop+70, cTemp, pal[3],pal[1],font);
	}
	// Draw line separator
	cOsdResources::DrawOrizontalLine(osd, iTop+104, 0, iWidth, pal[2]);
}

void cSysInfoOsd::CpuData(int iTop, int iPartialTop) {
	int iPerCentCpu=0;
	int iTopGraph=10;
	int iDownGraph=120;
	char cTemp[100];
	double d=0;
	int i=0;

	// Cpu Speed
	sprintf(cTemp, tr("Cpu speed:"));
	osd->DrawText(15, iTop+10, cTemp, pal[3],pal[1],font);
	ExecShellCmd("cat /proc/cpuinfo | grep 'cpu MHz' | cut -c 12-60", cTemp);
	strcpy(cTemp, itoa(cUtility::CharToInt(cTemp)));
	strcat(cTemp, "Mhz");
	osd->DrawText(215, iTop+10, cTemp, pal[3],pal[1],font);
	// Calculate cpu free
	ExecShellCmd("CPU=0; for I in `ps -eo ""%C"" | grep ""\\.""`; do CPU=`echo $CPU $I | awk '{ print $1 + $2 }'`; done; echo $CPU", cTemp);
	iPerCentCpu=cUtility::CharToInt(cTemp);
	if (iPerCentCpu>100) iPerCentCpu=100;
	sprintf(cTemp, tr("Cpu used:"));
	osd->DrawText(15, iTop+40, cTemp, pal[3],pal[1],font);
	strcpy(cTemp, (itoa(iPerCentCpu)));
	strcat(cTemp, "%");
	osd->DrawText(215, iTop+40, cTemp, pal[3],pal[1],font);
	sprintf(cTemp, tr("Cpu free:"));
	osd->DrawText(15, iTop+70, cTemp, pal[3],pal[1],font);
	strcpy(cTemp, itoa(100-iPerCentCpu));
	strcat(cTemp, "%");	
	osd->DrawText(215, iTop+70, cTemp, pal[3],pal[1],font);
	// Cpu Graph
	d=((iDownGraph-iTopGraph)/100)*iPerCentCpu;
	i=(int)d;
	cOsdResources::DrawOrinzontalProgress(osd, 320, iTop+iTopGraph, 80, iPartialTop-20, i);
	// Draw line separator
	cOsdResources::DrawOrizontalLine(osd, iTop+iPartialTop, 0, iWidth, pal[2]);
}


void cSysInfoOsd::MemData(int iTop, int iPartialTop) {	
	int iPerCentMem=0;
	int iTopGraph=10;
	int iDownGraph=120;
	char cTemp[100];
	double dTemp=0;
	double d=0;
	int i=0;
	
	// total memory
	sprintf(cTemp, tr("Total memory:"));
	osd->DrawText(15, iTop+10, cTemp, pal[3],pal[1],font);
	ExecShellCmd("cat /proc/meminfo | grep -i 'MEMTOTAL' | cut -c 16-23 | tr -d ' '", cTemp);
	dTemp=atof(cTemp);
	int iMemTot=(int)(dTemp/1000);
	strcpy(cTemp, itoa(iMemTot));
	strcat(cTemp, "Mb");
	osd->DrawText(215, iTop+10, cTemp, pal[3],pal[1],font);
	// Free memory
	sprintf(cTemp, tr("Free memory:"));
	osd->DrawText(15, iTop+40, cTemp, pal[3],pal[1],font);
	ExecShellCmd("cat /proc/meminfo | grep -i 'MEMFREE' | cut -c 16-23 | tr -d ' '", cTemp);
	dTemp=atof(cTemp);
	int iMemFree=(int)(dTemp/1000);
	strcpy(cTemp, itoa(iMemFree));
	strcat(cTemp, "Mb");
	osd->DrawText(215, iTop+40, cTemp, pal[3],pal[1],font);
	// Used memory
	sprintf(cTemp, tr("Used memory:"));
	osd->DrawText(15, iTop+70, cTemp, pal[3],pal[1],font);
	int iMemUsed=iMemTot-iMemFree;
	strcpy(cTemp, itoa(iMemUsed));
	strcat(cTemp, "Mb");
	osd->DrawText(215, iTop+70, cTemp, pal[3],pal[1],font);
	// Mem Graph
	iPerCentMem=(100*iMemUsed)/iMemTot;
	d=((iDownGraph-iTopGraph)/100)*iPerCentMem;
	i=(int)d;
	cOsdResources::DrawOrinzontalProgress(osd, 320, iTop+iTopGraph, 80, iPartialTop-20, i);
}


void cSysInfoOsd::ExecShellCmd(char *cCommand, char *cReturn) {
	for (int i=0; i<100; i++) cReturn[i]=' ';
	FILE *infile=popen(cCommand,"r");
	fread(cReturn, 1, 100, infile);
	fclose(infile);
	for (int i=0; i<100; i++) {
		if ((cReturn[i]==' ')&&(cReturn[i+1]==' ')&&(cReturn[i+2]==' ')&&(cReturn[i+3]==' ')&&(cReturn[i+4]==' ')) cReturn[i]='\0';
	}
}

void cSysInfoOsd::DisplayBitmap() {
  osd->Flush();
}
