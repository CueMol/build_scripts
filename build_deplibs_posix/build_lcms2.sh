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
LCMS2_VER=2.15
LCMS2_URL=https://github.com/mm2/Little-CMS/releases/download/lcms${LCMS2_VER}/lcms2-${LCMS2_VER}.tar.gz
wget --progress=dot:mega ${LCMS2_URL}
tar xzf lcms2-${LCMS2_VER}.tar.gz
cd lcms2-${LCMS2_VER}

#####

LCMS2_INSTPATH=$BASEDIR/lcms2-${LCMS2_VER}

if [ $RUNNER_OS = "macOS" ]; then
    ###
elif [ $RUNNER_OS = "Linux" ]; then
    export CFLAGS="-fPIC"
    export CXXFLAGS="-fPIC"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

./configure \
    --prefix=$LCMS2_INSTPATH \
    --enable-static --disable-shared

make -j 8
make install

# Clean-up
rm -rf $TMPDIR
