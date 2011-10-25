/**************************************************************************/
/* Name :   fup                                                           */
/*                                                                        */
/* Author:  Schischu                                                      */
/*                                                                        */
/* Licence: This file is subject to the terms and conditions of the       */
/*          GNU General Public License version 2.                         */
/**************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
//#include <gcrypt.h> /* sha1 / crc32 */
#include <fcntl.h>

#include <zlib.h>

#include "crc16.h"
#include "dummy.h"

#define VERSION "1.7"
#define DATE "25.10.2011"

//#define USE_ZLIB

unsigned short blockCounter = 0;
unsigned short blockCounterTotal = 0;

#define MAX_PART_NUMBER 17
#define EXTENSION_LEN 32

#define PART_SIGN 1
#define PART_FLASH 2

#if 0
struct {
unsigned int Id;
char Extension[EXTENSION_LEN];
char Description[EXTENSION_LEN];
unsigned int Offset;
unsigned int Size;
unsigned int Flags;
} tPartition;



(0x0,  ".loader.mtd0",   "Loader", 0x00000000, 0x00100000, (PART_FLASH)),
(0x01,     ".app.mtd1",     "App", 0x00b00000, 0x00700000, (PART_FLASH | PART_SIGN)),
(0x02, ".config0.mtd5", "Config0", 0x02100000, 0x00040000, (PART_FLASH)),
(0x03, ".config4.mtd5", "Config4", 0x02140000, 0x00040000, (PART_FLASH)),
(0x04, ".config8.mtd5", "Config8", 0x02180000, 0x00020000, (PART_FLASH)),
(0x05, ".configA.mtd5", "ConfigA", 0x021A0000, 0x00020000, (PART_FLASH)),

(0x06,  ".kernel.mtd6",  "Kernel", 0x00100000, 0x00300000, (PART_FLASH)),
(0x07,     ".dev.mtd4",  "Loader", 0x00000000, 0x00100000, (PART_FLASH | PART_SIGN)),
(0x08,  ".rootfs.mtd8",  "Loader", 0x00000000, 0x00100000, (PART_FLASH | PART_SIGN)),
(0x09,    ".user.mtd9",  "Loader", 0x00000000, 0x00100000, (PART_FLASH)),
(0x10,           ".10",  "Loader", 0x00000000, 0x00100000, (PART_FLASH)),
#endif
unsigned char has[MAX_PART_NUMBER];
FILE* fd[MAX_PART_NUMBER];
char ext[MAX_PART_NUMBER][EXTENSION_LEN] = {
".loader.mtd0",
".app.mtd1",
".config0.mtd5", //F mtd5 offset 0x00000000
".config4.mtd5", //E mtd5 offset 0x00040000
".config8.mtd5",
".configA.mtd5", //C mtd5 offset 0x000A0000
".kernel.mtd6",
".dev.mtd4",
".rootfs.mtd8",
".user.mtd9",
".10",
".11",
".12",
".13",
".14",
".15",
".16"
};

/*void fromShort(unsigned char ** shortBuf, unsigned short val) {
  *shortBuf[0] = val >> 8;
  *shortBuf[1] = val & 0xFF;
}*/


unsigned short toShort(unsigned char shortBuf[2]) {
   //printf("%s:%s[%d] %x %x\n", __FILE__, __func__, __LINE__, shortBuf[0], shortBuf[1]);
   return (unsigned short)(shortBuf[1] + (shortBuf[0] << 8));
}

unsigned short extractShort(unsigned char dataBuf[], unsigned short pos) {
   unsigned char shortBuf[2];
   memcpy(shortBuf, dataBuf + pos, 2);
   return toShort(shortBuf);
}

unsigned short readShort(FILE* file) {
   unsigned char shortBuf[2];
   if (fread(shortBuf, 1, 2, file) == 2)
      return toShort(shortBuf);
   else return 0;
}

int extractAndWrite(FILE* file, unsigned char * buffer, unsigned short len, unsigned short decLen) {
#ifdef USE_ZLIB
         if(len != decLen) {
            //zlib
            z_stream strm;
            unsigned char out[decLen];
            
            strm.zalloc = Z_NULL;
            strm.zfree = Z_NULL;
            strm.opaque = Z_NULL;
            strm.avail_in = 0;
            strm.next_in = Z_NULL;
            inflateInit(&strm);
            
            strm.avail_in = len;
            strm.next_in = buffer;
            
            strm.avail_out = decLen;
            strm.next_out = out;
            inflate(&strm, Z_NO_FLUSH);
            unsigned short have = decLen - strm.avail_out;
            
            inflateEnd(&strm);
            
            fwrite(out, 1, decLen, file);
            return decLen;
         }
         else 
#endif
         {
            fwrite(buffer, 1, len, file);
            return len;
         }
   
}
#define DATA_BLOCKSIZE 0x7FFA

unsigned short readAndCompress(FILE * file, unsigned char ** dataBuf, unsigned short pos, unsigned short * uncompressedDataLen) {

   unsigned short have = 0;
   *uncompressedDataLen = fread((*dataBuf) + pos, 1, *uncompressedDataLen, file);
#ifdef USE_ZLIB
   // So now we have to check if zlib can compress this or not
   z_stream strm;
   unsigned char in[*uncompressedDataLen];
   unsigned char out[*uncompressedDataLen];
   
   strm.zalloc = Z_NULL;
   strm.zfree = Z_NULL;
   strm.opaque = Z_NULL;
   deflateInit(&strm, Z_DEFAULT_COMPRESSION);
   
   strm.avail_in = *uncompressedDataLen;
   memcpy(in, (*dataBuf) + pos, *uncompressedDataLen);
   strm.next_in = in;
   
   //do {
      strm.avail_out = *uncompressedDataLen;
      strm.next_out = out + have;
   
      deflate(&strm, Z_FINISH);
      have = *uncompressedDataLen - strm.avail_out;
      //printf("%s:%s[%d] have=%d strm.avail_out=%d\n", __FILE__, __func__, __LINE__, have, strm.avail_out);
      //getchar();
   //}while(strm.avail_out != 0);
   
   deflateEnd(&strm);
   
   //printf("%s:%s[%d] *uncompressedDataLen=%d have=%d strm.avail_out=%d\n", __FILE__, __func__, __LINE__, *uncompressedDataLen, have, strm.avail_out);
   //if(strm.avail_out == 0 && have > 0 && *uncompressedDataLen > have) {
   if(have < *uncompressedDataLen) {
      memcpy((*dataBuf) + pos, out, have);
   } else 
#endif
   {
      have = *uncompressedDataLen;
   }
   
   return have;
}

unsigned short insertShort(unsigned char ** dataBuf, unsigned short pos, unsigned short value) {
   (*dataBuf)[pos] = value >> 8;
   (*dataBuf)[pos + 1] = value & 0xFF;
   return 2;
}



int writeBlock(FILE* irdFile, FILE* file, unsigned char firstBlock, unsigned short type) {
   unsigned short blockHeaderPos = 0;
   unsigned short nextBlockHeaderPos = 0;
   unsigned short compressedDataLen = 0;
   unsigned short uncompressedDataLen = DATA_BLOCKSIZE;
   
   
   unsigned char * blockHeader = (unsigned char *)malloc(4);
   unsigned char * dataBuf = (unsigned char *)malloc(DATA_BLOCKSIZE + 4 /*TYPE + LEN*/);
   unsigned short dataCrc = 0;
   
   if(firstBlock && type == 0x10) {
      unsigned short resellerId = 0x2303;
      
      insertShort(&dataBuf, 0, type);
      insertShort(&dataBuf, 2, resellerId);
      insertShort(&dataBuf, 4, 0);
      insertShort(&dataBuf, 6, 0);
      insertShort(&dataBuf, 8, 0xFFFF);
      insertShort(&dataBuf, 10, 0);
      insertShort(&dataBuf, 12, 0);
      insertShort(&dataBuf, 14, 0);
      compressedDataLen = 12;
      uncompressedDataLen = compressedDataLen;
   }
   else {
      compressedDataLen = readAndCompress(file, &dataBuf, 4 /*TYPE + LEN*/, &uncompressedDataLen);
      //compressedDataLen += 4; /*TYPE + LEN*/
      insertShort(&dataBuf, 0, type);
      insertShort(&dataBuf, 2, uncompressedDataLen);
   }
   
   dataCrc = crc16(dataCrc, dataBuf, compressedDataLen + 4 /*TYPE + LEN*/);
   
   insertShort(&blockHeader, 0, compressedDataLen + 6);
   insertShort(&blockHeader, 2, dataCrc);
   fwrite(blockHeader, 1, 4, irdFile);
   fwrite(dataBuf, 1, compressedDataLen + 4 /*TYPE + LEN*/, irdFile);
   
   free(blockHeader);
   free(dataBuf);
   
   return uncompressedDataLen;
}

int readBlock(FILE* file, const char * name, unsigned char firstBlock)
{
   printf("%s:%s[%d]\n", __FILE__, __func__, __LINE__);
   
   unsigned short len = 0;
   unsigned short crc = 0;
   unsigned short type = 0;
   
   len = readShort(file);
   if(len == 0) return 0;
   crc = readShort(file);
   
   
   printf(" LEN  = %X (%d)\n", len, len);
   printf(" CRC  = %X\n", crc);
   
   unsigned char dataBuf[len - 2/*crc*/];
   if (fread(dataBuf, 1, len - 2/*crc*/, file) != len - 2/*crc*/)
      return 0;
   
   unsigned short dataCrc = 0;
   dataCrc = crc16(dataCrc, dataBuf, len - 2/*crc*/);
   printf("  CALC CRC = %04X\n", dataCrc);
   
   if(crc != dataCrc)
      getchar();
   
   type = extractShort(dataBuf, 0);
   printf("  TYPE = %X\n", type);
   
   blockCounterTotal++;
   
   if(firstBlock && type == 0x10) {
      printf("-> header\n");
      {
         unsigned short fpVersion = extractShort(dataBuf, 0);
         unsigned short systemId1 = extractShort(dataBuf, 2);
         unsigned short systemId2 = extractShort(dataBuf, 4);
         
         unsigned short blockcount1 = extractShort(dataBuf, 6);
         unsigned short blockcount2 = extractShort(dataBuf, 8);
         
         unsigned short softwareversion1 = extractShort(dataBuf, 10);
         unsigned short softwareversion2 = extractShort(dataBuf, 12);
         unsigned short softwareversion3 = extractShort(dataBuf, 14);
         
         printf("  fpVersion: %04X systemId: %04X%04X blockcount: %04X%04X\n", fpVersion, systemId1, systemId2, blockcount1, blockcount2);
         printf("  softwareVersion: %04X%04X%04X\n", softwareversion1, softwareversion2, softwareversion3);
         //[2]
         //[4]
      }
   }
   else {
      if(type < MAX_PART_NUMBER) {
         if(!has[type]) {
            blockCounter = 1;
            has[type] = 1;
            char nameOut[strlen(name) + 1 + strlen(ext[type])];
            strncpy(nameOut, name, strlen(name));
            strncpy(nameOut + strlen(name), ext[type], strlen(ext[type]));
            nameOut[strlen(name) + strlen(ext[type])] = '\0';
            fd[type] = fopen(nameOut, "wb");
            printf("-> %s\n", nameOut);
         }

         printf("   %s (%d)\n", ext[type], blockCounter++);

         unsigned short decLen = extractShort(dataBuf, 2);
         printf("    LEN = %X (%d)\n", decLen, decLen);
         extractAndWrite(fd[type], dataBuf + 4, len -6, decLen);
      }
      else {
         getchar();
      }
   
   
   }
   
   return len;
}
extern unsigned long crc32 (unsigned long crc, const unsigned char * buf, unsigned int len);

int main(int argc, char* argv[])
{ 
   FILE*          file;
   long int pos = 0;
   unsigned char firstBlock = 1;
      
   if(argc == 3 && strlen(argv[1]) == 2 && strncmp(argv[1], "-s", 2) == 0) {
      unsigned long crc = 0;
      char signedFileName[128];
      strcpy(signedFileName, argv[2]);
      strcat(signedFileName, ".signed");
      
      FILE* signedFile = fopen(signedFileName, "wb");
      file = fopen(argv[2], "r");
      
      unsigned char buffer[0x2710];
      while(!feof(file)) {
         int count = fread(buffer, 1, 0x2710, file); //Actually it would be enpugh to fseek and only to read q byte.
         fwrite(buffer, 1, count, signedFile);
         crc = crc32(crc, buffer, 1/*0x2710*/);
      }
   
      printf("Signed footer: %08lX\n", crc);
      fwrite(&crc, 1, 4, signedFile);
      
      fclose(file);
      fclose(signedFile);
   }
   else if(argc == 3 && strlen(argv[1]) == 2 && strncmp(argv[1], "-t", 2) == 0) {
      unsigned long crc = 0;
      unsigned long orgcrc = 0;
      file = fopen(argv[2], "r");
      
      unsigned char buffer[0x2710];
      while(!feof(file)) { // Actually we would ned to remove the sign at the end
         int count = fread(buffer, 1, 0x2710, file);
         if(count != 0x2710) {
             orgcrc = (buffer[count - 1] << 24) + (buffer[count - 2] << 16) + (buffer[count - 3] << 8) + (buffer[count - 4]);
         }
         crc = crc32(crc, buffer, 1/*0x2710*/);
      }
   
      printf("Signed footer: %08lX\n", crc);
      printf("Original Signed footer: %08lX\n", orgcrc);
      
      fclose(file);
   }
   else if(argc == 3 && strlen(argv[1]) == 2 && strncmp(argv[1], "-x", 2) == 0) {
      for(int i = 0; i < MAX_PART_NUMBER; i++) {
         has[i] = 0;
         fd[i] = NULL;
      }
      
      file = fopen(argv[2], "r");
      
      while(!feof(file)) {
         pos = ftell(file);
         int len = readBlock(file, argv[2], firstBlock);
         firstBlock = 0;
         if (len > 0) {
            pos += len + 2/*LEN FIELD*/;
            fseek(file, pos, SEEK_SET);
         }
         else break;
         //getchar();
      }
      fclose(file);
      
      for(int i = 0; i < MAX_PART_NUMBER; i++) {
          if(fd[i] != NULL)
          fclose(fd[i]);
      }
   }
   else if(argc == 2 && strlen(argv[1]) == 2 && strncmp(argv[1], "-v", 2) == 0) {
      printf("Version: %s Date: %s\n", VERSION, DATE);
   }
   else if(argc >= 3 && strlen(argv[1]) == 2 && strncmp(argv[1], "-c", 2) == 0) {
      FILE* irdFile = fopen(argv[2], "w+");
      unsigned short totalBlockCount = 0;
      unsigned short headerDataBlockLen = 0;
      
      // Header
      headerDataBlockLen = writeBlock(irdFile, NULL, 1, 0x10);
      headerDataBlockLen+=4;
      
      unsigned char appendPartCount = argc - 3;
      for(int i = 0; i < appendPartCount; i+=2) {
         unsigned char type = 0x01;
         
         if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-feelinglucky", 13) == 0)
            type = 0x00;
         //else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-0", 2) == 0)
         //   type = 0x00;
            
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-a", 2) == 0)
            type = 0x01;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-1", 2) == 0)
            type = 0x01;
            
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-c0", 3) == 0)
            type = 0x02;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-2", 2) == 0)
            type = 0x02;
            
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-c4", 3) == 0)
            type = 0x03;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-3", 2) == 0)
            type = 0x03;
            
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-c8", 3) == 0)
            type = 0x04;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-4", 2) == 0)
            type = 0x04;
            
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-ca", 3) == 0)
            type = 0x05;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-5", 2) == 0)
            type = 0x05;
            
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-k", 2) == 0)
            type = 0x06;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-6", 2) == 0)
            type = 0x06;
            
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-d", 2) == 0)
            type = 0x07;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-7", 2) == 0)
            type = 0x07;
            
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-r", 2) == 0)
            type = 0x08;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-8", 2) == 0)
            type = 0x08;
            
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-u", 2) == 0)
            type = 0x09;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-9", 2) == 0)
            type = 0x09;
            
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-10", 3) == 0)
            type = 0x10;
         /*else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-11", 3) == 0)
            type = 0x11;
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-12", 3) == 0)
            type = 0x12;
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-13", 3) == 0)
            type = 0x13;
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-14", 3) == 0)
            type = 0x14;
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-15", 3) == 0)
            type = 0x15;
         else if(strlen(argv[3 + i]) == 3 && strncmp(argv[3 + i], "-16", 3) == 0)
            type = 0x16;*/
         
         FILE* file = fopen(argv[3 + i + 1], "rb");
         
         printf("Adding %s\n", argv[3 + i + 1]);
         unsigned short partBlocksize = totalBlockCount;
         while(writeBlock(irdFile, file, 0, type) == DATA_BLOCKSIZE) {
            totalBlockCount++;
            printf(".");
         }
         totalBlockCount++;
         partBlocksize = totalBlockCount - partBlocksize;
         printf("\nAdded %d Blocks, total %d\n", partBlocksize, totalBlockCount);
         fclose(file);
      }
      
      /// Refresh Header
      unsigned char * dataBuf = (unsigned char *)malloc(headerDataBlockLen);
      
      // Read Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fread(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update Blockcount
      insertShort(&dataBuf, 8, totalBlockCount);
      
      // Rewrite Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fwrite(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update CRC
      unsigned short dataCrc = crc16(0, dataBuf, headerDataBlockLen);
      insertShort(&dataBuf, 0, dataCrc);
      
      // Rewrite CRC
      fseek(irdFile, 0x02, SEEK_SET);
      fwrite(dataBuf, 1, 2, irdFile);
      
      free(dataBuf);
      
      fclose(irdFile);
   }
   else if(argc >= 3 && strlen(argv[1]) == 3 && strncmp(argv[1], "-ce", 3) == 0) {
      FILE* irdFile = fopen(argv[2], "w+");
      unsigned short totalBlockCount = 0;
      unsigned short headerDataBlockLen = 0;
      //unsigned char * headerDataBloc;
      
      // Header
      headerDataBlockLen = writeBlock(irdFile, NULL, 1, 0x10);
      headerDataBlockLen+=4;
      
      unsigned char appendPartCount = argc - 3;
      for(int i = 0; i < appendPartCount; i+=2) {

         unsigned char type = 0x01;
         
         if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-f", 2) == 0) // ORIGNINAL APP_BAK NOW FW
            type = 0x01;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-k", 2) == 0) // KERNEL
            type = 0x06;
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-e", 2) == 0) //ORIGNINAL ROOT NOW EXT
            type = 0x08; 
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-g", 2) == 0) //ORIGNINAL DEV NOW G
            type = 0x07; 
         else if(strlen(argv[3 + i]) == 2 && strncmp(argv[3 + i], "-r", 2) == 0) //ORIGNINAL USER NOW ROOT
            type = 0x09; // 7 if dev, than we need to split the file in 3 files
         
         if(type == 0x01 || type == 0x08 || type== 0x07) {
            printf("Adding signed dummy squashfs header");
            FILE* file = fopen("dummy.squash.signed.padded", "w");
            printf(".");
            if(file != NULL) {
               printf(".");
               fwrite(dummy, 1, dummy_size, file);
               printf(".");
               fclose(file);
               printf(".");
               file = fopen("dummy.squash.signed.padded", "rb");
               printf(".");
               if(file != NULL) {
                  while(writeBlock(irdFile, file, 0, type) == DATA_BLOCKSIZE) {
                     printf(".");
                     totalBlockCount++;
                  }
                  totalBlockCount++;
                  fclose(file);
               }
               else
                  printf("\nCould not write signed dummy squashfs header (2)\n");
               remove("dummy.squash.signed.padded");
            }
            else
               printf("\nCould not write signed dummy squashfs header (1)\n");
            printf("\n");
         }
         
         if(strncmp(argv[3 + i + 1], "foo", 3) != 0) {
            FILE* file = fopen(argv[3 + i + 1], "rb");
            if(file != NULL) {
               /*if(type == 0x07) { // DEV ROOT
                  // We have to split it onto 3 partitions
                  // dev    2E0000 2,875MB (300000 - 20000)
                  // config 100000 1MB
                  // user   1E00000 30MB
                  unsigned char buffer[0x1000];
               }*/
               
               printf("Adding %s", argv[3 + i + 1]);
               unsigned short partBlocksize = totalBlockCount;
               while(writeBlock(irdFile, file, 0, type) == DATA_BLOCKSIZE) {
                  totalBlockCount++;
                  printf(".");
               }
               totalBlockCount++;
               partBlocksize = totalBlockCount - partBlocksize;
               printf("\nAdded %d Blocks, total %d\n", partBlocksize, totalBlockCount);
               fclose(file);
            }
            else
               printf("\nCould not append %s\n", argv[3 + i + 1]);
            printf("\n");
         }
         else {
            printf("This is a foo partition\n");
         }
      }
      
      /// Refresh Header
      unsigned char * dataBuf = (unsigned char *)malloc(headerDataBlockLen);
      
      // Read Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fread(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update Blockcount
      insertShort(&dataBuf, 8, totalBlockCount);
      
      // Rewrite Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fwrite(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update CRC
      unsigned short dataCrc = crc16(0, dataBuf, headerDataBlockLen);
      insertShort(&dataBuf, 0, dataCrc);
      
      // Rewrite CRC
      fseek(irdFile, 0x02, SEEK_SET);
      fwrite(dataBuf, 1, 2, irdFile);
      
      free(dataBuf);
      
      fclose(irdFile);
   }
   else if(argc == 4 && strlen(argv[1]) == 2 && strncmp(argv[1], "-r", 2) == 0) {
      unsigned char headerDataBlockLen = 0;
      unsigned int resellerId = 0;
      
      sscanf(argv[3], "%x", &resellerId);
      
      FILE* irdFile = fopen(argv[2], "r+");
      if(irdFile == NULL) {
         printf("Error opening %s\n", argv[2]);
      }
      
      headerDataBlockLen = readShort(irdFile);
      headerDataBlockLen -= 2;
      
      printf("Changing reseller id to %04x\n", resellerId);
      
      /// Refresh Header
      unsigned char * dataBuf = (unsigned char *)malloc(headerDataBlockLen);
      
      // Read Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fread(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update Blockcount
      insertShort(&dataBuf, 2, resellerId&0xFFFF);
      
      // Rewrite Header Data Block
      fseek(irdFile, 0x04, SEEK_SET);
      fwrite(dataBuf, 1, headerDataBlockLen, irdFile);
      
      // Update CRC
      unsigned short dataCrc = crc16(0, dataBuf, headerDataBlockLen);
      insertShort(&dataBuf, 0, dataCrc);
      
      // Rewrite CRC
      fseek(irdFile, 0x02, SEEK_SET);
      fwrite(dataBuf, 1, 2, irdFile);
      
      free(dataBuf);
      
      fclose(irdFile);
   }
   else {
#ifdef USE_ZLIB
      unsigned char zlib = 1;
#else
      unsigned char zlib = 0;
#endif
      printf("\n");
      printf("Version: %s Date: %s USE_ZLIB: %d                                                        \n", VERSION, DATE, zlib);
      printf("\n");
      printf("Usage: %s -xcstv []                                                                      \n", argv[0]);
      printf("       -x [update.ird]           Extract IRD                                             \n");
      printf("       -c [update.ird] Options   Create IRD                                              \n");
      printf("         Options:                                                                        \n");
      printf("              [file.part]         Append Loader   (0) 0x00000000 - 0x000FFFFF (1   MB)   \n");
      printf("          -k  [file.part]         Append Kernel   (6) 0x00100000 - 0x003FFFFF (3   MB)   \n");
      printf(" *        -ao [file.part]         Append App Org  (*) 0x00400000 - 0x00aFFFFF (7   MB)   \n");
      printf(" s        -a  [file.part]         Append App      (1) 0x00b00000 - 0x011FFFFF (7   MB)   \n");
      printf(" s        -r  [file.part]         Append Root     (8) 0x01200000 - 0x01dFFFFF (12  MB)   \n");
      printf(" s        -d  [file.part]         Append Dev      (7) 0x01e00000 - 0x020FFFFF (3   MB)   \n");
      printf("          -c0 [file.part]         Append Config0  (2) 0x02100000 - 0x0213FFFF (256 KB)   \n");
      printf("          -c4 [file.part]         Append Config4  (3) 0x02140000 - 0x0217FFFF (256 KB)   \n");
      printf("          -c8 [file.part]         Append Config8  (4) 0x02180000 - 0x0219FFFF (128 KB)   \n");
      printf("          -ca [file.part]         Append ConfigA  (5) 0x021A0000 - 0x021BFFFF (128 KB)   \n");
      printf(" *        -cc [file.part]         Append ConfigC  (*) 0x021C0000 - 0x021FFFFF (256 KB)   \n");
      printf("          -u  [file.part]         Append User     (9) 0x02200000 - 0x03FFFFFF (30  MB)   \n");
      printf("          -1  [file.part]         Append Type 1   (1)                                    \n");
      printf("          ...                                                                            \n");
      printf("          -10 [file.part]         Append Type 10 (10)                                    \n");
    //printf("          -16 [file.part]         Append Type 16 (16)                                    \n");
      printf("       -ce [update.ird] Options   Create Enigma2 IRD                                     \n");
      printf("         Options:                                                                        \n");
      printf("          -k [file.part]          Append Kernel       0x00100000 - 0x003FFFFF (3      MB)\n");
      printf("          -f [file.part]          Append FW           0x00B20000 - 0x011FFFFF (6.875  MB)\n");
    //printf("          -r [file.part]          Append Root         0x01E20000 - 0x03FFFFFF (33.875 MB)\n");
      printf("          -r [file.part]          Append Root         0x02200000 - 0x03FFFFFF (30     MB)\n");
      printf("          -e [file.part]          Append Ext          0x01220000 - 0x01DFFFFF (11.875 MB)\n");
      printf("          -g [file.part]          Append G            0x01E20000 - 0x020FFFFF (2.875  MB)\n");
      printf("       -s [unsigned.squashfs]    Sign squashfs part                                      \n");
      printf("       -t [signed.squashfs]      Test signed squashfs part                               \n");
      printf("       -r [update.ird] id        Change reseller id (e.g. 2303 for atevio 7500)          \n");
      printf("       -v                        Display version                                         \n");
      printf("\n");
      printf("Note: For creating squashfs part. use mksquashfs v3.3                                    \n");
      printf("      ./mksquashfs squashfs-root flash.rootfs.own.mtd8 -nopad -le                        \n");
      printf("\n");
      printf("Example:                                                                                 \n");
      printf("  Creating a new IRD file with rootfs and kernel:                                        \n");
      printf("   %s -c my.ird -r flash.rootfs.own.mtd8.signed -k uimage.mtd6                           \n", argv[0]);
      printf("\n");
      printf("  Extracting a IRD file:                                                                 \n");
      printf("   %s -x my.ird                                                                          \n", argv[0]);
      printf("\n");
      printf("  Signing a squashfs partition:                                                          \n");
      printf("   %s -s my.squashfs                                                                     \n", argv[0]);
      return -1;
   }

   return 0;
}
