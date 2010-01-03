#ifdef USE_TTXTSUBS

#ifndef __VDRTTXTSUBSHOOKS_H
#define __VDRTTXTSUBSHOOKS_H

class cDevice;
class cChannel;

#define VDRTTXTSUBSHOOKS

class cTtxtSubsRecorderBase {
 public:
  virtual ~cTtxtSubsRecorderBase() {};

  // returns a PES packet if there is data to add to the recording
  virtual uint8_t *GetPacket(uint8_t **buf, size_t *len) { return NULL; };
  virtual void DeviceAttach(void) {};
};

class cVDRTtxtsubsHookListener {
 public:
  cVDRTtxtsubsHookListener(void) {};
  virtual ~cVDRTtxtsubsHookListener();

  void HookAttach(void);

  virtual void HideOSD(void) {};
  virtual void ShowOSD(void) {};
  virtual void PlayerTeletextData(uint8_t *p, int length) {};
  virtual cTtxtSubsRecorderBase *NewTtxtSubsRecorder(cDevice *dev, const cChannel *ch)
    { return NULL; };

  // used by VDR to call hook listeners
  static cVDRTtxtsubsHookListener *Hook(void);
};

#endif /* __VDRTTXTSUBSHOOKS_H */
#endif /* TTXTSUBS */
