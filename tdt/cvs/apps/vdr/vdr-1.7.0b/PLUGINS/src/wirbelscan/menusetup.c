/*
 * menusetup.c: ptv - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */


#include <linux/dvb/frontend.h>
#include <vdr/menuitems.h>
#include <vdr/device.h>
#include <vdr/config.h>
#include "menusetup.h"
#include "common.h"
#include "frequencies.h"
#include "satfrequencies.h"
#if VDRVERSNUM < 10507
#include "i18n.h"
#endif
#include "scanner.h"

static const char * verbosities[]={
"errors only",
"messages (quiet)",
"messages (verbose)",
"messages (debug)",
"NULL",
};


// plugin setup data
cWirbelscanSetup WirbelscanSetup;

int TerrScanning   =0;
int CableScanning  =0;
int AnalogScanning =0;
int SatScanning    =0;

int TerrPercent    =0;
int CablePercent   =0;
int AnalogPercent  =0;
int SatPercent     =0;

cTerrScanner      * TerrScanner =NULL;
cCableScanner     * CableScanner=NULL;
cAnalogScanner    * AnalogScanner =NULL;
cSatScanner       * SatScanner=NULL;

static const char * TerrScannerDesc   = "wirbelscan terr scanner";
static const char * CableScannerDesc  = "wirbelscan cable scanner";
static const char * AnalogScannerDesc = "wirbelscan analog scanner";
static const char * SatScannerDesc    = "wirbelscan sat scanner";

cOsdItem          * ProgressTerr=NULL;
cOsdItem          * ProgressCable;
cOsdItem          * ProgressAnalog;
cOsdItem          * ProgressSat;


// display update thread for progess    
cUpdateThread        * UpdateThread;

// pointer to actual menu
cMenuSetupWirbelscan * MenuSetupWirbelscan;

// stored info, wether before scan vdr setup allows finding new transponders.
int VDRUpdateChannels;


///! stopScanners() should be called only if plugin is destroyed.
void stopScanners(void) {
 if (UpdateThread) {
    d(0, "Stopping display update thread");
    UpdateThread->SetShouldstop(true);
    }
 if (CableScanner) {
    d(0, "Stopping cable scanner.");
    CableScanner->SetShouldstop(true);
    }
  if (TerrScanner) {
    d(0, "Stopping terr scanner.");
    TerrScanner->SetShouldstop(true);
    }
  if (AnalogScanner) {
    d(0, "Stopping analog scanner.");
    AnalogScanner->SetShouldstop(true);
    }
  if (SatScanner) {
    d(0, "Stopping sat scanner.");
    SatScanner->SetShouldstop(true);
    }
  }

///! DoScan(int DVB_Type), call this one to create new scanner(s).
bool DoScan(int DVB_Type) {
  switch (DVB_Type) {
    case DVB_TERR:
      if (TerrScanning) {
        Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$Scan is already running!!"));
        sleep(4);
        return false;
        }        
      TerrScanner = new cTerrScanner(TerrScannerDesc, &TerrScanning, &TerrPercent);
      Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$DVB-T scan started."));
      break;
    case DVB_CABLE:
      if (CableScanning) {
        Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$Scan is already running!!"));
        sleep(4);
        return false;
        }
      CableScanner = new cCableScanner(CableScannerDesc, &CableScanning, &CablePercent);
      Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$DVB-C scan started."));
      break;
    case DVB_SAT:
      if (SatScanning) {
        Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$Scan is already running!!"));
        sleep(4);
        return false;
        }    
      SatScanner = new cSatScanner(SatScannerDesc, &SatScanning, &SatPercent);
      Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$DVB-S scan started."));
      break;
    case PVR_X50:
      if (AnalogScanning) {
        Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$Scan is already running!!"));
        sleep(4);
        return false;
        }    
      AnalogScanner = new cAnalogScanner(AnalogScannerDesc, &AnalogScanning, &AnalogPercent);
      Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$PVR x50 scan started."));
      break;
    }
  return true;
}

///! DoStop(void), call this one to stop all scanner(s).
void DoStop(void) {
  if (TerrScanning)   TerrScanner->SetShouldstop(true);
  if (CableScanning)  CableScanner->SetShouldstop(true);
  if (AnalogScanning) AnalogScanner->SetShouldstop(true);
  if (SatScanning)    SatScanner->SetShouldstop(true);
}

class cMenuAbout : public cMenuSetupPage {
 private:
 protected:
   void Store(void) {};
 public:
   cMenuAbout(void);
   ~cMenuAbout(void);
   void AddText(const char * s, const char * t);
};

void cMenuAbout::AddText(const char * s, const char * t) {
  char * buf=NULL;
  asprintf(&buf, "%s %s", s, t);
  cOsdItem * osditem = new cOsdItem(buf);
  Add(osditem);
  free(buf);
}

cMenuAbout::cMenuAbout() {
  AddText(trNOOP("Plugin:")  , trNOOP("wirbelscan-0.0.4a"));
  AddText(trNOOP(" "),trNOOP(" "));
  AddText(trNOOP("Description:")  , tr("dvb c/t/s/analog scan for VDR"));
  AddText(trNOOP(" "),trNOOP(" "));
  AddText(trNOOP("Written by:")  , trNOOP("Winfried Koehler <handygewinnspiel#gmx#de>"));
  AddText(trNOOP(" "),trNOOP(" "));
  AddText(trNOOP("Homepage:")  , trNOOP("http://wirbel.htpc-forum.de"));
  AddText(trNOOP(" "),trNOOP(" "));
  AddText(trNOOP("License:")  , trNOOP("GPLv2 or higher,"));
  AddText(trNOOP("")  , trNOOP("See the file COPYING for further license information."));

  SetSection(tr("About wirbelscan Plugin.."));
}

cMenuAbout::~cMenuAbout() {
}

cWirbelscanSetup::cWirbelscanSetup(void) {
  logFile      =STDOUT;             /* log errors/messages to stdout */
  verbosity    =2;                  /* default to messages           */
  CountryIndex =60;                 /* default to Germany            */
  SatIndex     =0;                  /* default to Astra 19.2         */
}

cMenuSetupWirbelscan::~cMenuSetupWirbelscan(void) {
if (UpdateThread) {
  d(0, "Cancelling UpdateThread");
  UpdateThread->SetShouldstop(true);
  UpdateThread=NULL;
  }
}
cMenuSetupWirbelscan::cMenuSetupWirbelscan(void) {
 int CountryCount=0;
 int SatCount=0;
 char * buf;

  static const char *DVB_Types[4];
  DVB_Types[0]="DVB-T";
  DVB_Types[1]="DVB-C";
  DVB_Types[2]="DVB-S";
  DVB_Types[3]="PVRx50";


  static const char *Symbolrates[8];
  Symbolrates[0]=tr("Plugin.WIRBELSCAN$AUTO");
  Symbolrates[1]="6900";
  Symbolrates[2]="6875";
  Symbolrates[3]="6111"; /* 0.0.3 */
  Symbolrates[4]="6250"; /* 0.0.3a as suggested by ulf for w_scan */
  Symbolrates[5]="6790"; /* 0.0.3a as suggested by ulf for w_scan */
  Symbolrates[6]="6811"; /* 0.0.3a as suggested by ulf for w_scan */ 
  Symbolrates[7]=tr("Plugin.WIRBELSCAN$ALL (slow)"); /* 0.0.3a */ 


  static const char *Qams[5];
  Qams[0]=tr("Plugin.WIRBELSCAN$AUTO");
  Qams[1]="64";
  Qams[2]="128";
  Qams[3]="256";
  Qams[4]=tr("Plugin.WIRBELSCAN$ALL (slow)"); /* 0.0.3a */ 

  static const char *ChSyntax[2];
  ChSyntax[0]="reserved";
  ChSyntax[1]="pvrinput";

  static const char *logfiles[3];
  logfiles[0]=tr("Plugin.WIRBELSCAN$Off");
  logfiles[1]="stdout";
  logfiles[2]="syslog";

/* the four color buttons */
  const char * BtnRed   =tr("Plugin.WIRBELSCAN$Stop");
  const char * BtnGreen =tr("Plugin.WIRBELSCAN$Start");
  const char * BtnYellow=" ";
  const char * BtnBlue  =tr("Plugin.WIRBELSCAN$About");
  SetHelp(BtnRed, BtnGreen, BtnYellow, BtnBlue);

  MenuSetupWirbelscan = this;
  tmpSetup = WirbelscanSetup;

  SetSection(tr("Plugin.WIRBELSCAN$Setup"));
  AddCategory(tr("Plugin.WIRBELSCAN$Scan Settings"));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$verbosity"), \
                 &tmpSetup.verbosity, 4, verbosities));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$logfile"), \
                 &tmpSetup.logFile, 3, logfiles));
  while (CountryNames[CountryCount+1] != NULL) CountryCount++;
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$Country"), \
                 &tmpSetup.CountryIndex,   CountryCount, CountryNames));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$Source Type"), \
                 &tmpSetup.DVB_Type, 4, DVB_Types));
/* dvb-t */
  AddCategory(tr("Plugin.WIRBELSCAN$DVB-T"));
  asprintf(&buf, "DVB-T   Scan:   %d%%", TerrPercent);
  ProgressTerr = new cOsdItem(buf);
  freeAndNull(buf);
  Add(ProgressTerr);
/* dvb-c */
  AddCategory(tr("Plugin.WIRBELSCAN$DVB-C"));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$Symbolrate"), \
                 &tmpSetup.DVBC_Symbolrate, 8, Symbolrates));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$QAM"), \
                 &tmpSetup.DVBC_QAM, 5, Qams));
  asprintf(&buf, "DVB-C   Scan:   %d%%", CablePercent);
  ProgressCable = new cOsdItem(buf);
  freeAndNull(buf);
  Add(ProgressCable);
/* dvb-s */
  AddCategory(tr("Plugin.WIRBELSCAN$DVB-S"));
  while (SatNames[SatCount+1] != NULL) SatCount++;
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$Satellite"), \
                 &tmpSetup.SatIndex,   SatCount, SatNames));
  asprintf(&buf, "DVB-S   Scan:   %d%%", SatPercent);
  ProgressSat = new cOsdItem(buf);
  freeAndNull(buf);
  Add(ProgressSat);
/* analog */
  AddCategory(tr("Plugin.WIRBELSCAN$Analog PVR x50"));
  Add(new cMenuEditStraItem(tr("Plugin.WIRBELSCAN$channel syntax"), \
                 &tmpSetup.ChannelSyntax,  2, ChSyntax));
  asprintf(&buf, "PVR x50 Scan:   %d%%", AnalogPercent);
  ProgressAnalog = new cOsdItem(buf);
  freeAndNull(buf);
  Add(ProgressAnalog);
/* recreate update thread if menu was reopened during scan(s) */
  if (TerrScanning  ||
      CableScanning ||
      SatScanning   ||
      AnalogScanning) {
    UpdateThread = new cUpdateThread;
    }
}

void cMenuSetupWirbelscan::AddCategory(const char * category) {
  char * buf=NULL;
  asprintf(&buf, "---------------  %s ", category);
  cOsdItem * osditem = new cOsdItem(buf);
  Add(osditem);
  freeAndNull(buf);
  }
  
eOSState cMenuSetupWirbelscan::ProcessKey(eKeys Key) {
  eOSState state = cMenuSetupPage::ProcessKey(Key);
  if (state == osUnknown) {
    switch(Key) {
      case kOk:    Store();
                   state=osBack;
                   return state;
                   break;
      case kGreen: state=osContinue;
                   StartScan();
                   break;
      case kRed:   state=osContinue;
                   StopScan();
                   break;
      case kBlue:  return AddSubMenu(new cMenuAbout());
                   break;
      default:     break;
      }
    }
  if ((TerrScanning  ||
      CableScanning  ||
      AnalogScanning ||
      SatScanning) && 
      (state != osBack))
      return osContinue;
  return state;      
}

bool cMenuSetupWirbelscan::StopScan(void) {
  DoStop();
  return true;
}


bool cMenuSetupWirbelscan::StartScan(void) {
  d(0, "StartScan(%s)",\
    (tmpSetup.DVB_Type==DVB_TERR)?  "stTerr":\
    (tmpSetup.DVB_Type==DVB_CABLE)? "stCable":\
    (tmpSetup.DVB_Type==DVB_SAT)?   "stSat":\
    (tmpSetup.DVB_Type==PVR_X50)?   "stPvr":"unknown");
  if (Timers.First() != NULL) {
    d(0, "Skipping scan: CANNOT SCAN - Timers on Schedule!");
    Skins.Message(mtInfo, tr("Plugin.WIRBELSCAN$CANNOT SCAN - Timers on Schedule!"));
    sleep(6);
    return false;
    }
  // fixme: later one, the plugin should restore users setting.
  VDRUpdateChannels=Setup.UpdateChannels;
  if (VDRUpdateChannels != 0) {
    d(3, "Setting UpdateChannels=0");
    Setup.UpdateChannels=0;
    }

  WirbelscanSetup=tmpSetup;
  DoScan(WirbelscanSetup.DVB_Type);
  if (UpdateThread == NULL) UpdateThread = new cUpdateThread();
  d(0, "leaving StartScan(%s)",\
    (tmpSetup.DVB_Type==DVB_TERR)? "stTerr":\
    (tmpSetup.DVB_Type==DVB_CABLE)?"stCable":\
    (tmpSetup.DVB_Type==DVB_SAT)?  "stSat":\
    (tmpSetup.DVB_Type==PVR_X50)?  "stPvr":"unknown");
  return true;
}

void cMenuSetupWirbelscan::Store(void) {
    WirbelscanSetup = tmpSetup;
    SetupStore("verbosity",                 WirbelscanSetup.verbosity);
    SetupStore("logFile",                   WirbelscanSetup.logFile);
    SetupStore("DVB_Type",                  WirbelscanSetup.DVB_Type);
    SetupStore("DVBC_Symbolrate",           WirbelscanSetup.DVBC_Symbolrate);
    SetupStore("DVBC_QAM",                  WirbelscanSetup.DVBC_QAM);
    SetupStore("CountryIndex",              WirbelscanSetup.CountryIndex);
    SetupStore("SatIndex",                  WirbelscanSetup.SatIndex);
    SetupStore("ChannelSyntax",             WirbelscanSetup.ChannelSyntax);
}

///! -------------------- UpdateThread ------------------------------
///! updates periodically the SetupMenu with the scan threads progress.
///! ----------------------------------------------------------------

cUpdateThread::cUpdateThread(void) {
  shouldstop=false;
  d(3, "Creating new UpdateThread.");
  Start();
};

cUpdateThread::~cUpdateThread(void) {
  d(3, "Destroying UpdateThread");
  SetShouldstop(true);
}

bool cUpdateThread::ActionAllowed(void) {
  return (Running() && !shouldstop);
}

void cUpdateThread::Action(void) {
  char * buf;
  char * marker;
  int toggle=0;
  while (ActionAllowed()) {
  CWait.Wait(1000);
  toggle++;
  if (toggle > 3) toggle=0;
  switch (toggle) {
    case 0:  asprintf(&marker,"|||||"); break;
    case 1:  asprintf(&marker,"/////"); break;
    case 2:  asprintf(&marker,"-----"); break;
    default: asprintf(&marker,"\\\\\\\\\\");
    }
  if (!ActionAllowed()) break;
  d(4, "UpdateThread::Action()");
  if (MenuSetupWirbelscan == NULL) { //should never happen, only to be shure.
    d(0, "UpdateThread: No Menu pointer. Exiting.");
    break;
    }
  if (TerrScanning  || CableScanning || SatScanning || AnalogScanning) {
    if (ProgressTerr) {
      d(4, "UpdateThread: ProgressTerr %d %%", TerrPercent);
      asprintf(&buf,"DVB-T   Scan:   %d%% %s", TerrPercent, TerrScanning?marker:"");
      if (ActionAllowed()) ProgressTerr->SetText(buf, true);
      freeAndNull(buf);
      if (ActionAllowed())
        ProgressTerr->Set();
      else break;
      }
    if (ProgressCable) {
      d(4, "UpdateThread: ProgressCable %d %%", CablePercent);
      asprintf(&buf,"DVB-C   Scan:   %d%% %s", CablePercent, CableScanning?marker:"");
      if (ActionAllowed()) ProgressCable->SetText(buf, true);
      freeAndNull(buf);
      if (ActionAllowed())
        ProgressCable->Set();
      else break;
      }
    if (ProgressSat) {
      d(4, "UpdateThread: ProgressSat %d %%", SatPercent);
      asprintf(&buf,"DVB-S   Scan:   %d%% %s", SatPercent, SatScanning?marker:"");
      if (ActionAllowed()) ProgressSat->SetText(buf, true);
      freeAndNull(buf);
      if (ActionAllowed())
        ProgressSat->Set();
      else break;
      }
    if (ProgressAnalog) {
      d(4, "UpdateThread: ProgressAnalog %d %%", AnalogPercent);
      asprintf(&buf,"PVR x50 Scan:   %d%% %s", AnalogPercent, AnalogScanning?marker:"");
      if (ActionAllowed()) ProgressAnalog->SetText(buf, true);
      freeAndNull(buf);
      if (ActionAllowed())
        ProgressAnalog->Set();
      else break;
      }
    d(4, "UpdateThread: reDisplaying Menu");
    if (ActionAllowed()) MenuSetupWirbelscan->Display();
    }
  else break;
  }
  Cancel(0);
  UpdateThread=NULL;
}

