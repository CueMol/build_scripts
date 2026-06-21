#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

EMBREE_VER=4.4.1
TBB_VER=2023.0.0

#####

TMPDIR=$BASEDIR/tmp
mkdir -p $TMPDIR
cd $TMPDIR

# get source (no source asset for v4.4.1; use GitHub auto-generated archive)
EMBREE_URL=https://github.com/RenderKit/embree/archive/refs/tags/v${EMBREE_VER}.tar.gz
wget --progress=dot:mega -O embree-${EMBREE_VER}.tar.gz $EMBREE_URL
tar xzf embree-${EMBREE_VER}.tar.gz
cd embree-${EMBREE_VER}

#####

EMBREE_INSTPATH=$BASEDIR/embree-${EMBREE_VER}
TBB_INSTPATH=$BASEDIR/tbb-${TBB_VER}

if [ $RUNNER_OS = "macOS" ]; then
    OPTIONS="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
elif [ $RUNNER_OS = "Linux" ]; then
    OPTIONS="-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi

# ISA: x86_64 -> AVX2; arm64 -> let Embree auto-detect NEON (do not pass x86 ISA names)
if [ "$RUNNER_ARCH" = "ARM64" ]; then
    ISA_OPTIONS=""
else
    ISA_OPTIONS="-DEMBREE_MAX_ISA=AVX2"
fi

mkdir -p build
cd build

# Static Embree with TBB tasking. EMBREE_INSTALL_DEPENDENCIES=OFF is required for a
# static TBB (otherwise the install step tries to copy a non-existent TBB shared lib).
# TBB_DIR points at the cmake config dir, not the install root.
cmake .. \
      -DCMAKE_INSTALL_PREFIX=$EMBREE_INSTPATH \
      -DCMAKE_BUILD_TYPE="Release" \
      ${OPTIONS} \
      -DEMBREE_STATIC_LIB=ON \
      -DEMBREE_TASKING_SYSTEM=TBB \
      -DEMBREE_TBB_ROOT=$TBB_INSTPATH \
      -DTBB_DIR=$TBB_INSTPATH/lib/cmake/TBB \
      -DEMBREE_INSTALL_DEPENDENCIES=OFF \
      -DEMBREE_ISPC_SUPPORT=OFF \
      -DEMBREE_TUTORIALS=OFF \
      ${ISA_OPTIONS}

make -j 8
make install

# Clean-up
rm -rf $TMPDIR
