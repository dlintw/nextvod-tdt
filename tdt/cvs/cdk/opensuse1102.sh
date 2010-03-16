#!/bin/bash
# created by schischu and konfetti
# based on tdt ubuntu910.sh script

# USE AS ROOT (sudo su)

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo $0)" 1>&2
  exit 1
fi
    
# Most important packages
zypper install -y subversion \
git-core \
ccache \
patch

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

