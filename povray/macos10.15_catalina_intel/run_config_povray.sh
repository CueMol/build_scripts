#!/bin/bash

set -eux

TMPDIR=$HOME/tmp/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget -c --content-disposition https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz

tar xzf povray-3.7.0.10.tar.gz
cd povray-3.7.0.10

cd unix/
./prebuild.sh
cd ../

instpath=$HOME/proj64/povray/

./configure \
    NON_REDISTRIBUTABLE_BUILD=yes \
    COMPILED_BY="your name <email@address>" \
    --prefix=$instpath \
    --with-boost=$HOME/proj64/povray/boost_1_76_static \
    --with-libpng=$HOME/proj64/povray/libpng12/lib \
    --without-libjpeg \
    --without-libtiff

make -j 8
make install

cd ..
rm -rf povray-3.7.0.10
