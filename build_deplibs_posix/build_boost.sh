#!/bin/sh
set -eux

BASEDIR=$1
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

BOOST_VER=1_84_0
SRC_FILE=boost_$BOOST_VER.tar.bz2
SRC_URL=https://archives.boost.io/release/1.84.0/source/$SRC_FILE

# get source
wget --progress=dot:giga $SRC_URL
tar xjf $SRC_FILE
cd boost_$BOOST_VER

#####

INST_PATH=$BASEDIR/boost_$BOOST_VER

bash bootstrap.sh
./b2 \
 --prefix=$INST_PATH \
 --with-date_time \
 --with-filesystem \
 --with-iostreams \
 --with-system \
 --with-thread \
 --with-chrono \
 --with-timer \
 -d0 \
link=shared threading=multi install

# architecture=x86 address-model=64 
# --exec-prefix=$instpath \
# --libdir=$instpath \
# --includedir=$instpath \

# Clean-up
rm -rf $TMPDIR
