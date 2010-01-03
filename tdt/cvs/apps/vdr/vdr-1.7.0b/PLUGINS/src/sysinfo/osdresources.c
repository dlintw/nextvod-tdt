#include "osdresources.h"

cOsdResources::cOsdResources(string sFile) {
    // Read setup file
    ReadInputFile(sFile);
    // Get value
    iLeft = GetIntProperty("OSDLeft");
    iTop = GetIntProperty("OSDTop");
    iWidth = GetIntProperty("OSDWidth");
    iHeight = GetIntProperty("OSDHeight");
}

void cOsdResources::ReadInputFile(string sFile) {
    try {
        char cTemp;
        string sInput;
        int iDx=0;
        iArrInput = 0;
        const char *cFile;
        cFile = sFile.c_str();
        ifstream fin(cFile);
        while (!fin.eof()) {
           cTemp=fin.get();
           if (cTemp=='\n') {
                sArrInput[iDx]=sInput;
                iArrInput++;
                sInput="";
                iDx++;
            } else {
                sInput=sInput+cTemp;            
            }
        }
        if (sInput.length() > 0) {
            sArrInput[iDx]=sInput;
            iArrInput++;
        }
        fin.close();
    }
    catch (char *cMessage) {
        cout << "cOsdResources::ReadInputFile - " << cMessage << endl;
    }
}

int cOsdResources::GetIntProperty(string sProperty) {
    int iReturn = 0;
    for (int i=0; i<iArrInput; i++) {
        string sCode = cUtility::StrBeforeChar(sArrInput[i], '=');
        string sValue = cUtility::StrAfterChar(sArrInput[i], '=');
        if (sCode == sProperty) {
            iReturn = cUtility::StrToInt(sValue);
        }
    }
    return iReturn;
}

void cOsdResources::DrawOrizontalLine(cOsd *oLineOsd,int iLineTop, int iY1, int iY2, int iColor) {
	for(int i=iY1; i<iY2; i++) {
		oLineOsd->DrawPixel(i, iLineTop, iColor);
		oLineOsd->DrawPixel(i, iLineTop, iColor);	
    }
}

void cOsdResources::DrawVerticallLine(cOsd *oLineOsd,int iLineLeft, int iX1, int iX2, int iColor) {
	for(int i=iX1; i<iX2; i++) {
		oLineOsd->DrawPixel(iLineLeft, i, iColor);
		oLineOsd->DrawPixel(iLineLeft+1, i, iColor);	
    }
}

void cOsdResources::DrawOrinzontalProgress(cOsd *oProgressOsd,int iLeft, int iTop, int iWidth, int iHeight, int iValue) {
	int iRealLeft = iLeft + 2;
	int iRealTop = iTop + 2;
	int iRealHeight = iHeight - 4;
	int iRealWidth = iWidth - 4;
	double dRealHeight = (double)iRealHeight;
	double dPercent = dRealHeight / 100;
	double dValue = (double)iValue;
	double dQuote = dValue * dPercent;
	int iQuote = (int)(dQuote);
	oProgressOsd->DrawRectangle(iLeft, iTop, iLeft+iWidth, iTop+iHeight, clrBlack);
	oProgressOsd->DrawRectangle(iRealLeft, iRealTop+(iRealHeight-iQuote), iRealLeft+iRealWidth, iRealTop+iRealHeight, clrRed);		
	
	int iCharWidth = 14;
	int iTextWidth = 0;
	if (iValue <= 9) iTextWidth = iCharWidth*2;
	if ((iValue > 9) && (iValue <= 99)) iTextWidth = iCharWidth*3;
	if (iValue == 100) iTextWidth = iCharWidth*4;
	
	int iTextLeft = iRealLeft+(int)((int)(iRealWidth/2)-(int)(iTextWidth/2));
	int iTextTop = iRealTop+(int)(iRealHeight/2)-10;
	
	char cTemp[100];
	strcpy(cTemp, itoa(iValue));
	strcat(cTemp, "%");
	static const cFont *font = cFont::GetFont(fontOsd);
	
	oProgressOsd->DrawText(iTextLeft, iTextTop, cTemp, clrWhite, clrBlack, font);
}


