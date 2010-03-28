#!/bin/bash
# prepared by lareq
# based on tdt ubuntu910.sh and opensuse1102.sh scripts

# HAS TO BE START AS ROOT (su -) or sudo

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo $0)" 1>&2
  exit 1
fi
    
#packages
yum install -y subversion \
git \
ccache \
rpm-build \
libtool \
gcc-c++ \
gettext \
flex \
bison \
ncurses-devel \
texinfo \
zlib-devel \
gettext-devel \
swig 
