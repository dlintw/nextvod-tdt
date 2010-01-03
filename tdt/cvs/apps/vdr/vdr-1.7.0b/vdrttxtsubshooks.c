#ifdef USE_TTXTSUBS

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "vdrttxtsubshooks.h"

// XXX Really should be a list...
static cVDRTtxtsubsHookListener *gListener;

// ------ class cVDRTtxtsubsHookProxy ------

class cVDRTtxtsubsHookProxy : public cVDRTtxtsubsHookListener
{
 public:
  virtual void HideOSD(void) { if(gListener) gListener->HideOSD(); };
  virtual void ShowOSD(void) { if(gListener) gListener->ShowOSD(); };
  virtual void PlayerTeletextData(uint8_t *p, int length)
    { if(gListener) gListener->PlayerTeletextData(p, length); };
  virtual cTtxtSubsRecorderBase *NewTtxtSubsRecorder(cDevice *dev, const cChannel *ch)
    { if(gListener) return gListener->NewTtxtSubsRecorder(dev, ch); else return NULL; };
};


// ------ class cVDRTtxtsubsHookListener ------

cVDRTtxtsubsHookListener::~cVDRTtxtsubsHookListener()
{
  gListener = 0;
}

void cVDRTtxtsubsHookListener::HookAttach(void)
{
  gListener = this;
  //printf("cVDRTtxtsubsHookListener::HookAttach\n");
}

static cVDRTtxtsubsHookProxy gProxy;

cVDRTtxtsubsHookListener *cVDRTtxtsubsHookListener::Hook(void)
{
  return &gProxy;
}

#endif /* TTXTSUBS */
