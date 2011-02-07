#!/bin/sh

MODDIR=$1

PTI_P131_ARGS=""
PTI_P179_ARGS="waitMS=20 videoMem=4096"
STMDVB_P131_ARGS=""
STMDVB_P179_ARGS=""

echo "init AVS"
insmod $MODDIR/avs.ko type=stv6417
