#FROM ubuntu:12.04
FROM ubuntu:14.04
#MAINTAINER Hoseog Lee <hoseog@gmail.com>
MAINTAINER Daniel Chalef <daniel.chalef@gmail.com>

ENV ANT_OPTS -Dfile.encoding=UTF8
ENV DEBIAN_FRONTEND noninteractive
ENV SIRIUS_HOME /opt/sirius
RUN export SIRIUS_HOME=$SIRIUS_HOME 
RUN export THREADS=`getconf _NPROCESSORS_ONLN`

COPY compile-sirius-servers.sh.patch /tmp/

#RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse" >> /etc/apt/sources.list;\
#	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse" >> /etc/apt/sources.list;\
#	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse" >> /etc/apt/sources.list;\
#	echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:kirillshkrogalev/ffmpeg-next

RUN apt-add-repository -y multiverse

RUN apt-get update; apt-get upgrade -y

RUN	apt-get install -y \
	apt-utils \
	git wget unzip \
	vim sudo aptitude \
	python-pip python-dev subversion\
	build-essential default-jdk ant \
	automake autoconf libtool bison libboost-all-dev ffmpeg 
RUN	apt-get install -y swig curl python-pip \
	checkinstall git cmake libfaac-dev libjack-jackd2-dev \
  	libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev \
  	libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev \
  	libxvidcore-dev texi2html yasm zlib1g-dev gfortran speex

RUN apt-get -y install \
  tesseract-ocr tesseract-ocr-eng libtesseract-dev libleptonica-dev

#RUN apt-get -y \
#	install libopenblas-base liblapack3 liblapack-dev

RUN apt-get -y \
	install libprotobuf-dev protobuf-compiler

RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN pip install pickledb
RUN aptitude install -y sox

#Download sirius source
RUN rm -rf $SIRIUS_HOME
RUN git clone https://github.com/claritylab/sirius.git $SIRIUS_HOME

#Download OpenBLAS source
RUN git clone https://github.com/xianyi/OpenBLAS.git $SIRIUS_HOME/OpenBLAS 
WORKDIR $SIRIUS_HOME/OpenBLAS
RUN git checkout v0.2.14
RUN make -j $THREADS CPPFLAGS="-mtune=native" CFLAGS="-mtune=native"
RUN make install

#Setting up sirius
WORKDIR $SIRIUS_HOME/sirius-application
RUN patch -p0 compile-sirius-servers.sh < /tmp/compile-sirius-servers.sh.patch
RUN ./get-dependencies.sh
RUN ./get-kaldi.sh
RUN ./get-opencv.sh
RUN ./compile-sirius-servers.sh

#Automatic Speech Recognition(ASR)
WORKDIR $SIRIUS_HOME/sirius-application/run-scripts
RUN ./start-asr-server.sh

#Image Matching(IMM)
#RUN $SIRIUS_HOME/sirius-application/image-matching/make-db.py landmarks $SIRIUS_HOME/sirius-application/image-matching/matching/landmarks/db/
#RUN $SIRIUS_HOME/sirius-application/image-matching/start-imm-server.sh

#Question-Answering System(QA)
