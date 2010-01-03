#ifndef __SYSINFOCONFIG_H
#define __SYSINFOCONFIG_H


struct sSysInfoConfig {
  int red;
  int green;
  int blue;
  int refresh;
  int originx;
  int originy;
  int width;
  int height; //Not configurable through OSD
  int alpha1;
  int alpha2;
  int alphaborder;
  int usedxr3;
  int lines;
  int hidemenu;
};

extern sSysInfoConfig config;

// #define DEBUG

#endif //__SYSINFOCONFIG_H

