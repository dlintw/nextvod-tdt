/*
 * wirbelscan.c: A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */

#include <vdr/plugin.h>
#include <vdr/i18n.h>
#include "menusetup.h"
#if VDRVERSNUM < 10507
#include "i18n.h"
#endif


static const char *VERSION        = "0.0.4a";
static const char *DESCRIPTION    = trNOOP("dvb c/t/s/analog scan");
static const char *MAINMENUENTRY  = NULL; /* don't like a main menu for stupid plugins.. */

class cPluginWirbelscan : public cPlugin {
private:
  // Add any member variables or functions you may need here.
public:
  cPluginWirbelscan(void);
  virtual ~cPluginWirbelscan();
  virtual const char *Version(void) { return VERSION; }
  virtual const char *Description(void) { return tr(DESCRIPTION); }
  virtual const char *CommandLineHelp(void);
  virtual bool ProcessArgs(int argc, char *argv[]);
  virtual bool Initialize(void);
  virtual bool Start(void);
  virtual void Stop(void);
  virtual void Housekeeping(void);
  virtual void MainThreadHook(void);
  virtual cString Active(void);
  virtual const char *MainMenuEntry(void) { return tr(MAINMENUENTRY); }
  virtual cOsdObject *MainMenuAction(void);
  virtual cMenuSetupPage *SetupMenu(void);
  virtual bool SetupParse(const char *Name, const char *Value);
  virtual bool Service(const char *Id, void *Data = NULL);
  virtual const char **SVDRPHelpPages(void);
  virtual cString SVDRPCommand(const char *Command, const char *Option, int &ReplyCode);
  };

cPluginWirbelscan::cPluginWirbelscan(void)
{

}

cPluginWirbelscan::~cPluginWirbelscan()
{
  // Clean up after yourself!
}

const char *cPluginWirbelscan::CommandLineHelp(void)
{
  // Return a string that describes all known command line options.
  return NULL;
}

bool cPluginWirbelscan::ProcessArgs(int argc, char *argv[])
{
  // Implement command line argument processing here if applicable.
  return true;
}

bool cPluginWirbelscan::Initialize(void)
{
  // Initialize any background activities the plugin shall perform.
#if VDRVERSNUM < 10507
  RegisterI18n(wirbelscan_Phrases); /* initialize phrases for internationalization */
#endif
  return true;
}

bool cPluginWirbelscan::Start(void)
{
  // Start any background activities the plugin shall perform.
  return true;
}

void cPluginWirbelscan::Stop(void)
{
  // Stop any background activities the plugin shall perform.
  stopScanners();
}

void cPluginWirbelscan::Housekeeping(void)
{
  // Perform any cleanup or other regular tasks.
}

void cPluginWirbelscan::MainThreadHook(void)
{
  // Perform actions in the context of the main program thread.
  // WARNING: Use with great care - see PLUGINS.html!
}

cString cPluginWirbelscan::Active(void)
{
  // Return a message string if shutdown should be postponed
  return NULL;
}

cOsdObject *cPluginWirbelscan::MainMenuAction(void)
{
  // Perform the action when selected from the main VDR menu.
  return NULL;
}

cMenuSetupPage *cPluginWirbelscan::SetupMenu(void)
{
  // Return a setup menu in case the plugin supports one.
  return new cMenuSetupWirbelscan();
}

bool cPluginWirbelscan::SetupParse(const char *Name, const char *Value)
{
  if      (!strcasecmp(Name, "verbosity"))       WirbelscanSetup.verbosity=atoi(Value);
  else if (!strcasecmp(Name, "logFile"))         WirbelscanSetup.logFile=atoi(Value);
  else if (!strcasecmp(Name, "DVB_Type"))        WirbelscanSetup.DVB_Type=atoi(Value);
  else if (!strcasecmp(Name, "DVBC_Symbolrate")) WirbelscanSetup.DVBC_Symbolrate=atoi(Value);
  else if (!strcasecmp(Name, "DVBC_QAM"))        WirbelscanSetup.DVBC_QAM=atoi(Value);
  else if (!strcasecmp(Name, "CountryIndex"))    WirbelscanSetup.CountryIndex=atoi(Value);
  else if (!strcasecmp(Name, "SatIndex"))        WirbelscanSetup.SatIndex=atoi(Value);
  else if (!strcasecmp(Name, "ChannelSyntax"))   WirbelscanSetup.ChannelSyntax=atoi(Value);
  else return false;
  return true;
}

bool cPluginWirbelscan::Service(const char *Id, void *Data)
{
  // Handle custom service requests from other plugins
  return false;
}

#define SVDRP_TEST 1

const char **cPluginWirbelscan::SVDRPHelpPages(void)
{
  static const char * SVDRHelp[] = {
    "S_TERR     Trigger DVB-T scan.",
    "S_CABL     Trigger DVB-C scan.",
    "S_SAT      Trigger DVB-S scan.",
    "S_PVR      Trigger PVRx50 scan.",
    "S_STOP     Stop scan(s) (if any).",
    "M_AUTO     Set DVB-C Modulation to QAM_AUTO.",
    "M64        Set DVB-C Modulation to QAM64.",
    "M128       Set DVB-C Modulation to QAM128.",
    "M256       Set DVB-C Modulation to QAM256.",
    "SR_AUTO    Set DVB-C symbolrate to AUTO.",
    "SR6900     Set DVB-C symbolrate to 6900.",
    "SR6875     Set DVB-C symbolrate to 6875.",
    NULL
    };
  return SVDRHelp;
}

cString cPluginWirbelscan::SVDRPCommand(const char *Command, const char *Option, int &ReplyCode)
{
  if     (!strcasecmp(Command,"S_TERR"))  {
    if (DoScan(DVB_TERR))  return "DVB-T scan started";                   else return "Could not start DVB-T scan.";  }
  else if(!strcasecmp(Command,"S_CABL"))  {
    if (DoScan(DVB_CABLE)) return "DVB-C scan started";                   else return "Could not start DVB-C scan.";  }
  else if(!strcasecmp(Command,"S_SAT"))   {
    if (DoScan(DVB_SAT))   return "DVB-S scan started";                   else return "Could not start DVB-S scan.";  }
  else if(!strcasecmp(Command,"S_PVR"))   {
    if (DoScan(PVR_X50))   return "PVRx50 scan started";                  else return "Could not start PVRx50 scan."; }
  else if(!strcasecmp(Command,"S_STOP"))  { DoStop();                          return "stopping scan(s)";             }
  else if(!strcasecmp(Command,"M_AUTO"))  { WirbelscanSetup.DVBC_QAM=0;        return "setting DVB-C QAM_AUTO";       }
  else if(!strcasecmp(Command,"M64"))     { WirbelscanSetup.DVBC_QAM=1;        return "setting DVB-C QAM64";          }
  else if(!strcasecmp(Command,"M128"))    { WirbelscanSetup.DVBC_QAM=2;        return "setting DVB-C QAM128";         }
  else if(!strcasecmp(Command,"M256"))    { WirbelscanSetup.DVBC_QAM=3;        return "setting DVB-C QAM256";         }
  else if(!strcasecmp(Command,"SR_AUTO")) { WirbelscanSetup.DVBC_Symbolrate=0; return "setting DVB-C SR_AUTO";        }
  else if(!strcasecmp(Command,"SR6900"))  { WirbelscanSetup.DVBC_Symbolrate=1; return "setting DVB-C SR6900";         }
  else if(!strcasecmp(Command,"SR6875"))  { WirbelscanSetup.DVBC_Symbolrate=2; return "setting DVB-C SR6875";         }
  return NULL;
}

VDRPLUGINCREATOR(cPluginWirbelscan); // Don't touch this!
