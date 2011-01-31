#ifndef SWPACK_H_ 
#define SWPACK_H_ 



#include "swinventory.h"



class SwPack
{
public:
	SwPack();
	SwPack(unsigned char* data, unsigned int datalen);
	void            print();
	void            printXML(bool d);
	void            parse();
	void            parseXML();

	bool            verify();
	void            extract();

	void            setProductCode(unsigned int code) {
		this->mHeader->mProductCode = code; }

	void            appendPartition(unsigned int flashOffset, char* filename, unsigned char * data, unsigned int dataLength);
	int 			createImage(unsigned char ** data);

private:
	typedef struct sSWPack
	{
		unsigned char mMagicNumber[SW_UPDATE_MAGIC_SIZE];
		unsigned int  mHeaderVersion;
		unsigned int  mProductCode;
		unsigned int  mSWVersion;
		time_t        mDate;
		unsigned int  mInventoryCount; /* not used ->loop over MAX_INVENTORY_COUNT */
		unsigned int  mInvalidateFlag;

		char          mUpdateInfo[SW_UPDATE_INFO_LENGTH];
	} tSWPack;

	tSWPack       * mHeader;

	unsigned int    mDataLength;
	unsigned char * mData;

	char          * mXML;

	unsigned int    mChildDataOffset;
	unsigned int    mChildDataLength;
	unsigned char * mChildData;

	unsigned int    mInventoryCount;
	SwInventory   * mInventory[MAX_INVENTORY_COUNT];

private:
	unsigned int    mCurInventoryOffset;
};

#endif
