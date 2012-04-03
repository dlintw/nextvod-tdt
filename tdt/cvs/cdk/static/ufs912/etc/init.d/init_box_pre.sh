#!/bin/sh

MODDIR=$1

PTI_P179_ARGS="waitMS=20 videoMem=4096"
PTI_P191_ARGS="waitMS=20 videoMem=4096"
STMDVB_P179_ARGS=""
STMDVB_P191_ARGS=""

echo "init AVS"
insmod $MODDIR/avs.ko type=stv6417
