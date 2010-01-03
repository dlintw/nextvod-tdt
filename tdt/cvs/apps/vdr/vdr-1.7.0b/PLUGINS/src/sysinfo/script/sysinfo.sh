#!/bin/bash

case "$1" in
	cputemp)
		sensors | grep -i 'CPU TEMP' | cut -c 10-18 | tr -d ' '
		exit $?
        ;;
	cpufan)
		sensors | grep -i 'FAN1' | cut -c 10-18 | tr -d ' '
		exit $?
        ;;
	mbtemp)
		sensors | grep -i 'M/B TEMP' | cut -c 10-18 | tr -d ' '
		exit $?
        ;;
	mbfan)
		sensors | grep -i 'FAN2' | cut -c 10-18 | tr -d ' '
		exit $?
        ;;		
	vidspace)
		df -h | grep hda1 | cut -c 33-38 | tr -d ' '
		exit $?
        ;;		
	*)
		echo ""
		echo "Usage: sysinfo.sh {cputemp|cpufan|mbtemp|mbfan|vidspace}"
		echo ""
		exit 1
		;;
esac
exit 0
