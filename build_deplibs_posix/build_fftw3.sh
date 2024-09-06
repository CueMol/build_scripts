#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

#####

TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --progress=dot:mega https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
cd fftw-3.3.10

#####

INSTPATH=$BASEDIR/fftw-3.3.10

if [ $RUNNER_OS = "macOS" ]; then
    ###
elif [ $RUNNER_OS = "Linux" ]; then
    export CFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

./configure --prefix=$INSTPATH \
            --enable-float \
            --disable-fortran
make -j 8
make install

# Clean-up
rm -rf $TMPDIR
