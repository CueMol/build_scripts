#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

TBB_VER=2023.0.0

#####

TMPDIR=$BASEDIR/tmp
mkdir -p $TMPDIR
cd $TMPDIR

# get source (GitHub auto-generated archive; release assets are prebuilt binaries, not source)
TBB_URL=https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v${TBB_VER}.tar.gz
wget --progress=dot:mega -O oneTBB-${TBB_VER}.tar.gz $TBB_URL
tar xzf oneTBB-${TBB_VER}.tar.gz
cd oneTBB-${TBB_VER}

#####

TBB_INSTPATH=$BASEDIR/tbb-${TBB_VER}

if [ $RUNNER_OS = "macOS" ]; then
    OPTIONS="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
elif [ $RUNNER_OS = "Linux" ]; then
    OPTIONS="-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

mkdir -p build
cd build

# Static build: TBB_STRICT=OFF avoids -Werror on newer compilers,
# TBB_INSTALL=ON emits lib/cmake/TBB/TBBConfig.cmake for downstream find_package.
cmake .. \
      -DCMAKE_INSTALL_PREFIX=$TBB_INSTPATH \
      -DCMAKE_BUILD_TYPE="Release" \
      ${OPTIONS} \
      -DBUILD_SHARED_LIBS=OFF \
      -DTBB_TEST=OFF \
      -DTBB_STRICT=OFF \
      -DTBB_INSTALL=ON

make -j 8
make install

# Clean-up
rm -rf $TMPDIR
