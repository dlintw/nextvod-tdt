#!/bin/bash
# USE AS ROOT (sudo su)

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo $0)" 1>&2
  exit 1
fi

# Link sh to bash instead of dash
rm -f /bin/sh
ln -s /bin/bash /bin/sh

# Most important packages
apt-get -y install subversion \
git-core \
ccache \
rpm

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
