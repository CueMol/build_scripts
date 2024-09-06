#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
GLEW_VER=2.1.0
GLEW_URL=https://sourceforge.net/projects/glew/files/glew/${GLEW_VER}/glew-${GLEW_VER}.tgz/download
wget --content-disposition -O glew-${GLEW_VER}.tgz $GLEW_URL
     
tar xzf glew-${GLEW_VER}.tgz
cd glew-${GLEW_VER}

#####

GLEW_INSTPATH=$BASEDIR/glew-${GLEW_VER}

if [ $RUNNER_OS = "macOS" ]; then
    CC="clang -Wno-strict-prototypes -Wdeprecated-declarations"
elif [ $RUNNER_OS = "Linux" ]; then
    CC="gcc -fPIC"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

make \
    CC="$CC" \
    GLEW_PREFIX=$GLEW_INSTPATH \
    GLEW_DEST=$GLEW_INSTPATH \
    install

# Clean-up
rm -rf $TMPDIR
