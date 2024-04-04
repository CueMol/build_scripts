#!/bin/bash
set -eux

BASEDIR=$1
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --content-disposition \
     https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz/download
tar xzf glew-2.1.0.tgz
cd glew-2.1.0

#####

INSTPATH=$BASEDIR/builds/glew-2.1.0

make \
    CC="clang -Wno-strict-prototypes -Wdeprecated-declarations" \
    GLEW_PREFIX=$INSTPATH \
    GLEW_DEST=$INSTPATH \
    install
