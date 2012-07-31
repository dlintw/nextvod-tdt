#!/bin/sh
#########################################
# Original Neutrino Release Cycle Format:
# SBBBYYYYMMTTHHMM
# | |   | | |  | |_MM	= Minutes 0 - 59
# | |   | | |  |___HH	= Hours 0 - 23
# | |   | | |______TT	= Day 0 - 31
# | |   | |________MM	= Month 0 - 12
# | |   |__________YYYY	= Year
# | |______________BBB	= Build-Revision (interesting for Image-Groups!)
# |________________S	= Snapshot Version: 0 = Release, 1 = Beta, 2 = Internal, L = Locale,
#					    S = Settings, A = Addon, T = Text
#########################################
cd /tdt/tdt
homepage="http://neutrino.mbremer.de"
docs="http://forum.mbremer.de"
forum="http://forum.mbremer.de"
release="1"
version="100"
datum=`date +'%Y%m%d%H%M'`
gitversion=`git describe | awk -F '-' '{print $1$2}'`
stmversion=`cat /tdt/tdt/cvs/cdk/linux{,-sh4}/localversion-stm | awk -F '_' '{print $2"_"$3}'`
plversion=`ls -l /tdt/tdt/cvs/driver/player2 | awk -F '_' '{print $2}'`
echo "imagename=BPanther-Image ($stmversion, player$plversion)" > /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "homepage=$homepage" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "creator=BPanther" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "version=$release$version$datum" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "git=$gitversion" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "docs=$docs" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
echo "forum=$forum" >> /tdt/tdt/cvs/cdk/root/var/etc/.version
cp /tdt/tdt/cvs/cdk/root/var/etc/.version /tdt/tdt/tufsbox/release_neutrino/var/etc/.version
mv /tdt/tdt/tufsbox/release_neutrino/var/etc/.version /tdt/tdt/tufsbox/release_neutrino/.version
ln -sf /.version /tdt/tdt/tufsbox/release_neutrino/var/etc/.version
#########################################
#stmver=`echo "$stmversion" | awk -F '_' '{print $1}'`
#boxname=`cat /tdt/tdt/tufsbox/release_neutrino/etc/hostname`
#if [ -e /tdt/tdt/cvs/cdk/own_build/neutrino/etc/.usbimage ]; then
#	echo "http://$boxname.mbremer.de/USB-BA/$stmver/Neutrino-BA.list" > /tdt/tdt/tufsbox/release_neutrino/etc/update.urls
#fi
#if [ -e /tdt/tdt/cvs/cdk/own_build/neutrino/var/etc/.usbimage ]; then
#	echo "http://$boxname.mbremer.de/USB-BA/$stmver/Neutrino-BA.list" > /tdt/tdt/tufsbox/release_neutrino/var/etc/update.urls
#fi
#if [ -e /tdt/tdt/cvs/cdk/own_build/neutrino/etc/.flashimage ]; then
#	echo "http://$boxname.mbremer.de/FLASH/$stmver/Neutrino.list" > /tdt/tdt/tufsbox/release_neutrino/etc/update.urls
#fi
#if [ -e /tdt/tdt/cvs/cdk/own_build/neutrino/var/etc/.flashimage ]; then
#	echo "http://$boxname.mbremer.de/FLASH/$stmver/Neutrino.list" > /tdt/tdt/tufsbox/release_neutrino/var/etc/update.urls
#fi
