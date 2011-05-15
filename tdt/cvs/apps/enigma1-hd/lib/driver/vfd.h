#ifndef VFD_H_
#define VFD_H_

#define ICON_ON  1
#define ICON_OFF 0

typedef enum { USB = 0x10, HD, HDD, LOCK, BT, MP3, MUSIC, DD, MAIL, MUTE, PLAY, PAUSE, FF, FR, REC, CLOCK } tvfd_icon;

class evfd
{
protected:
	static evfd *instance;
	int file_vfd;
#ifdef SWIG
	evfd();
	~evfd();
#endif
public:
#ifndef SWIG
	evfd();
	~evfd();
#endif
	void init();
	static evfd* getInstance();

	void vfd_set_icon(tvfd_icon id, bool onoff);
	void vfd_set_icon(tvfd_icon id, bool onoff, bool force);
	void vfd_clear_icons();

	void vfd_write_string(char * string);
	void vfd_write_string(char * str, bool force);
	void vfd_write_string_scrollText(char* text);
	void vfd_clear_string();
	
	void vfd_set_brightness(unsigned char setting);
	void vfd_set_light(bool onoff);
};


#endif
