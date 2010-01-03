#ifndef CUTILITY_H
#define CUTILITY_H

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class cUtility {
	public:
        static string StrTrim(string sInput);
        static string StrBeforeChar(string sLine, char cFind);
        static string StrAfterChar(string sLine, char cFind);
        static int StrToInt(string sInput);
		static int CharToInt(char *cInput);
};

#endif // CUTILITY_H
