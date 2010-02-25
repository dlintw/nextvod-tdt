#!/bin/sh
#touch .deps/lirc .deps/lirc.do_prepare .deps/lirc.do_compile; \
#mkdir -p ./../../tufsbox/cdkroot/usr/bin; \
#touch ./../../tufsbox/cdkroot/usr/bin/lircd; \
mkdir -p ./root/boot; \
touch ./root/boot/video_7109.elf ./root/boot/video_7100.elf ./root/boot/audio.elf; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/pseudocard; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/pseudocard/pseudocard.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/silencegen; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/silencegen/silencegen.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/mmelog; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/mmelog/mmelog.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/monitor; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/monitor/stm_monitor.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/video/stm; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/video/stm/stm_v4l2.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/dvb; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/dvb/stmdvb.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/ksound; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/sound/ksound/ksound.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/mpeg2_hard_host_transformer; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/backend; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/backend/player2.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/h264_preprocessor; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/h264_preprocessor/sth264pp.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/allocator; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/media/dvb/stm/allocator/stmalloc.ko; \
mkdir -p ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/platform; \
touch ./../../tufsbox/cdkroot/lib/modules/2.6.17.14_stm22_0041/extra/player2/linux/drivers/stm/platform/platform.ko
