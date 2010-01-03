#include "utility.h"

string cUtility::StrTrim(string sInput) {
    string sRetVal="";
    int iStart=0;
    int iStop=0;
	int iStrLength=sInput.length();
    for(int i=0; i<iStrLength; i++) {
        if (sInput[i] != ' ') {
            iStart=i;
            i=sInput.length();
        }
    }
    for(int i=iStrLength-1; i>0; i--) {
        if (sInput[i] != ' ') {
            iStop=i;
            i=0;
        }
    }
    sRetVal=sInput.substr(iStart,iStop-iStart+1);
    return sRetVal;
}

string cUtility::StrBeforeChar(string sLine, char cFind) {
    string sRetVal = "";
    int iStrLength=sLine.length();
    if (sLine.length() != 0) {
        for(int i=0; i<iStrLength; i++) {
    	    if (sLine[i] != cFind) {
    	        sRetVal = sRetVal + sLine[i];
    	    } else {
    		i = sLine.length();
    	    }
        }
    }
    sRetVal=StrTrim(sRetVal);
    return sRetVal;
}

string cUtility::StrAfterChar(string sLine, char cFind) {
    string sRetVal = "";
    int iStart=0;
    int iStrLength=sLine.length();
    if (iStrLength!=0) {
        for(int i=0; i<iStrLength; i++) {
            if ((sLine[i] == cFind) && (iStart== 0)) {
				iStart=i;
			}
        }
        for(int i=iStart+1; i<iStrLength; i++) {
			sRetVal=sRetVal+sLine[i];
    	}
    }
    sRetVal=StrTrim(sRetVal);
    return sRetVal;
}

int cUtility::StrToInt(string sInput) {
	char cTemp[100];
	int iStrLength=sInput.length();
	int iLenght=0;
	for (int i=0; i<iStrLength; i++) {
		cTemp[i] = sInput[i];
		iLenght = i;
	}
	cTemp[iLenght+1]='\0';
	return atoi(cTemp);
}

int cUtility::CharToInt(char *cInput) {
	double dTemp=0;
	int iReturn=0;
	dTemp=atof(cInput);
	iReturn=(int)dTemp;	
	return iReturn;
}
