#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

TMPDIR=$BASEDIR/tmp
mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --progress=dot:mega https://github.com/mm2/Little-CMS/releases/download/lcms2.15/lcms2-2.15.tar.gz
tar xzf lcms2-2.15.tar.gz
cd lcms2-2.15

#####

INSTPATH=$BASEDIR/builds/lcms2-2.15

./configure \
    --prefix=$INSTPATH \
    --enable-static --disable-shared

make -j 8
make install
