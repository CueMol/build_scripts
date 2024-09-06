#!/bin/sh
set -eux

BASEDIR=$1
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --progress=dot:giga https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.bz2
tar xjf boost_1_84_0.tar.bz2
cd boost_1_84_0

#####

INST_PATH=$BASEDIR/boost_1_84_0

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
