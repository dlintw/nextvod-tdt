#!/bin/bash
# created by schischu and konfetti
# based on tdt ubuntu910.sh script

# USE AS ROOT (sudo su)

# NOTE DOWNGRADING RPM CRASHES YAST! SO ONLY USE THIS ON AN DEVELOPMENT MACHSCHINE!!!

# Insert old RPM repositories
zypper ar -c http://download.opensuse.org/distribution/11.0/repo/oss/ openSUSE-11.0-Oss

#This command takes 1min
zypper refresh

# Install older versions
zypper install bash=3.2-112.1
zypper install rpm=4.4.2-199.1

# Most important packages
zypper install -y subversion \
git-core \
ccache

# The rest
zypper install -y automake \
ncurses-devel \
flex \
bison \
texinfo \
gettext-devel \
xfsprogs-devel \
zlib-devel \
libtool \
swig \
make \
gcc \
gcc-c++





