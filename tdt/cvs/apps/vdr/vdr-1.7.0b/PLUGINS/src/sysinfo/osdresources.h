#ifndef COSDRESOURCES_H
#define COSDRESOURCES_H

#include <iostream>
#include <fstream>
#include <string>
#include <vdr/menuitems.h>
#include <ctype.h>
#include <vdr/osd.h>
#include "utility.h"



using namespace std;

class cOsdResources {
	private:
		string sArrInput[1000];
        int iArrInput;
        void ReadInputFile(string sFile);
        int GetIntProperty(string sProperty);
	public:
        int iLeft;
        int iTop;
        int iWidth;
        int iHeight;
        cOsdResources(string sFile);
		
		static void DrawOrizontalLine(cOsd *oLineOsd,int iLineTop, int iY1, int iY2, int iColor);
		static void DrawVerticallLine(cOsd *oLineOsd,int iLineLeft, int iX1, int iX2, int iColor);		
		static void DrawBarGraph(cOsd *oBarGraphOsd, int iValue, int iLeft,int iTop, int iWidth, int iHeight);
		static void DrawOrinzontalProgress(cOsd *oProgressOsd,int iLeft, int iTop, int iWidth, int iHeight, int iValue);
};

#endif // COSDRESOURCES_H
