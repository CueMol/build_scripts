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
wget --progress=dot:mega https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.tar.xz
tar xJf CGAL-4.14.3.tar.xz
cd CGAL-4.14.3

#####

BOOST_DIR=$BASEDIR/boost_1_84_0
INSTPATH=$BASEDIR/CGAL-4.14.3

mkdir -p build
cd build

if [ $RUNNER_OS = "macOS" ]; then
    OPTIONS="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_CXX_FLAGS=\"-std=c++14\""
elif [ $RUNNER_OS = "Linux" ]; then
    OPTIONS="-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

cmake .. \
      -DCMAKE_INSTALL_PREFIX=$INSTPATH \
      -DCMAKE_BUILD_TYPE="Release" \
      ${OPTIONS} \
      -DBOOST_ROOT=$BOOST_DIR \
      -DWITH_CGAL_Qt5=OFF \
      -DWITH_CGAL_ImageIO=OFF \
      -DCGAL_DISABLE_GMP=TRUE \
      -DBUILD_SHARED_LIBS=FALSE

#      -DCGAL_HEADER_ONLY=TRUE

make -j 8
make install

rm -rf $TMPDIR
