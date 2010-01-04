/*
 * scanner.c: wirbelscan - A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */

#include <stdarg.h>
#include <stdlib.h>
#include <linux/dvb/frontend.h>
#include <linux/videodev2.h>
#include <vdr/sources.h>
#include <vdr/eitscan.h>
#include <vdr/channels.h>
#include "scanner.h"
#include "menusetup.h"
#include "common.h"
#include "frequencies.h"
#include "satfrequencies.h"
#if VDRVERSNUM < 10507
#include "i18n.h"
#endif
#include <vdr/svdrp.h>

///!-------------v 0.0.2, storing/restoring channels-----------------
///!  
///!-----------------------------------------------------------------

int TerrScan   =0;
int CableScan  =0;
int AnalogScan =0;
int SatScan    =0;

int LastChanBeforeScan=-1;

cChannels OrigChannels;
cChannels Searchlist;
cChannels Analoglist;
cCondWait aWait;
char * SkinMessage;


void SaveChannels(void) {
  d(3, "SaveChannels()");
  while (OrigChannels.Count() > 0) {
    OrigChannels.Del(OrigChannels.First());
    OrigChannels.ReNumber();
    }
  for (cChannel *channel = Channels.First(); channel; channel = Channels.Next(channel)) {
    cChannel * tr = new cChannel; 
    * tr = * channel;
    OrigChannels.Add(tr);
    d(3, "saved Channel %s(%d) source=%s", 
        OrigChannels.Last()->Name(), 
        OrigChannels.Last()->Number(), 
        cSource::IsSat(OrigChannels.Last()->Source())?"Sat":
        cSource::IsCable(OrigChannels.Last()->Source())?"Cable":
        cSource::IsTerr(OrigChannels.Last()->Source())?"Terr":"PVRx50");
    }
}

void ReportNewTransponders(void) {
 for (cChannel *channel = Searchlist.First(); channel; channel = Searchlist.Next(channel)) {
   cChannel * tr = new cChannel; 
   * tr = * channel;
   d(3, "new transponder %s f%d s%d m%d i%d", \
      (tr->IsSat())?"S":(tr->IsCable())?"C":(tr->IsTerr())?"T":"P", \
      tr->Frequency(), tr->Srate(), tr->Modulation(), tr->Inversion());
   }
}

void ClearChannels(void) {
  d(3, "ClearChannels()"); 
  while (Channels.Count() > 0) {
   Channels.IncBeingEdited();
    Channels.Del(Channels.First());
    Channels.DecBeingEdited();
    Channels.ReNumber();
    }
}

void RestoreChannels(void) {
  d(3, "RestoreChannels()");
  Channels.IncBeingEdited();
  for (cChannel *channel = OrigChannels.First(); channel; channel = OrigChannels.Next(channel)) {
    cChannel * tr = new cChannel; 
    * tr = * channel;
    Channels.Add(tr);  
    }
  Channels.DecBeingEdited();
}

void AddAnalogchannels(void) {
  d(3, "AddAnalogchannels()");
  if (Analoglist.Count() <= 0) return;
  Channels.IncBeingEdited();
  for (cChannel *channel = Analoglist.First(); channel; channel = Analoglist.Next(channel)) {
    cChannel * tr = new cChannel; 
    * tr = * channel;
    if (Channels.HasUniqueChannelID(tr)) {
      Channels.Add(tr);
      Channels.ReNumber();
      Channels.SetModified(true); 
      isyslog ("new channel %d %s", channel->Number(), *channel->ToText());
      d(1, "    new channel %d %s", channel->Number(), *channel->ToText());
      }
    else
      d(1, "    channel already known. not added."); 
    }
  Channels.DecBeingEdited(); 
}


void BeforeScan(void) {
  if ((Channels.Count() > 0) && (cDevice::CurrentChannel() > 0))
    LastChanBeforeScan=cDevice::CurrentChannel();
  else
    LastChanBeforeScan=-1;
  SaveChannels();
  ClearChannels();
}

void AfterScan(void) {
 Setup.UpdateChannels=4;
 ReportNewTransponders();
 RestoreChannels();
 Searchlist.ReNumber();
 for (cChannel *channel = Searchlist.First(); channel; channel = Searchlist.Next(channel)) {
   cChannel * tr = new cChannel; 
   * tr = * channel;
   if (tr != NULL) {
     d(3, "switching to %d", tr->Frequency());
     Searchlist.SwitchTo(tr->Number());
     EITScanner.AddTransponder(tr);
     aWait.Wait(4000);
     }
   }
 Channels.SetModified(); // check: is this really enough avoiding duplicate channels?
 d(3, "Clearing Searchlist.");
 while (Searchlist.Count() > 0) 
   Searchlist.Del(Searchlist.First());
 AddAnalogchannels();
 Setup.UpdateChannels=5;
 EITScanner.ForceScan();
 Channels.Save();
 if (LastChanBeforeScan > 0) {
   d(3, "switching to last channel before scan.");
   Channels.SwitchTo(LastChanBeforeScan);
   }
 d(3, "leaving AfterScan()");
}



///!-------------terr scanning stuff---------------------------------
///!  tested, seems to work with cinergy T² cards..
///!-----------------------------------------------------------------

cTerrScanner::cTerrScanner(const char *Description, int * Scanning, int * Percent) {
  fd_frontend     = -1;
  detachReceivers = 0;
  percent   = Percent;
  *percent  = 0;
  isLiving  = Scanning;
  *isLiving = 1;
  shouldstop=false;
  Start();
}

cTerrScanner::~cTerrScanner(void) {
  SetShouldstop(true);
  if (Active()) {
    *isLiving=0;
    }
  Cancel(3);
}

bool cTerrScanner::ActionAllowed(void) {
  return (Running() && !shouldstop);
}

bool cTerrScanner::CheckTransponder(int freq, int inv, int bw, int mod, int tm, int ch, int cl, int h,\
                                    int gi, int maxtunetrials, int maxlocktrials) {
  if (shouldstop) return false;
  cChannel * Transponder = new cChannel;
  char * TransponderStr;
  d(3, "    %s f%d S%d I%d B%d M%d C%d D%d T%d Y%d G%d", "T", freq, 27500, inv, bw, mod, ch, cl, tm, h, gi);
  asprintf(&TransponderStr, "dummytransponder;wirbelscan:227000:I999B8M16T8C0D0Y0G4:T:27500:302:303:0:0:3:1:1000:3");
  Transponder->Parse(TransponderStr);
  freeAndNull(TransponderStr);
  cDevice::GetDevice(cardnum)->SwitchChannel(Transponder, false); /* switching to invalid transponder */

  asprintf(&TransponderStr, "test;wirbelscan:%d:I%dB%dM%dT%dC%dD%dY%dG%d:T:27500:302:303:0:0:3:1:%d:3",\
      freq, inv, bw, mod, tm, ch, cl, h, gi, cnt++); 
  if (!Transponder->Parse(TransponderStr)) d(0, "    could not parse transponder data %s.", TransponderStr);
  freeAndNull(TransponderStr);
  cDevice::GetDevice(cardnum)->SwitchChannel(Transponder,false); /* now switching scanned transponder */
  for (int trialcount=1;trialcount<maxlocktrials;trialcount++) {
    CWait.Wait(500);
    if ((trialcount>maxtunetrials) && !HasSomeSignal()) return false;
    if (HasLock()) {
      d(1, "    T %d has lock, adding to scan list.", freq);
      Searchlist.Add(Transponder);
      fIndex++;      
      return true;
      }
    }
  return false;
}

void cTerrScanner::GetStatus(void) {
  memset(&frontend_status,0, sizeof(frontend_status));
  IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status);
  if(IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status))
    d(0, "Unable to read frontend status.");
  d(4, "    %s %s %s",\
  (frontend_status & FE_HAS_SIGNAL)?"HAS_SIGNAL":"NO_SIGNAL",\
  (frontend_status & FE_HAS_CARRIER)?"HAS_CARRIER":"NO_CARRIER",\
  (frontend_status & FE_HAS_LOCK)?"HAS LOCK":"NO_LOCK");
}

void cTerrScanner::Action (void) {
  d(2, "cTerrScanner enters Action()");
  ScanChannel = new cChannel;
  TerrScan++;
  cardnum=-1;
  LiveView=false;
  memset(&fe_info, 0, sizeof(fe_info));
  if ((CableScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
    BeforeScan();    
    }
  else {
    if (CableScan)  d(3, "skipping BeforeScan(): cable scanner is running.");
    if (SatScan)    d(3, "skipping BeforeScan(): sat scanner is running.");
    if (AnalogScan) d(3, "skipping BeforeScan(): analog scanner is running.");
    }
  for (int i=MAXDEVICES-1; i>=0; i--) {
     asprintf (&buf, "/dev/dvb/adapter%i/frontend0", i);
     if ((fd_frontend = open (buf, O_RDONLY | O_NONBLOCK)) < 0) {
       freeAndNull(buf);
       continue;
       }
     freeAndNull(buf);
     if (IOCTL(fd_frontend, FE_GET_INFO, &fe_info) < 0) {
       closeIfOpen(fd_frontend);
       continue;
       }
     if (fe_info.type == FE_OFDM) {
       cardnum=i;
       break;
       }     
     }

  if (cardnum>=0)
    d(3, "Scanning DVB-T using DVB device /dev/dvb/adapter%d", cardnum);
  else {
    d(0, "wirbelscan: no usable DVB-T device available. EXITING.");
    *isLiving=0;
    TerrScan=0; 
    *percent=100;
    if ((CableScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
      if (!shouldstop) AfterScan();   // do not disturb other scans ..
      }
    Cancel(3);
    return;
    }
  if (IOCTL(fd_frontend, FE_GET_INFO, &fe_info) < 0) {
    d(0, "unable to determine frontend properties, using fallback mode");
    inversion=qam=coderateh=coderatel=transmissionmode=guardinterval=hierarchy=SEARCH;
    }
  else {
    inversion          =(fe_info.caps & FE_CAN_INVERSION_AUTO)?        999:0;
    qam                =(fe_info.caps & FE_CAN_QAM_AUTO)?              999:64;
    coderateh=coderatel=(fe_info.caps & FE_CAN_FEC_AUTO)?              999:0;
    transmissionmode   =(fe_info.caps & FE_CAN_TRANSMISSION_MODE_AUTO)?999:8;
    guardinterval      =(fe_info.caps & FE_CAN_GUARD_INTERVAL_AUTO)?   999:4;
    hierarchy          =(fe_info.caps & FE_CAN_HIERARCHY_AUTO)?        999:0;                                                     
    }
  d(3, " %s",(inversion != 999)?\
         "INVERSION_AUTO not supported, using fallback mode.":"using INVERSION_AUTO");
  d(3, " %s",(qam != 999)?\
         "QAM_AUTO not supported, using fallback mode.":"using QAM_AUTO");
  d(3, " %s",(coderateh != 999)?\
         "FEC_AUTO not supported, using fallback mode.":"using FEC_AUTO");
  d(3, " %s",(transmissionmode != 999)?\
         "TRANSMISSION_MODE_AUTO not supported, using fallback mode.":"using TRANSMISSION_MODE_AUTO");
  d(3, " %s",(guardinterval != 999)?\
         "GUARD_INTERVAL_AUTO not supported, using fallback mode.":"using GUARD_INTERVAL_AUTO");
  d(3, " %s",(hierarchy != 999)?\
         "HIERARCHY_AUTO not supported, using fallback mode.":"using HIERARCHY_AUTO"); 
  cIndex  = WirbelscanSetup.CountryIndex;
  vnorm   = CountryPropertiesDVBT[cIndex].videonorm;
  flIndex = CountryPropertiesDVBT[cIndex].freqlist_id;
  fCount  = freqlistsDVBT[flIndex].freqlist_count;
  fIndex=0;
  while(ActionAllowed()) {
    if (fIndex==fCount) break; //eof
    freq=freqlistsDVBT[flIndex].freqlist[fIndex].channelfreq;
    d(3, "scanning %d", freq);
    cnt=(int) freq / 16;
    inversion          =(fe_info.caps & FE_CAN_INVERSION_AUTO)?        999:0;
    qam                =(fe_info.caps & FE_CAN_QAM_AUTO)?              999:64;
    coderateh=coderatel=(fe_info.caps & FE_CAN_FEC_AUTO)?              999:0;
    transmissionmode   =(fe_info.caps & FE_CAN_TRANSMISSION_MODE_AUTO)?999:8;
    guardinterval      =(fe_info.caps & FE_CAN_GUARD_INTERVAL_AUTO)?   999:4;
    hierarchy          =(fe_info.caps & FE_CAN_HIERARCHY_AUTO)?        999:0;                                                     
    if (!ActionAllowed()) break;
    for (pa=0;pa<2;pa++) {
      if (inversion != 999)
        switch (pa) {
          case 0:   inversion=0;   break;
          case 1:   inversion=1;   break;
          default:  inversion=999; break;
          }
      for (pb=0;pb<6;pb++) {
        if (qam != 999)
          switch (pb) {
            case 0:    qam=64;  break;
            case 1:    qam=16;  break;
            case 2:    qam=32;  break;
            case 3:    qam=128; break;
            case 4:    qam=256; break;
            case 5:    qam=0;   break;
            default:   qam=999; break;
            }
        for (pc=0;pc<4;pc++) {
          if (hierarchy != 999)
            switch (pc) {
              case 0:    hierarchy=0;   break;
              case 1:    hierarchy=1;   break;
              case 2:    hierarchy=2;   break;
              case 3:    hierarchy=4;   break;
              default:   hierarchy=999; break;
            }
          for (pd=0;pd<9;pd++) {
            if (coderateh != 999)
              switch (pd) {
                case 0:  coderateh=0;   break;
                case 1:  coderateh=12;  break;
                case 2:  coderateh=23;  break;
                case 3:  coderateh=34;  break;
                case 4:  coderateh=45;  break;
                case 5:  coderateh=56;  break;
                case 6:  coderateh=67;  break;
                case 7:  coderateh=78;  break;
                case 8:  coderateh=89;  break;
                default: coderateh=999; break;
              }
            for (pe=0;pe<9;pe++) {
              if (coderatel != 999)
                switch (pe) {
                  case 0:  coderatel=0;   break;
                  case 1:  coderatel=12;  break;
                  case 2:  coderatel=23;  break;
                  case 3:  coderatel=34;  break;
                  case 4:  coderatel=45;  break;
                  case 5:  coderatel=56;  break;
                  case 6:  coderatel=67;  break;
                  case 7:  coderatel=78;  break;
                  case 8:  coderatel=89;  break;
                  default: coderatel=999; break;
                  }
              for (pf=0;pf<4;pf++) {
                if (guardinterval!=999)
                switch (pf) {
                  case 0:   guardinterval=32;  break;
                  case 1:   guardinterval=16;  break;
                  case 2:   guardinterval=8;   break;
                  case 3:   guardinterval=4;   break;
                  default:  guardinterval=999; break;
                  }
                for (pg=0;pg<2;pg++) {
                   if (transmissionmode!=999)
                     switch(pg) {
                       case 0:  transmissionmode=8;
                       case 1:  transmissionmode=2;
                       default: transmissionmode=999;
                       }
                   //v0.0.2a introduction freq offset param 20070122

                   if (CheckTransponder(freq, inversion, (freq>226500)?8:7,  qam, transmissionmode,\
                       coderateh, coderatel, hierarchy, guardinterval, 4, 8))  break;
                   if ((CountryPropertiesDVBT[cIndex].is_Offset == FREQ_OFFSET_UP) ||
                       (CountryPropertiesDVBT[cIndex].is_Offset == FREQ_OFFSET_BOTH))
                     if (CheckTransponder(freq+CountryPropertiesDVBT[cIndex].freq_Offset,\
                         inversion, (freq>226500)?8:7,  qam, transmissionmode,\
                         coderateh, coderatel, hierarchy, guardinterval, 4, 8))  break;
                   if ((CountryPropertiesDVBT[cIndex].is_Offset == FREQ_OFFSET_DOWN) ||
                       (CountryPropertiesDVBT[cIndex].is_Offset == FREQ_OFFSET_BOTH))
                     if (CheckTransponder(freq-CountryPropertiesDVBT[cIndex].freq_Offset,\
                         inversion, (freq>226500)?8:7,  qam, transmissionmode,\
                         coderateh, coderatel, hierarchy, guardinterval, 4, 8))  break;
             
                   //v0.0.2a introduction freq offset param 20070122
                   if (!ActionAllowed() || transmissionmode==999) break;
                  }
                if (HasLock() || guardinterval==999) break;
                }
              if (HasLock() || coderatel == 999) break;
              }
            if (HasLock() || coderateh == 999) break;  
            }
          if (HasLock() || hierarchy == 999) break;    
          }
        if (HasLock() || qam == 999) break;   
        }
      if (HasLock() || inversion==999) break;            
      }
    fIndex++; //do not touch.
    if (fCount>0) *percent=(int) 0.5 + (100*fIndex)/fCount;
    } //end while active
  closeIfOpen(fd_frontend);
  if ((CableScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
    if (!shouldstop) AfterScan();   // do not disturb other scans ..
    }
  else {
    if (CableScan)  d(3, "skipping AfterScan(): cable scanner is running.");
    if (SatScan)    d(3, "skipping AfterScan(): sat scanner is running.");
    if (AnalogScan) d(3, "skipping AfterScan(): analog scanner is running.");
    }
  TerrScan=0; 
  *percent=100;
  Skins.QueueMessage(mtInfo, tr("Plugin.WIRBELSCAN$DVB-T scan done."),5,-1);
  d(2, "cTerrScanner leaves Action()");
  sleep(6);
  *isLiving=0;
  Cancel(0);
};

///!-------------cable scanning stuff--------------------------------
///!  tested, seems to work with TT FF cards..
///!-----------------------------------------------------------------

cCableScanner::cCableScanner(const char *Description, int * Scanning, int * Percent) {
  fd_frontend     = -1;
  detachReceivers = 0;
  percent   = Percent;
  *percent  = 0;
  isLiving  = Scanning;
  *isLiving = 1;
  shouldstop=false;
  Start();
}

cCableScanner::~cCableScanner(void) {
  SetShouldstop(true);
  if (Active()) {
    *isLiving=0;
    }
  Cancel(3);
}

bool cCableScanner::ActionAllowed(void) {
  return (Running() && !shouldstop);
}

bool cCableScanner::CheckTransponder(int frequency, int srate, int mod, int coderateh, int maxtunetrials, int maxlocktrials) {
  if (shouldstop) return false;
  cChannel * Transponder = new cChannel;
  char * TransponderStr;
  d(3, "    %s f%d S%d M%d C%d", "C", frequency, srate, mod, coderateh);
  asprintf(&TransponderStr, "dummytransponder;wirbelscan:106000:C0M256:C:6900:302:303:0:0:3:1:1000:3");
  Transponder->Parse(TransponderStr);
  freeAndNull(TransponderStr);
  cDevice::GetDevice(cardnum)->SwitchChannel(Transponder, false); /* switching to invalid transponder */
  asprintf(&TransponderStr, "test;wirbelscan:%d:M%dC%d:C:%d:302:303:0:0:3:1:%d:3",\
      frequency, mod, coderateh, srate, cnt++); 
  if (!Transponder->Parse(TransponderStr)) d(0, "    could not parse transponder data %s.", TransponderStr);
  freeAndNull(TransponderStr);
  cDevice::GetDevice(cardnum)->SwitchChannel(Transponder,false); /* now switching scanned transponder */
  for (int trialcount=1;trialcount<maxlocktrials;trialcount++) {
    CWait.Wait(500);
    if ((trialcount>maxtunetrials) && !HasSomeSignal()) return false;
    if (HasLock()) {
      d(1, "    C %d has lock, adding to scan list.", freq);
      Searchlist.Add(Transponder);
      fIndex++;      
      return true;
      }
    }
  return false;
}

void cCableScanner::GetStatus(void) {
  memset(&frontend_status,0, sizeof(frontend_status));
  IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status);
  if(IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status))
    d(0, "Unable to read frontend status.");
  d(4, "    %s %s %s",\
  (frontend_status & FE_HAS_SIGNAL)?"HAS_SIGNAL":"NO_SIGNAL",\
  (frontend_status & FE_HAS_CARRIER)?"HAS_CARRIER":"NO_CARRIER",\
  (frontend_status & FE_HAS_LOCK)?"HAS LOCK":"NO_LOCK");
}

void cCableScanner::Action (void) {
  d(2, "cCableScanner enters Action()");
  ScanChannel = new cChannel;
  CableScan++;
  cardnum=-1;
  LiveView=false;
  memset(&fe_info, 0, sizeof(fe_info));
  if ((TerrScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
    BeforeScan();
    }
  else {
    if (TerrScan)   d(3, "skipping BeforeScan(): terr scanner is running.");
    if (SatScan)    d(3, "skipping BeforeScan(): sat scanner is running.");
    if (AnalogScan) d(3, "skipping BeforeScan(): analog scanner is running.");
    }
  for (int i=MAXDEVICES-1; i>=0; i--) {
     asprintf (&buf, "/dev/dvb/adapter%i/frontend0", i);
     if ((fd_frontend = open (buf, O_RDONLY | O_NONBLOCK)) < 0) {
       freeAndNull(buf);
       continue;
       }
     freeAndNull(buf);
     if (IOCTL(fd_frontend, FE_GET_INFO, &fe_info) < 0) {
       closeIfOpen(fd_frontend);
       continue;
       }
     if (fe_info.type == FE_QAM) {
       cardnum=i;
       break;
       }     
     }
  if (cardnum>=0)
    d(3, "Scanning DVB-C using DVB device /dev/dvb/adapter%d", cardnum);
  else {
    d(0, "wirbelscan: no usable DVB-C device available. EXITING.");
    *isLiving=0;
    CableScan=0; 
    *percent=100;
    if ((TerrScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
      if (!shouldstop) AfterScan();   // do not disturb other scans ..
      }
    Cancel(3);
    return;
    }
  if (IOCTL(fd_frontend, FE_GET_INFO, &fe_info) < 0) {
    d(0, "unable to determine frontend properties, using fallback mode");
    qam=64;
    coderateh=0;
    }
  else {
    qam                =(fe_info.caps & FE_CAN_QAM_AUTO)?              999:64;
    coderateh          =(fe_info.caps & FE_CAN_FEC_AUTO)?              999:0;                                                  
    }
  d(3, " %s",(qam != 999)?\
         "QAM_AUTO not supported, using fallback mode.":"using QAM_AUTO");
  d(3, " %s",(coderateh != 999)?\
         "FEC_AUTO not supported, using fallback mode.":"using FEC_AUTO");
  cIndex  = WirbelscanSetup.CountryIndex;
  vnorm   = CountryPropertiesDVBC[cIndex].videonorm;
  flIndex = CountryPropertiesDVBC[cIndex].freqlist_id;
  fCount  = freqlistsDVBC[flIndex].freqlist_count;
  fIndex=0;
  while(ActionAllowed()) {
    if (fIndex==fCount) break; //eof
    freq=freqlistsDVBC[flIndex].freqlist[fIndex].channelfreq;
    d(3, "scanning %d", freq);
    cnt=(int) freq / 16;
    switch(WirbelscanSetup.DVBC_QAM) {
      case 0: // QAM_AUTO
        switch(WirbelscanSetup.DVBC_Symbolrate) {
          case 0: // SRATE_AUTO
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            break;
          case 1: // 6900
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            break;
          case 2: // 6875
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            break;
          case 3: // 6111
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6111, 256, coderateh, 4, 20)) continue;
            break;
          case 4: // 6250
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6250, 256, coderateh, 4, 20)) continue;
            break;
          case 5: // 6790
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6790, 256, coderateh, 4, 20)) continue;
            break;
          case 6: // 6811
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6811, 256, coderateh, 4, 20)) continue;
            break;
          case 7: // ALL (slow)
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6111, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6250, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6790, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6811, 256, coderateh, 4, 20)) continue;
            break;
          } // end switch SRate
        break; // end QAM_AUTO
      case 1: // QAM_64
        switch(WirbelscanSetup.DVBC_Symbolrate) {
          case 0: // SRATE_AUTO
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            break;
          case 1: // 6900
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            break;
          case 2: // 6875
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            break;
          case 3: // 6111
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            break;
          case 4: // 6250
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            break;
          case 5: // 6790
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            break;
          case 6: // 6811
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            break;
          case 7: // ALL (slow)
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            break;
          } // end switch SRate
        break;  // end QAM_64
      case 2: // QAM_128
        switch(WirbelscanSetup.DVBC_Symbolrate) {
          case 0: // SRATE_AUTO
            if (CheckTransponder(freq, 6900, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6875, 128,  coderateh, 4, 12))  continue;
            break;
          case 1: // 6900
            if (CheckTransponder(freq, 6900, 128,  coderateh, 4, 12))  continue;
            break;
          case 2: // 6875
            if (CheckTransponder(freq, 6875, 128,  coderateh, 4, 12))  continue;
            break;
          case 3: // 6111
            if (CheckTransponder(freq, 6111, 128,  coderateh, 4, 12))  continue;
            break;
          case 4: // 6250
            if (CheckTransponder(freq, 6250, 128,  coderateh, 4, 12))  continue;
            break;
          case 5: // 6790
            if (CheckTransponder(freq, 6790, 128,  coderateh, 4, 12))  continue;
            break;
          case 6: // 6811
            if (CheckTransponder(freq, 6811, 128,  coderateh, 4, 12))  continue;
            break;
          case 7: // ALL (slow)
            if (CheckTransponder(freq, 6900, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6875, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6111, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6250, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6790, 128,  coderateh, 4, 12))  continue;
            if (CheckTransponder(freq, 6811, 128,  coderateh, 4, 12))  continue;
            break;
          } // end switch SRate
        break; // end QAM_128
      case 3: // QAM_256
        switch(WirbelscanSetup.DVBC_Symbolrate) {
          case 0: // SRATE_AUTO
            if (CheckTransponder(freq, 6900, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6875, 256,  coderateh, 4, 20))  continue;
            break;
          case 1: // 6900
            if (CheckTransponder(freq, 6900, 256,  coderateh, 4, 20))  continue;
            break;
          case 2: // 6875
            if (CheckTransponder(freq, 6875, 256,  coderateh, 4, 20))  continue;
            break;
          case 3: // 6111
            if (CheckTransponder(freq, 6111, 256,  coderateh, 4, 20))  continue;
            break;
          case 4: // 6250
            if (CheckTransponder(freq, 6250, 256,  coderateh, 4, 20))  continue;
            break;
          case 5: // 6790
            if (CheckTransponder(freq, 6790, 256,  coderateh, 4, 20))  continue;
            break;
          case 6: // 6811
            if (CheckTransponder(freq, 6811, 256,  coderateh, 4, 20))  continue;
            break;
          case 7: // ALL (slow)
            if (CheckTransponder(freq, 6900, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6875, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6111, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6250, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6790, 256,  coderateh, 4, 20))  continue;
            if (CheckTransponder(freq, 6811, 256,  coderateh, 4, 20))  continue;
            break;
          }
        break; // end QAM_256
      case 4: // QAM_ALL (slow) /* 0.0.3a */
        switch(WirbelscanSetup.DVBC_Symbolrate) {
          case 0: // SRATE_AUTO
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            break;
          case 1: // 6900
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            break;
          case 2: // 6875
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            break;
          case 3: // 6111
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6111, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6111, 256, coderateh, 4, 20)) continue;
            break;
          case 4: // 6250
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6250, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6250, 256, coderateh, 4, 20)) continue;
            break;
          case 5: // 6790
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6790, 128, coderateh, 4, 12)) continue;   
            if (CheckTransponder(freq, 6790, 256, coderateh, 4, 20)) continue;
            break;
          case 6: // 6811
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6811, 128, coderateh, 4, 12)) continue;  
            if (CheckTransponder(freq, 6811, 256, coderateh, 4, 20)) continue;
            break;
          case 7: // ALL (slow)
            if (CheckTransponder(freq, 6900, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6900, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6900, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6875, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6875, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6875, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6111, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6111, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6111, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6250, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6250, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6250, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6790, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6790, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6790, 256, coderateh, 4, 20)) continue;
            if (CheckTransponder(freq, 6811, 64,  coderateh, 4, 8))  continue;
            if (CheckTransponder(freq, 6811, 128, coderateh, 4, 12)) continue;
            if (CheckTransponder(freq, 6811, 256, coderateh, 4, 20)) continue;
            break;
          }
        break; // end QAM_ALL (slow)
     }
    fIndex++; //do not touch.
    if (fCount>0) *percent=(int) 0.5 + (100*fIndex)/fCount;
    } //end while active
  closeIfOpen(fd_frontend);
  if ((TerrScan == 0) && (SatScan == 0) && (AnalogScan == 0)) {
    if (!shouldstop) AfterScan();   // do not disturb other scans ..
    }
  else {
    if (TerrScan)   d(3, "skipping AfterScan(): terr scanner is running.");
    if (SatScan)    d(3, "skipping AfterScan(): sat scanner is running.");
    if (AnalogScan) d(3, "skipping AfterScan(): analog scanner is running.");
    }
  CableScan=0;  
  *percent=100;
  Skins.QueueMessage(mtInfo, tr("Plugin.WIRBELSCAN$DVB-C scan done."),5,-1);
  d(2, "cCableScanner leaves Action()");
  sleep(6);
  *isLiving=0;
  Cancel(0);
};

///!-------------sat scanning stuff----------------------------------
///!  trying some sat scanning, completely!! untested..
///!-----------------------------------------------------------------  

cSatScanner::cSatScanner(const char *Description, int * Scanning, int * Percent) {
  fd_frontend     = -1;
  detachReceivers = 0;
  percent   = Percent;
  *percent  = 0;
  isLiving  = Scanning;
  *isLiving = 1;
  shouldstop=false;
  Start();
}

cSatScanner::~cSatScanner(void) {
  SetShouldstop(true);
  if (Active()) {
    *isLiving=0;
    }
  Cancel(3);
}

bool cSatScanner::ActionAllowed(void) {
  return (Running() && !shouldstop);
}

void cSatScanner::SetTransponderData(void) {
  if (shouldstop) return;
  asprintf(&buf, "test;wirbelscan:%d:%sC%d:%s:%d:302:303:0:0:3:1:%d:3",\
      freq, Polarisations[polarisation], coderateh,\
      SatProperties[WirbelscanSetup.SatIndex].source_id, symbolrate, cnt++); 
  if (!ScanChannel->Parse(buf)) d(0, "    could not parse channel data %s.", buf);
  freeAndNull(buf);
  d(3, "    %s %s f%d S%d %sC%d",\
     "S", SatProperties[WirbelscanSetup.SatIndex].source_id,\
     freq, symbolrate, Polarisations[polarisation], coderateh);
}

void cSatScanner::SwitchTransponder(void) {
  if (shouldstop) return;
  cDevice::GetDevice(cardnum)->SwitchChannel(ScanChannel,LiveView);
}

void cSatScanner::GetStatus(void) {
  memset(&frontend_status,0, sizeof(frontend_status));
  IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status);
  if(IOCTL(fd_frontend, FE_READ_STATUS, &frontend_status))
    d(0, "Unable to read frontend status.");
  d(4, "    %s %s %s",\
  (frontend_status & FE_HAS_SIGNAL)?"HAS_SIGNAL":"NO_SIGNAL",\
  (frontend_status & FE_HAS_CARRIER)?"HAS_CARRIER":"NO_CARRIER",\
  (frontend_status & FE_HAS_LOCK)?"HAS LOCK":"NO_LOCK");
}

void cSatScanner::Action (void) {
  d(2, "cSatScanner enters Action()");
  ScanChannel = new cChannel;
  memset(&fe_info, 0, sizeof(fe_info));
  SatScan++;
  if ((TerrScan == 0) && (CableScan == 0) && (AnalogScan == 0)) {
    BeforeScan();
    }
  else {
    if (CableScan)  d(3, "skipping BeforeScan(): cable scanner is running.");
    if (TerrScan)   d(3, "skipping BeforeScan(): terr scanner is running.");
    if (AnalogScan) d(3, "skipping BeforeScan(): analog scanner is running.");
    } 
  cardnum=-1;
  LiveView=false;
  for (int i=MAXDEVICES-1; i>=0; i--) {
     asprintf (&buf, "/dev/dvb/adapter%i/frontend0", i);
     if ((fd_frontend = open (buf, O_RDONLY | O_NONBLOCK)) < 0) {
       freeAndNull(buf);
       continue;
       }
     freeAndNull(buf);
     if (IOCTL(fd_frontend, FE_GET_INFO, &fe_info) < 0) {
       closeIfOpen(fd_frontend);
       continue;
       }
     if (fe_info.type == FE_QPSK) {
       cardnum=i;
       break;
       }     
     }
  if (cardnum>=0)
    d(3, "Scanning DVB-S using DVB device /dev/dvb/adapter%d", cardnum);
  else {
    d(0, "wirbelscan: no usable DVB-S device available. EXITING.");
    *isLiving=0;
    SatScan=0; 
    *percent=100;
    if ((TerrScan == 0) && (CableScan == 0) && (AnalogScan == 0)) {
      if (!shouldstop) AfterScan();   // do not disturb other scans ..
      }
    Cancel(3);
    return;
    }
  cIndex  = WirbelscanSetup.SatIndex;
  flIndex = SatProperties[cIndex].freqlist_id;
  fCount  = freqlistsSat[flIndex].freqlist_count;
  fIndex=0;
  while(ActionAllowed()) {
    if (fIndex==fCount) break; //eof
    freq        =freqlistsSat[cIndex].freqlist[fIndex].channelfreq;
    polarisation=freqlistsSat[cIndex].freqlist[fIndex].channelpolarisation;
    symbolrate  =freqlistsSat[cIndex].freqlist[fIndex].channelsymbolrate;
    coderateh   =freqlistsSat[cIndex].freqlist[fIndex].channelcoderateh;
    d(3, "scanning %d", freq);
    cnt=(int) freq / 16;
    SetTransponderData();
    SwitchTransponder();
    for (int trialcount=0;trialcount<8;trialcount++) { 
      CWait.Wait(500); // no signal after max (6 x 500msecs) or no lock after (8 x 500msecs) -> giving up.
      if ((trialcount>6) && !HasSomeSignal()) break;
      if (HasLock()) break;
      }
    if (!ActionAllowed()) break;
    if (HasLock()) {
      d(1, "    stSat %d has lock, adding to scan list.", freq);
      cChannel * tr = new cChannel; 
      * tr = * ScanChannel;
      Searchlist.Add(tr);
      ScanChannel = new cChannel;
      }
    else
      d(3, "    nothing.");
    fIndex++; //do not touch.
    if (fCount>0) *percent=(int) 0.5 + (100*fIndex)/fCount;
    }
  closeIfOpen(fd_frontend);
  if ((TerrScan == 0) && (CableScan == 0) && (AnalogScan == 0)) {
    if (!shouldstop) AfterScan();   // do not disturb other scans ..
    }
  else {
    if (CableScan)  d(3, "skipping AfterScan(): cable scanner is running.");
    if (TerrScan)   d(3, "skipping AfterScan(): terr scanner is running.");
    if (AnalogScan) d(3, "skipping AfterScan(): analog scanner is running.");
    }
  SatScan=0; 
  *percent=100;
  Skins.QueueMessage(mtInfo, tr("Plugin.WIRBELSCAN$DVB-S scan done."),5,-1);
  d(2, "cSatScanner leaves Action()");
  sleep(6);
  *isLiving=0;
  Cancel(0);
};

///!-------------analog scanning stuff-------------------------------
///!  see my last ptv plugin or my w_pvrscan to understand..
///!-----------------------------------------------------------------

cAnalogScanner::cAnalogScanner(const char *Description, int * Scanning, int * Percent) {
  fd_videodev     = -1;
  detachReceivers = 0;
  percent   = Percent;
  *percent  = 0;
  isLiving  = Scanning;
  *isLiving = 1;
  shouldstop=false;
  Start();
}

cAnalogScanner::~cAnalogScanner(void) {
  SetShouldstop(true);
  if (Active()) {
    *isLiving=0;
    }
  Cancel(3);
}

bool cAnalogScanner::ActionAllowed(void) {
  return (Running() && !shouldstop);
}

bool cAnalogScanner::IsPvr(int dev) {
  struct v4l2_capability  capability;
  int fd;
  char * str;
  asprintf(&str, "/dev/video%d", dev);
  fd = open(str, O_RDWR);
  freeAndNull(str);
  if (fd>0){
    memset(&capability, 0, sizeof(struct v4l2_capability));
    if (!ioctl(fd, VIDIOC_QUERYCAP, &capability)) {       
      if (!memcmp(capability.driver, "ivtv", 4)) {
         closeIfOpen(fd);
         return true;
        }
      else {
       closeIfOpen(fd);
       }
      }
    }
  return false;
}

bool  cAnalogScanner::EnumInputs(struct v4l2_input * vin) {
  if (IOCTL(fd_videodev, VIDIOC_ENUMINPUT, vin)) {
    d(0, "EnumInputs failed, Error %s", strerror(errno));
    return false;
    }
  return true;
}

bool  cAnalogScanner::SetInput(int input) {
  if (IOCTL(fd_videodev, VIDIOC_S_INPUT, &input)) {
    d(0, "setting input failed, Error %s", strerror(errno));
    return false;
    }
  return true;
}

bool cAnalogScanner::SetFrequency(int frequency) {
  if (shouldstop) return false;
  struct v4l2_frequency freqStruct;
  memset(&freqStruct, 0, sizeof(freqStruct));
  freqStruct.tuner = 0;
  freqStruct.type  = V4L2_TUNER_ANALOG_TV;
  freqStruct.frequency = (int) ((double) (frequency * 16.0 )/ 1000.0 + 0.5);
  if (IOCTL(fd_videodev, VIDIOC_S_FREQUENCY, &freqStruct) != 0) {
    d(0, "couldnt set frequency %d. Error %s", freqStruct.frequency, strerror(errno));
    return false;
    }
  return true;
}

int cAnalogScanner::GetSignalStatus   (void) {
  if (shouldstop) return 0;
  struct v4l2_tuner tuner;
  memset(&tuner, 0, sizeof(tuner));
  tuner.index       = 0;
  tuner.type        = V4L2_TUNER_ANALOG_TV;
  if (IOCTL(fd_videodev, VIDIOC_G_TUNER, &tuner)) {
    d(0, "GetSignalstatus failed (%s)", strerror(errno));
    return -1;
    }
  return (tuner.signal > MINSIGNALSTRENGTH)?1:0;
}

void cAnalogScanner::Action (void) {
  struct   v4l2_input vin;
  int      input=0;
  char *   channelstr;

  d(2, "cAnalogScanner enters Action()");
  AnalogScan++;
  cardnum=-1;
  LiveView=false;
  if ((CableScan == 0) && (SatScan == 0) && (TerrScan == 0)) {
    BeforeScan();
    }
  else {
    if (CableScan)  d(3, "skipping BeforeScan(): cable scanner is running.");
    if (TerrScan)   d(3, "skipping BeforeScan(): terr scanner is running.");
    if (SatScan)    d(3, "skipping BeforeScan(): sat scanner is running.");
    } 
  memset(&vin, 0, sizeof(vin)); 
  for (int i=0; i<cDevice::NumDevices(); i++) {
    if (!IsPvr(i)) continue;
    cardnum=i;
    break;
    }
  if (cardnum>=0)
    d(3, "Scanning PVR x50 using ivtv device /dev/video%d", cardnum);
  else {
    d(0, "wirbelscan: no usable PVR x50 device available. EXITING.");
    *isLiving=0;
    AnalogScan=0; 
    *percent=100;
    if ((TerrScan == 0) && (CableScan == 0) && (SatScan == 0)) {
      if (!shouldstop) AfterScan();   // do not disturb other scans ..
      }
    Cancel(3);
    return;
    }
  asprintf(&buf, "/dev/video%i", cardnum);
  fd_videodev = open(buf, O_RDWR | O_NONBLOCK);
  freeAndNull(buf);
  cIndex  = WirbelscanSetup.CountryIndex;
  vnorm   = CountryProperties[cIndex].videonorm;
  flIndex = CountryProperties[cIndex].freqlist_id;
  fCount  = freqlists[flIndex].freqlist_count;
  d(3, "Country=%s, Videonorm=%s", \
    CountryNames[cIndex], \
    (vnorm==V4L2_STD_PAL)?"PAL":(vnorm==V4L2_STD_NTSC)?"NTSC":"SECAM");
  vin.index=0;
  while (EnumInputs(&vin)) {
    if (!memcmp(vin.name, "Tuner", 5)) {
      d(3, "Tuner is input %d.", vin.index);
      input=vin.index;
      break;
      }
    vin.index++;
    }  
  SetInput(input);
  switch (WirbelscanSetup.ChannelSyntax) {
    case CHANNEL_SYNTAX_PVRINPUT:
      switch (vnorm) {
        case V4L2_STD_NTSC:  vnorm=0;  break;
        case V4L2_STD_SECAM: vnorm=1;  break;
        default:             vnorm=999;break;
        }
      break; 
    }
  fIndex=0;
  while(ActionAllowed()) {
    if (fIndex==fCount) break; //eof
    freq =freqlists[flIndex].freqlist[fIndex].channelfreq;
    d(3, "scanning %d", freq);
    cnt=(int) freq / 16;
    SetFrequency(freq);
    CWait.Wait(2500);
    if (!ActionAllowed()) break;
    if (GetSignalStatus()) {
      d(1, "    stPvr %d has signal, trying to add channel.", freq);          
      switch (WirbelscanSetup.ChannelSyntax) {
        case CHANNEL_SYNTAX_PVRINPUT:
          asprintf(&channelstr, \
            "%s;wirbelscan:%d:I%dC%d:C:0:301:300:305:A1:%d:0:0:%d", \
            freqlists[flIndex].freqlist[fIndex].channelname, \
            freq, vnorm, input, (int) (freq*16)/1000, fIndex);
            break;          
        }
      if (ScanChannel.Parse(channelstr)) {
        if (Analoglist.HasUniqueChannelID(&ScanChannel)) {
          cChannel * channel = new cChannel;
          *channel = ScanChannel;
          Analoglist.Add(channel);
          }
        else
          d(1, "    channel already known. not added.");
        }  
      else
        d(0, "    error: cannot parse channel data.");  
      freeAndNull(channelstr); // v0.0.2a: missing free() added.
      }
    else
      d(3, "    nothing.");
    fIndex++; //do not touch.
    if (fCount>0) *percent=(int) 0.5 + (100*fIndex)/fCount;
    }
/*
v0.0.2a: added missing external analog inputs
-wirbel
*/
  vin.index=0;
  while (EnumInputs(&vin)) {
    if (!memcmp(vin.name, "Tuner", 5)) {
      vin.index++;
      continue;             
      }
    switch(vin.index) {
      case 0: input=0;  break;
      case 1: input=12; break;
      case 2: input=23; break;
      case 3: input=34; break;
      case 4: input=45; break;
      case 5: input=56; break;
      case 6: input=67; break;
      case 7: input=78; break;
      case 8: input=89; break;
      default: input=999; break;
      }
    switch (WirbelscanSetup.ChannelSyntax) {
      case CHANNEL_SYNTAX_PVRINPUT:
        asprintf(&channelstr, "%s;wirbelscan:1:I%dC%d:C:0:301:300:305:A1:%d:0:0:0", \
                  vin.name, vnorm, input, 9000+vin.index);  break;
        break;
      }
    if (ScanChannel.Parse(channelstr)) {
      if (Analoglist.HasUniqueChannelID(&ScanChannel)) {
        cChannel * channel = new cChannel;
        *channel = ScanChannel;
        Analoglist.Add(channel);
        }
      else
        d(1, "    channel already known. not added.");
      }  
    else
      d(0, "    error: cannot parse channel data.");
    freeAndNull(channelstr);
    vin.index++;   
    }
/*
end external inputs
*/
  closeIfOpen(fd_videodev);
  if ((TerrScan == 0) && (CableScan == 0) && (SatScan == 0)) {
    if (!shouldstop) AfterScan();   // do not disturb other scans ..
    }
  else {
    if (CableScan)  d(3, "skipping AfterScan(): cable scanner is running.");
    if (TerrScan)   d(3, "skipping AfterScan(): terr scanner is running.");
    if (SatScan)    d(3, "skipping AfterScan(): sat scanner is running.");
    } 
  AnalogScan=0;
  *percent=100;
  Skins.QueueMessage(mtInfo, tr("Plugin.WIRBELSCAN$PVR x50 scan done."),5,-1);
  d(2, "cAnalogScanner leaves Action()");
  sleep(6);
  *isLiving=0;
  Cancel(0);
};
