#ifndef __ufs912__
#define __ufs912__

/* this setups the mode temporarily (for one ioctl)
 * to the desired mode. currently the "normal" mode
 * is the compatible vfd mode
 */
struct set_mode_s {
	int compat; /* 0 = compatibility mode to vfd driver; 1 = micom mode */
};

struct set_brightness_s {
	int level;
};

struct set_icon_s {
	int icon_nr;
	int on;
};

struct set_led_s {
	int led_nr;
    /* on:
     * 0 = off
     * 1 = on
     * 2 = slow
     * 3 = fast
     */
	int on;
};

struct set_fan_s {
    int on;
};

struct set_rf_s {
    int on;
};

/* YYMMDDhhmm */
struct set_standby_s {
    char time[10];
};

/* YYMMDDhhmmss */
struct set_time_s {
    char time[12];
};

/* YYMMDDhhmmss */
struct get_time_s {
    char time[12];
};

struct get_wakeupstatus {
    char status;
};

/* YYMMDDhhmmss */
struct get_wakeuptime {
    char time[12];
};

struct micom_ioctl_data {
    union
    {
        struct set_icon_s icon;
        struct set_led_s led;
        struct set_fan_s fan;
        struct set_rf_s rf;
        struct set_brightness_s brightness;
        struct set_mode_s mode;
        struct set_standby_s standby;
        struct set_time_s time;
        struct get_time_s get_time;
        struct get_wakeupstatus status;
        struct get_wakeuptime wakeup_time;
    } u;
};


#endif
