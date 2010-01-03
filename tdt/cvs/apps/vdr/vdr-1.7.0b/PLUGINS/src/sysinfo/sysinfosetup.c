/*
 * pilotsetup.c: A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 * $Id$
 */
 

#include "sysinfosetup.h"
#include "config.h"

cSysInfoSetup::cSysInfoSetup(void) {

  Red         = config.red;
  Green       = config.green;
  Blue        = config.blue;
  Refresh     = config.refresh;
  Originx     = config.originx;
  Originy     = config.originy;
  Width       = config.width;
  Height      = config.height;
  Alpha1      = config.alpha1;
  Alpha2      = config.alpha2;
  AlphaBorder = config.alphaborder;
  UseDXR3     = config.usedxr3;
  
  //Add(new cMenuEditIntItem(tr("Red"),                     &Red, 0, 255));
  //Add(new cMenuEditIntItem(tr("Green"),                   &Green, 0, 255));
  //Add(new cMenuEditIntItem(tr("Blue"),                    &Blue, 0, 255));
  Add(new cMenuEditIntItem(tr("Refresh Time in second"),  &Refresh, 0, 255));
  //Add(new cMenuEditIntItem(tr("Origin X"),                &Originx, 0, 768));
  //Add(new cMenuEditIntItem(tr("Origin Y"),                &Originy, 0, 576));
  //Add(new cMenuEditIntItem(tr("Width"),                   &Width, 0, 768));
  Add(new cMenuEditIntItem(tr("Background opacity"),      &Alpha1, 0, 255));
  Add(new cMenuEditIntItem(tr("Text opacity"),         &Alpha2, 0, 255));
  Add(new cMenuEditIntItem(tr("Border opacity"),       &AlphaBorder, 0, 255));
  Add(new cMenuEditBoolItem(tr("Use DXR3"),            &UseDXR3));
}

void cSysInfoSetup::Store(void)
{
  //SetupStore("Red",         config.red = Red);
  //SetupStore("Green",       config.green = Green);
  //SetupStore("Blue",        config.blue = Blue);
  SetupStore("Refresh",     config.refresh = Refresh);
  //SetupStore("OriginX",     config.originx = Originx);
  //SetupStore("OriginY",     config.originy = Originy);
  //SetupStore("Width",       config.width = Width);
  SetupStore("Alpha1",      config.alpha1 = Alpha1);
  SetupStore("Alpha2",      config.alpha2 = Alpha2);
  SetupStore("AlphaBorder", config.alphaborder = AlphaBorder);
  SetupStore("UseDXR3",     config.usedxr3 = UseDXR3);
}


