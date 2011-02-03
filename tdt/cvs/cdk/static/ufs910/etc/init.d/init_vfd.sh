#!/bin/sh

MODDIR=$1

insmod $MODDIR/vfd.ko
VFD=/dev/vfd
