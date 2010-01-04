/*
 * menusetup.h: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */

#ifndef __WIRBELSCAN_MENUSETUP_H_
#define __WIRBELSCAN_MENUSETUP_H_

#include <vdr/menuitems.h>
#include <vdr/osdbase.h>
#include <vdr/thread.h>
#include "scanner.h"
 
#define STDOUT                  1
#define SYSLOG                  2

#define ADAPTER_AUTO            0

#define SEARCH                  1000

#define DVB_TERR                0
#define DVB_CABLE               1
#define DVB_SAT                 2
#define PVR_X50                 3

#define DVBC_INVERSION_AUTO     0

#define DVBC_QAM_AUTO           0
#define DVBC_QAM_64             1
#define DVBC_QAM_128            2
#define DVBC_QAM_256            3

#define CHANNEL_SYNTAX_PTV      0
#define CHANNEL_SYNTAX_PVRINPUT 1

#define MAXSIGNALSTRENGTH       65535
#define MINSIGNALSTRENGTH       16383


void stopScanners(void);
bool DoScan (int DVB_Type);
void DoStop (void);

class cWirbelscanSetup {
 private:
 public:
  int verbosity;
  int logFile;
  int DVB_Type;
  int DVBC_Symbolrate;
  int DVBC_QAM;
  int CountryIndex;
  int SatIndex;
  int ChannelSyntax;
  cWirbelscanSetup(void);
};

extern cWirbelscanSetup WirbelscanSetup;


class cMenuSetupWirbelscan : public cMenuSetupPage {
 private:
    cWirbelscanSetup tmpSetup;
 protected:
    virtual void Store(void);
    virtual bool StartScan(void);
    virtual bool StopScan(void);
    virtual void AddCategory(const char * category);
 public:
    cMenuSetupWirbelscan(void);
    ~cMenuSetupWirbelscan(void);
    virtual eOSState ProcessKey(eKeys Key);
};


class cUpdateThread : public cThread {
 private:
   cCondWait CWait;
   bool shouldstop;
 protected:
   virtual void Action(void);
 public:
  cUpdateThread(void);
  virtual ~cUpdateThread (void);
  virtual void SetShouldstop(bool On) {shouldstop=On;};
  virtual bool ActionAllowed(void);
};


#endif

