#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --content-disposition \
     https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz/download
tar xzf glew-2.1.0.tgz
cd glew-2.1.0

#####

INSTPATH=$BASEDIR/glew-2.1.0

if [ $RUNNER_OS = "macOS" ]; then
    CC="clang -Wno-strict-prototypes -Wdeprecated-declarations"
elif [ $RUNNER_OS = "Linux" ]; then
    CC="gcc"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

make \
    CC="$CC" \
    GLEW_PREFIX=$INSTPATH \
    GLEW_DEST=$INSTPATH \
    install
