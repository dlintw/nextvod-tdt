#ifndef DISABLE_HDD
#ifndef DISABLE_FILE
/*
 * setup_harddisk.cpp
 *
 * Copyright (C) 2002 Felix Domke <tmbinc@tuxbox.org>
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: setup_harddisk.cpp,v 1.28 2009/02/28 17:14:58 dbluelle Exp $
 */

#include <setup_harddisk.h>
#include <enigma.h>
#include <enigma_main.h>
#include <lib/gui/emessage.h>
#include <lib/gui/ebutton.h>
#include <lib/gui/combobox.h>
#include <lib/gui/emessage.h>
#include <lib/gui/statusbar.h>
#include <lib/dvb/epgcache.h>
#include <lib/system/info.h>
#include <sys/vfs.h> // for statfs
#include <unistd.h>
#include <signal.h>

static int getCapacity(int dev)
{
	FILE *f=fopen(eString().sprintf("/sys/block/sd%c/size", dev).c_str(), "r");
	if (!f)
		return -1;
	int capacity=-1;
	fscanf(f, "%d", &capacity);
	fclose(f);
	return capacity;
}

static eString getModel(int dev)
{
	char line[1024];

	FILE *f=fopen(eString().sprintf("/sys/block/sd%c/device/model", dev).c_str(), "r");
	if (!f)
		return "";
	*line=0;
	fgets(line, 1024, f);
	fclose(f);
	if (!*line)
		return "";
	line[strlen(line)-1]=0;
	return line;
}

static eString getVendor(int dev)
{
	char line[1024];

	FILE *f=fopen(eString().sprintf("/sys/block/sd%c/device/vendor",dev).c_str(), "r");
	if (!f)
		return "";
	*line=0;
	fgets(line, 1024, f);
	fclose(f);
	if (!*line)
		return "";
	line[strlen(line)-1]=0;
	return line;
}

int freeDiskspace(int dev, eString mp="")
{
	FILE *f=fopen("/proc/mounts", "rb");
	if (!f)
		return -1;
	eString path;

	path.sprintf("/dev/sd%c1", dev);

	while (1)
	{
		char line[1024];
		if (!fgets(line, 1024, f))
			break;
		if (!strncmp(line, path.c_str(), path.size()))
		{
			eString mountpoint=line;
			mountpoint=mountpoint.mid(mountpoint.find(' ')+1);
			mountpoint=mountpoint.left(mountpoint.find(' '));
//			eDebug("mountpoint: %s", mountpoint.c_str());
			if ( mp && mountpoint != mp )
				return -1;
			struct statfs s;
			int free;
			if (statfs(mountpoint.c_str(), &s)<0)
				free=-1;
			else
				free=s.f_bfree/1000*s.f_bsize/1000;
			fclose(f);
			return free;
		}
	}
	fclose(f);
	return -1;
}

static int numPartitions(int dev)
{
	eString path;
	int numpart;
	path.sprintf("ls /sys/block/sd%c > /tmp/tmp.out ", dev);
	system( path.c_str() );

	FILE *f=fopen("/tmp/tmp.out", "rb");
	if (!f)
	{
		eDebug("fopen failed");
		return -1;
		numpart= -1;
	
	} else 
		numpart = 0;

	while (1)
	{
		char line[1024];
		if (!fgets(line, 1024, f))
			break;
		if ( !strncmp(line, eString().sprintf("sd%c", dev).c_str(), 3))
			numpart++;

	}
	fclose(f);
	system("rm /tmp/tmp.out");
	return numpart;
}

extern eString resolvSymlinks(const eString &path);

eString getPartFS(int dev, eString mp="")
{
	FILE *f=fopen("/proc/mounts", "rb");
	if (!f)
		return "";
	eString path;
	path.sprintf("/dev/sd%c1", dev);

	eString tmp=resolvSymlinks(mp);

	while (1)
	{
		char line[1024];
		if (!fgets(line, 1024, f))
			break;

		if (!strncmp(line, path.c_str(), path.size()))
		{
			eString mountpoint=line;
			mountpoint=mountpoint.mid(mountpoint.find(' ')+1);
			mountpoint=mountpoint.left(mountpoint.find(' '));
//			eDebug("mountpoint: %s", mountpoint.c_str());
			if ( tmp && mountpoint != tmp )
				continue;

			eString fs=line;
			fs=fs.mid(fs.find(' ')+1);
			fs=fs.mid(fs.find(' ')+1);
			fs=fs.left(fs.find(' '));
			eString mpath=line;
			mpath=mpath.left(mpath.find(' '));
			mpath=mpath.mid(mpath.rfind('/')+1);
			fclose(f);
			return fs+','+mpath;
		}
	}
	fclose(f);
	return "";
}

eHarddiskSetup::eHarddiskSetup()
: eListBoxWindow<eListBoxEntryText>(_("Harddisk Setup"), 5, 540)
{
	init_eHarddiskSetup();
}
void eHarddiskSetup::init_eHarddiskSetup()
{
	nr=0;
	
	move(ePoint(80, 136));
	for (int c='a'; c<'h'; c++)	
	{
		int num= 0;				
                removable=1;				
		// check for presence
		char line[1024];
		int ok=1;
		FILE *f=fopen(eString().sprintf("/sys/block/sd%c/removable", c).c_str(), "r");
		if (!f)
			continue;
		if (!fgets(line, 1024, f)) 
			ok=0;
		if (strcmp(line, "0\n")==0)
		        removable=0;	
		fclose(f);

		if (ok)
		{
			int capacity=getCapacity(c);
			if (capacity < 0)
				continue;
						
			capacity=capacity/1000*512/1024;
//                      eDebug("[%s] c = %c removable = %d",__FUNCTION__, c, removable);
			eString sharddisks;
                        if (removable==1) 
			    sharddisks="Storage "+getModel(c)+getVendor(c);
			else
			    sharddisks="Harddisk "+getModel(c)+getVendor(c);
					        
			sharddisks+=" (";
			sharddisks+=eString().sprintf("sd%c", c );
			if (capacity <= 10000)
			    sharddisks+=eString().sprintf(" - %d MB", capacity );
			else
			    sharddisks+=eString().sprintf(" - %d GB", capacity/1000 );
			sharddisks+=")";
			
			nr++;
//			eDebug("[%s] nr = %d" ,__FUNCTION__, nr);
			new eListBoxEntryText(&list, sharddisks, (void*)c);
		}
	}
	
	CONNECT(list.selected, eHarddiskSetup::selectedHarddisk);
}

void eHarddiskSetup::selectedHarddisk(eListBoxEntryText *t)
{
	if ((!t) || (((int)t->getKey())==-1))
	{
		close(0);
		return;
	}
	int dev=(int)t->getKey();
	
	eHarddiskMenu menu(dev);
	
	hide();
	menu.show();
	menu.exec();
	menu.hide();
	show();
}

void eHarddiskMenu::check()
{
	hide();
	ePartitionCheck check(dev);
	check.show();
	check.exec();
	check.hide();
	show();
	restartNet=true;
}

void eHarddiskMenu::extPressed()
{
	if ( visible )
	{
		gPixmap *pm = eSkin::getActive()->queryImage("arrow_down");
		if (pm)
			ext->setPixmap( pm );
		fs->hide();
		lbltimeout->hide();
		lblacoustic->hide();
		timeout->hide();
		acoustic->hide();
		store->hide();
		sbar->hide();
		resize( getSize()-eSize( 0, 80) );
		sbar->move( sbar->getPosition()-ePoint(0,80) );
		sbar->show();
		eZap::getInstance()->getDesktop(eZap::desktopFB)->invalidate( eRect( getAbsolutePosition()+ePoint( 0, height() ), eSize( width(), 80 ) ));
		visible=0;
	}
	else
	{
		gPixmap *pm = eSkin::getActive()->queryImage("arrow_up");
		if (pm)
			ext->setPixmap( pm );
		sbar->hide();
		sbar->move( sbar->getPosition()+ePoint(0,80) );
		resize( getSize()+eSize( 0, 80) );
		sbar->show();
		fs->show();
	        if (!removable)
		{
    		    lbltimeout->show();
		    lblacoustic->show();
		    timeout->show();
		    acoustic->show();
		    store->show();
		}
		visible=1;
	}
}

void eHarddiskMenu::s_format()
{
	hide();

        removable=1;				
	// check for presence
	char line[1024];
	FILE *f=fopen(eString().sprintf("/sys/block/sd%c/removable", dev).c_str(), "r");
	if (!f)
		return ;
	else	
	    fgets(line, 1024, f);
	     
	if (strcmp(line, "0\n")==0)
	        removable=0;	
	fclose(f);

	do
	{
		{
			int res = eMessageBox::ShowBox(
				 _("Are you SURE that you want to format this disk?\n"),
				 _("formatting harddisk..."),
				 eMessageBox::btYes|eMessageBox::btCancel, eMessageBox::btCancel);
			if (res != eMessageBox::btYes)
				break;
		}
		if (numpart)
		{
			int res = eMessageBox::ShowBox(
				 _("There's data on this harddisk.\n"
				 "You will lose that data. Proceed?"),
				 _("formatting harddisk..."),
				 eMessageBox::btYes|eMessageBox::btNo, eMessageBox::btNo);
			if (res != eMessageBox::btYes)
				break;
		}

// kill samba server... (exporting /hdd)
		system("killall -9 smbd nmbd");
		system("/bin/umount -l /hdd");

		restartNet=true;
		system(
				eString().sprintf(
				"/bin/umount -l /dev/sd%c1", dev).c_str());
		eMessageBox msg(
			_("please wait while initializing harddisk.\nThis might take some minutes.\n"),
			_("formatting harddisk..."), 0);
		msg.show();
		

		int capacity=getCapacity(dev);
//		eDebug("capacity = %d", capacity);


		FILE *f=popen(
				eString().sprintf(
				"/sbin/sfdisk -f -uM /dev/sd%c",dev).c_str(), "w");
		if (!f)
		{
			eMessageBox msg(
				_("sorry, couldn't find sfdisk utility to partition harddisk."),
				_("formatting harddisk..."),
				 eMessageBox::btOK|eMessageBox::iconError);
			msg.show();
			msg.exec();
			msg.hide();
			break;
		}
                if ( !fs->getCurrent()->getKey() )
		    fprintf(f,"0,1024,c,\n;\n;\n;\ny\n");
		else    
            	    fprintf(f,"0,\n;\n;\n;\ny\n");

		fclose(f);

/*Set up Swapspace*/
		system(eString().sprintf("/sbin/mkswap /dev/sd%c1",dev).c_str());

#if ENABLE_REISERFS
		if ( !fs->getCurrent()->getKey() )  // reiserfs
		{
			::sync();
			if ( system( eString().sprintf(
					"/sbin/mkreiserfs -f /dev/sd%c",dev).c_str())>>8)
				goto err;
			::sync();
			if ( system( eString().sprintf(
					"/bin/mount -t reiserfs /dev/sd%d1 /hdd",dev).c_str())>>8)
				goto err;
			::sync();
			if ( system("mkdir /hdd/movie")>>8 )
				goto err;
			::sync();
			goto noerr;
		}
		else  
#endif
		
		if ( !fs->getCurrent()->getKey() ) //vfat
		{
//			eDebug("[%s] **** vfat", __FUNCTION__);
			::sync();
			if ( system( eString().sprintf(
				    "/sbin/mkfs.vfat /dev/sd%c1",dev).c_str())>>8)
				goto err;
			::sync();
			if ( system( eString().sprintf(
				    "/bin/mount -t vfat /dev/sd%c1 /mnt/sd%c",dev, dev).c_str())>>8)
				goto err;
			::sync();

		        if ( system( eString().sprintf(
		    		    "mkdir /mnt/sd%c/movie", dev).c_str())>>8 )
				goto err;
			::sync();
		
			goto noerr;
		}
		else  // ext3
		{
			::sync();
			if (removable==0){

				if ( system( eString().sprintf(
                            		"/sbin/mkfs.ext3 -T largefile -m0 /dev/sd%c1",dev).c_str())>>8)
				goto err;
				
			} else {	

				if ( system( eString().sprintf(
					"/sbin/mkfs.ext3 -i 1024 -b 1024 /dev/sd%c1", dev ).c_str())>>8)
				goto err;
			}	
	
			::sync();
			
			if (removable==0){
			
			    if ( system(eString().sprintf(
					"/bin/mount -t ext3 /dev/sd%c1 /mnt/sd%c", dev, dev).c_str())>>8)
 	    			goto err;
				::sync();

				if ( system("mkdir /hdd/movie")>>8 )
				goto err;
				::sync();
			} else {
			
			    if ( system(eString().sprintf(
					"/bin/mount -t ext3 /dev/sd%c1 /mnt/sd%c", dev, dev).c_str())>>8)
				goto err;
				::sync();
				
			    if ( system(eString().sprintf(
					"mkdir /mnt/sd%c/movie", dev).c_str())>>8 )
				goto err;
				::sync();
                        }  
			goto noerr;
		}

err:
		{
			eMessageBox::ShowBox(
				_("creating filesystem failed."),
				_("formatting harddisk..."),
				 eMessageBox::btOK|eMessageBox::iconError);
			break;
		}
noerr:
		{
			eZapMain::getInstance()->clearRecordings();
			eMessageBox::ShowBox(
				_("successfully formatted your disk!"),
				_("formatting harddisk..."),
				 eMessageBox::btOK|eMessageBox::iconInfo);
		}
		readStatus();
	} while (0);
	show();
}

void eHarddiskMenu::readStatus()
{
	eString mod=getModel(dev);
	setText(mod);
	model->setText(mod);
	if (removable == 0 ){
		int cap=getCapacity(dev)/1000*512/1000;
		if (cap != -1)
		    capacity->setText(eString().sprintf("%d.%03d GB", cap/1024, cap%1024));

	} else if (removable == 1) {	
	        int cap=getCapacity(dev)/1000*512;
    		if (cap != -1)
		    capacity->setText(eString().sprintf("%d.%03d MB", cap/1024, cap%1024));
	}	

	if (freeDiskspace(dev) > 0)    
	         if (dev == 97)
			bus->setText(eString().sprintf("/hdd").c_str());
		 else
		        bus->setText(eString().sprintf("/mnt/sd%c", dev).c_str());  	
	else
	    	    bus->setText("no mount");

	numpart=numPartitions(dev);
	int fds;
	
	if (numpart == -1)
		status->setText(_("(error reading information)"));
	else if (!numpart)
		status->setText(_("uninitialized - format it to use!"));
	else if ((fds=freeDiskspace(dev)) != -1)
		status->setText(eString().sprintf(_("in use, %d.%03d GB (~%d minutes) free"), fds/1024, fds%1024, fds/33 ));
	else
		status->setText(_("initialized, but unknown filesystem"));
}
// Function to store settings
void eHarddiskMenu::storevalues()
{
	eConfig::getInstance()->setKey("/extras/hdparm-s", timeout->getNumber()*12);
	eConfig::getInstance()->setKey("/extras/hdparm-m", acoustic->getNumber());

	eMessageBox::ShowBox(_("The settings have been saved successfully"), _("Harddisk"),eMessageBox::btOK);
}

// Function to send HDD to standby immediately
void eHarddiskMenu::hddstandby()
{
	system(eString().sprintf("/sbin/hdparm -y /dev/sd%c", dev).c_str());
} 

eHarddiskMenu::eHarddiskMenu(int dev): dev(dev), restartNet(false)
{
	init_eHarddiskMenu();
}
void eHarddiskMenu::init_eHarddiskMenu()
{
	removable=1;				
	// check for presence
	char line[1024];
	FILE *f=fopen(eString().sprintf("/sys/block/sd%c/removable", dev).c_str(), "r");
	if (!f)
		return ;
	else	
	    fgets(line, 1024, f);
	     
	if (strcmp(line, "0\n")==0)
	        removable=0;	
	fclose(f);

	visible=0;
	status=new eLabel(this); status->setName("status");
	model=new eLabel(this); model->setName("model");
	capacity=new eLabel(this); capacity->setName("capacity");
	bus=new eLabel(this); bus->setName("bus");
	
	standby=new eButton(this); standby->setName("standby");
	format=new eButton(this); format->setName("format");
	bcheck=new eButton(this); bcheck->setName("check");
	ext=new eButton(this); ext->setName("ext");

	fs=new eComboBox(this,2); fs->setName("fs"); fs->hide();

	lbltimeout=new eLabel(this); lbltimeout->setName("lbltimeout");lbltimeout->hide();
	lblacoustic=new eLabel(this); lblacoustic->setName("lblacoustic");lblacoustic->hide();
	timeout=new eNumber(this,1,0, 20, 3, 0, 0); timeout->setName("timeout");timeout->hide();
	acoustic=new eNumber(this,1,0,254, 3, 0, 0); acoustic->setName("acoustic");acoustic->hide();
	store=new eButton(this); store->setName("store");store->hide();


	sbar = new eStatusBar(this); sbar->setName("statusbar");

	new eListBoxEntryText( *fs, ("ext3"), (void*) 1 );
	new eListBoxEntryText( *fs, ("vfat"), (void*) 0 );	
#ifdef ENABLE_REISERFS
	new eListBoxEntryText( *fs, ("reiserfs"), (void*) 0 );
#endif
	fs->setCurrent((void*)1);
  
	if (eSkin::getActive()->build(this, "eHarddiskMenu"))
		eFatal("skin load of \"eHarddiskMenu\" failed");

	gPixmap *pm = eSkin::getActive()->queryImage("arrow_down");
	if (pm)
	{
		eSize s = ext->getSize();
		ext->setPixmap( pm );
		ext->setPixmapPosition( ePoint(s.width()/2 - pm->x/2, s.height()/2 - pm->y/2) );
	}

	readStatus();

	int hddstandby = 60;
	if( (eConfig::getInstance()->getKey("/extras/hdparm-s", hddstandby)) )
		timeout->setNumber(hddstandby/12);
	else
		timeout->setNumber(hddstandby/12);

	int hddacoustic=128;
	if( (eConfig::getInstance()->getKey("/extras/hdparm-m", hddacoustic)) )
		acoustic->setNumber(hddacoustic);
	else
		acoustic->setNumber(hddacoustic);

	CONNECT(ext->selected, eHarddiskMenu::extPressed);
	CONNECT(format->selected, eHarddiskMenu::s_format);
	CONNECT(bcheck->selected, eHarddiskMenu::check);
	CONNECT(standby->selected, eHarddiskMenu::hddstandby);
	CONNECT(store->selected, eHarddiskMenu::storevalues);
}

ePartitionCheck::ePartitionCheck( int dev )
:eWindow(1), dev(dev), fsck(0)
{
	init_ePartitionCheck();
}
void ePartitionCheck::init_ePartitionCheck()
{
	lState = new eLabel(this);
	lState->setName("state");
	bClose = new eButton(this);
	bClose->setName("close");
	CONNECT( bClose->selected, ePartitionCheck::accept );
	if (eSkin::getActive()->build(this, "ePartitionCheck"))
		eFatal("skin load of \"ePartitionCheck\" failed");
	bClose->hide();
}

int ePartitionCheck::eventHandler( const eWidgetEvent &e )
{
	switch(e.type)
	{
		case eWidgetEvent::execBegin:
		{
			system("killall nmbd smbd");
			eEPGCache::getInstance()->messages.send(eEPGCache::Message(eEPGCache::Message::pause));
			eEPGCache::getInstance()->messages.send(eEPGCache::Message(eEPGCache::Message::flush));
			eString fs = getPartFS(dev, eString().sprintf("mnt/sd%c", dev).c_str()), 
						part = fs.mid( fs.find(",")+1 );
						fs = fs.left( fs.find(",") );	

			// kill samba server... (exporting /hdd)
			system("killall -9 smbd");

			if ( system(eString().sprintf("/bin/umount /mnt/sd%c", dev).c_str()) >> 8)
			{
				eMessageBox msg(
				_("could not unmount the filesystem... "),
				_("check filesystem..."),
				 eMessageBox::btOK|eMessageBox::iconError);
	 			close(-1);
			}
			if ( fs == "ext3" )
			{
				eWindow::globalCancel(eWindow::OFF);
				fsck = new eConsoleAppContainer( eString().sprintf("/sbin/fsck.ext3 -f -y /dev/sd%c1",dev) );

				if ( !fsck->running() )
				{
					eMessageBox msg(
						_("sorry, couldn't find fsck.ext3 utility to check the ext3 filesystem."),
						_("check filesystem..."),
						eMessageBox::btOK|eMessageBox::iconError);
					msg.show();
					msg.exec();
					msg.hide();
					close(-1);
				}
				else
				{
					eDebug("fsck.ext3 opened");
					CONNECT( fsck->dataAvail, ePartitionCheck::getData );
					CONNECT( fsck->appClosed, ePartitionCheck::fsckClosed );
				}
			}

			else if ( fs == "vfat" )
			{
				eWindow::globalCancel(eWindow::OFF);
				fsck = new eConsoleAppContainer( eString().sprintf("/sbin/fsck.vfat -f -y /dev/sd%c1", dev) );

				if ( !fsck->running() )
				{
					eMessageBox msg(
						_("sorry, couldn't find fsck.vfat utility to check the vfat filesystem."),
						_("check filesystem..."),
						eMessageBox::btOK|eMessageBox::iconError);
					msg.show();
					msg.exec();
					msg.hide();
					close(-1);
				}
				else
				{
					eDebug("fsck.vfat opened");
					CONNECT( fsck->dataAvail, ePartitionCheck::getData );
					CONNECT( fsck->appClosed, ePartitionCheck::fsckClosed );
				}
			}

			else if ( fs == "reiserfs" && eSystemInfo::getInstance()->getHwType() == eSystemInfo::DM7000 )
			{
				eWindow::globalCancel(eWindow::OFF);
				fsck = new eConsoleAppContainer( eString().sprintf("/sbin/reiserfsck -y --fix-fixable /dev/sd%c1",dev) );

				if ( !fsck->running() )
				{
					eMessageBox msg(
						_("sorry, couldn't find reiserfsck utility to check the reiserfs filesystem."),
						_("check filesystem..."),
						eMessageBox::btOK|eMessageBox::iconError);
					msg.show();
					msg.exec();
					msg.hide();
					close(-1);
				}
				else
				{
					eDebug("reiserfsck opened");
					CONNECT( fsck->dataAvail, ePartitionCheck::getData );
					CONNECT( fsck->appClosed, ePartitionCheck::fsckClosed );
					fsck->write("Yes\n",4);
				}
			}

			else
			{
				eMessageBox::ShowBox(
					_("not supported filesystem for check."),
					_("check filesystem..."),
					eMessageBox::btOK|eMessageBox::iconError);
				close(-1);
			}
		}
		break;

		case eWidgetEvent::execDone:
			eWindow::globalCancel(eWindow::ON);
			if (fsck)
				delete fsck;
			eEPGCache::getInstance()->messages.send(eEPGCache::Message(eEPGCache::Message::restart));
			eDVB::getInstance()->restartSamba();
		break;

		default:
			return eWindow::eventHandler( e );
	}
	return 1;	
}

void ePartitionCheck::onCancel()
{
	if (fsck)
		fsck->kill();
}

void ePartitionCheck::fsckClosed(int state)
{
	if ( system( eString().sprintf("/bin/mount /dev/sd%c1 /mnt/sd%c", dev, dev).c_str() ) >> 8 )
		eDebug("mount hdd after check failed");

	if (fsck)
	{
		delete fsck;
		fsck=0;
	}

	bClose->show();
}

void ePartitionCheck::getData( eString str )
{
	str.removeChars('\x8');
	if ( str.find("<y>") != eString::npos )
		fsck->write("y",1);
	else if ( str.find("[N/Yes]") != eString::npos )
		fsck->write("Yes",3);
	eString tmp = lState->getText();
	tmp+=str;

	eSize size=lState->getSize();
	int height = size.height();
	size.setHeight(height*2);
	eLabel l(this);
	l.hide();
	l.resize(size);
	l.setText(tmp);
	if ( l.getExtend().height() > height )
		tmp=str;

	lState->setText(tmp);
}

#endif // DISABLE_FILE
#endif // DISABLE_HDD
