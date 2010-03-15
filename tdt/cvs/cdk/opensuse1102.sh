#!/bin/bash
# created by schischu and konfetti
# based on tdt ubuntu910.sh script

# USE AS ROOT (sudo su)

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





