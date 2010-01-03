#ifndef __SYSINFOSETUP_H
#define __SYSINFOSETUP_H

#include <vdr/plugin.h>

class cSysInfoSetup : public cMenuSetupPage 
{
private:
  int Red;
  int Green;
  int Blue;
  int Refresh;
  int Originx;
  int Originy;
  int Width;
  int Height;
  int Alpha1, Alpha2, AlphaBorder;
  int CloseOnSwitch;
  int UseDXR3;
protected:
  virtual void Store(void);
public:
  cSysInfoSetup(void);
};

#endif //__SYSINFOSETUP_H

