#ifndef SWINVENTORY_H_ 
#define SWINVENTORY_H_ 

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
//#include <gcrypt.h> /* sha1 / crc32 */
#include <fcntl.h>

#include "misc.h"
#include "swunity.h"

class SwInventory
{
public:
	SwInventory();
	SwInventory(unsigned char* data, unsigned int offset, unsigned int datalen);
	void            print();
	void            printXML(bool d);
	int             parse();
	int             isValid();

	bool            verify();
	void            extract();

	void            setProductCode(unsigned int code) {
		this->mUnity->setProductCode(code); }

	void            setPartition(unsigned int flashOffset, char * filename, unsigned char * data, unsigned int dataLength, unsigned int imageOffset);
	unsigned int    getData(unsigned char ** data);
	unsigned int    getChildData(unsigned char ** data);

	unsigned int	getImageOffset();
private:
	typedef struct sSWInventory
	{
		unsigned char mMagicNumber[SW_UPDATE_MAGIC_SIZE];
		unsigned int  mHeaderVersion;
		unsigned int  mImageOffset;
		unsigned int  mImageSize;//200h greater than datalength in unity
		unsigned int  mFlashOffset;//same as in unity
		unsigned int  mSWVersion;
		unsigned int  mImageNumber;
	} tSWInventory;

	tSWInventory  * mHeader;

	unsigned int    mDataOffsetToBOF;
	unsigned int    mDataLength;
	unsigned char * mData;

	unsigned int    mChildDataLength;
	unsigned char * mChildData;

	SwUnity       * mUnity;
};

#endif
