#include <stdio.h>

#include "dvb-ci.h"

static const char * FILENAME = "dvb-ci.cpp";

void CI_MenuAnswer(unsigned char bSlotIndex,unsigned char choice)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void CI_Answer(unsigned char bSlotIndex,unsigned char *pBuffer,unsigned char nLength)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void CI_CloseMMI(unsigned char bSlotIndex)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

void CI_EnterMenu(unsigned char bSlotIndex)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}


bool cDvbCi::Init(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
return 0;
}

bool cDvbCi::SendPMT(unsigned char *data, int len)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
return 0;
}

bool cDvbCi::SendDateTime(void)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
return 0;
}

//
cDvbCi::cDvbCi(int Slots) {
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}

cDvbCi::~cDvbCi()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
}


static cDvbCi* pDvbCiInstance = NULL;

cDvbCi * cDvbCi::getInstance()
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	
	if (pDvbCiInstance == NULL)
		pDvbCiInstance = new cDvbCi(2);
	
	return pDvbCiInstance;
}

bool cDvbCi::CamPresent(int slot)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0; 
}

bool cDvbCi::GetName(int slot, char * name)
{
	printf("%s:%s\n", FILENAME, __FUNCTION__);
	return 0;
}

