#ifndef tuxtxt_common_123
#define tuxtxt_common_123

#include <sys/ioctl.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include "tuxtxt_def.h"
#if TUXTXT_COMPRESS == 1
#include <zlib.h>
#endif


/* shapes */
enum
{
	S_END = 0,
	S_FHL, /* full horizontal line: y-offset */
	S_FVL, /* full vertical line: x-offset */
	S_BOX, /* rectangle: x-offset, y-offset, width, height */
	S_TRA, /* trapez: x0, y0, l0, x1, y1, l1 */
	S_BTR, /* trapez in bgcolor: x0, y0, l0, x1, y1, l1 */
	S_INV, /* invert */
	S_LNK, /* call other shape: shapenumber */
	S_CHR, /* Character from freetype hibyte, lowbyte */
	S_ADT, /* Character 2F alternating raster */
	S_FLH, /* flip horizontal */
	S_FLV  /* flip vertical */
};

/* shape coordinates */
enum
{
	S_W13 = 5, /* width*1/3 */
	S_W12, /* width*1/2 */
	S_W23, /* width*2/3 */
	S_W11, /* width */
	S_WM3, /* width-3 */
	S_H13, /* height*1/3 */
	S_H12, /* height*1/2 */
	S_H23, /* height*2/3 */
	S_H11, /* height */
	S_NrShCoord
};

/* G3 characters */
unsigned char aG3_20[] = { S_TRA, 0, S_H23, 1, 0, S_H11, S_W12, S_END };
unsigned char aG3_21[] = { S_TRA, 0, S_H23, 1, 0, S_H11, S_W11, S_END };
unsigned char aG3_22[] = { S_TRA, 0, S_H12, 1, 0, S_H11, S_W12, S_END };
unsigned char aG3_23[] = { S_TRA, 0, S_H12, 1, 0, S_H11, S_W11, S_END };
unsigned char aG3_24[] = { S_TRA, 0, 0, 1, 0, S_H11, S_W12, S_END };
unsigned char aG3_25[] = { S_TRA, 0, 0, 1, 0, S_H11, S_W11, S_END };
unsigned char aG3_26[] = { S_INV, S_LNK, 0x66, S_END };
unsigned char aG3_27[] = { S_INV, S_LNK, 0x67, S_END };
unsigned char aG3_28[] = { S_INV, S_LNK, 0x68, S_END };
unsigned char aG3_29[] = { S_INV, S_LNK, 0x69, S_END };
unsigned char aG3_2a[] = { S_INV, S_LNK, 0x6a, S_END };
unsigned char aG3_2b[] = { S_INV, S_LNK, 0x6b, S_END };
unsigned char aG3_2c[] = { S_INV, S_LNK, 0x6c, S_END };
unsigned char aG3_2d[] = { S_INV, S_LNK, 0x6d, S_END };
unsigned char aG3_2e[] = { S_BOX, 2, 0, 3, S_H11, S_END };
unsigned char aG3_2f[] = { S_ADT };
unsigned char aG3_30[] = { S_LNK, 0x20, S_FLH, S_END };
unsigned char aG3_31[] = { S_LNK, 0x21, S_FLH, S_END };
unsigned char aG3_32[] = { S_LNK, 0x22, S_FLH, S_END };
unsigned char aG3_33[] = { S_LNK, 0x23, S_FLH, S_END };
unsigned char aG3_34[] = { S_LNK, 0x24, S_FLH, S_END };
unsigned char aG3_35[] = { S_LNK, 0x25, S_FLH, S_END };
unsigned char aG3_36[] = { S_INV, S_LNK, 0x76, S_END };
unsigned char aG3_37[] = { S_INV, S_LNK, 0x77, S_END };
unsigned char aG3_38[] = { S_INV, S_LNK, 0x78, S_END };
unsigned char aG3_39[] = { S_INV, S_LNK, 0x79, S_END };
unsigned char aG3_3a[] = { S_INV, S_LNK, 0x7a, S_END };
unsigned char aG3_3b[] = { S_INV, S_LNK, 0x7b, S_END };
unsigned char aG3_3c[] = { S_INV, S_LNK, 0x7c, S_END };
unsigned char aG3_3d[] = { S_INV, S_LNK, 0x7d, S_END };
unsigned char aG3_3e[] = { S_LNK, 0x2e, S_FLH, S_END };
unsigned char aG3_3f[] = { S_BOX, 0, 0, S_W11, S_H11, S_END };
unsigned char aG3_40[] = { S_BOX, 0, S_H13, S_W11, S_H13, S_LNK, 0x7e, S_END };
unsigned char aG3_41[] = { S_BOX, 0, S_H13, S_W11, S_H13, S_LNK, 0x7e, S_FLV, S_END };
unsigned char aG3_42[] = { S_LNK, 0x50, S_BOX, S_W12, S_H13, S_W12, S_H13, S_END };
unsigned char aG3_43[] = { S_LNK, 0x50, S_BOX, 0, S_H13, S_W12, S_H13, S_END };
unsigned char aG3_44[] = { S_LNK, 0x48, S_FLV, S_LNK, 0x48, S_END };
unsigned char aG3_45[] = { S_LNK, 0x44, S_FLH, S_END };
unsigned char aG3_46[] = { S_LNK, 0x47, S_FLV, S_END };
unsigned char aG3_47[] = { S_LNK, 0x48, S_FLH, S_LNK, 0x48, S_END };
unsigned char aG3_48[] = { S_TRA, 0, 0, S_W23, 0, S_H23, 0, S_BTR, 0, 0, S_W13, 0, S_H13, 0, S_END };
unsigned char aG3_49[] = { S_LNK, 0x48, S_FLH, S_END };
unsigned char aG3_4a[] = { S_LNK, 0x48, S_FLV, S_END };
unsigned char aG3_4b[] = { S_LNK, 0x48, S_FLH, S_FLV, S_END };
unsigned char aG3_4c[] = { S_LNK, 0x50, S_BOX, 0, S_H13, S_W11, S_H13, S_END };
unsigned char aG3_4d[] = { S_CHR, 0x25, 0xE6 };
unsigned char aG3_4e[] = { S_CHR, 0x25, 0xCF };
unsigned char aG3_4f[] = { S_CHR, 0x25, 0xCB };
unsigned char aG3_50[] = { S_BOX, S_W12, 0, 2, S_H11, S_FLH, S_BOX, S_W12, 0, 2, S_H11,S_END };
unsigned char aG3_51[] = { S_BOX, 0, S_H12, S_W11, 2, S_FLV, S_BOX, 0, S_H12, S_W11, 2,S_END };
unsigned char aG3_52[] = { S_LNK, 0x55, S_FLH, S_FLV, S_END };
unsigned char aG3_53[] = { S_LNK, 0x55, S_FLV, S_END };
unsigned char aG3_54[] = { S_LNK, 0x55, S_FLH, S_END };
unsigned char aG3_55[] = { S_LNK, 0x7e, S_FLV, S_BOX, 0, S_H12, S_W12, 2, S_FLV, S_BOX, 0, S_H12, S_W12, 2, S_END };
unsigned char aG3_56[] = { S_LNK, 0x57, S_FLH, S_END};
unsigned char aG3_57[] = { S_LNK, 0x55, S_LNK, 0x50 , S_END};
unsigned char aG3_58[] = { S_LNK, 0x59, S_FLV, S_END};
unsigned char aG3_59[] = { S_LNK, 0x7e, S_LNK, 0x51 , S_END};
unsigned char aG3_5a[] = { S_LNK, 0x50, S_LNK, 0x51 , S_END};
unsigned char aG3_5b[] = { S_CHR, 0x21, 0x92};
unsigned char aG3_5c[] = { S_CHR, 0x21, 0x90};
unsigned char aG3_5d[] = { S_CHR, 0x21, 0x91};
unsigned char aG3_5e[] = { S_CHR, 0x21, 0x93};
unsigned char aG3_5f[] = { S_CHR, 0x00, 0x20};
unsigned char aG3_60[] = { S_INV, S_LNK, 0x20, S_END };
unsigned char aG3_61[] = { S_INV, S_LNK, 0x21, S_END };
unsigned char aG3_62[] = { S_INV, S_LNK, 0x22, S_END };
unsigned char aG3_63[] = { S_INV, S_LNK, 0x23, S_END };
unsigned char aG3_64[] = { S_INV, S_LNK, 0x24, S_END };
unsigned char aG3_65[] = { S_INV, S_LNK, 0x25, S_END };
unsigned char aG3_66[] = { S_LNK, 0x20, S_FLV, S_END };
unsigned char aG3_67[] = { S_LNK, 0x21, S_FLV, S_END };
unsigned char aG3_68[] = { S_LNK, 0x22, S_FLV, S_END };
unsigned char aG3_69[] = { S_LNK, 0x23, S_FLV, S_END };
unsigned char aG3_6a[] = { S_LNK, 0x24, S_FLV, S_END };
unsigned char aG3_6b[] = { S_BOX, 0, 0, S_W11, S_H13, S_TRA, 0, S_H13, S_W11, 0, S_H23, 1, S_END };
unsigned char aG3_6c[] = { S_TRA, 0, 0, 1, 0, S_H12, S_W12, S_FLV, S_TRA, 0, 0, 1, 0, S_H12, S_W12, S_BOX, 0, S_H12, S_W12,1, S_END };
unsigned char aG3_6d[] = { S_TRA, 0, 0, S_W12, S_W12, S_H12, 0, S_FLH, S_TRA, 0, 0, S_W12, S_W12, S_H12, 0, S_END };
unsigned char aG3_6e[] = { S_CHR, 0x00, 0x20};
unsigned char aG3_6f[] = { S_CHR, 0x00, 0x20};
unsigned char aG3_70[] = { S_INV, S_LNK, 0x30, S_END };
unsigned char aG3_71[] = { S_INV, S_LNK, 0x31, S_END };
unsigned char aG3_72[] = { S_INV, S_LNK, 0x32, S_END };
unsigned char aG3_73[] = { S_INV, S_LNK, 0x33, S_END };
unsigned char aG3_74[] = { S_INV, S_LNK, 0x34, S_END };
unsigned char aG3_75[] = { S_INV, S_LNK, 0x35, S_END };
unsigned char aG3_76[] = { S_LNK, 0x66, S_FLH, S_END };
unsigned char aG3_77[] = { S_LNK, 0x67, S_FLH, S_END };
unsigned char aG3_78[] = { S_LNK, 0x68, S_FLH, S_END };
unsigned char aG3_79[] = { S_LNK, 0x69, S_FLH, S_END };
unsigned char aG3_7a[] = { S_LNK, 0x6a, S_FLH, S_END };
unsigned char aG3_7b[] = { S_LNK, 0x6b, S_FLH, S_END };
unsigned char aG3_7c[] = { S_LNK, 0x6c, S_FLH, S_END };
unsigned char aG3_7d[] = { S_LNK, 0x6d, S_FLV, S_END };
unsigned char aG3_7e[] = { S_BOX, S_W12, 0, 2, S_H12, S_FLH, S_BOX, S_W12, 0, 2, S_H12, S_END };// help char, not printed directly (only by S_LNK)

unsigned char *aShapes[] =
{
	aG3_20, aG3_21, aG3_22, aG3_23, aG3_24, aG3_25, aG3_26, aG3_27, aG3_28, aG3_29, aG3_2a, aG3_2b, aG3_2c, aG3_2d, aG3_2e, aG3_2f,
	aG3_30, aG3_31, aG3_32, aG3_33, aG3_34, aG3_35, aG3_36, aG3_37, aG3_38, aG3_39, aG3_3a, aG3_3b, aG3_3c, aG3_3d, aG3_3e, aG3_3f,
	aG3_40, aG3_41, aG3_42, aG3_43, aG3_44, aG3_45, aG3_46, aG3_47, aG3_48, aG3_49, aG3_4a, aG3_4b, aG3_4c, aG3_4d, aG3_4e, aG3_4f,
	aG3_50, aG3_51, aG3_52, aG3_53, aG3_54, aG3_55, aG3_56, aG3_57, aG3_58, aG3_59, aG3_5a, aG3_5b, aG3_5c, aG3_5d, aG3_5e, aG3_5f,
	aG3_60, aG3_61, aG3_62, aG3_63, aG3_64, aG3_65, aG3_66, aG3_67, aG3_68, aG3_69, aG3_6a, aG3_6b, aG3_6c, aG3_6d, aG3_6e, aG3_6f,
	aG3_70, aG3_71, aG3_72, aG3_73, aG3_74, aG3_75, aG3_76, aG3_77, aG3_78, aG3_79, aG3_7a, aG3_7b, aG3_7c, aG3_7d, aG3_7e
};

tuxtxt_cache_struct tuxtxt_cache;
static pthread_mutex_t tuxtxt_cache_lock = PTHREAD_MUTEX_INITIALIZER;
int tuxtxt_get_zipsize(int p,int sp)
{
    tstCachedPage* pg = tuxtxt_cache.astCachetable[p][sp];
    if (!pg) return 0;
#if TUXTXT_COMPRESS == 1
	return pg->ziplen;
#elif TUXTXT_COMPRESS == 2
	pthread_mutex_lock(&tuxtxt_cache_lock);
	int zipsize = 0,i,j;
	for (i = 0; i < 23*5; i++)
		for (j = 0; j < 8; j++)
		zipsize += pg->bitmask[i]>>j & 0x01;

	zipsize+=23*5;//bitmask
	pthread_mutex_unlock(&tuxtxt_cache_lock);
	return zipsize;
#else
	return 23*40;
#endif
}
void tuxtxt_compress_page(int p, int sp, unsigned char* buffer)
{
	pthread_mutex_lock(&tuxtxt_cache_lock);
	tstCachedPage* pg = tuxtxt_cache.astCachetable[p][sp];
	if (!pg)
	{
		printf("tuxtxt: trying to compress a not allocated page!!\n");
		pthread_mutex_unlock(&tuxtxt_cache_lock);
		return;
	}

#if TUXTXT_COMPRESS == 1
	unsigned char pagecompressed[23*40];
	uLongf comprlen = 23*40;
	if (compress2(pagecompressed,&comprlen,buffer,23*40,Z_BEST_SPEED) == Z_OK)
	{
		if (pg->pData)
			pg->pData = realloc(pg->pData,comprlen); 
		else
			pg->pData = malloc(comprlen);
		pg->ziplen = 0;
		if (pg->pData)
		{
			pg->ziplen = comprlen;
			memcpy(pg->pData,pagecompressed,comprlen);
		}
	}
#elif TUXTXT_COMPRESS == 2
	int i,j=0;
	unsigned char cbuf[23*40];
	memset(pg->bitmask,0,sizeof(pg->bitmask));
	for (i = 0; i < 23*40; i++)
	{
		if (i && buffer[i] == buffer[i-1])
		    continue;
		pg->bitmask[i>>3] |= 0x80>>(i&0x07);
		cbuf[j++]=buffer[i];
	}
	if (pg->pData)
		pg->pData = realloc(pg->pData,j); 
	else
		pg->pData = malloc(j);
	if (pg->pData)
	{
		memcpy(pg->pData,cbuf,j);
	}
	else
		memset(pg->bitmask,0,sizeof(pg->bitmask));

#else
	memcpy(pg->data,buffer,23*40);
#endif
	pthread_mutex_unlock(&tuxtxt_cache_lock);

}
void tuxtxt_decompress_page(int p, int sp, unsigned char* buffer)
{
	pthread_mutex_lock(&tuxtxt_cache_lock);
    tstCachedPage* pg = tuxtxt_cache.astCachetable[p][sp];
	memset(buffer,' ',23*40);
    if (!pg)
    {
		printf("tuxtxt: trying to decompress a not allocated page!!\n");
		pthread_mutex_unlock(&tuxtxt_cache_lock);
		return;
    }
	if (pg->pData)
	{
#if TUXTXT_COMPRESS == 1
		if (pg->ziplen)
		{
			uLongf comprlen = 23*40;
			uncompress(buffer,&comprlen,pg->pData,pg->ziplen);
		}

#elif TUXTXT_COMPRESS == 2
		int i,j=0;
		char c=0x20;
		for (i = 0; i < 23*40; i++)
		{
		    if (pg->bitmask[i>>3] & 0x80>>(i&0x07))
				c = pg->pData[j++];
		    buffer[i] = c;
		}
#else
		memcpy(buffer,pg->data,23*40);
#endif
	}
	pthread_mutex_unlock(&tuxtxt_cache_lock);
}
void tuxtxt_next_dec(int *i) /* skip to next decimal */
{
	(*i)++;

	if ((*i & 0x0F) > 0x09)
		*i += 0x06;

	if ((*i & 0xF0) > 0x90)
		*i += 0x60;

	if (*i > 0x899)
		*i = 0x100;
}

void tuxtxt_prev_dec(int *i)           /* counting down */
{
	(*i)--;

	if ((*i & 0x0F) > 0x09)
		*i -= 0x06;

	if ((*i & 0xF0) > 0x90)
		*i -= 0x60;

	if (*i < 0x100)
		*i = 0x899;
}

int tuxtxt_is_dec(int i)
{
	return ((i & 0x00F) <= 9) && ((i & 0x0F0) <= 0x90);
}

int tuxtxt_next_hex(int i) /* return next existing non-decimal page number */
{
	int startpage = i;
	if (startpage < 0x100)
		startpage = 0x100;

	do
	{
		i++;
		if (i > 0x8FF)
			i = 0x100;
		if (i == startpage)
			break;
	}  while ((tuxtxt_cache.subpagetable[i] == 0xFF) || tuxtxt_is_dec(i));
	return i;
}
#define number2char(c) ((c) + (((c) <= 9) ? '0' : ('A' - 10)))
/* print hex-number into string, s points to last digit, caller has to provide enough space, no termination */
void tuxtxt_hex2str(char *s, unsigned int n)
{
	do {
		char c = (n & 0xF);
		*s-- = number2char(c);
		n >>= 4;
	} while (n);
}
/*
 * TOP-Text
 * Info entnommen aus videotext-0.6.19991029,
 * Copyright (c) 1994-96 Martin Buck  <martin-2.buck@student.uni-ulm.de>
 */
void tuxtxt_decode_btt()
{
	/* basic top table */
	int i, current, b1, b2, b3, b4;
	unsigned char btt[23*40];

	if (tuxtxt_cache.subpagetable[0x1f0] == 0xff || 0 == tuxtxt_cache.astCachetable[0x1f0][tuxtxt_cache.subpagetable[0x1f0]]) /* not yet received */
		return;
	tuxtxt_decompress_page(0x1f0,tuxtxt_cache.subpagetable[0x1f0],btt);
	if (btt[799] == ' ') /* not completely received or error */
		return;

	current = 0x100;
	for (i = 0; i < 800; i++)
	{
		b1 = btt[i];
		if (b1 == ' ')
			b1 = 0;
		else
		{
			b1 = dehamming[b1];
			if (b1 == 0xFF) /* hamming error in btt */
			{
				btt[799] = ' '; /* mark btt as not received */
				return;
			}
		}
		tuxtxt_cache.basictop[current] = b1;
		tuxtxt_next_dec(&current);
	}
	/* page linking table */
	tuxtxt_cache.maxadippg = -1; /* rebuild table of adip pages */
	for (i = 0; i < 10; i++)
	{
		b1 = dehamming[btt[800 + 8*i +0]];

		if (b1 == 0xE)
			continue; /* unused */
		else if (b1 == 0xF)
			break; /* end */

		b4 = dehamming[btt[800 + 8*i +7]];

		if (b4 != 2) /* only adip, ignore multipage (1) */
			continue;

		b2 = dehamming[btt[800 + 8*i +1]];
		b3 = dehamming[btt[800 + 8*i +2]];

		if (b1 == 0xFF || b2 == 0xFF || b3 == 0xFF)
		{
			printf("TuxTxt <Biterror in btt/plt index %d>\n", i);
			btt[799] = ' '; /* mark btt as not received */
			return;
		}

		b1 = b1<<8 | b2<<4 | b3; /* page number */
		tuxtxt_cache.adippg[++tuxtxt_cache.maxadippg] = b1;
	}
#ifdef DEBUG
	printf("TuxTxt <BTT decoded>\n");
#endif
	tuxtxt_cache.bttok = 1;
}

void tuxtxt_decode_adip() /* additional information table */
{
	int i, p, j, b1, b2, b3, charfound;
	unsigned char padip[23*40];

	for (i = 0; i <= tuxtxt_cache.maxadippg; i++)
	{
		p = tuxtxt_cache.adippg[i];
		if (!p || tuxtxt_cache.subpagetable[p] == 0xff || 0 == tuxtxt_cache.astCachetable[p][tuxtxt_cache.subpagetable[p]]) /* not cached (avoid segfault) */
			continue;

		tuxtxt_decompress_page(p,tuxtxt_cache.subpagetable[p],padip);
		for (j = 0; j < 44; j++)
		{
			b1 = dehamming[padip[20*j+0]];
			if (b1 == 0xE)
				continue; /* unused */

			if (b1 == 0xF)
				break; /* end */

			b2 = dehamming[padip[20*j+1]];
			b3 = dehamming[padip[20*j+2]];

			if (b1 == 0xFF || b2 == 0xFF || b3 == 0xFF)
			{
				printf("TuxTxt <Biterror in ait %03x %d %02x %02x %02x %02x %02x %02x>\n", p, j,
						 padip[20*j+0],
						 padip[20*j+1],
						 padip[20*j+2],
						 b1, b2, b3
						 );
				return;
			}

			if (b1>8 || b2>9 || b3>9) /* ignore extries with invalid or hex page numbers */
			{
				continue;
			}

			b1 = b1<<8 | b2<<4 | b3; /* page number */
			charfound = 0; /* flag: no printable char found */

			for (b2 = 11; b2 >= 0; b2--)
			{
				b3 = deparity[padip[20*j + 8 + b2]];
				if (b3 < ' ')
					b3 = ' ';

				if (b3 == ' ' && !charfound)
					tuxtxt_cache.adip[b1][b2] = '\0';
				else
				{
					tuxtxt_cache.adip[b1][b2] = b3;
					charfound = 1;
				}
			}
		} /* next link j */
		tuxtxt_cache.adippg[i] = 0; /* completely decoded: clear entry */
#ifdef DEBUG
		printf("TuxTxt <ADIP %03x decoded>\n", p);
#endif
	} /* next adip page i */

	while (!tuxtxt_cache.adippg[tuxtxt_cache.maxadippg] && (tuxtxt_cache.maxadippg >= 0)) /* and shrink table */
		tuxtxt_cache.maxadippg--;
}
/******************************************************************************
 * GetSubPage                                                                 *
 ******************************************************************************/
int tuxtxt_GetSubPage(int page, int subpage, int offset)
{
	int loop;


	for (loop = subpage + offset; loop != subpage; loop += offset)
	{
		if (loop < 0)
			loop = 0x79;
		else if (loop > 0x79)
			loop = 0;
		if (loop == subpage)
			break;

		if (tuxtxt_cache.astCachetable[page][loop])
		{
#ifdef DEBUG
			printf("TuxTxt <NextSubPage: %.3X-%.2X>\n", page, subpage);
#endif
			return loop;
		}
	}

#ifdef DEBUG
	printf("TuxTxt <NextSubPage: no other SubPage>\n");
#endif
	return subpage;
}

/******************************************************************************
 * clear_cache                                                                *
 ******************************************************************************/

void tuxtxt_clear_cache()
{
	pthread_mutex_lock(&tuxtxt_cache_lock);
	int clear_page, clear_subpage, d26;
	tuxtxt_cache.maxadippg  = -1;
	tuxtxt_cache.bttok      = 0;
	tuxtxt_cache.cached_pages  = 0;
	tuxtxt_cache.page_receiving = -1;
	tuxtxt_cache.vtxtpid = -1;
	memset(&tuxtxt_cache.subpagetable, 0xFF, sizeof(tuxtxt_cache.subpagetable));
	memset(&tuxtxt_cache.basictop, 0, sizeof(tuxtxt_cache.basictop));
	memset(&tuxtxt_cache.adip, 0, sizeof(tuxtxt_cache.adip));
	memset(&tuxtxt_cache.flofpages, 0 , sizeof(tuxtxt_cache.flofpages));
	memset(&tuxtxt_cache.timestring, 0x20, 8);
 	unsigned char magazine;
	for (magazine = 1; magazine < 9; magazine++)
	{
		tuxtxt_cache.current_page  [magazine] = -1;
		tuxtxt_cache.current_subpage [magazine] = -1;
	}

	for (clear_page = 0; clear_page < 0x900; clear_page++)
		for (clear_subpage = 0; clear_subpage < 0x80; clear_subpage++)
			if (tuxtxt_cache.astCachetable[clear_page][clear_subpage])
			{
				tstPageinfo *p = &(tuxtxt_cache.astCachetable[clear_page][clear_subpage]->pageinfo);
				if (p->p24)
					free(p->p24);
				if (p->ext)
				{
					if (p->ext->p27)
						free(p->ext->p27);
					for (d26=0; d26 < 16; d26++)
						if (p->ext->p26[d26])
							free(p->ext->p26[d26]);
					free(p->ext);
				}
#if TUXTXT_COMPRESS >0
				if (tuxtxt_cache.astCachetable[clear_page][clear_subpage]->pData)
					free(tuxtxt_cache.astCachetable[clear_page][clear_subpage]->pData);
#endif
				free(tuxtxt_cache.astCachetable[clear_page][clear_subpage]);
				tuxtxt_cache.astCachetable[clear_page][clear_subpage] = 0;
			}
	for (clear_page = 0; clear_page < 9; clear_page++)
	{
		if (tuxtxt_cache.astP29[clear_page])
		{
		    if (tuxtxt_cache.astP29[clear_page]->p27)
			free(tuxtxt_cache.astP29[clear_page]->p27);
		    for (d26=0; d26 < 16; d26++)
			if (tuxtxt_cache.astP29[clear_page]->p26[d26])
			    free(tuxtxt_cache.astP29[clear_page]->p26[d26]);
		    free(tuxtxt_cache.astP29[clear_page]);
		    tuxtxt_cache.astP29[clear_page] = 0;
		}
		tuxtxt_cache.current_page  [clear_page] = -1;
		tuxtxt_cache.current_subpage [clear_page] = -1;
	}
	memset(&tuxtxt_cache.astCachetable, 0, sizeof(tuxtxt_cache.astCachetable));
	memset(&tuxtxt_cache.astP29, 0, sizeof(tuxtxt_cache.astP29));
#ifdef DEBUG
	printf("TuxTxt cache cleared\n");
#endif
	pthread_mutex_unlock(&tuxtxt_cache_lock);
}
/******************************************************************************
 * init_demuxer                                                               *
 ******************************************************************************/

int tuxtxt_init_demuxer()
{
	/* open demuxer */
	if ((tuxtxt_cache.dmx = open(DMX, O_RDWR)) == -1)
	{
		perror("TuxTxt <open DMX>");
		return 0;
	}


	if (ioctl(tuxtxt_cache.dmx, DMX_SET_BUFFER_SIZE, 64*1024) < 0)
	{
		perror("TuxTxt <DMX_SET_BUFFERSIZE>");
		return 0;
	}
#ifdef DEBUG
	printf("TuxTxt: initialized\n");
#endif
	/* init successfull */

	return 1;
}
/******************************************************************************
 * CacheThread support functions                                              *
 ******************************************************************************/

void tuxtxt_decode_p2829(unsigned char *vtxt_row, tstExtData **ptExtData)
{
	int bitsleft, colorindex;
	unsigned char *p;
	int t1 = deh24(&vtxt_row[7-4]);
	int t2 = deh24(&vtxt_row[10-4]);

	if (t1 < 0 || t2 < 0)
	{
#ifdef DEBUG
		printf("TuxTxt <Biterror in p28>\n");
#endif
		return;
	}

	if (!(*ptExtData))
		(*ptExtData) = calloc(1, sizeof(tstExtData));
	if (!(*ptExtData))
		return;

	(*ptExtData)->p28Received = 1;
	(*ptExtData)->DefaultCharset = (t1>>7) & 0x7f;
	(*ptExtData)->SecondCharset = ((t1>>14) & 0x0f) | ((t2<<4) & 0x70);
	(*ptExtData)->LSP = !!(t2 & 0x08);
	(*ptExtData)->RSP = !!(t2 & 0x10);
	(*ptExtData)->SPL25 = !!(t2 & 0x20);
	(*ptExtData)->LSPColumns = (t2>>6) & 0x0f;

	bitsleft = 8; /* # of bits not evaluated in val */
	t2 >>= 10; /* current data */
	p = &vtxt_row[13-4];	/* pointer to next data triplet */
	for (colorindex = 0; colorindex < 16; colorindex++)
	{
		if (bitsleft < 12)
		{
			t2 |= deh24(p) << bitsleft;
			if (t2 < 0)	/* hamming error */
				break;
			p += 3;
			bitsleft += 18;
		}
		(*ptExtData)->bgr[colorindex] = t2 & 0x0fff;
		bitsleft -= 12;
		t2 >>= 12;
	}
	if (t2 < 0 || bitsleft != 14)
	{
#ifdef DEBUG
		printf("TuxTxt <Biterror in p28/29 t2=%d b=%d>\n", t2, bitsleft);
#endif
		(*ptExtData)->p28Received = 0;
		return;
	}
	(*ptExtData)->DefScreenColor = t2 & 0x1f;
	t2 >>= 5;
	(*ptExtData)->DefRowColor = t2 & 0x1f;
	(*ptExtData)->BlackBgSubst = !!(t2 & 0x20);
	t2 >>= 6;
	(*ptExtData)->ColorTableRemapping = t2 & 0x07;
}

void tuxtxt_erase_page(int magazine)
{
	pthread_mutex_lock(&tuxtxt_cache_lock);
    tstCachedPage* pg = tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]];
	if (pg)
	{
		memset(&(pg->pageinfo), 0, sizeof(tstPageinfo));	/* struct pageinfo */
		memset(pg->p0, ' ', 24);
#if TUXTXT_COMPRESS == 1
    	if (pg->pData) {free(pg->pData); pg->pData = NULL;}
#elif TUXTXT_COMPRESS == 2
		memset(pg->bitmask, 0, 23*5);
#else
		memset(pg->data, ' ', 23*40);
#endif
	}
	pthread_mutex_unlock(&tuxtxt_cache_lock);
}

void tuxtxt_allocate_cache(int magazine)
{
	/* check cachetable and allocate memory if needed */
	if (tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]] == 0)
	{

		tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]] = malloc(sizeof(tstCachedPage));
		if (tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]] )
		{
#if TUXTXT_COMPRESS >0
			tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->pData = 0;
#endif
			tuxtxt_erase_page(magazine);
			tuxtxt_cache.cached_pages++;
		}
	}
}
/******************************************************************************
 * CacheThread                                                                *
 ******************************************************************************/
#define DEBUG
void *tuxtxt_CacheThread(void *arg)
{
	const unsigned char rev_lut[32] = {
		0x00,0x08,0x04,0x0c, /*  upper nibble */
		0x02,0x0a,0x06,0x0e,
		0x01,0x09,0x05,0x0d,
		0x03,0x0b,0x07,0x0f,
		0x00,0x80,0x40,0xc0, /*  lower nibble */
		0x20,0xa0,0x60,0xe0,
		0x10,0x90,0x50,0xd0,
		0x30,0xb0,0x70,0xf0 };
	unsigned char pes_packet[184];
	unsigned char vtxt_row[42];
	int line, byte/*, bit*/;
	int b1, b2, b3, b4;
	int packet_number;
	int doupdate=0;
	unsigned char magazine = 0xff;
	unsigned char pagedata[9][23*40];
	tstPageinfo *pageinfo_thread;

	printf("TuxTxt running thread...(%03x)\n",tuxtxt_cache.vtxtpid);
	tuxtxt_cache.receiving = 1;

	nice(3);
	
	while (1)
	{
		/* check stopsignal */
		pthread_testcancel();
		if (!tuxtxt_cache.receiving) continue;

		/* read packet */
		ssize_t readcnt;
		readcnt = read(tuxtxt_cache.dmx, &pes_packet, sizeof(pes_packet));

		if (readcnt != sizeof(pes_packet))
		{
#ifdef DEBUG
			printf ("TuxTxt: readerror\n");
#endif
			continue;
		}

		/* analyze it */
		for (line = 0; line < 4; line++)
		{
			unsigned char *vtx_rowbyte = &pes_packet[line*0x2e];
			if ((vtx_rowbyte[0] == 0x02 || vtx_rowbyte[0] == 0x03) && (vtx_rowbyte[1] == 0x2C))
			{
				/* clear rowbuffer */
				/* convert row from lsb to msb (begin with magazin number) */
				for (byte = 4; byte < 46; byte++)
				{
					unsigned char upper,lower;
					upper = (vtx_rowbyte[byte] >> 4) & 0xf;
					lower = vtx_rowbyte[byte] & 0xf;
					vtxt_row[byte-4] = (rev_lut[upper]) | (rev_lut[lower+16]);
				}

				/* get packet number */
				b1 = dehamming[vtxt_row[0]];
				b2 = dehamming[vtxt_row[1]];

				if (b1 == 0xFF || b2 == 0xFF)
				{
#ifdef DEBUG
					printf("TuxTxt <Biterror in Packet>\n");
#endif
					continue;
				}

				b1 &= 8;

				packet_number = b1>>3 | b2<<1;

				/* get magazine number */
				magazine = dehamming[vtxt_row[0]] & 7;
				if (!magazine) magazine = 8;

				if (packet_number == 0 && tuxtxt_cache.current_page[magazine] != -1 && tuxtxt_cache.current_subpage[magazine] != -1)
 				    tuxtxt_compress_page(tuxtxt_cache.current_page[magazine],tuxtxt_cache.current_subpage[magazine],pagedata[magazine]);

//printf("receiving packet %d %03x/%02x\n",packet_number, tuxtxt_cache.current_page[magazine],tuxtxt_cache.current_subpage[magazine]);

				/* analyze row */
				if (packet_number == 0)
				{
    					/* get pagenumber */
					b2 = dehamming[vtxt_row[3]];
					b3 = dehamming[vtxt_row[2]];

					if (b2 == 0xFF || b3 == 0xFF)
					{
						tuxtxt_cache.current_page[magazine] = tuxtxt_cache.page_receiving = -1;
#ifdef DEBUG
						printf("TuxTxt <Biterror in Page>\n");
#endif
						continue;
					}

					tuxtxt_cache.current_page[magazine] = tuxtxt_cache.page_receiving = magazine<<8 | b2<<4 | b3;

					if (b2 == 0x0f && b3 == 0x0f)
					{
						tuxtxt_cache.current_subpage[magazine] = -1; /* ?ff: ignore data transmissions */
						continue;
					}

					/* get subpagenumber */
					b1 = dehamming[vtxt_row[7]];
					b2 = dehamming[vtxt_row[6]];
					b3 = dehamming[vtxt_row[5]];
					b4 = dehamming[vtxt_row[4]];

					if (b1 == 0xFF || b2 == 0xFF || b3 == 0xFF || b4 == 0xFF)
					{
#ifdef DEBUG
						printf("TuxTxt <Biterror in SubPage>\n");
#endif
						tuxtxt_cache.current_subpage[magazine] = -1;
						continue;
					}

					b1 &= 3;
					b3 &= 7;

					if (tuxtxt_is_dec(tuxtxt_cache.page_receiving)) /* ignore other subpage bits for hex pages */
					{
#if 0	/* ? */
						if (b1 != 0 || b2 != 0)
						{
#ifdef DEBUG
							printf("TuxTxt <invalid subpage data p%03x %02x %02x %02x %02x>\n", tuxtxt_cache.page_receiving, b1, b2, b3, b4);
#endif
							tuxtxt_cache.current_subpage[magazine] = -1;
							continue;
						}
						else
#endif
							tuxtxt_cache.current_subpage[magazine] = b3<<4 | b4;
					}
					else
						tuxtxt_cache.current_subpage[magazine] = b4; /* max 16 subpages for hex pages */

					/* store current subpage for this page */
					tuxtxt_cache.subpagetable[tuxtxt_cache.current_page[magazine]] = tuxtxt_cache.current_subpage[magazine];

					tuxtxt_allocate_cache(magazine);
					tuxtxt_decompress_page(tuxtxt_cache.current_page[magazine],tuxtxt_cache.current_subpage[magazine],pagedata[magazine]);
					pageinfo_thread = &(tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->pageinfo);

					if ((tuxtxt_cache.page_receiving & 0xff) == 0xfe) /* ?fe: magazine organization table (MOT) */
						pageinfo_thread->function = FUNC_MOT;

					/* check controlbits */
					if (dehamming[vtxt_row[5]] & 8)   /* C4 -> erase page */
					{
#if TUXTXT_COMPRESS == 1
						tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->ziplen = 0;
#elif TUXTXT_COMPRESS == 2
						memset(tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->bitmask, 0, 23*5);
#else
						memset(tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->data, ' ', 23*40);
#endif
						memset(pagedata[magazine],' ', 23*40);
					}
					if (dehamming[vtxt_row[9]] & 8)   /* C8 -> update page */
						doupdate = tuxtxt_cache.page_receiving;

					pageinfo_thread->boxed = !!(dehamming[vtxt_row[7]] & 0x0c);

					/* get country control bits */
					b1 = dehamming[vtxt_row[9]];
					if (b1 == 0xFF)
					{
#ifdef DEBUG
						printf("TuxTxt <Biterror in CountryFlags>\n");
#endif
					}
					else
					{
						pageinfo_thread->nationalvalid = 1;
						pageinfo_thread->national = rev_lut[b1] & 0x07;
					}

					/* check parity, copy line 0 to cache (start and end 8 bytes are not needed and used otherwise) */
					unsigned char *p = tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->p0;
					for (byte = 10; byte < 42-8; byte++)
						*p++ = deparity[vtxt_row[byte]];

					if (!tuxtxt_is_dec(tuxtxt_cache.page_receiving))
						continue; /* valid hex page number: just copy headline, ignore timestring */

					/* copy timestring */
					p = tuxtxt_cache.timestring;
					for (; byte < 42; byte++)
						*p++ = deparity[vtxt_row[byte]];
				} /* (packet_number == 0) */
				else if (packet_number == 29 && dehamming[vtxt_row[2]]== 0) /* packet 29/0 replaces 28/0 for a whole magazine */
				{
					tuxtxt_decode_p2829(vtxt_row, &(tuxtxt_cache.astP29[magazine]));
				}
				else if (tuxtxt_cache.current_page[magazine] != -1 && tuxtxt_cache.current_subpage[magazine] != -1)
					/* packet>0, 0 has been correctly received, buffer allocated */
				{
					pageinfo_thread = &(tuxtxt_cache.astCachetable[tuxtxt_cache.current_page[magazine]][tuxtxt_cache.current_subpage[magazine]]->pageinfo);
					/* pointer to current info struct */

					if (packet_number <= 25)
					{
						unsigned char *p = NULL;
						if (packet_number < 24)
							p = pagedata[magazine] + 40*(packet_number-1);
						else
						{
							if (!(pageinfo_thread->p24))
								pageinfo_thread->p24 = calloc(2, 40);
							if (pageinfo_thread->p24)
								p = pageinfo_thread->p24 + (packet_number - 24) * 40;
						}
						if (p)
						{
							if (tuxtxt_is_dec(tuxtxt_cache.current_page[magazine]))
								for (byte = 2; byte < 42; byte++)
									*p++ = deparity[vtxt_row[byte]]; /* check/remove parity bit */
							else if ((tuxtxt_cache.current_page[magazine] & 0xff) == 0xfe)
								for (byte = 2; byte < 42; byte++)
									*p++ = dehamming[vtxt_row[byte]]; /* decode hamming 8/4 */
							else /* other hex page: no parity check, just copy */
								memcpy(p, &vtxt_row[2], 40);
						}
					}
					else if (packet_number == 27)
					{
						int descode = dehamming[vtxt_row[2]]; /* designation code (0..15) */

						if (descode == 0xff)
						{
#ifdef DEBUG
							printf("TuxTxt <Biterror in p27>\n");
#endif
							continue;
						}
						if (descode == 0) // reading FLOF-Pagelinks
						{
							b1 = dehamming[vtxt_row[0]];
							if (b1 != 0xff)
							{
								b1 &= 7;

								for (byte = 0; byte < FLOFSIZE; byte++)
								{
									b2 = dehamming[vtxt_row[4+byte*6]];
									b3 = dehamming[vtxt_row[3+byte*6]];

									if (b2 != 0xff && b3 != 0xff)
									{
										b4 = ((b1 ^ (dehamming[vtxt_row[8+byte*6]]>>1)) & 6) |
											((b1 ^ (dehamming[vtxt_row[6+byte*6]]>>3)) & 1);
										if (b4 == 0)
											b4 = 8;
										if (b2 <= 9 && b3 <= 9)
											tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine] ][byte] = b4<<8 | b2<<4 | b3;
									}
								}

								/* copy last 2 links to adip for TOP-Index */
								if (pageinfo_thread->p24) /* packet 24 received */
								{
									int a, a1, e=39, l=3;
									char *p = (char*) pageinfo_thread->p24;
									do
									{
										for (;
											  l >= 2 && 0 == tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine]][l];
											  l--)
											; /* find used linkindex */
										for (;
											  e >= 1 && !isalnum(p[e]);
											  e--)
											; /* find end */
										for (a = a1 = e - 1;
											  a >= 0 && p[a] >= ' ';
											  a--) /* find start */
											if (p[a] > ' ')
											a1 = a; /* first non-space */
										if (a >= 0 && l >= 2)
										{
											strncpy((char*) tuxtxt_cache.adip[tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine]][l]],
													  &p[a1],
													  12);
											if (e-a1 < 11)
												tuxtxt_cache.adip[tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine]][l]][e-a1+1] = '\0';
#if 0 //DEBUG
											printf(" %03x/%02x %d %d %d %d %03x %s\n",
													 tuxtxt_cache.current_page[magazine], tuxtxt_cache.current_subpage[magazine],
													 l, a, a1, e,
													 tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine]][l],
													 tuxtxt_cache.adip[tuxtxt_cache.flofpages[tuxtxt_cache.current_page[magazine]][l]]
													 );
#endif
										}
										e = a - 1;
										l--;
									} while (l >= 2);
								}
							}
						}
						else if (descode == 4)	/* level 2.5 links (ignore level 3.5 links of /4 and /5) */
						{
							int i;
							tstp27 *p;

							if (!pageinfo_thread->ext)
								pageinfo_thread->ext = calloc(1, sizeof(tstExtData));
							if (!pageinfo_thread->ext)
								continue;
							if (!(pageinfo_thread->ext->p27))
								pageinfo_thread->ext->p27 = calloc(4, sizeof(tstp27));
							if (!(pageinfo_thread->ext->p27))
								continue;
							p = pageinfo_thread->ext->p27;
							for (i = 0; i < 4; i++)
							{
								int d1 = deh24(&vtxt_row[6*i + 3]);
								int d2 = deh24(&vtxt_row[6*i + 6]);
								if (d1 < 0 || d2 < 0)
								{
#ifdef DEBUG
									printf("TuxTxt <Biterror in p27/4-5>\n");
#endif
									continue;
								}
								p->local = i & 0x01;
								p->drcs = !!(i & 0x02);
								p->l25 = !!(d1 & 0x04);
								p->l35 = !!(d1 & 0x08);
								p->page =
									(((d1 & 0x000003c0) >> 6) |
									 ((d1 & 0x0003c000) >> (14-4)) |
									 ((d1 & 0x00003800) >> (11-8))) ^
									(dehamming[vtxt_row[0]] << 8);
								if (p->page < 0x100)
									p->page += 0x800;
								p->subpage = d2 >> 2;
								if ((p->page & 0xff) == 0xff)
									p->page = 0;
								else if (p->page > 0x899)
								{
									// workaround for crash on RTL Shop ...
									// sorry.. i dont understand whats going wrong here :)
									printf("[TuxTxt] page > 0x899 ... ignore!!!!!!\n");
									continue;
								}
								else if (tuxtxt_cache.astCachetable[p->page][0])	/* link valid && linked page cached */
								{
									tstPageinfo *pageinfo_link = &(tuxtxt_cache.astCachetable[p->page][0]->pageinfo);
									if (p->local)
										pageinfo_link->function = p->drcs ? FUNC_DRCS : FUNC_POP;
									else
										pageinfo_link->function = p->drcs ? FUNC_GDRCS : FUNC_GPOP;
								}
								p++; /*  */
							}
						}
					}

					else if (packet_number == 26)
					{
						int descode = dehamming[vtxt_row[2]]; /* designation code (0..15) */

						if (descode == 0xff)
						{
#ifdef DEBUG
							printf("TuxTxt <Biterror in p26>\n");
#endif
							continue;
						}
						if (!pageinfo_thread->ext)
							pageinfo_thread->ext = calloc(1, sizeof(tstExtData));
						if (!pageinfo_thread->ext)
							continue;
						if (!(pageinfo_thread->ext->p26[descode]))
							pageinfo_thread->ext->p26[descode] = malloc(13 * 3);
						if (pageinfo_thread->ext->p26[descode])
							memcpy(pageinfo_thread->ext->p26[descode], &vtxt_row[3], 13 * 3);
#if 0//DEBUG
						int i, t, m;

						printf("P%03x/%02x %02d/%x",
								 tuxtxt_cache.current_page[magazine], tuxtxt_cache.current_subpage[magazine],
								 packet_number, dehamming[vtxt_row[2]]);
						for (i=7-4; i <= 45-4; i+=3) /* dump all triplets */
						{
							t = deh24(&vtxt_row[i]); /* mode/adr/data */
							m = (t>>6) & 0x1f;
							printf(" M%02xA%02xD%03x", m, t & 0x3f, (t>>11) & 0x7f);
							if (m == 0x1f)	/* terminator */
								break;
						}
						putchar('\n');
#endif
					}
					else if (packet_number == 28)
					{
						int descode = dehamming[vtxt_row[2]]; /* designation code (0..15) */

						if (descode == 0xff)
						{
#ifdef DEBUG
							printf("TuxTxt <Biterror in p28>\n");
#endif
							continue;
						}
						if (descode != 2)
						{
							int t1 = deh24(&vtxt_row[7-4]);
							pageinfo_thread->function = t1 & 0x0f;
							if (!pageinfo_thread->nationalvalid)
							{
								pageinfo_thread->nationalvalid = 1;
								pageinfo_thread->national = (t1>>4) & 0x07;
							}
						}

						switch (descode) /* designation code */
						{
						case 0: /* basic level 1 page */
						{
							tuxtxt_decode_p2829(vtxt_row, &(pageinfo_thread->ext));
							break;
						}
						case 1: /* G0/G1 designation for older decoders, level 3.5: DCLUT4/16, colors for multicolored bitmaps */
						{
							break; /* ignore */
						}
						case 2: /* page key */
						{
							break; /* ignore */
						}
						case 3: /* types of PTUs in DRCS */
						{
							break; /* TODO */
						}
						case 4: /* CLUTs 0/1, only level 3.5 */
						{
							break; /* ignore */
						}
						default:
						{
							break; /* invalid, ignore */
						}
						} /* switch designation code */
					}
					else if (packet_number == 30)
					{
#if 0//DEBUG
						int i;

						printf("p%03x/%02x %02d/%x ",
								 tuxtxt_cache.current_page[magazine], tuxtxt_cache.current_subpage[magazine],
								 packet_number, dehamming[vtxt_row[2]]);
						for (i=26-4; i <= 45-4; i++) /* station ID */
							putchar(deparity[vtxt_row[i]]);
						putchar('\n');
#endif
					}
				}
				/* set update flag */
				if (tuxtxt_cache.current_page[magazine] == tuxtxt_cache.page && tuxtxt_cache.current_subpage[magazine] != -1)
				{
 				    tuxtxt_compress_page(tuxtxt_cache.current_page[magazine],tuxtxt_cache.current_subpage[magazine],pagedata[magazine]);
					tuxtxt_cache.pageupdate = 1+(doupdate == tuxtxt_cache.page ? 1: 0);
					doupdate=0;
					if (!tuxtxt_cache.zap_subpage_manual)
						tuxtxt_cache.subpage = tuxtxt_cache.current_subpage[magazine];
				}
			}
		}
	}
	return 0;
}
/******************************************************************************
 * start_thread                                                               *
 ******************************************************************************/
int tuxtxt_start_thread()
{
	if (tuxtxt_cache.vtxtpid == -1) return 0;


	tuxtxt_cache.thread_starting = 1;
	struct dmx_pes_filter_params dmx_flt;

	/* set filter & start demuxer */
	dmx_flt.pid      = tuxtxt_cache.vtxtpid;
	dmx_flt.input    = DMX_IN_FRONTEND;
	dmx_flt.output   = DMX_OUT_TAP;
	dmx_flt.pes_type = DMX_PES_OTHER;
	dmx_flt.flags    = DMX_IMMEDIATE_START;

	if (tuxtxt_cache.dmx == -1) tuxtxt_init_demuxer();

	if (ioctl(tuxtxt_cache.dmx, DMX_SET_PES_FILTER, &dmx_flt) == -1)
	{
		perror("TuxTxt <DMX_SET_PES_FILTER>");
		tuxtxt_cache.thread_starting = 0;
		return 0;
	}

	/* create decode-thread */
	if (pthread_create(&tuxtxt_cache.thread_id, NULL, tuxtxt_CacheThread, NULL) != 0)
	{
		perror("TuxTxt <pthread_create>");
		tuxtxt_cache.thread_starting = 0;
		tuxtxt_cache.thread_id = 0;
		return 0;
	}
#if 1//DEBUG
	printf("TuxTxt service started %x\n", tuxtxt_cache.vtxtpid);
#endif
	tuxtxt_cache.receiving = 1;
	tuxtxt_cache.thread_starting = 0;
	return 1;
}
/******************************************************************************
 * stop_thread                                                                *
 ******************************************************************************/

int tuxtxt_stop_thread()
{

	/* stop decode-thread */
	if (tuxtxt_cache.thread_id != 0)
	{
		if (pthread_cancel(tuxtxt_cache.thread_id) != 0)
		{
			perror("TuxTxt <pthread_cancel>");
			return 0;
		}

		if (pthread_join(tuxtxt_cache.thread_id, &tuxtxt_cache.thread_result) != 0)
		{
			perror("TuxTxt <pthread_join>");
			return 0;
		}
		tuxtxt_cache.thread_id = 0;
	}
	if (tuxtxt_cache.dmx != -1)
	{
		ioctl(tuxtxt_cache.dmx, DMX_STOP);
//        close(tuxtxt_cache.dmx);
  	}
//	tuxtxt_cache.dmx = -1;
#if 1//DEBUG
	printf("TuxTxt stopped service %x\n", tuxtxt_cache.vtxtpid);
#endif
	return 1;
}

/******************************************************************************
 * decode Level2.5                                                            *
 ******************************************************************************/
int tuxtxt_eval_triplet(int iOData, tstCachedPage *pstCachedPage,
					  unsigned char *pAPx, unsigned char *pAPy,
					  unsigned char *pAPx0, unsigned char *pAPy0,
					  unsigned char *drcssubp, unsigned char *gdrcssubp,
					  signed char *endcol, tstPageAttr *attrPassive, unsigned char* pagedata, unsigned char* page_char, tstPageAttr* page_atrb);

/* get object data */
/* in: absolute triplet number (0..506, start at packet 3 byte 1) */
/* in: pointer to cache struct of page data */
/* out: 18 bit triplet data, <0 if invalid number, not cached, or hamming error */
int tuxtxt_iTripletNumber2Data(int iONr, tstCachedPage *pstCachedPage, unsigned char* pagedata)
{
	if (iONr > 506 || 0 == pstCachedPage)
		return -1;

	unsigned char *p;
	int packet = (iONr / 13) + 3;
	int packetoffset = 3 * (iONr % 13);

fprintf(stderr, "%s\n", __func__);

	if (packet <= 23)
		p = pagedata + 40*(packet-1) + packetoffset + 1;
	else if (packet <= 25)
	{
		if (0 == pstCachedPage->pageinfo.p24)
			return -1;
		p = pstCachedPage->pageinfo.p24 + 40*(packet-24) + packetoffset + 1;
	}
	else
	{
		int descode = packet - 26;
		if (0 == pstCachedPage->pageinfo.ext)
			return -1;
		if (0 == pstCachedPage->pageinfo.ext->p26[descode])
			return -1;
		p = pstCachedPage->pageinfo.ext->p26[descode] + packetoffset;	/* first byte (=designation code) is not cached */
	}
	return deh24(p);
}

#define RowAddress2Row(row) ((row == 40) ? 24 : (row - 40))

/* dump interpreted object data to stdout */
/* in: 18 bit object data */
/* out: termination info, >0 if end of object */
void tuxtxt_eval_object(int iONr, tstCachedPage *pstCachedPage,
					  unsigned char *pAPx, unsigned char *pAPy,
					  unsigned char *pAPx0, unsigned char *pAPy0,
					  tObjType ObjType, unsigned char* pagedata, unsigned char* page_char, tstPageAttr* page_atrb)
{
	int iOData;
	int iONr1 = iONr + 1; /* don't terminate after first triplet */
	unsigned char drcssubp=0, gdrcssubp=0;
	signed char endcol = -1; /* last column to which to extend attribute changes */
	tstPageAttr attrPassive = { white  , black , C_G0P, 0, 0, 1 ,0, 0, 0, 0, 0, 0, 0, 0x3f}; /* current attribute for passive objects */

fprintf(stderr, "%s\n", __func__);
	do
	{
		iOData = tuxtxt_iTripletNumber2Data(iONr, pstCachedPage,pagedata);	/* get triplet data, next triplet */
		if (iOData < 0) /* invalid number, not cached, or hamming error: terminate */
			break;

		if (endcol < 0)
		{
			if (ObjType == OBJ_ACTIVE)
			{
				endcol = 40;
			}
			else if (ObjType == OBJ_ADAPTIVE) /* search end of line */
			{
				int i;
				for (i = iONr; i <= 506; i++)
				{
					int iTempOData = tuxtxt_iTripletNumber2Data(i, pstCachedPage,pagedata); /* get triplet data, next triplet */
					int iAddress = (iTempOData      ) & 0x3f;
					int iMode    = (iTempOData >>  6) & 0x1f;
					//int iData    = (iTempOData >> 11) & 0x7f;
					if (iTempOData < 0 || /* invalid number, not cached, or hamming error: terminate */
						 (iAddress >= 40	/* new row: row address and */
						 && (iMode == 0x01 || /* Full Row Color or */
							  iMode == 0x04 || /* Set Active Position */
							  (iMode >= 0x15 && iMode <= 0x17) || /* Object Definition */
							  iMode == 0x17))) /* Object Termination */
						break;
					if (iAddress < 40 && iMode != 0x06)
						endcol = iAddress;
				}

			}
		}
		iONr++;
	}
	while (0 == tuxtxt_eval_triplet(iOData, pstCachedPage, pAPx, pAPy, pAPx0, pAPy0, &drcssubp, &gdrcssubp, &endcol, &attrPassive, pagedata, page_char, page_atrb)
			 || iONr1 == iONr); /* repeat until termination reached */
}

void tuxtxt_eval_NumberedObject(int p, int s, int packet, int triplet, int high,
								 unsigned char *pAPx, unsigned char *pAPy,
								 unsigned char *pAPx0, unsigned char *pAPy0, unsigned char* page_char, tstPageAttr* page_atrb)
{
fprintf(stderr, "%s\n", __func__);
	if (!packet || 0 == tuxtxt_cache.astCachetable[p][s])
		return;
	unsigned char pagedata[23*40];
	tuxtxt_decompress_page(p, s,pagedata);


	int idata = deh24(pagedata + 40*(packet-1) + 1 + 3*triplet);
	int iONr;

	if (idata < 0)	/* hamming error: ignore triplet */
		return;
	if (high)
		iONr = idata >> 9; /* triplet number of odd object data */
	else
		iONr = idata & 0x1ff; /* triplet number of even object data */
	if (iONr <= 506)
	{

		tuxtxt_eval_object(iONr, tuxtxt_cache.astCachetable[p][s], pAPx, pAPy, pAPx0, pAPy0, (tObjType)(triplet % 3),pagedata, page_char, page_atrb);
	}
}

int tuxtxt_eval_triplet(int iOData, tstCachedPage *pstCachedPage,
					  unsigned char *pAPx, unsigned char *pAPy,
					  unsigned char *pAPx0, unsigned char *pAPy0,
					  unsigned char *drcssubp, unsigned char *gdrcssubp,
					  signed char *endcol, tstPageAttr *attrPassive, unsigned char* pagedata, unsigned char* page_char, tstPageAttr* page_atrb)
{
	int iAddress = (iOData      ) & 0x3f;
	int iMode    = (iOData >>  6) & 0x1f;
	int iData    = (iOData >> 11) & 0x7f;

fprintf(stderr, "%s\n", __func__);

	if (iAddress < 40) /* column addresses */
	{
		int offset;	/* offset to page_char and page_atrb */

		if (iMode != 0x06)
			*pAPx = iAddress;	/* new Active Column */
		offset = (*pAPy0 + *pAPy) * 40 + *pAPx0 + *pAPx;	/* offset to page_char and page_atrb */


		switch (iMode)
		{
		case 0x00:
			if (0 == (iData>>5))
			{
				int newcolor = iData & 0x1f;
				if (*endcol < 0) /* passive object */
					attrPassive->fg = newcolor;
				else if (*endcol == 40) /* active object */
				{
					tstPageAttr *p = &page_atrb[offset];
					int oldcolor = (p)->fg; /* current color (set-after) */
					int c = *pAPx0 + *pAPx;	/* current column absolute */
					do
					{
						p->fg = newcolor;
						p++;
						c++;
					} while (c < 40 && p->fg == oldcolor);	/* stop at change by level 1 page */
				}
				else /* adaptive object */
				{
					tstPageAttr *p = &page_atrb[offset];
					int c = *pAPx;	/* current column relative to object origin */
					do
					{
						p->fg = newcolor;
						p++;
						c++;
					} while (c <= *endcol);
				}

			}
			break;
		case 0x01:
			if (iData >= 0x20)
			{

				page_char[offset] = iData;
				if (*endcol < 0) /* passive object */
				{
					attrPassive->charset = C_G1C; /* FIXME: separated? */
					page_atrb[offset] = *attrPassive;
				}
				else if (page_atrb[offset].charset != C_G1S)
					page_atrb[offset].charset = C_G1C; /* FIXME: separated? */
			}
			break;
		case 0x02:
		case 0x0b:

			page_char[offset] = iData;
			if (*endcol < 0) /* passive object */
			{
				attrPassive->charset = C_G3;
				page_atrb[offset] = *attrPassive;
			}
			else
				page_atrb[offset].charset = C_G3;
			break;
		case 0x03:
			if (0 == (iData>>5))
			{
				int newcolor = iData & 0x1f;
				if (*endcol < 0) /* passive object */
					attrPassive->bg = newcolor;
				else if (*endcol == 40) /* active object */
				{
					tstPageAttr *p = &page_atrb[offset];
					int oldcolor = (p)->bg; /* current color (set-after) */
					int c = *pAPx0 + *pAPx;	/* current column absolute */
					do
					{
						p->bg = newcolor;
						if (newcolor == black)
							p->IgnoreAtBlackBgSubst = 1;
						p++;
						c++;
					} while (c < 40 && p->bg == oldcolor);	/* stop at change by level 1 page */
				}
				else /* adaptive object */
				{
					tstPageAttr *p = &page_atrb[offset];
					int c = *pAPx;	/* current column relative to object origin */
					do
					{
						p->bg = newcolor;
						if (newcolor == black)
							p->IgnoreAtBlackBgSubst = 1;
						p++;
						c++;
					} while (c <= *endcol);
				}

			}
			break;
		case 0x06:

			/* ignore */
			break;
		case 0x07:

			if ((iData & 0x60) != 0) break; // reserved data field
			if (*endcol < 0) /* passive object */
			{
				attrPassive->flashing=iData & 0x1f;
				page_atrb[offset] = *attrPassive;
			}
			else
				page_atrb[offset].flashing=iData & 0x1f;
			break;
		case 0x08:

			if (*endcol < 0) /* passive object */
			{
				attrPassive->setG0G2=iData & 0x3f;
				page_atrb[offset] = *attrPassive;
			}
			else
				page_atrb[offset].setG0G2=iData & 0x3f;
			break;
		case 0x09:

			page_char[offset] = iData;
			if (*endcol < 0) /* passive object */
			{
				attrPassive->charset = C_G0P; /* FIXME: secondary? */
				attrPassive->setX26  = 1;
				page_atrb[offset] = *attrPassive;
			}
			else
			{
				page_atrb[offset].charset = C_G0P; /* FIXME: secondary? */
				page_atrb[offset].setX26  = 1;
			}
			break;
//		case 0x0b: (see 0x02)
		case 0x0c:
		{

			int conc = (iData & 0x04);
			int inv  = (iData & 0x10);
			int dw   = (iData & 0x40 ?1:0);
			int dh   = (iData & 0x01 ?1:0);
			int sep  = (iData & 0x20);
			int bw   = (iData & 0x02 ?1:0);
			if (*endcol < 0) /* passive object */
			{
				if (conc)
				{
					attrPassive->concealed = 1;
					attrPassive->fg = attrPassive->bg;
				}
				attrPassive->inverted = (inv ? 1- attrPassive->inverted : 0);
				attrPassive->doubleh = dh;
				attrPassive->doublew = dw;
				attrPassive->boxwin = bw;
				if (bw) attrPassive->IgnoreAtBlackBgSubst = 0;
				if (sep)
				{
					if (attrPassive->charset == C_G1C)
						attrPassive->charset = C_G1S;
					else
						attrPassive->underline = 1;
				}
				else
				{
					if (attrPassive->charset == C_G1S)
						attrPassive->charset = C_G1C;
					else
						attrPassive->underline = 0;
				}
			}
			else
			{

				int c = *pAPx0 + (*endcol == 40 ? *pAPx : 0);	/* current column */
				int c1 = offset;
				tstPageAttr *p = &page_atrb[offset];
				do
				{
					p->inverted = (inv ? 1- p->inverted : 0);
					if (conc)
					{
						p->concealed = 1;
						p->fg = p->bg;
					}
					if (sep)
					{
						if (p->charset == C_G1C)
							p->charset = C_G1S;
						else
							p->underline = 1;
					}
					else
					{
						if (p->charset == C_G1S)
							p->charset = C_G1C;
						else
							p->underline = 0;
					}
					p->doublew = dw;
					p->doubleh = dh;
					p->boxwin = bw;
					if (bw) p->IgnoreAtBlackBgSubst = 0;
					p++;
					c++;
					c1++;
				} while (c < *endcol);
			}
			break;
		}
		case 0x0d:

			page_char[offset] = iData & 0x3f;
			if (*endcol < 0) /* passive object */
			{
				attrPassive->charset = C_OFFSET_DRCS + ((iData & 0x40) ? (0x10 + *drcssubp) : *gdrcssubp);
				page_atrb[offset] = *attrPassive;
			}
			else
				page_atrb[offset].charset = C_OFFSET_DRCS + ((iData & 0x40) ? (0x10 + *drcssubp) : *gdrcssubp);
			break;
		case 0x0f:

			page_char[offset] = iData;
			if (*endcol < 0) /* passive object */
			{
				attrPassive->charset = C_G2;
				page_atrb[offset] = *attrPassive;
			}
			else
				page_atrb[offset].charset = C_G2;
			break;
		default:
			if (iMode == 0x10 && iData == 0x2a)
				iData = '@';
			if (iMode >= 0x10)
			{

				page_char[offset] = iData;
				if (*endcol < 0) /* passive object */
				{
					attrPassive->charset = C_G0P;
					attrPassive->diacrit = iMode & 0x0f;
					attrPassive->setX26  = 1;
					page_atrb[offset] = *attrPassive;
				}
				else
				{
					page_atrb[offset].charset = C_G0P;
					page_atrb[offset].diacrit = iMode & 0x0f;
					page_atrb[offset].setX26  = 1;
				}
			}
			break; /* unsupported or not yet implemented mode: ignore */
		} /* switch (iMode) */
	}
	else /* ================= (iAddress >= 40): row addresses ====================== */
	{

		switch (iMode)
		{
		case 0x00:
			if (0 == (iData>>5))
			{

				tuxtxt_cache.FullScrColor = iData & 0x1f;
			}
			break;
		case 0x01:
			if (*endcol == 40) /* active object */
			{
				*pAPy = RowAddress2Row(iAddress);	/* new Active Row */

				int color = iData & 0x1f;
				int row = *pAPy0 + *pAPy;
				int maxrow;

				if (row <= 24 && 0 == (iData>>5))
					maxrow = row;
				else if (3 == (iData>>5))
					maxrow = 24;
				else
					maxrow = -1;
				for (; row <= maxrow; row++)
					tuxtxt_cache.FullRowColor[row] = color;
				*endcol = -1;
			}
			break;
		case 0x04:

			*pAPy = RowAddress2Row(iAddress); /* new Active Row */
			if (iData < 40)
				*pAPx = iData;	/* new Active Column */
			*endcol = -1; /* FIXME: check if row changed? */
			break;
		case 0x07:

			if (iAddress == 0x3f)
			{
				*pAPx = *pAPy = 0; /* new Active Position 0,0 */
				if (*endcol == 40) /* active object */
				{
					int color = iData & 0x1f;
					int row = *pAPy0; // + *pAPy;
					int maxrow;

					if (row <= 24 && 0 == (iData>>5))
						maxrow = row;
					else if (3 == (iData>>5))
						maxrow = 24;
					else
						maxrow = -1;
					for (; row <= maxrow; row++)
						tuxtxt_cache.FullRowColor[row] = color;
				}
				*endcol = -1;
			}
			break;
		case 0x08:
		case 0x09:
		case 0x0a:
		case 0x0b:
		case 0x0c:
		case 0x0d:
		case 0x0e:
		case 0x0f:

			/* ignore */
			break;
		case 0x10:

			tuxtxt_cache.tAPy = iAddress - 40;
			tuxtxt_cache.tAPx = iData;
			break;
		case 0x11:
		case 0x12:
		case 0x13:
			if (iAddress & 0x10)	/* POP or GPOP */
			{
				unsigned char APx = 0, APy = 0;
				unsigned char APx0 = *pAPx0 + *pAPx + tuxtxt_cache.tAPx, APy0 = *pAPy0 + *pAPy + tuxtxt_cache.tAPy;
				int triplet = 3 * ((iData >> 5) & 0x03) + (iMode & 0x03);
				int packet = (iAddress & 0x03) + 1;
				int subp = iData & 0x0f;
				int high = (iData >> 4) & 0x01;


				if (APx0 < 40) /* not in side panel */
				{

					tuxtxt_eval_NumberedObject((iAddress & 0x08) ? tuxtxt_cache.gpop : tuxtxt_cache.pop, subp, packet, triplet, high, &APx, &APy, &APx0, &APy0, page_char,page_atrb);

				}

			}
			else if (iAddress & 0x08)	/* local: eval invoked object */
			{
				unsigned char APx = 0, APy = 0;
				unsigned char APx0 = *pAPx0 + *pAPx + tuxtxt_cache.tAPx, APy0 = *pAPy0 + *pAPy + tuxtxt_cache.tAPy;
				int descode = ((iAddress & 0x01) << 3) | (iData >> 4);
				int triplet = iData & 0x0f;

				if (APx0 < 40) /* not in side panel */
				{

					tuxtxt_eval_object(13 * 23 + 13 * descode + triplet, pstCachedPage, &APx, &APy, &APx0, &APy0, (tObjType)(triplet % 3), pagedata, page_char, page_atrb);

				}

			}
			break;
		case 0x15:
		case 0x16:
		case 0x17:
			if (0 == (iAddress & 0x08))	/* Object Definition illegal or only level 3.5 */
				break; /* ignore */

			tuxtxt_cache.tAPx = tuxtxt_cache.tAPy = 0;
			*endcol = -1;
			return 0xFF; /* termination by object definition */
			break;
		case 0x18:
			if (0 == (iData & 0x10)) /* DRCS Mode reserved or only level 3.5 */
				break; /* ignore */

			if (iData & 0x40)
				*drcssubp = iData & 0x0f;
			else
				*gdrcssubp = iData & 0x0f;
			break;
		case 0x1f:

			tuxtxt_cache.tAPx = tuxtxt_cache.tAPy = 0;
			*endcol = -1;
			return 0x80 | iData; /* explicit termination */
			break;
		default:
			break; /* unsupported or not yet implemented mode: ignore */
		} /* switch (iMode) */
	} /* (iAddress >= 40): row addresses */

	if (iAddress < 40 || iMode != 0x10) /* leave temp. AP-Offset unchanged only immediately after definition */
		tuxtxt_cache.tAPx = tuxtxt_cache.tAPy = 0;


	return 0; /* normal exit, no termination */
}
#endif
