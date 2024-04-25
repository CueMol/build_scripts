#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --content-disposition -c --progress=dot:mega \
     https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
tar xzf glew-2.2.0.tgz
cd glew-2.2.0

msbuild build/vc14/glew_static.vcxproj /t:rebuild /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143

#####

INSTPATH=$BASEDIR/glew-2.1.0

mkdir -p $INSTPATH/lib
cp -v lib/Release/x64/glew32s.lib $INSTPATH/lib/glew.lib

mkdir -p $INSTPATH/include/GL
cp -v include/GL/*.h $INSTPATH/include/GL/
