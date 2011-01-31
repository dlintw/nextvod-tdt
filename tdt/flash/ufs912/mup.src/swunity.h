#ifndef SWUNITY_H_ 
#define SWUNITY_H_ 

#include "misc.h"

class SwUnity
{
public:
	SwUnity();
	SwUnity(unsigned char* data, unsigned int datalen);
	void            print();
	void            printXML(bool d);
	int             parse();
	int             isValid();

	bool            verify();
	void            extract();

	void            setProductCode(unsigned int code) {
			this->mHeader->mProductCode = code; }

	void            setPartition(unsigned int flashOffset, char* filename, unsigned char * data, unsigned int dataLength);
	unsigned int    getData(unsigned char ** data);
private:
	void            calcSH1(unsigned char ** sh1_hash, unsigned int * sh1_hash_len);
	unsigned int    calcCRC32(unsigned char ** crc32_hash, unsigned int * crc32_hash_len);



private:
	typedef struct sSWUnity
	{
		unsigned char mMagicNumber[SW_UPDATE_MAGIC_SIZE];
		unsigned int  mHeaderVersion;
		unsigned int  mProductCode;
		unsigned int  mSWVersion;
		time_t        mDate;
		unsigned int  mFlashOffset;
		unsigned int  mDataLength;

		char          mHashValue[20];
		unsigned int  mCRC;

		unsigned char mFileName[SW_UPDATE_FILENAME_LENGTH];
		unsigned char mUpdateInfo[SW_UPDATE_INFO_LENGTH];
	} tSWUnity;

	// Parsed Unity Header
	tSWUnity  * mHeader;

	// Unity Header + Partition Data
	unsigned int    mDataLength;
	unsigned char * mData;

	// Partition Data
	unsigned int    mChildDataLength;
	unsigned char * mChildData;
};

#endif
