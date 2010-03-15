#!/bin/bash
# USE AS ROOT (sudo su)

# Insert old RPM repositories 
echo "deb http://de.archive.ubuntu.com/ubuntu/ jaunty main restricted" >> /etc/apt/sources.list
echo "deb-src http://de.archive.ubuntu.com/ubuntu/ jaunty main restricted" >> /etc/apt/sources.list
apt-get update

# Link sh to bash instead of dash
rm -f /bin/sh
ln -s /bin/bash /bin/sh

# Most important packages
apt-get -y install subversion \
git-core \
ccache

# The rest
apt-get -y install \
automake \
libncurses5-dev \
flex \
bison \
gawk \
texinfo \
gettext \
cfv \
fakeroot \
xfslibs-dev \
zlib1g-dev \
libtool \
g++ \
swig \
pkg-config
