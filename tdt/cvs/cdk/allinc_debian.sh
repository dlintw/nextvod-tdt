#!/bin/sh

echo "
              This is the
OPEN   ______ _____ _____  __  _____ 
| | | |  ___/  ___||  _  |/  ||  _  |
| | | | |_  \  --. | |_| | | || |/| |
| | | |  _|   --. \ \___ | | ||  /| |
| |_| | |   /\__/ /.___/ /_| |\ |_/ /
 \___/\_|   \____/ \____/ \___/\___/ 
                            PROJECT
"

echo "
######################################################################
# customizing /usr/sbin path needed for debian-based distributions   #
######################################################################
"
sleep 2
export PATH=$PATH:/sbin:/usr/sbin
echo "
########################################################
#               executing make.sh                      #
########################################################
"
sleep 2
./make.sh
echo "
########################################################
# going to make whatever you want ;-)                  #
# this will may take a while.                          #
########################################################"
sleep 5
echo "What do you want to do next? "
echo "1) make clean"
echo "2) make bootstrap-cross"
echo "3) make yaud-stock"
echo "4) make clean and yaud-stock"
echo "5) make clean, yaud-stock and flash-stock-squashfs"
echo "6) make clean, yaud-stock and flash-stock-squashfs-full"
echo "7) make flash-stock-squashfs"
echo "8) make yaud-enigma"
echo "9) make nothing"

echo "Select 1-9"
read x

case "$x" in
    1 )
            make clean
			rm .deps/*
			export PATH=$PATH:/sbin:/usr/sbin
			./make.sh
            ;;
    2 )
            if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
			make bootstrap-cross
			else 
			echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
			echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
			fi
			;;
    3 )
			if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
			make yaud-stock
			else 
			echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
			echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
			fi
			;;
    4)
			make clean
			rm .deps/*
			export PATH=$PATH:/sbin:/usr/sbin
			./make.sh
			if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
			make yaud-stock
			else 
			echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
			echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
			fi
	    ;;
    5)
			make clean
			rm .deps/*
			export PATH=$PATH:/sbin:/usr/sbin
			./make.sh
			if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
			make yaud-stock
			export PATH=$PATH:/sbin:/usr/sbin
			./make.sh
			make flash-stock-squashfs
			else 
			echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
			echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
			fi
	    ;;
    6)
                        make clean
                        rm .deps/*
                        export PATH=$PATH:/sbin:/usr/sbin
                        ./make.sh
                        if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
                        make yaud-stock
                        export PATH=$PATH:/sbin:/usr/sbin
                        ./make.sh
                        make flash-stock-squashfs-full
                        else
                        echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
                        echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
                        fi
            ;;
    7)
	    make flash-stock-squashfs
            ;;
    8)
                        if [ -e ../../Archive/linux-2.6.17.14_stm22_0037.tar.gz ]; then
                        make yaud-enigma
                        else
                        echo "Missing linux-2.6.17.14_stm22_0037.tar.gz in Archive!"
                        echo "Have a look @ http://svn.ufs910.de/trac/wiki/SVN_updaten !!"
                        fi
                        ;;

    9)
            echo "nothing to do. have a nice day"
            exit
            ;;

    *)
            echo "invalid choice"
            ;;
esac
