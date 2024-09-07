#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

CGAL_VER="4.14.3"
BOOST_VER="1_84_0"

#####

TMPDIR=$BASEDIR/tmp
mkdir -p $TMPDIR
cd $TMPDIR

# get source
CGAL_URL=https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-${CGAL_VER}/CGAL-${CGAL_VER}.tar.xz
wget --progress=dot:mega $CGAL_URL
tar xJf CGAL-${CGAL_VER}.tar.xz
cd CGAL-${CGAL_VER}

#####

BOOST_DIR=$BASEDIR/boost_${BOOST_VER}
CGAL_INSTPATH=$BASEDIR/CGAL-${CGAL_VER}

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
      -DCMAKE_INSTALL_PREFIX=$CGAL_INSTPATH \
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
