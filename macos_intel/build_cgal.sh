#!/bin/bash
set -eux

BASEDIR=$1
TMPDIR=$BASEDIR/tmp

mkdir -p $TMPDIR
cd $TMPDIR

# get source
wget --progress=dot:mega https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz
tar xJf CGAL-4.14.3.tar.xz
cd CGAL-4.14.3

#####

INSTPATH=$BASEDIR/builds/CGAL-4.14.3

mkdir build && cd build

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$INSTPATH \
      -DCMAKE_BUILD_TYPE="Release" \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_CXX_FLAGS="-std=c++14" \
      -DBOOST_ROOT=$BASEDIR/builds/boost_1_84/ \
      -DWITH_CGAL_Qt5=OFF \
      -DWITH_CGAL_ImageIO=OFF \
      -DCGAL_DISABLE_GMP=TRUE \
      -DBUILD_SHARED_LIBS=FALSE

make -j 8
make install

