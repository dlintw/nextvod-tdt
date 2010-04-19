#!/bin/bash

mkdir -p root/boot;
touch root/boot/{video_7109,video_7100,video_7111,audio,audio_7111}.elf

CDKROOT=../../tufsbox/cdkroot

# find kernel version in config.log
[ -e config.log ] && KERNELVERSION=`grep ^KERNELVERSION config.log | sed -e "s/^.*='//;s/'$//"`
# if config.log does not exist, or does not contain KERNELVERSION, assume default value.
KERNELVERSION=${KERNELVERSION:-2.6.17.14_stm22_0041}

DRIVERDIR=${CDKROOT}/lib/modules/${KERNELVERSION}/extra/player2/linux/drivers

for module in \
  sound/pseudocard/pseudocard.ko \
  sound/silencegen/silencegen.ko \
  sound/ksound/ksound.ko \
  stm/mmelog/mmelog.ko \
  stm/monitor/stm_monitor.ko \
  stm/platform/platform.ko \
  stm/platform/p2div64.ko \
  media/video/stm/stm_v4l2.ko \
  media/dvb/stm/dvb/stmdvb.ko \
  media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
  media/dvb/stm/backend/player2.ko \
  media/dvb/stm/h264_preprocessor/sth264pp.ko \
  media/dvb/stm/allocator/stmalloc.ko
do
  mkdir -p `dirname ${DRIVERDIR}/${module}`
  touch ${DRIVERDIR}/${module}
done

