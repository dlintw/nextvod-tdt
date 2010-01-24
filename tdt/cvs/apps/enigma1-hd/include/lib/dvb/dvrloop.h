#ifndef __dvrloop_h
#define __dvrloop_h

#include <lib/base/ebase.h>

class eDVRLoop: public Object
{
	static eDVRLoop *instance;
public:
        void dvrLoop(int);
        void playStream(int);
	eDVRLoop();
	~eDVRLoop();
	static eDVRLoop *getInstance() { return instance; }
};

#endif
