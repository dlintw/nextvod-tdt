#include "config.h"
#include "sysinfoosd.h"
#include "sysinfosetup.h"
#include "i18n.h"

static const char *VERSION        = "0.1.0a";
static const char *DESCRIPTION    = "System information plugin";
static const char *MAINMENUENTRY  = "SysInfo";


//class cSysInfo : cPlugin {
class cSysInfo : public cPlugin {
private:
  // Add any member variables or functions you may need here.
public:
  cSysInfo(void);
  virtual ~cSysInfo();
  virtual const char *Version(void) { return VERSION; }
  virtual const char *Description(void) { return tr(DESCRIPTION); }
  virtual const char *CommandLineHelp(void);
  virtual bool ProcessArgs(int argc, char *argv[]);
  virtual bool Start(void);
  virtual void Housekeeping(void);
  virtual const char *MainMenuEntry(void) { return tr(MAINMENUENTRY); }
  virtual cOsdObject *MainMenuAction(void);
  virtual cMenuSetupPage *SetupMenu(void);
  virtual bool SetupParse(const char *Name, const char *Value);
  };
  
cSysInfo::cSysInfo(void) {
  // Initialize any member variables here.
  // DON'T DO ANYTHING ELSE THAT MAY HAVE SIDE EFFECTS, REQUIRE GLOBAL
  // VDR OBJECTS TO EXIST OR PRODUCE ANY OUTPUT!
  config.originx=50;
  config.originy=250;
  config.width=620;
  config.height=300;
  config.red=200;
  config.green=0;
  config.refresh=5;
  config.blue=0;
  config.alpha1=128;
  config.alpha2=255;
  config.alphaborder=255;
  config.usedxr3=0;
}

cSysInfo::~cSysInfo() {
  // Clean up after yourself!
}

const char *cSysInfo::CommandLineHelp(void) {
  // Return a string that describes all known command line options.
  return NULL;
}

bool cSysInfo::ProcessArgs(int argc, char *argv[]) {
  // Implement command line argument processing here if applicable.
  return true;
}

bool cSysInfo::Start(void) {
  // Start any background activities the plugin shall perform.
  RegisterI18n(Phrases);
  // Default values for setup
  return true;
}

void cSysInfo::Housekeeping(void) {
  // Perform any cleanup or other regular tasks.
}

cOsdObject *cSysInfo::MainMenuAction(void) {
  // Perform the action when selected from the main VDR menu.
  config.height=8 * (LINEHEIGHT + 4);
  return new cSysInfoOsd;
}

cMenuSetupPage *cSysInfo::SetupMenu(void) {
  // Return a setup menu in case the plugin supports one.
  return new cSysInfoSetup;
}

bool cSysInfo::SetupParse(const char *Name, const char *Value) {
  // Parse your own setup parameters and store their values.
  //if      (!strcasecmp(Name, "Width"))                 config.width = atoi(Value);
  //else if (!strcasecmp(Name, "Red"))                   config.red = atoi(Value);
  //else if (!strcasecmp(Name, "Green"))                 config.green = atoi(Value);
  //else if (!strcasecmp(Name, "Blue"))                  config.blue = atoi(Value);
  if      (!strcasecmp(Name, "Refresh"))               config.refresh = atoi(Value);
  else if (!strcasecmp(Name, "Alpha1"))                config.alpha1 = atoi(Value);
  else if (!strcasecmp(Name, "Alpha2"))                config.alpha2 = atoi(Value);
  //else if (!strcasecmp(Name, "OriginX"))               config.originx = atoi(Value);
  //else if (!strcasecmp(Name, "OriginY"))               config.originy = atoi(Value);
  else if (!strcasecmp(Name, "AlphaBorder"))           config.alphaborder = atoi(Value);
  else if (!strcasecmp(Name, "UseDXR3"))               config.usedxr3 = atoi(Value);
  else if (!strcasecmp(Name, "HideMenu"))              config.hidemenu = atoi(Value);
  else
     return false;
  
  return true;
}

sSysInfoConfig config;

VDRPLUGINCREATOR(cSysInfo); // Don't touch this!
