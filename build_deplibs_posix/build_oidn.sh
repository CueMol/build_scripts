#!/bin/bash
set -eux

BASEDIR=$1
RUNNER_OS=$2
RUNNER_ARCH=$3

# Centralized versions
source "$(dirname "$0")/../deplibs.env"

#####

TMPDIR=$BASEDIR/tmp
mkdir -p $TMPDIR
cd $TMPDIR

# ISPC: build-time-only compiler for OIDN's CPU kernels. Fetch a prebuilt binary
# into TMPDIR (removed before packaging, so it never lands in the tarball).
if [ $RUNNER_OS = "macOS" ]; then
    if [ "$RUNNER_ARCH" = "ARM64" ]; then
        ISPC_ASSET=ispc-v${ISPC_VER}-macOS.arm64.tar.gz
    else
        ISPC_ASSET=ispc-v${ISPC_VER}-macOS.x86_64.tar.gz
    fi
elif [ $RUNNER_OS = "Linux" ]; then
    ISPC_ASSET=ispc-v${ISPC_VER}-linux.tar.gz
else
    echo "unknown runner os: $RUNNER_OS"
    exit 1
fi
ISPC_URL=https://github.com/ispc/ispc/releases/download/v${ISPC_VER}/${ISPC_ASSET}
wget --progress=dot:mega -O $ISPC_ASSET $ISPC_URL
tar xzf $ISPC_ASSET
# Resolve the ispc binary by glob; the extracted dir name varies by version/arch.
ISPC_BIN=$(ls $TMPDIR/ispc-v${ISPC_VER}*/bin/ispc)

# OIDN source: use the official source release asset (weights are bundled, so no
# Git LFS is needed). The auto-generated GitHub archive would ship broken LFS
# pointer files instead of the model weights.
OIDN_URL=https://github.com/RenderKit/oidn/releases/download/v${OIDN_VER}/oidn-${OIDN_VER}.src.tar.gz
wget --progress=dot:mega -O oidn-${OIDN_VER}.src.tar.gz $OIDN_URL
tar xzf oidn-${OIDN_VER}.src.tar.gz
cd oidn-${OIDN_VER}

#####

OIDN_INSTPATH=$BASEDIR/oidn-${OIDN_VER}
TBB_INSTPATH=$BASEDIR/tbb-${TBB_VER}

if [ $RUNNER_OS = "macOS" ]; then
    OPTIONS="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
elif [ $RUNNER_OS = "Linux" ]; then
    OPTIONS="-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
fi

mkdir -p build
cd build

# CPU-only static OIDN with TBB tasking. GPU devices (SYCL/CUDA/HIP/Metal) are all
# OFF so OIDN_STATIC_LIB yields a fully static library. ISA is left at the default
# (multiple ISPC targets dispatched at runtime). TBB_DIR points at the cmake config
# dir; TBB_ROOT at the install root (both passed for robust find_package(TBB)).
cmake .. \
      -G Ninja \
      -DCMAKE_INSTALL_PREFIX=$OIDN_INSTPATH \
      -DCMAKE_BUILD_TYPE="Release" \
      ${OPTIONS} \
      -DOIDN_STATIC_LIB=ON \
      -DOIDN_DEVICE_CPU=ON \
      -DOIDN_DEVICE_SYCL=OFF \
      -DOIDN_DEVICE_CUDA=OFF \
      -DOIDN_DEVICE_HIP=OFF \
      -DOIDN_DEVICE_METAL=OFF \
      -DOIDN_APPS=OFF \
      -DOIDN_FILTER_RT=ON \
      -DOIDN_FILTER_RTLIGHTMAP=OFF \
      -DISPC_EXECUTABLE=$ISPC_BIN \
      -DTBB_ROOT=$TBB_INSTPATH \
      -DTBB_DIR=$TBB_INSTPATH/lib/cmake/TBB

cmake --build . -j 8
cmake --install .

# Clean-up (also removes the build-time-only ISPC under TMPDIR)
rm -rf $TMPDIR
