#!/bin/bash
set -eux

BASEDIR=$1

TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --progress=dot:mega https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
cd fftw-3.3.10

#####

INSTPATH=$BASEDIR/fftw-3.3.10

./configure --prefix=$INSTPATH \
            --enable-float \
            --disable-fortran
make -j 8
make install
