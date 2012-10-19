TODO:
* What to do with precompiled binaries/drivers.
* Missing binaries/drivers.
* Common binaries and drivers
* Create custom directories for each box with configs in static/
   halt
   fstab
   keymap
   auto.usb
   lircd.conf
   hostname
   ...
* What to do with drivers which are common but are not build for every box. Maybe as simple as if [ -e...
   cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release/lib/modules/ftdi.ko
   cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release/lib/modules
   cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release/lib/modules
   cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release/lib/modules

audio710x:
   cp $(staticprefix)/firmware/audio.elf $(releaseprefix)/boot/audio.elf
audio7105:
   cp $(staticprefix)/firmware/audio_7105.elf $(releaseprefix)/boot/audio.elf
video7100:
   cp $(staticprefix)/firmware/video.elf $(releaseprefix)/boot/video.elf
video7109:
   cp $(staticprefix)/firmware/video_7109.elf $(releaseprefix)/boot/video.elf
video7105:
   cp $(staticprefix)/firmware/video_7105.elf $(releaseprefix)/boot/video.elf
video7111:
   cp $(staticprefix)/firmware/video_7111.elf $(releaseprefix)/boot/video.elf

cpu7100: audio710x video7100
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(releaseprefix)/lib/modules/
cpu7101: cpu7109
cpu7109: audio710x video7109
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(releaseprefix)/lib/modules/
cpu7105: audio7105 video7105
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7105.ko $(releaseprefix)/lib/modules/
   cp $(prefix)/release/lib/firmware/component_7105_pdk7105.fw $(releaseprefix)/lib/firmware/component.fw
cpu7111: audio7105 video7111
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7111.ko $(releaseprefix)/lib/modules/
   cp $(prefix)/release/lib/firmware/component_7111_mb618.fw $(releaseprefix)/lib/firmware/component.fw



release_cuberevo: cpu7109

release_cuberevo_9500hd: release_cuberevo

release_cuberevo_2000hd: release_cuberevo

release_cuberevo_250hd: release_cuberevo

release_cuberevo_mini_fta: release_cuberevo

release_cuberevo_mini2: release_cuberevo

release_cuberevo_mini: release_cuberevo


release_ufs922: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(releaseprefix)/lib/modules/

   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(releaseprefix)/lib/modules/

release_ufs912: cpu7111
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(releaseprefix)/lib/modules/

release_spark: cpu7111
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(releaseprefix)/lib/modules/

release_spark7162: cpu7105
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(releaseprefix)/lib/modules/

release_fortis_hdbox: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(releaseprefix)/lib/modules/

release_atevio7500: cpu7105
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release/lib/modules/

release_octagon1008: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/avl2108.ko $(releaseprefix)/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(releaseprefix)/lib/modules/

release_hs7810a: cpu7111
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(releaseprefix)/lib/modules/

release_ufs910: cpu7100
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(releaseprefix)/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(releaseprefix)/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(releaseprefix)/lib/modules/

   mv $(prefix)/release/lib/firmware/dvb-fe-cx21143.fw $(releaseprefix)/lib/firmware/dvb-fe-cx24116.fw

release_hl101: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(releaseprefix)/lib/modules/

release_adb_box: cpu7100
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/smartcard.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(releaseprefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(releaseprefix)/lib/modules/vfd.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(releaseprefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(releaseprefix)/lib/modules/cooler.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/cec_ctrl.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release/lib/modules/
	sh4-linux-strip --strip-unneeded $(prefix)/release/lib/modules/dvb-as102.ko
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(releaseprefix)/lib/modules/
	sh4-linux-strip --strip-unneeded $(releaseprefix)/lib/modules/stmcore-display-stx7100.ko

release_vip2_v1: release_vip1_v2
release_vip1_v2: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(releaseprefix)/lib/modules/


release_hs5101: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button_hs5101/button.ko $(releaseprefix)/lib/modules/
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs5101/vfd.ko $(releaseprefix)/lib/modules/

   cp -p $(targetprefix)/usr/bin/lircd $(releaseprefix)/usr/bin/

release_tf7700: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(releaseprefix)/lib/modules/
   if STM22
      cp $(kernelprefix)/linux/drivers/net/tun.ko $(releaseprefix)/lib/modules
   endif

release_ipbox9900: cpu7101
   cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(releaseprefix)/lib/modules/
   if STM22
      cp $(kernelprefix)/linux/drivers/net/tun.ko $(releaseprefix)/lib/modules
   endif

release_common:
cp -f $(targetprefix)/sbin/shutdown $(releaseprefix)/sbin/



