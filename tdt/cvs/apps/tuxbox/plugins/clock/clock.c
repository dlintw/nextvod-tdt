/*
 * $Id: clock.c,v 1.1 2009/12/30 22:33:29 rhabarber1848 Exp $
 *
 * clock - d-box2 linux project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
*/

#include <string.h>
#include <stdio.h>
#include <time.h>
#include "clock.h"
#include "text.h"
#include "gfx.h"

extern int FSIZE_BIG;
extern int FSIZE_MED;
extern int FSIZE_SMALL;

unsigned char FONT[64]= "/share/fonts/pakenham.ttf";
#define NCF_FILE "/var/tuxbox/config/neutrino.conf"
#define CFG_FILE "/var/tuxbox/config/clock.conf"
#define MAIL_FILE "/tmp/tuxmail.new"
//#define CFG_FILE "/tmp/clock.conf"


#define CL_VERSION  "0.13"

static char menucoltxt[CMH][24]={"Content_Selected_Text","Content_Selected","Content_Text","Content","Content_inactive_Text","inactive","Head_Text","Head"};

//					   CMCST,   CMCS,    CMCT,    CMC,     CMCIT,   CMCI,    CMHT,    CMH	
//					   WHITE,   BLUE0,   TRANSP,  FLASH,   ORANGE,  GREEN,   YELLOW,  RED
unsigned short rd[] = {0x00<<8, 0x32<<8, 0xc8<<8, 0x00<<8, 0x6e<<8, 0x00<<8, 0xbe<<8, 0x00<<8,
					   0xFF<<8, 0x00<<8, 0x00<<8, 0xFF<<8, 0xFF<<8, 0x00<<8, 0x7F<<8, 0x7F<<8};
unsigned short gn[] = {0x00<<8, 0x6e<<8, 0xc8<<8, 0x1e<<8, 0x8c<<8, 0x00<<8, 0x8c<<8, 0x14<<8,
					   0xFF<<8, 0x80<<8, 0x00<<8, 0xFF<<8, 0xC0<<8, 0x7F<<8, 0x7F<<8, 0x00<<8};
unsigned short bl[] = {0x00<<8, 0xc8<<8, 0xc8<<8, 0x46<<8, 0xaa<<8, 0x80<<8, 0x00<<8, 0x32<<8, 
					   0xFF<<8, 0xFF<<8, 0x80<<8, 0xFF<<8, 0x00<<8, 0x00<<8, 0x00<<8, 0x00<<8};
unsigned short tr[] = {0x00<<8, 0x14<<8, 0x00<<8, 0x14<<8, 0x00<<8, 0x0a<<8, 0x00<<8, 0x00<<8,
					   0x0000,  0x0A00,  0x0000,  0x0000,  0x0000,  0x0000,  0x0000,  0x0000 };
					   
unsigned short ord[256], ogn[256], obl[256], otr[256];

struct fb_cmap colormap = {0, 256, ord, ogn, obl, otr};


unsigned char *lfb = 0, *lbb = 0;
char tstr[512];
int xpos=540,ypos=0,sdat=0,big=0,secs=1, fcol=2, bcol=1, mail=0;

int ExistFile(char *fname)
{
FILE *efh;

	if((efh=fopen(fname,"r"))==NULL)
	{
		return 0;
	}
	fclose(efh);
	return 1;
}

void TrimString(char *strg)
{
char *pt1=strg, *pt2=strg;

	while(*pt2 && *pt2<=' ')
	{
		++pt2;
	}
	if(pt1 != pt2)
	{
		do
		{
			*pt1=*pt2;
			++pt1;
			++pt2;
		}
		while(*pt2);
		*pt1=0;
	}
	while(strlen(strg) && strg[strlen(strg)-1]<=' ')
	{
		strg[strlen(strg)-1]=0;
	}
}

int ReadConf()
{
	FILE *fd_conf;
	char *cptr;

	//open config

	if(!(fd_conf = fopen(CFG_FILE, "r")))
	{
		return 0;
	}
	while(fgets(tstr, 511, fd_conf))
	{
		TrimString(tstr);
		if((tstr[0]) && (tstr[0]!='#') && (!isspace(tstr[0])) && ((cptr=strchr(tstr,'='))!=NULL))
		{
			if(strstr(tstr,"X") == tstr)
			{
				sscanf(cptr+1,"%d",&xpos);
			}
			if(strstr(tstr,"Y=") == tstr)
			{
				sscanf(cptr+1,"%d",&ypos);
			}
			if(strstr(tstr,"DATE=") == tstr)
			{
				sscanf(cptr+1,"%d",&sdat);
			}
			if(strstr(tstr,"BIG=") == tstr)
			{
				sscanf(cptr+1,"%d",&big);
			}
			if(strstr(tstr,"SEC=") == tstr)
			{
				sscanf(cptr+1,"%d",&secs);
			}
			if(strstr(tstr,"FCOL=") == tstr)
			{
				sscanf(cptr+1,"%d",&fcol);
			}
			if(strstr(tstr,"BCOL=") == tstr)
			{
				sscanf(cptr+1,"%d",&bcol);
			}
			if(strstr(tstr,"MAIL=") == tstr)
			{
				sscanf(cptr+1,"%d",&mail);
			}
		}
	}
	return 1;
}

int Read_Neutrino_Cfg(char *entry)
{
FILE *nfh;
char tstr [512], *cfptr=NULL;
int rv=-1;

	if((nfh=fopen(NCF_FILE,"r"))!=NULL)
	{
		tstr[0]=0;

		while((!feof(nfh)) && ((strstr(tstr,entry)==NULL) || ((cfptr=strchr(tstr,'='))==NULL)))
		{
			fgets(tstr,500,nfh);
		}
		if(!feof(nfh) && cfptr)
		{
			++cfptr;
			if(sscanf(cfptr,"%d",&rv)!=1)
			{
				rv=-1;
			}
//			printf("%s\n%s=%s -> %d\n",tstr,entry,cfptr,rv);
		}
		fclose(nfh);
	}
	return rv;
}

/******************************************************************************
 * Clock Main
 ******************************************************************************/

int main (int argc, char **argv)
{
	int tv,index,i,j,k,w,cmct=CMCT,cmc=CMC,trnspi=TRANSP,trnsp=0,found,loop=1,x0,x1,x2,x3,x4,x5,x6,x7,ms,mw,newmail=0;
	time_t atim;
	struct tm *ltim;
	char *aptr,*rptr;
	char dstr[2]={0,0};
	FILE *tfh;

		printf("Clock Version %s\n",CL_VERSION);
		
		ReadConf();
	
		for(i=1; i<argc; i++)
		{
			aptr=argv[i];
			if((rptr=strchr(aptr,'='))!=NULL)
			{
				rptr++;
				if(strstr(aptr,"X=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						xpos=j;
					}
				}
				if(strstr(aptr,"Y=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						ypos=j;
					}
				}
				if(strstr(aptr,"DATE=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						sdat=j;
					}
				}
				if(strstr(aptr,"BIG=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						big=j;
					}
				}
				if(strstr(aptr,"SEC=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						secs=j;
					}
				}
				if(strstr(aptr,"FCOL=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						fcol=j;
					}
				}
				if(strstr(aptr,"BCOL=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						bcol=j;
					}
				}
				if(strstr(aptr,"MAIL=")!=NULL)
				{
					if(sscanf(rptr,"%d",&j)==1)
					{
						mail=j;
					}
				}
			}
		}
		if((sx=Read_Neutrino_Cfg("screen_StartX"))<0)
			sx=80;
		
		if((ex=Read_Neutrino_Cfg("screen_EndX"))<0)
			ex=620;

		if((sy=Read_Neutrino_Cfg("screen_StartY"))<0)
			sy=80;

		if((ey=Read_Neutrino_Cfg("screen_EndY"))<0)
			ey=505;
			
		for(index=CMCST; index<=CMH; index++)
		{
			sprintf(tstr,"menu_%s_alpha",menucoltxt[index-1]);
			if((tv=Read_Neutrino_Cfg(tstr))>=0)
				tr[index-1]=(tv<<8);

			sprintf(tstr,"menu_%s_blue",menucoltxt[index-1]);
			if((tv=Read_Neutrino_Cfg(tstr))>=0)
				bl[index-1]=(tv+(tv<<8));

			sprintf(tstr,"menu_%s_green",menucoltxt[index-1]);
			if((tv=Read_Neutrino_Cfg(tstr))>=0)
				gn[index-1]=(tv+(tv<<8));

			sprintf(tstr,"menu_%s_red",menucoltxt[index-1]);
			if((tv=Read_Neutrino_Cfg(tstr))>=0)
				rd[index-1]=(tv+(tv<<8));
		}
		
		fb = open(FB_DEVICE, O_RDWR);

		if(ioctl(fb, FBIOGET_FSCREENINFO, &fix_screeninfo) == -1)
		{
			printf("Clock <FBIOGET_FSCREENINFO failed>\n");
			return -1;
		}
		if(ioctl(fb, FBIOGET_VSCREENINFO, &var_screeninfo) == -1)
		{
			printf("Clock <FBIOGET_VSCREENINFO failed>\n");
			return -1;
		}
		
		if(ioctl(fb, FBIOGETCMAP, &colormap) == -1)
		{
			printf("Clock <FBIOGETCMAP failed>\n");
			return -1;
		}

		if(!(lfb = (unsigned char*)mmap(0, fix_screeninfo.smem_len, PROT_READ | PROT_WRITE, MAP_SHARED, fb, 0)))
		{
			printf("Clock <mapping of Framebuffer failed>\n");
			return -1;
		}

	//init fontlibrary

		if((error = FT_Init_FreeType(&library)))
		{
			printf("Clock <FT_Init_FreeType failed with Errorcode 0x%.2X>", error);
			munmap(lfb, fix_screeninfo.smem_len);
			return -1;
		}

		if((error = FTC_Manager_New(library, 1, 2, 0, &MyFaceRequester, NULL, &manager)))
		{
			printf("Clock <FTC_Manager_New failed with Errorcode 0x%.2X>\n", error);
			FT_Done_FreeType(library);
			munmap(lfb, fix_screeninfo.smem_len);
			return -1;
		}

		if((error = FTC_SBitCache_New(manager, &cache)))
		{
			printf("Clock <FTC_SBitCache_New failed with Errorcode 0x%.2X>\n", error);
			FTC_Manager_Done(manager);
			FT_Done_FreeType(library);
			munmap(lfb, fix_screeninfo.smem_len);
			return -1;
		}

		if((error = FTC_Manager_Lookup_Face(manager, FONT, &face)))
		{
			printf("Clock <FTC_Manager_Lookup_Face failed with Errorcode 0x%.2X>\n", error);
			FTC_Manager_Done(manager);
			FT_Done_FreeType(library);
			munmap(lfb, fix_screeninfo.smem_len);
			return -1;
		}

		use_kerning = FT_HAS_KERNING(face);

#ifdef FT_NEW_CACHE_API
		desc.face_id = FONT;
#else
		desc.font.face_id = FONT;
#endif
#if FREETYPE_MAJOR  == 2 && FREETYPE_MINOR == 0
		desc.image_type = ftc_image_mono;
#else
		desc.flags = FT_LOAD_MONOCHROME;
#endif

	//init backbuffer

		if(!(lbb = malloc(var_screeninfo.xres*var_screeninfo.yres)))
		{
			printf("Clock <allocating of Backbuffer failed>\n");
			FTC_Manager_Done(manager);
			FT_Done_FreeType(library);
			munmap(lfb, fix_screeninfo.smem_len);
			return -1;
		}

		memset(lbb, 0, var_screeninfo.xres*var_screeninfo.yres);

		startx = sx;
		starty = sy;
		mw=(big)?40:30;

	while(loop)
	{
		usleep(150000L);
		newmail=0;
		if(mail && ExistFile(MAIL_FILE))
		{
			if((tfh=fopen(MAIL_FILE,"r"))!=NULL)
			{
				if(fgets(tstr,511,tfh))
				{
					if(sscanf(tstr,"%d",&i))
					{
						newmail=i;
					}
				}
				fclose(tfh);
			}
		}
		ioctl(fb, FBIOGETCMAP, &colormap);
		found=0;
		trnsp=0;
		for(i=colormap.start;i<colormap.len && found!=7;i++)
		{
			if(!colormap.red[i] && !colormap.green[i] && !colormap.blue[i] && !colormap.transp[i])
			{
				cmc=i;
				found|=1;
			}
			if(colormap.red[i]>=0xF000 && colormap.green[i]>=0xF000  && colormap.blue[i]>=0xF000 && !colormap.transp[i])
			{
				cmct=i;
				found|=2;
			}
			if(colormap.transp[i]>trnsp)
			{
				trnspi=i;
				trnsp=colormap.transp[i];
				found|=4;
			}
		}	

		if(big)
		{
			x0=3;
			x1=14;
			x2=26;
			x3=BIG;
			x4=30;
			x5=60;
		}
		else
		{
			x0=7;
			x1=12;
			x2=18;
			x3=MED;
			x4=18;
			x5=40;
		}
		x6=0;
		x7=0;
		time(&atim);
		ltim=localtime(&atim);
		if(secs)
		{
			sprintf(tstr,"%02d:%02d:%02d",ltim->tm_hour,ltim->tm_min,ltim->tm_sec);
		}
		else
		{
			sprintf(tstr,"   %02d%c%02d",ltim->tm_hour,(ltim->tm_sec & 1)?':':' ',ltim->tm_min);
			if(!sdat)
			{
				x6=3;
				x7=36+4*big;
			}
		}
		if((xpos>=mw)||(!secs))
		{
			ms=xpos+((secs)?0:36+4*big)-mw;
		}
		else
		{
			ms=xpos+100+20*big;
		}
		k=((ms>xpos)&&mail)?mw:0;
		RenderBox(xpos+x7, ypos, xpos+x7+100+20*big, ypos+x2+2*(1+big), FILL, (bcol==0)?trnspi:((bcol==1)?cmc:cmct));
		for(i=x6; i<strlen(tstr); i++)
		{
			*dstr=tstr[i];
			RenderString(dstr, xpos-x0+(i*x1), ypos+x2, 30, CENTER, x3, (fcol==0)?trnspi:((fcol==2)?cmct:cmc));
		}

		if(sdat)
		{
			sprintf(tstr,"%02d.%02d.%02d",ltim->tm_mday,ltim->tm_mon+1,ltim->tm_year-100);
			RenderBox(xpos, ypos+x4, xpos+100+20*big, ypos+x5, FILL, (bcol==0)?trnspi:((bcol==1)?cmc:cmct));
			for(i=0; i<strlen(tstr); i++)
			{
				*dstr=tstr[i];
				RenderString(dstr, xpos-x0+(i*x1), ypos+x5-2-2*big, 30, CENTER, x3, (fcol==0)?trnspi:((fcol==2)?cmct:cmc));
			}
		}
		if(mail)
		{
			if(newmail)
			{
				RenderBox(ms, ypos, ms+mw, ypos+x2+2*(1+big), FILL, (bcol==0)?trnspi:((bcol==1)?cmc:cmct));
				if(!(ltim->tm_sec & 1))
				{
					RenderBox(ms+5, ypos+5+(1+big), ms+mw-5, ypos+x2+(1+big)-2, GRID, (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+5, ypos+5+(1+big), ms+mw-5, ypos+x2+(1+big)-2, (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+5, ypos+x2+(1+big)-2, ms+mw-5, ypos+5+(1+big), (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+5, ypos+5+(1+big), ms+((mw-2)/2), ypos+2, (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+6, ypos+6+(1+big), ms+((mw-2)/2)+1, ypos+3, (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+((mw-2)/2), ypos+2, ms+mw-5, ypos+5+(1+big), (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
					DrawLine(ms+((mw-2)/2)+1, ypos+3, ms+mw-6, ypos+6+(1+big), (fcol==0)?trnspi:((fcol==1)?cmc:cmct));
				}
				else
				{
					sprintf(tstr,"%d",newmail);
					RenderString(tstr, ms, ypos+x2, mw, CENTER, x3, (fcol==0)?trnspi:((fcol==2)?cmct:cmc));
				}
			}
			else
			{
				if(!sdat || secs)
				{
					RenderBox(ms+((ms>(xpos+100))?1:0), ypos, ms+mw-((k)?0:1), ypos+x2+2*(1+big), FILL, trnspi);
				}
			}
		}
		else
		{
			ms=xpos;
		}
		
		w=100+20*big+((mail)?5*big+((secs)?mw:0):0)+k-((k&&!sdat)?mw:0);
		for(i=0;i<=((sdat)?40:20)*(1+big);i++)
		{
			j=(starty+ypos+i)*var_screeninfo.xres+((ms<xpos)?ms:xpos)+startx;
			if((j+w)<var_screeninfo.xres*var_screeninfo.yres)
			{
				memcpy(lfb+j, lbb+j, w);
			}
		}
		if(++loop>5)
		{
			if(ExistFile("/tmp/.clock_kill"))
			{
				loop=0;
			}
		}	
	}	

	cmct=0;
	cmc=0;
	for(i=colormap.start;i<colormap.len;i++)
	{
		if(colormap.transp[i]>cmct)
		{
			cmc=i;
			cmct=colormap.transp[i];
		}
	}
	memset(lbb, cmc, var_screeninfo.xres*var_screeninfo.yres);
	for(i=0;i<=((sdat)?40:20)*(1+big);i++)
	{
		j=(starty+ypos+i)*var_screeninfo.xres+((ms<xpos)?ms:xpos)+startx;
		if((j+100+20*big+((mail)?mw:0))<var_screeninfo.xres*var_screeninfo.yres)
		{
			memcpy(lfb+j, lbb+j, w);
		}
	}
	FTC_Manager_Done(manager);
	FT_Done_FreeType(library);

	free(lbb);
	munmap(lfb, fix_screeninfo.smem_len);

	close(fb);
	remove("/tmp/.clock_kill");
	return 0;
}

