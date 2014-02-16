# Usage
# =====
# mkdir /tmp/root
# docker run -t -i -v /tmp/root:/root dlin/ubuntu-duckbox /bin/bash
# cd /tdt/tdt/cvs/cdk && make yaud-xbmc-nightly
# In the REVISIONS menu, choose 5)Frodo_rc3

FROM ubuntu:12.04
MAINTAINER Daniel YC Lin <dlin.tw at gmail>

RUN apt-get update
ADD localtime /etc/localtime

RUN ln -sf bash /bin/sh
RUN apt-get install -y git unzip subversion openssh-server gcc g++ make \
  libreadline-dev unzip gettext libtool automake autoconf \
  flex bison libglib2.0-dev zlib1g-dev texinfo rpm bzip2 libncurses5-dev \
  ccache gawk fakeroot xfslibs-dev swig pkg-config
  #redhat-lsb glibc-static automake-1.11.3 autoconf-2.68

RUN wget -O /tmp/fossil.zip \
  http://www.fossil-scm.org/download/fossil-linux-x86-20140127173344.zip \
  && unzip -d /usr/bin /tmp/fossil.zip && rm /tmp/fossil.zip

RUN mkdir /var/run/sshd
RUN /etc/init.d/ssh start
RUN echo 'root:root' | chpasswd

RUN git clone https://git.gitorious.org/open-duckbox-project-sh4/tdt.git

RUN wget -O/tmp/cdk.zip https://www.dropbox.com/s/fh5ae25j3nc03dq/cdk.zip

RUN unzip -d tdt/tdt/cvs/cdk -o /tmp/cdk.zip
#WORKDIR tdt/tdt/cvs/cdk
#RUN sed -i -e 's,ftp://,http://,' rules-archive

# extra required packages
RUN apt-get install -y autopoint ruby cmake doxygen default-jdk libnfs-dev
RUN mkdir /Archive && wget -O /Archive/pcre-8.30.tar.bz2 http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.30.tar.bz2
RUN wget -O /Archive/tinyxml_2_6_2.tar.gz http://download.sf.net/tinyxml/2.6.2/tinyxml_2_6_2.tar.gz

RUN cd /tdt/tdt/cvs/cdk && ./make.sh 20 4 y 2 1 2 1 2
#RUN make yaud-xbmc-nightly

#ENTRYPOINT ["/usr/sbin/sshd", "-D"]
#EXPOSE 22
