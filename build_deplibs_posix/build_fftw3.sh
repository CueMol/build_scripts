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
FFTW_VER=3.3.10
FFTW_URL=https://www.fftw.org/fftw-${FFTW_VER}.tar.gz
wget --progress=dot:mega $FFTW_URL
tar xzf fftw-${FFTW_VER}.tar.gz
cd fftw-${FFTW_VER}

#####

FFTW_INSTPATH=$BASEDIR/fftw-${FFTW_VER}

if [ $RUNNER_OS = "macOS" ]; then
    echo "runner os: $RUNNER_OS"
elif [ $RUNNER_OS = "Linux" ]; then
    export CFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

./configure --prefix=$FFTW_INSTPATH \
            --enable-float \
            --disable-fortran
make -j 8
make install

# Clean-up
rm -rf $TMPDIR
